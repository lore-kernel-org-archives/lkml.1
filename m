Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbYGQKyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbYGQKyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYGQKyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:54:05 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:50246 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755229AbYGQKyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:54:04 -0400
Subject: MMC: s3cmci.c fixes for section mismatch warnings
Message-Id: <20080717105401.187834638@fluff.org.uk>
User-Agent: quilt/0.46-1
From: Ben Dooks <ben-linux@fluff.org>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben-linux@fluff.org>
Content-Disposition: inline; filename=simtec/simtec-mmc-fix-section-mismatch.patch
Date: Thu, 17 Jul 2008 11:54:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the naming of various functions in the s3cmc
driver to stop triggering section mismatch warnings.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>

Index: linux-2.6.26-quilt2/drivers/mmc/host/s3cmci.c
===================================================================
--- linux-2.6.26-quilt2.orig/drivers/mmc/host/s3cmci.c	2008-07-15 22:00:55.000000000 +0100
+++ linux-2.6.26-quilt2/drivers/mmc/host/s3cmci.c	2008-07-15 22:04:05.000000000 +0100
@@ -1355,17 +1355,17 @@ static int __devexit s3cmci_remove(struc
 	return 0;
 }
 
-static int __devinit s3cmci_probe_2410(struct platform_device *dev)
+static int __devinit s3cmci_2410_probe(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 0);
 }
 
-static int __devinit s3cmci_probe_2412(struct platform_device *dev)
+static int __devinit s3cmci_2412_probe(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 1);
 }
 
-static int __devinit s3cmci_probe_2440(struct platform_device *dev)
+static int __devinit s3cmci_2440_probe(struct platform_device *dev)
 {
 	return s3cmci_probe(dev, 1);
 }
@@ -1392,28 +1392,28 @@ static int s3cmci_resume(struct platform
 #endif /* CONFIG_PM */
 
 
-static struct platform_driver s3cmci_driver_2410 = {
+static struct platform_driver s3cmci_2410_driver = {
 	.driver.name	= "s3c2410-sdi",
 	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_probe_2410,
+	.probe		= s3cmci_2410_probe,
 	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2412 = {
+static struct platform_driver s3cmci_2412_driver = {
 	.driver.name	= "s3c2412-sdi",
 	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_probe_2412,
+	.probe		= s3cmci_2412_probe,
 	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
 };
 
-static struct platform_driver s3cmci_driver_2440 = {
+static struct platform_driver s3cmci_2440_driver = {
 	.driver.name	= "s3c2440-sdi",
 	.driver.owner	= THIS_MODULE,
-	.probe		= s3cmci_probe_2440,
+	.probe		= s3cmci_2440_probe,
 	.remove		= __devexit_p(s3cmci_remove),
 	.suspend	= s3cmci_suspend,
 	.resume		= s3cmci_resume,
@@ -1422,17 +1422,17 @@ static struct platform_driver s3cmci_dri
 
 static int __init s3cmci_init(void)
 {
-	platform_driver_register(&s3cmci_driver_2410);
-	platform_driver_register(&s3cmci_driver_2412);
-	platform_driver_register(&s3cmci_driver_2440);
+	platform_driver_register(&s3cmci_2410_driver);
+	platform_driver_register(&s3cmci_2412_driver);
+	platform_driver_register(&s3cmci_2440_driver);
 	return 0;
 }
 
 static void __exit s3cmci_exit(void)
 {
-	platform_driver_unregister(&s3cmci_driver_2410);
-	platform_driver_unregister(&s3cmci_driver_2412);
-	platform_driver_unregister(&s3cmci_driver_2440);
+	platform_driver_unregister(&s3cmci_2410_driver);
+	platform_driver_unregister(&s3cmci_2412_driver);
+	platform_driver_unregister(&s3cmci_2440_driver);
 }
 
 module_init(s3cmci_init);

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
