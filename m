Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbZHMKR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbZHMKR3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbZHMKR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:17:28 -0400
Received: from smtprelay09.ispgateway.de ([80.67.31.32]:60908 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZHMKR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:17:27 -0400
Date: Thu, 13 Aug 2009 12:17:22 +0200
From: Peter Feuerer <peter@piie.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>,
       lenb@kernel.org, Andreas Mohr <andi@lisas.de>,
       Peter Feuerer <peter@piie.net>
Subject: [PATCH 1/2] acerhdf: convert to dev_pm_ops
Message-Id: <20090813121722.48988dfc.peter@piie.net>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Df-Sender: 650477
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acerhdf: convert to dev_pm_ops

v 1.1:
Add .freeze func ptr to support suspend-to-disk,
as suggested by Dmitry Torokhov.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Peter Feuerer <peter@piie.net>
Cc: Andreas Mohr <andi@lisas.de>
Cc: Len Brown <lenb@kernel.org>
---
 drivers/platform/x86/acerhdf.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
index aa298d6..8ff5639 100644
--- a/drivers/platform/x86/acerhdf.c
+++ b/drivers/platform/x86/acerhdf.c
@@ -52,7 +52,7 @@
  */
 #undef START_IN_KERNEL_MODE
 
-#define DRV_VER "0.5.16"
+#define DRV_VER "0.5.17"
 
 /*
  * According to the Atom N270 datasheet,
@@ -435,7 +435,7 @@ struct thermal_cooling_device_ops acerhdf_cooling_ops = {
 };
 
 /* suspend / resume functionality */
-static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
+static int acerhdf_suspend(struct device *dev)
 {
 	if (kernelmode)
 		acerhdf_change_fanstate(ACERHDF_FAN_AUTO);
@@ -446,14 +446,6 @@ static int acerhdf_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int acerhdf_resume(struct platform_device *device)
-{
-	if (verbose)
-		pr_notice("resuming\n");
-
-	return 0;
-}
-
 static int __devinit acerhdf_probe(struct platform_device *device)
 {
 	return 0;
@@ -464,15 +456,19 @@ static int acerhdf_remove(struct platform_device *device)
 	return 0;
 }
 
+static struct dev_pm_ops acerhdf_pm_ops = {
+	.suspend = acerhdf_suspend,
+	.freeze  = acerhdf_suspend,
+};
+
 static struct platform_driver acerhdf_driver = {
 	.driver = {
-		.name = "acerhdf",
+		.name  = "acerhdf",
 		.owner = THIS_MODULE,
+		.pm    = &acerhdf_pm_ops,
 	},
 	.probe = acerhdf_probe,
 	.remove = acerhdf_remove,
-	.suspend = acerhdf_suspend,
-	.resume = acerhdf_resume,
 };
 
 
-- 
1.6.4



-- 
Peter Feuerer <peter@piie.net>
