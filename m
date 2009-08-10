Return-Path: <linux-kernel-owner+w=401wt.eu-S1751206AbZHJSww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206AbZHJSww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZHJSww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:52:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43673 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZHJSwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:52:51 -0400
Date: Mon, 10 Aug 2009 21:51:35 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] vhost: a kernel-level virtio server
Message-ID: <20090810185135.GA13924@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements vhost: a kernel-level backend for virtio,
The main motivation for this work is to reduce virtualization
overhead for virtio by removing system calls on data path,
without guest changes. For virtio-net, this removes up to
4 system calls per packet: vm exit for kick, reentry for kick,
iothread wakeup for packet, interrupt injection for packet.

Some more detailed description attached to the patch itself.

The patches are against 2.6.31-rc4.  I'd like them to go into linux-next
and down the road 2.6.32 if possible.  Please comment.

Userspace bits using this driver will be posted to kvm@vger shortly.

Michael S. Tsirkin (2):
  export cpu_tlbstate to modules
  vhost_net: a kernel-level virtio server

 MAINTAINERS                |   10 +
 arch/x86/kvm/Kconfig       |    1 +
 arch/x86/mm/tlb.c          |    1 +
 drivers/Makefile           |    1 +
 drivers/block/virtio_blk.c |    3 +
 drivers/vhost/Kconfig      |   11 +
 drivers/vhost/Makefile     |    2 +
 drivers/vhost/net.c        |  462 ++++++++++++++++++++++++++++++
 drivers/vhost/vhost.c      |  663 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/vhost.h      |  108 +++++++
 include/linux/Kbuild       |    1 +
 include/linux/miscdevice.h |    1 +
 include/linux/vhost.h      |  100 +++++++
 13 files changed, 1364 insertions(+), 0 deletions(-)
 create mode 100644 drivers/vhost/Kconfig
 create mode 100644 drivers/vhost/Makefile
 create mode 100644 drivers/vhost/net.c
 create mode 100644 drivers/vhost/vhost.c
 create mode 100644 drivers/vhost/vhost.h
 create mode 100644 include/linux/vhost.h
