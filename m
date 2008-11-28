Return-Path: <linux-kernel-owner+w=401wt.eu-S1755210AbYK1UKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbYK1UKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYK1UK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:10:26 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:23933 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYK1UKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:10:25 -0500
To: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:15:26 +0100
Subject: [PATCH] nvidia: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <4930502e.06e2660a.7d1e.ffffb800@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/video/nvidia/nv_accel.c:304:3: warning: returning void-valued expression
  drivers/video/nvidia/nv_accel.c:323:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/nvidia/nv_accel.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

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
-- 
1.5.6.3

