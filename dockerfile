#FROM __BASEIMAGE_ARCH__/python:2.7.15-jessie
#FROM python:2.7.15-jessie
FROM python:3.9.0-slim

#__CROSS_COPY qemu/qemu-__QEMU_ARCH__-static /usr/bin/

# based on https://github.com/pfichtner/docker-mqttwarn

# install python libraries (TODO: any others?)
RUN pip install paho-mqtt broadlink

# build /opt/mqttwarn
RUN mkdir -p /opt/broadlink-mqtt
WORKDIR /opt/broadlink-mqtt
RUN mkdir -p /var/log/broadlink

# add user mqttwarn to image
RUN groupadd -r broadlink && useradd -r -g broadlink broadlink
RUN chown -R broadlink /opt/broadlink-mqtt
RUN chown -R broadlink /var/log/broadlink

# process run as mqttwarn user
USER broadlink

# conf file from host
VOLUME ["/opt/broadlink-mqtt/conf"]

# commands dir
VOLUME ["/opt/broadlink-mqtt/commands/"]



# set conf path
ENV BROADLINKMQTTCONF="/opt/broadlink-mqtt/conf/mqtt.conf"

# finally, copy the current code (ideally we'd copy only what we need, but it
#  is not clear what that is, yet)
COPY . /opt/broadlink-mqtt

# run process
CMD python mqtt.py