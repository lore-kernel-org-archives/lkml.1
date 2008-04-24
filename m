Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbYDXE5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbYDXE5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754603AbYDXE4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:56:36 -0400
Received: from ozlabs.org ([203.10.76.45]:58758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980AbYDXE4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:56:34 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 23 Apr 2008 23:56:20 -0500
Cc: virtualization@lists.linux-foundation.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH 3/6] virtio: fix sparse return void-valued expression warnings
Cc: Harvey Harrison <harvey.harrison@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241456.21088.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>

drivers/virtio/virtio_pci.c:148:2: warning: returning void-valued expression
drivers/virtio/virtio_pci.c:155:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/virtio/virtio_pci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c0df924..de102a6 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -145,14 +145,14 @@ static void vp_set_status(struct virtio_device *vdev, u8 
status)
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* We should never be setting status to 0. */
 	BUG_ON(status == 0);
-	return iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	iowrite8(status, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
 static void vp_reset(struct virtio_device *vdev)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	/* 0 status means a reset. */
-	return iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
+	iowrite8(0, vp_dev->ioaddr + VIRTIO_PCI_STATUS);
 }
 
 /* the notify function used when creating a virt queue */

