Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXFBTJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXFBTJu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761658AbXFBTJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:09:40 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51900 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761604AbXFBTJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:09:39 -0400
Date: Sat, 2 Jun 2007 21:09:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Mattia Dongili <malattia@linux.it>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove sonypi_camera_command()
Message-ID: <20070602190942.GM5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used sonypi_camera_command().

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/char/sonypi.c  |   47 -----------------------------------------
 include/linux/sonypi.h |    2 -
 2 files changed, 49 deletions(-)

--- linux-2.6.22-rc3-mm1/include/linux/sonypi.h.old	2007-06-02 20:35:45.000000000 +0200
+++ linux-2.6.22-rc3-mm1/include/linux/sonypi.h	2007-06-02 20:35:51.000000000 +0200
@@ -153,8 +153,6 @@
 #define SONYPI_COMMAND_GETCAMERAROMVERSION	18	/* obsolete */
 #define SONYPI_COMMAND_GETCAMERAREVISION	19	/* obsolete */
 
-int sonypi_camera_command(int command, u8 value);
-
 #endif				/* __KERNEL__ */
 
 #endif				/* _SONYPI_H_ */
--- linux-2.6.22-rc3-mm1/drivers/char/sonypi.c.old	2007-06-02 20:35:58.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/char/sonypi.c	2007-06-02 20:36:16.000000000 +0200
@@ -885,53 +885,6 @@
 	return IRQ_HANDLED;
 }
 
-/* External camera command (exported to the motion eye v4l driver) */
-int sonypi_camera_command(int command, u8 value)
-{
-	if (!camera)
-		return -EIO;
-
-	mutex_lock(&sonypi_device.lock);
-
-	switch (command) {
-	case SONYPI_COMMAND_SETCAMERA:
-		if (value)
-			sonypi_camera_on();
-		else
-			sonypi_camera_off();
-		break;
-	case SONYPI_COMMAND_SETCAMERABRIGHTNESS:
-		sonypi_set(SONYPI_CAMERA_BRIGHTNESS, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERACONTRAST:
-		sonypi_set(SONYPI_CAMERA_CONTRAST, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAHUE:
-		sonypi_set(SONYPI_CAMERA_HUE, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERACOLOR:
-		sonypi_set(SONYPI_CAMERA_COLOR, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERASHARPNESS:
-		sonypi_set(SONYPI_CAMERA_SHARPNESS, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAPICTURE:
-		sonypi_set(SONYPI_CAMERA_PICTURE, value);
-		break;
-	case SONYPI_COMMAND_SETCAMERAAGC:
-		sonypi_set(SONYPI_CAMERA_AGC, value);
-		break;
-	default:
-		printk(KERN_ERR "sonypi: sonypi_camera_command invalid: %d\n",
-		       command);
-		break;
-	}
-	mutex_unlock(&sonypi_device.lock);
-	return 0;
-}
-
-EXPORT_SYMBOL(sonypi_camera_command);
-
 static int sonypi_misc_fasync(int fd, struct file *filp, int on)
 {
 	int retval;

