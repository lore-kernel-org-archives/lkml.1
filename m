Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbYFVOU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbYFVOU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 10:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205AbYFVOTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 10:19:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39256 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbYFVOTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 10:19:50 -0400
To: mchehab@infradead.org
Subject: [PATCH] zoran annotations and fixes
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KAQQ1-0001zj-IR@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jun 2008 15:19:49 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/zoran_card.c   |    2 +-
 drivers/media/video/zoran_driver.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/zoran_card.c b/drivers/media/video/zoran_card.c
index 006d488..2d087f4 100644
--- a/drivers/media/video/zoran_card.c
+++ b/drivers/media/video/zoran_card.c
@@ -1147,7 +1147,7 @@ zr36057_init (struct zoran *zr)
 		goto exit_free;
 	}
 	for (j = 0; j < BUZ_NUM_STAT_COM; j++) {
-		zr->stat_com[j] = 1;	/* mark as unavailable to zr36057 */
+		zr->stat_com[j] = cpu_to_le32(1); /* mark as unavailable to zr36057 */
 	}
 
 	/*
diff --git a/drivers/media/video/zoran_driver.c b/drivers/media/video/zoran_driver.c
index 5394d7a..6491544 100644
--- a/drivers/media/video/zoran_driver.c
+++ b/drivers/media/video/zoran_driver.c
@@ -2795,7 +2795,7 @@ zoran_do_ioctl (struct inode *inode,
 	{
 		struct v4l2_format *fmt = arg;
 		int i, res = 0;
-		__u32 printformat;
+		__le32 printformat;
 
 		dprintk(3, KERN_DEBUG "%s: VIDIOC_S_FMT - type=%d, ",
 			ZR_DEVNAME(zr), fmt->type);
@@ -3040,7 +3040,7 @@ zoran_do_ioctl (struct inode *inode,
 	{
 		int i, res = 0;
 		struct v4l2_framebuffer *fb = arg;
-		__u32 printformat = __cpu_to_le32(fb->fmt.pixelformat);
+		__le32 printformat = __cpu_to_le32(fb->fmt.pixelformat);
 
 		dprintk(3,
 			KERN_DEBUG
-- 
1.5.3.GIT


