Return-Path: <linux-kernel-owner+w=401wt.eu-S932601AbYEUAgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601AbYEUAgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765373AbYEUAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:32:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45323 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765982AbYEUAcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:32:52 -0400
To: mchehab@infradead.org
Subject: [PATCH] media/video: mix trivial endianness annotations
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Message-Id: <E1JycGB-0004vk-S5@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 21 May 2008 01:32:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/em28xx/em28xx-video.c         |    8 ++++----
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-video.c b/drivers/media/video/em28xx/em28xx-video.c
index 8996175..fb163ec 100644
--- a/drivers/media/video/em28xx/em28xx-video.c
+++ b/drivers/media/video/em28xx/em28xx-video.c
@@ -1166,13 +1166,13 @@ static int vidioc_g_register(struct file *file, void *priv,
 
 		reg->val = ret;
 	} else {
-		u64 val = 0;
+		__le64 val = 0;
 		ret = em28xx_read_reg_req_len(dev, USB_REQ_GET_STATUS,
 						   reg->reg, (char *)&val, 2);
 		if (ret < 0)
 			return ret;
 
-		reg->val = cpu_to_le64((__u64)val);
+		reg->val = le64_to_cpu(val);
 	}
 
 	return 0;
@@ -1183,9 +1183,9 @@ static int vidioc_s_register(struct file *file, void *priv,
 {
 	struct em28xx_fh      *fh  = priv;
 	struct em28xx         *dev = fh->dev;
-	u64 buf;
+	__le64 buf;
 
-	buf = le64_to_cpu((__u64)reg->val);
+	buf = cpu_to_le64(reg->val);
 
 	return em28xx_write_regs(dev, reg->reg, (char *)&buf,
 				 em28xx_reg_len(reg->reg));
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index 32e536e..3d26a30 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -210,7 +210,7 @@ static int qcm_stv_setb(struct usb_device *dev, u16 reg, u8 val)
 	return ret;
 }
 
-static int qcm_stv_setw(struct usb_device *dev, u16 reg, u16 val)
+static int qcm_stv_setw(struct usb_device *dev, u16 reg, __le16 val)
 {
 	int ret;
 
-- 
1.5.3.GIT


