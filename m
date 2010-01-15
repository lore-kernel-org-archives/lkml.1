Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab0AOQva (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896Ab0AOQva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:51:30 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42016 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752638Ab0AOQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:51:29 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] s3c-fb: Fix mixed code and variable declaration
Date: Fri, 15 Jan 2010 16:51:26 +0000
Message-Id: <1263574286-6382-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hoist osdc_data up into the variable declaration section.

Reported-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/video/s3c-fb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index e2e7afd..58e2fed 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -269,6 +269,7 @@ static int s3c_fb_set_par(struct fb_info *info)
 	int win_no = win->index;
 	u32 data;
 	u32 pagewidth;
+	u32 osdc_data;
 	int clkdiv;
 
 	dev_dbg(sfb->dev, "setting framebuffer parameters\n");
@@ -359,8 +360,6 @@ static int s3c_fb_set_par(struct fb_info *info)
 
 	data = var->xres * var->yres;
 
-	u32 osdc_data = 0;
-
 	osdc_data = VIDISD14C_ALPHA1_R(0xf) |
 		VIDISD14C_ALPHA1_G(0xf) |
 		VIDISD14C_ALPHA1_B(0xf);
-- 
1.6.6

