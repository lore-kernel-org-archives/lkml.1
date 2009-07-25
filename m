Return-Path: <linux-kernel-owner+w=401wt.eu-S1751522AbZGYR23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbZGYR23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 13:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZGYR22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 13:28:28 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:37221 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGYR21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 13:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BclYhi3PcSA/AtGjuHysNFTAUAbsAfScsCMBOviJfemDMsKjtUABrSBTSuLll7hjBh
         H/+xs099vo1TEZUPDNSG5ZuRVLiV8Fga/XM5MiiA/bdCdyBoBjZnU6QUlBAP3UILuWnj
         eUwSpiJ20KYNV19jcstlvO80ax3uDQJre9ync=
From: Arnaud Faucher <arnaud.faucher@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: [PATCH] net: irda: nsc-ircc: switch driver to dev_pm_ops
Date: Sat, 25 Jul 2009 13:28:23 -0400
Message-Id: <1248542903-31232-1-git-send-email-arnaud.faucher@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets rid of the following warning:
Platform driver 'nsc-ircc' needs updating - please use dev_pm_ops

Signed-off-by: Arnaud Faucher <arnaud.faucher@gmail.com>
---
 drivers/net/irda/nsc-ircc.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/irda/nsc-ircc.c b/drivers/net/irda/nsc-ircc.c
index 45fd9c1..c56946a 100644
--- a/drivers/net/irda/nsc-ircc.c
+++ b/drivers/net/irda/nsc-ircc.c
@@ -74,14 +74,18 @@ static char *driver_name = "nsc-ircc";
 
 /* Power Management */
 #define NSC_IRCC_DRIVER_NAME                  "nsc-ircc"
-static int nsc_ircc_suspend(struct platform_device *dev, pm_message_t state);
-static int nsc_ircc_resume(struct platform_device *dev);
+static int nsc_ircc_suspend(struct device *dev);
+static int nsc_ircc_resume(struct device *dev);
 
-static struct platform_driver nsc_ircc_driver = {
+static struct dev_pm_ops nsc_ircc_pm_ops = {
 	.suspend	= nsc_ircc_suspend,
 	.resume		= nsc_ircc_resume,
+};
+
+static struct platform_driver nsc_ircc_driver = {
 	.driver		= {
 		.name	= NSC_IRCC_DRIVER_NAME,
+		.pm	= &nsc_ircc_pm_ops,
 	},
 };
 
@@ -2316,9 +2320,9 @@ static int nsc_ircc_net_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	return ret;
 }
 
-static int nsc_ircc_suspend(struct platform_device *dev, pm_message_t state)
+static int nsc_ircc_suspend(struct device *dev)
 {
-     	struct nsc_ircc_cb *self = platform_get_drvdata(dev);
+	struct nsc_ircc_cb *self = dev_get_drvdata(dev);
  	int bank;
 	unsigned long flags;
  	int iobase = self->io.fir_base;
@@ -2352,9 +2356,9 @@ static int nsc_ircc_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int nsc_ircc_resume(struct platform_device *dev)
+static int nsc_ircc_resume(struct device *dev)
 {
- 	struct nsc_ircc_cb *self = platform_get_drvdata(dev);
+	struct nsc_ircc_cb *self = dev_get_drvdata(dev);
  	unsigned long flags;
 
 	if (!self->io.suspended)
-- 
1.6.3.3

