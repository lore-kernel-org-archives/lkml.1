Return-Path: <linux-kernel-owner+w=401wt.eu-S1751937AbYKLMWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbYKLMWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 07:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbYKLMW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 07:22:26 -0500
Received: from ozlabs.org ([203.10.76.45]:36457 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbYKLMWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 07:22:25 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 12 Nov 2008 06:22:21 -0600
Cc: Hollis Blanchard <hollisb@us.ibm.com>, aliguori@us.ibm.com,
       markmc@redhat.com, kvm@vger.kernel.org
Subject: [PATCH 1/7] virtio: Don't use PAGE_SIZE in virtio_pci.c
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811122252.22129.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The virtio PCI devices don't depend on the guest page size.  This matters
now PowerPC virtio is gaining ground (they like 64k pages).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_pci.c |    2 +-
 include/linux/virtio_pci.h  |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -r 8014f9c51f4e drivers/virtio/virtio_pci.c
--- a/drivers/virtio/virtio_pci.c	Wed Nov 12 21:12:39 2008 +1030
+++ b/drivers/virtio/virtio_pci.c	Wed Nov 12 21:47:21 2008 +1030
@@ -244,7 +244,7 @@
 	}
 
 	/* activate the queue */
-	iowrite32(virt_to_phys(info->queue) >> PAGE_SHIFT,
+	iowrite32(virt_to_phys(info->queue) >> VIRTIO_PCI_QUEUE_ADDR_SHIFT,
 		  vp_dev->ioaddr + VIRTIO_PCI_QUEUE_PFN);
 
 	/* create the vring */
diff -r 8014f9c51f4e include/linux/virtio_pci.h
--- a/include/linux/virtio_pci.h	Wed Nov 12 21:12:39 2008 +1030
+++ b/include/linux/virtio_pci.h	Wed Nov 12 21:47:21 2008 +1030
@@ -53,4 +53,8 @@
 
 /* Virtio ABI version, this must match exactly */
 #define VIRTIO_PCI_ABI_VERSION		0
+
+/* How many bits to shift physical queue address written to QUEUE_PFN.
+ * 12 is historical, and due to x86 page size. */
+#define VIRTIO_PCI_QUEUE_ADDR_SHIFT	12
 #endif


