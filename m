Return-Path: <linux-kernel-owner+w=401wt.eu-S934433AbZFMA5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934433AbZFMA5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760415AbZFMAzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58682 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbZFMAzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:48 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] fbdev: bf54x-lq043fb: use kzalloc over kmalloc/memset
Date: Fri, 12 Jun 2009 20:55:36 -0400
Message-Id: <1244854536-2367-6-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
References: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bf54x-lq043fb.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 8aa67de..e49ae5e 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -630,7 +630,7 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 
 	fbinfo->fbops = &bfin_bf54x_fb_ops;
 
-	fbinfo->pseudo_palette = kmalloc(sizeof(u32) * 16, GFP_KERNEL);
+	fbinfo->pseudo_palette = kzalloc(sizeof(u32) * 16, GFP_KERNEL);
 	if (!fbinfo->pseudo_palette) {
 		printk(KERN_ERR DRIVER_NAME
 		       "Fail to allocate pseudo_palette\n");
@@ -639,8 +639,6 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 		goto out4;
 	}
 
-	memset(fbinfo->pseudo_palette, 0, sizeof(u32) * 16);
-
 	if (fb_alloc_cmap(&fbinfo->cmap, BFIN_LCD_NBR_PALETTE_ENTRIES, 0)
 	    < 0) {
 		printk(KERN_ERR DRIVER_NAME
-- 
1.6.3.1

