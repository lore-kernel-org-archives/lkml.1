Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYC2DL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYC2DL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 23:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760145AbYC2DJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 23:09:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50129 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760144AbYC2DJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 23:09:52 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] virtio_pci iomem annotations
Cc: aliguori@us.ibm.com, linux-kernel@vger.kernel.org
Message-Id: <E1JfRS0-0002sT-Kf@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 29 Mar 2008 03:09:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/virtio/virtio_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index 59a8f73..150419c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -37,7 +37,7 @@ struct virtio_pci_device
 	struct pci_dev *pci_dev;
 
 	/* the IO mapping for the PCI config space */
-	void *ioaddr;
+	void __iomem *ioaddr;
 
 	/* a list of queues so we can dispatch IRQs */
 	spinlock_t lock;
@@ -111,7 +111,7 @@ static void vp_get(struct virtio_device *vdev, unsigned offset,
 		   void *buf, unsigned len)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
+	void __iomem *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
 	u8 *ptr = buf;
 	int i;
 
@@ -125,7 +125,7 @@ static void vp_set(struct virtio_device *vdev, unsigned offset,
 		   const void *buf, unsigned len)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
-	void *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
+	void __iomem *ioaddr = vp_dev->ioaddr + VIRTIO_PCI_CONFIG + offset;
 	const u8 *ptr = buf;
 	int i;
 
-- 
1.5.3.GIT


