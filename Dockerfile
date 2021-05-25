FROM bioconductor/bioconductor_docker:RELEASE_3_13

RUN apt-get update && apt-get -y install libgdal-dev gdal-bin \
    libproj-dev proj-data proj-bin libgeos-dev default-libmysqlclient-dev libmysqlclient-dev \
    texlive texlive-xetex texlive-fonts-extra texlive-extra-utils

WORKDIR /home/rstudio/clusterProfiler_test

COPY --chown=rstudio:rstudio . /home/rstudio/clusterProfiler_test

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); BiocManager::install(ask=FALSE)"

RUN Rscript -e "options(repos = c(CRAN = 'https://cran.r-project.org')); \
			    options(BioC_mirror=BiocManager::repositories()); \
				install.packages(c('ggplot2', 'cowplot', 'ggupset', 'kableExtra', 'ggnewscale', 'knitr', 'rmarkdown', 'bookdown')); \
				BiocManager::install(c('ChIPseeker', 'clusterProfiler', 'DOSE', 'enrichplot', 'org.Hs.eg.db', 'TxDb.Hsapiens.UCSC.hg19.knownGene'))"

RUN Rscript -e 'rmarkdown::render("supplementary_file.Rmd")'
