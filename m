Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZAGQnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZAGQnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 11:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760315AbZAGQmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 11:42:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:63955 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbZAGQmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 11:42:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=c6Bn1rByYndL7tU4uF9zzFelrdVugp/kGASPD10trBYYMD03de+P8se9/BNtNdvaW1
         gBeNqyZvgJiYuKAWzquPJwQR1/Y6N0Gb5lWfHRwSaSMnR3aCUwIdWqG9aqvfhuu2e1OM
         EmsTJs4I8zIETB/PbgDoDpmm1+pM/iXXB+e6A=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] video/framebuffer: fix bug: jpegview cannot work on framebuffer device other than 16BPP
Date: Thu,  8 Jan 2009 00:43:35 +0800
Message-Id: <1231346615-28958-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Force fb_var_screeninfo color format on all Blackfin Framebuffer Drivers.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/video/bf54x-lq043fb.c    |   15 ++++++++++++++-
 drivers/video/bfin-t350mcqb-fb.c |   15 ++++++++++++++-
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 7644ed2..37e60b1 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -335,7 +335,20 @@ static int bfin_bf54x_fb_check_var(struct fb_var_screeninfo *var,
 				   struct fb_info *info)
 {
 
-	if (var->bits_per_pixel != LCD_BPP) {
+	switch (var->bits_per_pixel) {
+	case 24:/* TRUECOLOUR, 16m */
+		var->red.offset = 16;
+		var->green.offset = 8;
+		var->blue.offset = 0;
+		var->red.length = var->green.length = var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->transp.msb_right = 0;
+		var->red.msb_right = 0;
+		var->green.msb_right = 0;
+		var->blue.msb_right = 0;
+		break;
+	default:
 		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index a9b3ada..2a423d3 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -254,7 +254,20 @@ static int bfin_t350mcqb_fb_check_var(struct fb_var_screeninfo *var,
 				   struct fb_info *info)
 {
 
-	if (var->bits_per_pixel != LCD_BPP) {
+	switch (var->bits_per_pixel) {
+	case 24:/* TRUECOLOUR, 16m */
+		var->red.offset = 0;
+		var->green.offset = 8;
+		var->blue.offset = 16;
+		var->red.length = var->green.length = var->blue.length = 8;
+		var->transp.offset = 0;
+		var->transp.length = 0;
+		var->transp.msb_right = 0;
+		var->red.msb_right = 0;
+		var->green.msb_right = 0;
+		var->blue.msb_right = 0;
+		break;
+	default:
 		pr_debug("%s: depth not supported: %u BPP\n", __func__,
 			 var->bits_per_pixel);
 		return -EINVAL;
-- 
1.5.6

