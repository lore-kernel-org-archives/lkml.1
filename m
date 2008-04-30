Return-Path: <linux-kernel-owner+w=401wt.eu-S1759970AbYD3WFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970AbYD3WFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 18:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761746AbYD3WDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 18:03:33 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:1024 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932434AbYD3WDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 18:03:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=iMSHOQuN8vj4+EIogb837qmkhopreSA1epHQNKzgvHH+Zm82/+arcUyswL5AltJpEIrGKJfGElQyqKUk/MfrDhOyHmXVb6BlmmJdJ+8c4ErmjBzlIHzejsnELrlz8V2MD+ZNcUEMGlfaxIO73zQcJOc2+iwqNdH+mjU9DnWaP70=
Subject: [PATCH 06/10] video: fix returning void-valued expression warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 15:03:42 -0700
Message-Id: <1209593022.24729.116.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/nvidia/nv_accel.c:304:3: warning: returning void-valued expression
drivers/video/nvidia/nv_accel.c:323:3: warning: returning void-valued expression
drivers/video/pm3fb.c:543:3: warning: returning void-valued expression
drivers/video/neofb.c:1526:4: warning: returning void-valued expression
drivers/video/neofb.c:1534:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:305:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:331:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:370:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1492:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1520:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1539:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1553:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/i810/i810_accel.c    |   18 ++++++++++++------
 drivers/video/intelfb/intelfbdrv.c |   20 +++++++++++++-------
 drivers/video/neofb.c              |    6 ++++--
 drivers/video/nvidia/nv_accel.c    |   12 ++++++++----
 drivers/video/pm3fb.c              |    6 ++++--
 5 files changed, 41 insertions(+), 21 deletions(-)

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
diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index e44303f..fc1dca2 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -1488,8 +1488,10 @@ static void intelfb_fillrect (struct fb_info *info,
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
@@ -1516,8 +1518,10 @@ static void intelfb_copyarea(struct fb_info *info,
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
@@ -1535,8 +1539,10 @@ static void intelfb_imageblit(struct fb_info *info,
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
@@ -1550,7 +1556,7 @@ static void intelfb_imageblit(struct fb_info *info,
 				    image->height, image->data,
 				    image->dx, image->dy,
 				    dinfo->pitch, info->var.bits_per_pixel))
-		return cfb_imageblit(info, image);
+		cfb_imageblit(info, image);
 }
 
 static int intelfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index 5246b04..971e525 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -1523,7 +1523,8 @@ neo2200_imageblit(struct fb_info *info, const struct fb_image *image)
 			 * is less than 16 bits wide. This is due to insufficient
 			 * padding when writing the image. We need to adjust
 			 * struct fb_pixmap. Not yet done. */
-			return cfb_imageblit(info, image);
+			cfb_imageblit(info, image);
+			return;
 		}
 		bltCntl_flags = NEO_BC0_SRC_MONO;
 	} else if (image->depth == info->var.bits_per_pixel) {
@@ -1531,7 +1532,8 @@ neo2200_imageblit(struct fb_info *info, const struct fb_image *image)
 	} else {
 		/* We don't currently support hardware acceleration if image
 		 * depth is different from display */
-		return cfb_imageblit(info, image);
+		cfb_imageblit(info, image);
+		return;
 	}
 
 	switch (info->var.bits_per_pixel) {
diff --git a/drivers/video/nvidia/nv_accel.c b/drivers/video/nvidia/nv_accel.c
index fa4821c..ad6472a 100644
--- a/drivers/video/nvidia/nv_accel.c
+++ b/drivers/video/nvidia/nv_accel.c
@@ -300,8 +300,10 @@ void nvidiafb_copyarea(struct fb_info *info, const struct fb_copyarea *region)
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
 
-	if (par->lockup)
-		return cfb_copyarea(info, region);
+	if (par->lockup) {
+		cfb_copyarea(info, region);
+		return;
+	}
 
 	NVDmaStart(info, par, BLIT_POINT_SRC, 3);
 	NVDmaNext(par, (region->sy << 16) | region->sx);
@@ -319,8 +321,10 @@ void nvidiafb_fillrect(struct fb_info *info, const struct fb_fillrect *rect)
 	if (info->state != FBINFO_STATE_RUNNING)
 		return;
 
-	if (par->lockup)
-		return cfb_fillrect(info, rect);
+	if (par->lockup) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8)
 		color = rect->color;
diff --git a/drivers/video/pm3fb.c b/drivers/video/pm3fb.c
index 68089d1..6666f45 100644
--- a/drivers/video/pm3fb.c
+++ b/drivers/video/pm3fb.c
@@ -539,8 +539,10 @@ static void pm3fb_imageblit(struct fb_info *info, const struct fb_image *image)
 		bgx = par->palette[image->bg_color];
 		break;
 	}
-	if (image->depth != 1)
-		return cfb_imageblit(info, image);
+	if (image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	if (info->var.bits_per_pixel == 8) {
 		fgx |= fgx << 8;
-- 
1.5.5.1.305.g7c84


