Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbYK1UPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbYK1UPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbYK1UPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:15:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:18994 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYK1UPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:15:07 -0500
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 18:19:24 +0100
Subject: [PATCH] neofb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49305146.170e660a.2535.ffffbeb9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/video/neofb.c:1456:4: warning: returning void-valued expression
  drivers/video/neofb.c:1464:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/neofb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index bfb802d..588527a 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -1453,7 +1453,8 @@ neo2200_imageblit(struct fb_info *info, const struct fb_image *image)
 			 * is less than 16 bits wide. This is due to insufficient
 			 * padding when writing the image. We need to adjust
 			 * struct fb_pixmap. Not yet done. */
-			return cfb_imageblit(info, image);
+			cfb_imageblit(info, image);
+			return;
 		}
 		bltCntl_flags = NEO_BC0_SRC_MONO;
 	} else if (image->depth == info->var.bits_per_pixel) {
@@ -1461,7 +1462,8 @@ neo2200_imageblit(struct fb_info *info, const struct fb_image *image)
 	} else {
 		/* We don't currently support hardware acceleration if image
 		 * depth is different from display */
-		return cfb_imageblit(info, image);
+		cfb_imageblit(info, image);
+		return;
 	}
 
 	switch (info->var.bits_per_pixel) {
-- 
1.5.6.3

