Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYDCAed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYDCAed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 20:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbYDCAdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 20:33:49 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:39551 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758143AbYDCAdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 20:33:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F4bYy7cVEdxmCABOzVMBS7S9IBSRKtIu7wkamfXIONRZTKp5W2FiDEOjhObPWWjF7L1+JerlSNuu8TyroCFy+Bh0Jjt8dXPp4d5xvDVDlZ+KfZzsT6sE8ftKX+bKc640pDxDxGiVNBuu80InolgzWBcMIw77gfWAODWWXdQS/Iw=
Subject: [PATCH 3/7] video: i810_accel.c fix sparse return void expression
	warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Antonino Daplas <adaplas@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 17:33:36 -0700
Message-Id: <1207182816.5740.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/i810/i810_accel.c:305:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:331:3: warning: returning void-valued expression
drivers/video/i810/i810_accel.c:370:3: warning: returning void-valued expression

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
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
1.5.5.rc1.135.g8527


