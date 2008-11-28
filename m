Return-Path: <linux-kernel-owner+w=401wt.eu-S1752635AbYK1UMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbYK1UMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 15:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbYK1UMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 15:12:44 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:63345 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYK1UMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 15:12:43 -0500
To: Joseph Chan <JosephChan@via.com.tw>
Cc: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Cc: trivial@kernel.org
Date: Fri, 28 Nov 2008 17:18:40 +0100
Subject: [PATCH] viafb: fix sparse warnings
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <493050b9.0aa1660a.74cd.ffffb85a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warnings:

  drivers/video/via/viafbdev.c:871:3: warning: returning void-valued expression
  drivers/video/via/viafbdev.c:938:3: warning: returning void-valued expression
  drivers/video/via/viafbdev.c:995:3: warning: returning void-valued expression

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/video/via/viafbdev.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 73ac754..243fde6 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -867,8 +867,10 @@ static void viafb_fillrect(struct fb_info *info,
 	u32 col = 0, rop = 0;
 	int pitch;
 
-	if (!viafb_accel)
-		return cfb_fillrect(info, rect);
+	if (!viafb_accel) {
+		cfb_fillrect(info, rect);
+		return;
+	}
 
 	if (!rect->width || !rect->height)
 		return;
@@ -934,8 +936,10 @@ static void viafb_copyarea(struct fb_info *info,
 
 	DEBUG_MSG(KERN_INFO "viafb_copyarea!!\n");
 
-	if (!viafb_accel)
-		return cfb_copyarea(info, area);
+	if (!viafb_accel) {
+		cfb_copyarea(info, area);
+		return;
+	}
 
 	if (!area->width || !area->height)
 		return;
@@ -991,8 +995,10 @@ static void viafb_imageblit(struct fb_info *info,
 	int i;
 	int pitch;
 
-	if (!viafb_accel)
-		return cfb_imageblit(info, image);
+	if (!viafb_accel) {
+		cfb_imageblit(info, image);
+		return;
+	}
 
 	udata = (u32 *) image->data;
 
-- 
1.5.6.3

