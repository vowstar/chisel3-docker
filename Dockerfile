FROM debian:sid

# Using faster mirror
ARG REPO=http://mirrors.163.com
RUN echo "deb ${REPO}/debian sid main non-free contrib" > /etc/apt/sources.list && \
    echo "deb ${REPO}/debian testing-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb ${REPO}/debian-security testing-security/updates main contrib non-free" >> /etc/apt/sources.list

# Update and install software
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        openjdk-8-jdk-headless \
        build-essential \
        python3 \
        bc \
        rsync \
        git \
        curl \
        wget \
        gnupg2 \
    && \
    rm -rf /var/lib/apt/lists/*

# Add sbt mirror and key
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823

# Update and install sbt
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        sbt \
    && \
    rm -rf /var/lib/apt/lists/*

# Compile firrtl
RUN cd /opt && \
    git clone --recursive https://github.com/freechipsproject/firrtl.git && \
    cd firrtl && \
    make build-scala
