Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYCFRVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYCFRVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 12:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbYCFRV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 12:21:28 -0500
Received: from ryu.zarb.org ([212.85.153.228]:55671 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYCFRV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 12:21:27 -0500
X-Greylist: delayed 940 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 12:21:27 EST
Subject: [PATCH] Add a device link to usbvideo devices, else hal will
	ignore them
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-usb-devel@lists.sourceforge.net, video4linux-list@redhat.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Mandriva
Date: Thu, 06 Mar 2008 18:05:42 +0100
Message-Id: <1204823142.7101.1.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.92-2mdv2008.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Pascal Terjan <pterjan@mandriva.com>
---
 drivers/media/video/usbvideo/usbvideo.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index fb434b5..5d363be 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -1034,6 +1034,11 @@ int usbvideo_RegisterVideoDevice(struct uvd *uvd)
 		info("%s: iface=%d. endpoint=$%02x paletteBits=$%08lx",
 		     __FUNCTION__, uvd->iface, uvd->video_endp, uvd->paletteBits);
 	}
+	if (uvd->dev == NULL) {
+		err("%s: uvd->dev == NULL", __FUNCTION__);
+		return -EINVAL;
+	}
+	uvd->vdev.dev=&(uvd->dev->dev);
 	if (video_register_device(&uvd->vdev, VFL_TYPE_GRABBER, video_nr) == -1) {
 		err("%s: video_register_device failed", __FUNCTION__);
 		return -EPIPE;
@@ -1041,10 +1046,6 @@ int usbvideo_RegisterVideoDevice(struct uvd *uvd)
 	if (uvd->debug > 1) {
 		info("%s: video_register_device() successful", __FUNCTION__);
 	}
-	if (uvd->dev == NULL) {
-		err("%s: uvd->dev == NULL", __FUNCTION__);
-		return -EINVAL;
-	}
 
 	info("%s on /dev/video%d: canvas=%s videosize=%s",
 	     (uvd->handle != NULL) ? uvd->handle->drvName : "???",
-- 
1.5.4.3

