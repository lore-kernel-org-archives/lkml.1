Return-Path: <linux-kernel-owner+w=401wt.eu-S933736AbYD3WGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933736AbYD3WGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933027AbYD3WDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:36 -0400
Received: from wr-out-0506.google.com ([64.233.184.237]:24648 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932884AbYD3WDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ssSGFCG/SoSIMJZbSsn3rvc4G9rHVdbmLT0KvVo8UfC/HdMG3GBF0ak/hwQDwMLARV/iaUmerbSy6V7N7onRV0o4cLIR/uu89zSIJ8UlLMKNryjqWVOH2STKz+zFC1xgO+Y0OOmbxoBO18wPa8mr+rvgSEwXBDtFOl2yE3o8k3s=
Subject: [PATCH 08/10] drivers: fix returning void-valued expression
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:43 -0700
Message-Id: <1209593023.24729.118.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/block/xen-blkfront.c:1011:2: warning: returning void-valued expression
drivers/isdn/i4l/isdn_net.c:1986:3: warning: returning void-valued expression
drivers/rtc/rtc-ds1511.c:648:2: warning: returning void-valued expression
drivers/rtc/rtc-stk17ta8.c:416:2: warning: returning void-valued expression
drivers/virtio/virtio_pci.c:148:2: warning: returning void-valued expression
drivers/virtio/virtio_pci.c:155:2: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/block/xen-blkfront.c |    2 +-
 drivers/isdn/i4l/isdn_net.c  |    2 +-
 drivers/rtc/rtc-ds1511.c     |    2 +-
 drivers/rtc/rtc-stk17ta8.c   |    2 +-
 drivers/virtio/virtio_pci.c  |    4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index f2fff57..cf92742 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1008,7 +1008,7 @@ module_init(xlblk_init);
 
 static void xlblk_exit(void)
 {
-	return xenbus_unregister_driver(&blkfront);
+	xenbus_unregister_driver(&blkfront);
 }
 module_exit(xlblk_exit);
 
diff --git a/drivers/isdn/i4l/isdn_net.c b/drivers/isdn/i4l/isdn_net.c
index ef1a300..ac37041 100644
--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -1983,7 +1983,7 @@ static void isdn_header_cache_update(struct hh_cache *hh,
 {
 	isdn_net_local *lp = dev->priv;
 	if (lp->p_encap == ISDN_NET_ENCAP_ETHER)
-		return eth_header_cache_update(hh, dev, haddr);
+		eth_header_cache_update(hh, dev, haddr);
 }
 
 static const struct header_ops isdn_header_ops = {
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index a83a40b..d1dbdfe 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -645,7 +645,7 @@ ds1511_rtc_init(void)
  static void __exit
 ds1511_rtc_exit(void)
 {
-	return platform_driver_unregister(&ds1511_rtc_driver);
+	platform_driver_unregister(&ds1511_rtc_driver);
 }
 
 module_init(ds1511_rtc_init);
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 31d3c8c..62dace3 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -413,7 +413,7 @@ static __init int stk17ta8_init(void)
 
 static __exit void stk17ta8_exit(void)
 {
-	return platform_driver_unregister(&stk17ta8_rtc_driver);
+	platform_driver_unregister(&stk17ta8_rtc_driver);
 }
 
 module_init(stk17ta8_init);
diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index c0df924..de102a6 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -145,14 +145,14 @@ static void vp_set_status(struct virtio_device *vdev, u8 status)
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
-- 
1.5.5.1.305.g7c84


