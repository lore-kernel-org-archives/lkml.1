Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYLHU0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYLHU0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 15:26:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbYLHU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 15:26:39 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:51347 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbYLHU0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 15:26:39 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mchehab@infradead.org
Cc: v4l-dvb-maintainer@linuxtv.org, linux-uvc-devel@lists.berlios.de,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] V4L: usbvideo, fix module ref count check
Date: Mon,  8 Dec 2008 21:25:34 +0100
Message-Id: <1228767934-14193-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usbvideo_ClientIncModCount may return value < 0 in the case of error, not > 0.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/media/video/usbvideo/usbvideo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/usbvideo/usbvideo.c b/drivers/media/video/usbvideo/usbvideo.c
index 7c575bb..6ace064 100644
--- a/drivers/media/video/usbvideo/usbvideo.c
+++ b/drivers/media/video/usbvideo/usbvideo.c
@@ -1123,7 +1123,7 @@ static int usbvideo_v4l_open(struct inode *inode, struct file *file)
 	if (uvd->debug > 1)
 		dev_info(&uvd->dev->dev, "%s($%p)\n", __func__, dev);
 
-	if (0 < usbvideo_ClientIncModCount(uvd))
+	if (usbvideo_ClientIncModCount(uvd) < 0)
 		return -ENODEV;
 	mutex_lock(&uvd->lock);
 
-- 
1.6.0.5

