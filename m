Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbYK1UN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbYK1UN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYK1UNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:13:17 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:5072 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYK1UNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:13:16 -0500
To: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 18:16:20 +0100
Subject: [PATCH] pm3fb: fix sparse warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <493050da.02e2660a.5173.ffffbf69@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:

  drivers/video/pm3fb.c:543:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/pm3fb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

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
1.5.6.3

