Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZGYMxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZGYMxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 08:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbZGYMxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 08:53:34 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:53641 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZGYMxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 08:53:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=fOuioiH/IAqAMwkd8yMsYdqjQa5mBTKTG8RKpFa6xMsv4P82j8kGoYDl30aS2r2gRt
         6hYgBSJ2xaxaTe7Tm8WPga9KpF/EslUjuWVNxH9w+JFdmTcVIqd9Dq83LGZnpAPgSX6j
         MVia3Qn80KRMBMA8XijWImxEELuZXxG68Osns=
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: [PATCH] net: irda: smsc-ircc2: switch driver to dev_pm_ops
Date: Sat, 25 Jul 2009 08:47:27 -0400
Message-Id: <1248526047-18017-1-git-send-email-arnaud.faucher@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'smsc-ircc2' needs updating - please use dev_pm_ops

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/net/irda/smsc-ircc2.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/irda/smsc-ircc2.c b/drivers/net/irda/smsc-ircc2.c
index d0797ad..0e216fe 100644
--- a/drivers/net/irda/smsc-ircc2.c
+++ b/drivers/net/irda/smsc-ircc2.c
@@ -250,14 +250,18 @@ static int  smsc_ircc_probe_transceiver_smsc_ircc_atc(int fir_base);
 
 /* Power Management */
 
-static int smsc_ircc_suspend(struct platform_device *dev, pm_message_t state);
-static int smsc_ircc_resume(struct platform_device *dev);
+static int smsc_ircc_suspend(struct device *dev);
+static int smsc_ircc_resume(struct device *dev);
 
-static struct platform_driver smsc_ircc_driver = {
+static struct dev_pm_ops smsc_ircc_pm_ops = {
 	.suspend	= smsc_ircc_suspend,
 	.resume		= smsc_ircc_resume,
+};
+
+static struct platform_driver smsc_ircc_driver = {
 	.driver		= {
 		.name	= SMSC_IRCC2_DRIVER_NAME,
+		.pm	= &smsc_ircc_pm_ops,
 	},
 };
 
@@ -1782,9 +1786,9 @@ static int smsc_ircc_net_close(struct net_device *dev)
 	return 0;
 }
 
-static int smsc_ircc_suspend(struct platform_device *dev, pm_message_t state)
+static int smsc_ircc_suspend(struct device *dev)
 {
-	struct smsc_ircc_cb *self = platform_get_drvdata(dev);
+	struct smsc_ircc_cb *self = dev_get_drvdata(dev);
 
 	if (!self->io.suspended) {
 		IRDA_DEBUG(1, "%s, Suspending\n", driver_name);
@@ -1803,9 +1807,9 @@ static int smsc_ircc_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int smsc_ircc_resume(struct platform_device *dev)
+static int smsc_ircc_resume(struct device *dev)
 {
-	struct smsc_ircc_cb *self = platform_get_drvdata(dev);
+	struct smsc_ircc_cb *self = dev_get_drvdata(dev);
 
 	if (self->io.suspended) {
 		IRDA_DEBUG(1, "%s, Waking up\n", driver_name);
-- 
1.6.3.3

