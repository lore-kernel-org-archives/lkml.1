Return-Path: <linux-kernel-owner+w=401wt.eu-S1763886AbXJNSis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763886AbXJNSis (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761087AbXJNSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:36:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60297 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761382AbXJNSgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:36:12 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] ibm_newemac annotations (iomem, NULL noise)
Cc: linux-kernel@vger.kernel.org, jgarzik@pobox.com
Message-Id: <E1Ih8Ju-00044Z-7l@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 14 Oct 2007 19:36:10 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/ibm_newemac/core.c  |    2 +-
 drivers/net/ibm_newemac/rgmii.c |   12 ++++++------
 drivers/net/ibm_newemac/tah.c   |    4 ++--
 drivers/net/ibm_newemac/zmii.c  |    4 ++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 8ea5009..c90c937 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -1950,7 +1950,7 @@ static u32 emac_ethtool_get_rx_csum(struct net_device *ndev)
 {
 	struct emac_instance *dev = netdev_priv(ndev);
 
-	return dev->tah_dev != 0;
+	return dev->tah_dev != NULL;
 }
 
 static int emac_get_regs_len(struct emac_instance *dev)
diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
index 3f57d6c..de41695 100644
--- a/drivers/net/ibm_newemac/rgmii.c
+++ b/drivers/net/ibm_newemac/rgmii.c
@@ -84,7 +84,7 @@ static inline u32 rgmii_mode_mask(int mode, int input)
 int __devinit rgmii_attach(struct of_device *ofdev, int input, int mode)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs *p = dev->base;
+	struct rgmii_regs __iomem *p = dev->base;
 
 	RGMII_DBG(dev, "attach(%d)" NL, input);
 
@@ -113,7 +113,7 @@ int __devinit rgmii_attach(struct of_device *ofdev, int input, int mode)
 void rgmii_set_speed(struct of_device *ofdev, int input, int speed)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs *p = dev->base;
+	struct rgmii_regs __iomem *p = dev->base;
 	u32 ssr;
 
 	mutex_lock(&dev->lock);
@@ -135,7 +135,7 @@ void rgmii_set_speed(struct of_device *ofdev, int input, int speed)
 void rgmii_get_mdio(struct of_device *ofdev, int input)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs *p = dev->base;
+	struct rgmii_regs __iomem *p = dev->base;
 	u32 fer;
 
 	RGMII_DBG2(dev, "get_mdio(%d)" NL, input);
@@ -156,7 +156,7 @@ void rgmii_get_mdio(struct of_device *ofdev, int input)
 void rgmii_put_mdio(struct of_device *ofdev, int input)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs *p = dev->base;
+	struct rgmii_regs __iomem *p = dev->base;
 	u32 fer;
 
 	RGMII_DBG2(dev, "put_mdio(%d)" NL, input);
@@ -177,7 +177,7 @@ void rgmii_put_mdio(struct of_device *ofdev, int input)
 void __devexit rgmii_detach(struct of_device *ofdev, int input)
 {
 	struct rgmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct rgmii_regs *p = dev->base;
+	struct rgmii_regs __iomem *p = dev->base;
 
 	mutex_lock(&dev->lock);
 
@@ -242,7 +242,7 @@ static int __devinit rgmii_probe(struct of_device *ofdev,
 	}
 
 	rc = -ENOMEM;
-	dev->base = (struct rgmii_regs *)ioremap(regs.start,
+	dev->base = (struct rgmii_regs __iomem *)ioremap(regs.start,
 						 sizeof(struct rgmii_regs));
 	if (dev->base == NULL) {
 		printk(KERN_ERR "%s: Can't map device registers!\n",
diff --git a/drivers/net/ibm_newemac/tah.c b/drivers/net/ibm_newemac/tah.c
index e05c7e8..f161fb1 100644
--- a/drivers/net/ibm_newemac/tah.c
+++ b/drivers/net/ibm_newemac/tah.c
@@ -42,7 +42,7 @@ void __devexit tah_detach(struct of_device *ofdev, int channel)
 void tah_reset(struct of_device *ofdev)
 {
 	struct tah_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct tah_regs *p = dev->base;
+	struct tah_regs __iomem *p = dev->base;
 	int n;
 
 	/* Reset TAH */
@@ -108,7 +108,7 @@ static int __devinit tah_probe(struct of_device *ofdev,
 	}
 
 	rc = -ENOMEM;
-	dev->base = (struct tah_regs *)ioremap(regs.start,
+	dev->base = (struct tah_regs __iomem *)ioremap(regs.start,
 					       sizeof(struct tah_regs));
 	if (dev->base == NULL) {
 		printk(KERN_ERR "%s: Can't map device registers!\n",
diff --git a/drivers/net/ibm_newemac/zmii.c b/drivers/net/ibm_newemac/zmii.c
index d063129..2219ec2 100644
--- a/drivers/net/ibm_newemac/zmii.c
+++ b/drivers/net/ibm_newemac/zmii.c
@@ -79,7 +79,7 @@ static inline u32 zmii_mode_mask(int mode, int input)
 int __devinit zmii_attach(struct of_device *ofdev, int input, int *mode)
 {
 	struct zmii_instance *dev = dev_get_drvdata(&ofdev->dev);
-	struct zmii_regs *p = dev->base;
+	struct zmii_regs __iomem *p = dev->base;
 
 	ZMII_DBG(dev, "init(%d, %d)" NL, input, *mode);
 
@@ -250,7 +250,7 @@ static int __devinit zmii_probe(struct of_device *ofdev,
 	}
 
 	rc = -ENOMEM;
-	dev->base = (struct zmii_regs *)ioremap(regs.start,
+	dev->base = (struct zmii_regs __iomem *)ioremap(regs.start,
 						sizeof(struct zmii_regs));
 	if (dev->base == NULL) {
 		printk(KERN_ERR "%s: Can't map device registers!\n",
-- 
1.5.3.GIT

