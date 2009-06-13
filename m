Return-Path: <linux-kernel-owner+w=401wt.eu-S934234AbZFMA4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934234AbZFMA4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 20:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbZFMAzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 20:55:49 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58680 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132AbZFMAzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 20:55:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] fbdev: *bfin*: fix __dev{init,exit} markings
Date: Fri, 12 Jun 2009 20:55:35 -0400
Message-Id: <1244854536-2367-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
References: <1244854536-2367-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The remove member of the platform_driver bfin_t350mcqb_driver should use
__devexit_p() to refer to the remove function, and that function should
get __devexit markings.  Likewise, the probe function should be marked
with __devinit and not __init.

Also, module_init() functions should be marked with __init rather than
__devinit.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/bf54x-lq043fb.c    |    8 ++++----
 drivers/video/bfin-t350mcqb-fb.c |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 6439a43..8aa67de 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -529,7 +529,7 @@ static irqreturn_t bfin_bf54x_irq_error(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_bf54x_probe(struct platform_device *pdev)
+static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 {
 	struct bfin_bf54xfb_info *info;
 	struct fb_info *fbinfo;
@@ -709,7 +709,7 @@ out1:
 	return ret;
 }
 
-static int bfin_bf54x_remove(struct platform_device *pdev)
+static int __devexit bfin_bf54x_remove(struct platform_device *pdev)
 {
 
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
@@ -778,7 +778,7 @@ static int bfin_bf54x_resume(struct platform_device *pdev)
 
 static struct platform_driver bfin_bf54x_driver = {
 	.probe = bfin_bf54x_probe,
-	.remove = bfin_bf54x_remove,
+	.remove = __devexit_p(bfin_bf54x_remove),
 	.suspend = bfin_bf54x_suspend,
 	.resume = bfin_bf54x_resume,
 	.driver = {
@@ -787,7 +787,7 @@ static struct platform_driver bfin_bf54x_driver = {
 		   },
 };
 
-static int __devinit bfin_bf54x_driver_init(void)
+static int __init bfin_bf54x_driver_init(void)
 {
 	return platform_driver_register(&bfin_bf54x_driver);
 }
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index f40eef8..5cc36cf 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -599,7 +599,7 @@ out1:
 	return ret;
 }
 
-static int bfin_t350mcqb_remove(struct platform_device *pdev)
+static int __devexit bfin_t350mcqb_remove(struct platform_device *pdev)
 {
 
 	struct fb_info *fbinfo = platform_get_drvdata(pdev);
@@ -655,7 +655,7 @@ static int bfin_t350mcqb_resume(struct platform_device *pdev)
 
 static struct platform_driver bfin_t350mcqb_driver = {
 	.probe = bfin_t350mcqb_probe,
-	.remove = bfin_t350mcqb_remove,
+	.remove = __devexit_p(bfin_t350mcqb_remove),
 	.suspend = bfin_t350mcqb_suspend,
 	.resume = bfin_t350mcqb_resume,
 	.driver = {
@@ -664,7 +664,7 @@ static struct platform_driver bfin_t350mcqb_driver = {
 		   },
 };
 
-static int __devinit bfin_t350mcqb_driver_init(void)
+static int __init bfin_t350mcqb_driver_init(void)
 {
 	return platform_driver_register(&bfin_t350mcqb_driver);
 }
-- 
1.6.3.1

