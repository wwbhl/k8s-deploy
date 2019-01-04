#!/bin/bash

set -e

# Check version in https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# Search "Running kubeadm without an internet connection"
# For running kubeadm without an internet connection you have to pre-pull the required master images for the version of choice:
KUBE_VERSION=v1.13.1
KUBE_PAUSE_VERSION=3.1
ETCD_VERSION=3.2.24
CORE_DNS_VERSION=1.2.6
GCR_URL=k8s.gcr.io
ALIYUN_URL=mirrorgooglecontainers

# When test v1.11.0, I found Kubernetes depends on both pause:3.1 and pause:3.1 

images=(kube-proxy:${KUBE_VERSION}
kube-scheduler:${KUBE_VERSION}
kube-controller-manager:${KUBE_VERSION}
kube-apiserver:${KUBE_VERSION}
pause:${KUBE_PAUSE_VERSION}
pause:${KUBE_PAUSE_VERSION}
etcd:${ETCD_VERSION})


for imageName in ${images[@]} ; do
  docker pull $ALIYUN_URL/$imageName
  docker tag  $ALIYUN_URL/$imageName $GCR_URL/$imageName
  docker rmi $ALIYUN_URL/$imageName
done
docker pull coredns/coredns:${CORE_DNS_VERSION}
docker tag coredns/coredns:${CORE_DNS_VERSION} $GCR_URL/coredns:${CORE_DNS_VERSION}
docker rmi coredns/coredns:${CORE_DNS_VERSION}
docker images



