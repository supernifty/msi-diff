configfile: "cfg/config.yaml"

# final output
rule all:
  input:
    "out/msi.summary.tsv",
    "out/msi.summary.rotated.transcribed.tsv",
    "out/msi.summary.mini.tsv",
    "out/msi.measure.summary",
    "out/msi.cluster.tumours",
    "out/msi.primaries.cluster",
    "out/msi.blood.cluster",
    "out/msi.tumours.png",
    "out/msi.samples.png",
    expand("out/msi.cluster.{range}.tsv", range=config['indel_length_cluster']),
    expand("out/msi.cluster.{range}.png", range=config['indel_length_cluster']),
    expand("out/msi.{caller}.common", caller=config['msi_callers']),
    expand("out/mmr.{caller}.common", caller=config['callers']),
    "out/mmr.cluster.cosmic.png",
    "out/mmr.cluster.mmr.png",
    "out/mmr.cluster.cancertype.png",
    "out/regions.msi.stats",
    "out/msi.repeat_context.all.heatmap.png",
    "out/msi.indel_context.all.heatmap.png",
    "out/msi.repeat_indel_context.all.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.heatmap.png",
    "out/msi.repeat_context_emast.all.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.raw.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.threshold_0.3.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.threshold_0.3.transcribed.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.threshold_0.3.log.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.representative.transcribed.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.representative.transcribed.sample_norm.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.representative.heatmap.png",
    "out/msi.repeat_indel_context_rotated.all.representative.complemented.heatmap.png",
    "out/msi.repeat_context.all.rotated.transcribed.heatmap.png",
    "out/msi.unique.tsv",
    "out/ddr.summary"

##### msi #####
include: 'Snakefile.msi'
include: 'Snakefile.mmr'

### overall stats

rule count_mutations:
  input:
    expand("in/{sample}.{caller}.vcf", sample=config['samples'], caller=config['callers'])
  output:
    "out/mutations.summary"
  log:
    stderr="log/count_mutations.stderr",
  shell:
    "src/count_mutations.py {input} 1>{output} 2>{log.stderr}"

### general setup

# builds a genome length file
rule make_genome_lengths:
  input:
    config["genome"]
  output:
    config["genome_lengths"]
  shell:
    "src/make_lengths.py < {input} > {output}"
