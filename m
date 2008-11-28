Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbYK1URe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbYK1URe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYK1URZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:17:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:9626 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYK1URY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:17:24 -0500
To: Sylvain Meyer <sylvain.meyer@worldonline.fr>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 18:28:49 +0100
Subject: [PATCH] intelfb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <493051d1.0c11660a.4d00.ffffb9b4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/video/intelfb/intelfbdrv.c:1497:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1525:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1544:3: warning: returning void-valued expression
  drivers/video/intelfb/intelfbdrv.c:1558:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/intelfb/intelfbdrv.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index a09e236..6d8e541 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -1493,8 +1493,10 @@ static void intelfb_fillrect (struct fb_info *info,
 	DBG_MSG("intelfb_fillrect\n");
 #endif
 
-	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_fillrect(info, rect);
+	if (!ACCEL(dinfo, info) || dinfo->depth == 4) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (rect->rop == ROP_COPY)
 		rop = PAT_ROP_GXCOPY;
@@ -1521,8 +1523,10 @@ static void intelfb_copyarea(struct fb_info *info,
 	DBG_MSG("intelfb_copyarea\n");
 #endif
 
-	if (!ACCEL(dinfo, info) || dinfo->depth == 4)
-		return cfb_copyarea(info, region);
+	if (!ACCEL(dinfo, info) || dinfo->depth == 4) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	intelfbhw_do_bitblt(dinfo, region->sx, region->sy, region->dx,
 			    region->dy, region->width, region->height,
@@ -1540,8 +1544,10 @@ static void intelfb_imageblit(struct fb_info *info,
 #endif
 
 	if (!ACCEL(dinfo, info) || dinfo->depth == 4
-	    || image->depth != 1)
-		return cfb_imageblit(info, image);
+	    || image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	if (dinfo->depth != 8) {
 		fgcolor = dinfo->pseudo_palette[image->fg_color];
@@ -1554,8 +1560,10 @@ static void intelfb_imageblit(struct fb_info *info,
 	if (!intelfbhw_do_drawglyph(dinfo, fgcolor, bgcolor, image->width,
 				    image->height, image->data,
 				    image->dx, image->dy,
-				    dinfo->pitch, info->var.bits_per_pixel))
-		return cfb_imageblit(info, image);
+				    dinfo->pitch, info->var.bits_per_pixel)) {
+		cfb_imageblit(info, image);
+		return;
+	}
 }
 
 static int intelfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
-- 
1.5.6.3

