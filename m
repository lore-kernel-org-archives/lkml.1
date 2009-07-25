Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbZGYQ5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbZGYQ5W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZGYQ5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:57:21 -0400
Received: from mail-yx0-f198.google.com ([209.85.210.198]:35119 "EHLO
	mail-yx0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbZGYQ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:57:21 -0400
X-Greylist: delayed 14986 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Jul 2009 12:57:21 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=R72Ej5+wH0/FeS6lhQ6NfZleLx+ZDeZkoE6YsocuzvXFOJ9t29eFPy8C3it9nvLdgl
         ylsHZsXxGnKU1nM2hmiy6cZhcOMca3wwuxbG8BNhruQsXlyFHyDnfaltZ3hcXmketmgh
         liIWybk50Xw5+XlQIsbUKxlAsBa9LZoN5ZXso=
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: [PATCH] net: irda: ali-ircc: switch driver to dev_pm_ops
Date: Sat, 25 Jul 2009 12:57:13 -0400
Message-Id: <1248541033-24639-1-git-send-email-arnaud.faucher@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'ali-ircc' needs updating - please use dev_pm_ops

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/net/irda/ali-ircc.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/irda/ali-ircc.c b/drivers/net/irda/ali-ircc.c
index ad17955..4ddc478 100644
--- a/drivers/net/irda/ali-ircc.c
+++ b/drivers/net/irda/ali-ircc.c
@@ -52,15 +52,19 @@
 #define ALI_IRCC_DRIVER_NAME "ali-ircc"
 
 /* Power Management */
-static int ali_ircc_suspend(struct platform_device *dev, pm_message_t state);
-static int ali_ircc_resume(struct platform_device *dev);
+static int ali_ircc_suspend(struct device *dev);
+static int ali_ircc_resume(struct device *dev);
 
-static struct platform_driver ali_ircc_driver = {
+static struct dev_pm_ops ali_ircc_pm_ops = {
 	.suspend	= ali_ircc_suspend,
 	.resume		= ali_ircc_resume,
+};
+
+static struct platform_driver ali_ircc_driver = {
 	.driver		= {
 		.name	= ALI_IRCC_DRIVER_NAME,
 		.owner	= THIS_MODULE,
+		.pm	= &ali_ircc_pm_ops,
 	},
 };
 
@@ -2120,9 +2124,9 @@ static int ali_ircc_is_receiving(struct ali_ircc_cb *self)
 	return status;
 }
 
-static int ali_ircc_suspend(struct platform_device *dev, pm_message_t state)
+static int ali_ircc_suspend(struct device *dev)
 {
-	struct ali_ircc_cb *self = platform_get_drvdata(dev);
+	struct ali_ircc_cb *self = dev_get_drvdata(dev);
 	
 	IRDA_MESSAGE("%s, Suspending\n", ALI_IRCC_DRIVER_NAME);
 
@@ -2136,9 +2140,9 @@ static int ali_ircc_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int ali_ircc_resume(struct platform_device *dev)
+static int ali_ircc_resume(struct device *dev)
 {
-	struct ali_ircc_cb *self = platform_get_drvdata(dev);
+	struct ali_ircc_cb *self = dev_get_drvdata(dev);
 	
 	if (!self->io.suspended)
 		return 0;
-- 
1.6.3.3

