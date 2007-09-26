Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbXIZAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbXIZAx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 20:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXIZAxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 20:53:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46697 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXIZAxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 20:53:50 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] usbvision-video: buggered method tables
Cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Message-Id: <E1IaL9q-00084l-9L@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 26 Sep 2007 01:53:42 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


duplicated .mmap in one, .vidioc_s_audio misspelled as .vidioc_g_audio
in other

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/media/video/usbvision/usbvision-video.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
index e3371f9..0cb006f 100644
--- a/drivers/media/video/usbvision/usbvision-video.c
+++ b/drivers/media/video/usbvision/usbvision-video.c
@@ -1387,7 +1387,6 @@ static const struct file_operations usbvision_fops = {
 	.ioctl		= video_ioctl2,
 	.llseek		= no_llseek,
 /* 	.poll          = video_poll, */
-	.mmap	       = usbvision_v4l2_mmap,
 	.compat_ioctl  = v4l_compat_ioctl32,
 };
 static struct video_device usbvision_video_template = {
@@ -1413,7 +1412,7 @@ static struct video_device usbvision_video_template = {
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_audio       = vidioc_g_audio,
-	.vidioc_g_audio       = vidioc_s_audio,
+	.vidioc_s_audio       = vidioc_s_audio,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_streamon      = vidioc_streamon,
@@ -1459,7 +1458,7 @@ static struct video_device usbvision_radio_template=
 	.vidioc_s_input       = vidioc_s_input,
 	.vidioc_queryctrl     = vidioc_queryctrl,
 	.vidioc_g_audio       = vidioc_g_audio,
-	.vidioc_g_audio       = vidioc_s_audio,
+	.vidioc_s_audio       = vidioc_s_audio,
 	.vidioc_g_ctrl        = vidioc_g_ctrl,
 	.vidioc_s_ctrl        = vidioc_s_ctrl,
 	.vidioc_g_tuner       = vidioc_g_tuner,
-- 
1.5.3.GIT


