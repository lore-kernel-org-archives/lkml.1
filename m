Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbYK1UQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbYK1UQU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:16:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYK1UQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:16:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:9458 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYK1UQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:16:09 -0500
To: Antonino Daplas <adaplas@pol.net>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 18:25:01 +0100
Subject: [PATCH] i810: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49305187.02a1660a.3c23.ffffa8ef@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/video/i810/i810_accel.c:305:3: warning: returning void-valued expression
  drivers/video/i810/i810_accel.c:331:3: warning: returning void-valued expression
  drivers/video/i810/i810_accel.c:370:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/i810/i810_accel.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/video/i810/i810_accel.c b/drivers/video/i810/i810_accel.c
index 76764ea..f5bedee 100644
--- a/drivers/video/i810/i810_accel.c
+++ b/drivers/video/i810/i810_accel.c
@@ -301,8 +301,10 @@ void i810fb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	u32 dx, dy, width, height, dest, rop = 0, color = 0;
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4) 
-		return cfb_fillrect(info, rect);
+	    par->depth == 4) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (par->depth == 1) 
 		color = rect->color;
@@ -327,8 +329,10 @@ void i810fb_copyarea(struct fb_info *info, const struct fb_copyarea *region)
 	u32 sx, sy, dx, dy, pitch, width, height, src, dest, xdir;
 
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4)
-		return cfb_copyarea(info, region);
+	    par->depth == 4) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	dx = region->dx * par->depth;
 	sx = region->sx * par->depth;
@@ -366,8 +370,10 @@ void i810fb_imageblit(struct fb_info *info, const struct fb_image *image)
 	u32 fg = 0, bg = 0, size, dst;
 	
 	if (!info->var.accel_flags || par->dev_flags & LOCKUP ||
-	    par->depth == 4 || image->depth != 1) 
-		return cfb_imageblit(info, image);
+	    par->depth == 4 || image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	switch (info->var.bits_per_pixel) {
 	case 8:
-- 
1.5.6.3

