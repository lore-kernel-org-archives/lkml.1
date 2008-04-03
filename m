Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbYDCAeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbYDCAeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760091AbYDCAeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:34:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:9328 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759981AbYDCAeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gEkaF8YDlElCjbV6Em/DAAz1FxaPZ/mBecEzBzGlhZ6GbAMpRpkdEWYoneUKz2NhsC7iFbiDvlhAj/ADQDy6mFQUZGz4cmeInPI3dHoofpZsR0vGyiuEzBpcQ2E3ogAr+J1CUbcQAnvV0PiOMB3Alzae4e8Cn9qBB02dSt8Yxrc=
Subject: [PATCH 4/7] video: intelfbdrv.c fix sparse return void expression
	warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Antonino Daplas <adaplas@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:36 -0700
Message-Id: <1207182816.5740.23.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/intelfb/intelfbdrv.c:1484:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1512:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1531:3: warning: returning void-valued expression
drivers/video/intelfb/intelfbdrv.c:1545:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/video/intelfb/intelfbdrv.c |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/intelfbdrv.c
index 481d58f..94c3ed0 100644
--- a/drivers/video/intelfb/intelfbdrv.c
+++ b/drivers/video/intelfb/intelfbdrv.c
@@ -1480,8 +1480,10 @@ static void intelfb_fillrect (struct fb_info *info,
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
@@ -1508,8 +1510,10 @@ static void intelfb_copyarea(struct fb_info *info,
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
@@ -1526,9 +1530,11 @@ static void intelfb_imageblit(struct fb_info *info,
 	DBG_MSG("intelfb_imageblit\n");
 #endif
 
-	if (!ACCEL(dinfo, info) || dinfo->depth == 4
-	    || image->depth != 1)
-		return cfb_imageblit(info, image);
+	if (!ACCEL(dinfo, info) || dinfo->depth == 4 ||
+	    image->depth != 1) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	if (dinfo->depth != 8) {
 		fgcolor = dinfo->pseudo_palette[image->fg_color];
@@ -1542,7 +1548,7 @@ static void intelfb_imageblit(struct fb_info *info,
 				    image->height, image->data,
 				    image->dx, image->dy,
 				    dinfo->pitch, info->var.bits_per_pixel))
-		return cfb_imageblit(info, image);
+		cfb_imageblit(info, image);
 }
 
 static int intelfb_cursor(struct fb_info *info, struct fb_cursor *cursor)
-- 
1.5.5.rc1.135.g8527


