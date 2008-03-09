Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbYCIVTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbYCIVTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbYCIVTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:19:22 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:35254 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbYCIVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:19:22 -0400
Message-ID: <47D45451.5030302@tiscali.nl>
Date: Sun, 09 Mar 2008 22:19:13 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org
CC: video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] drivers/media/video/tvp5150.c: logical-bitwise and confusion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/media/video/tvp5150.c b/drivers/media/video/tvp5150.c
index 445eba4..d28318c 100644
--- a/drivers/media/video/tvp5150.c
+++ b/drivers/media/video/tvp5150.c
@@ -672,7 +672,7 @@ static int tvp5150_set_vbi(struct i2c_client *c,
 	if (std == V4L2_STD_ALL) {
 		tvp5150_err("VBI can't be configured without knowing number of lines\n");
 		return 0;
-	} else if (std && V4L2_STD_625_50) {
+	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
 		line += 3;
 	}
@@ -719,7 +719,7 @@ static int tvp5150_get_vbi(struct i2c_client *c,
 	if (std == V4L2_STD_ALL) {
 		tvp5150_err("VBI can't be configured without knowing number of lines\n");
 		return 0;
-	} else if (std && V4L2_STD_625_50) {
+	} else if (std & V4L2_STD_625_50) {
 		/* Don't follow NTSC Line number convension */
 		line += 3;
 	}
