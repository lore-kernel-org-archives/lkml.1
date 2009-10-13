Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbZJMHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbZJMHS2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933616AbZJMHS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:18:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:55301 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933624AbZJMHS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:18:26 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: spi-devel-general@lists.sourceforge.net,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] spidev: add proper section markers
Date: Tue, 13 Oct 2009 03:17:48 -0400
Message-Id: <1255418268-29575-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver already uses __devexit_p() in the structure, but looks like
actual __dev{init,exit} markings were forgotten.

The spidev_spi driver also needs renaming to include a "_driver" suffix
to avoid section mismatch warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/spi/spidev.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 5d23983..f31467b 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -561,7 +561,7 @@ static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
-static int spidev_probe(struct spi_device *spi)
+static int __devinit spidev_probe(struct spi_device *spi)
 {
 	struct spidev_data	*spidev;
 	int			status;
@@ -610,7 +610,7 @@ static int spidev_probe(struct spi_device *spi)
 	return status;
 }
 
-static int spidev_remove(struct spi_device *spi)
+static int __devexit spidev_remove(struct spi_device *spi)
 {
 	struct spidev_data	*spidev = spi_get_drvdata(spi);
 
@@ -632,7 +632,7 @@ static int spidev_remove(struct spi_device *spi)
 	return 0;
 }
 
-static struct spi_driver spidev_spi = {
+static struct spi_driver spidev_spi_driver = {
 	.driver = {
 		.name =		"spidev",
 		.owner =	THIS_MODULE,
@@ -664,14 +664,14 @@ static int __init spidev_init(void)
 
 	spidev_class = class_create(THIS_MODULE, "spidev");
 	if (IS_ERR(spidev_class)) {
-		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 		return PTR_ERR(spidev_class);
 	}
 
-	status = spi_register_driver(&spidev_spi);
+	status = spi_register_driver(&spidev_spi_driver);
 	if (status < 0) {
 		class_destroy(spidev_class);
-		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 	}
 	return status;
 }
@@ -679,9 +679,9 @@ module_init(spidev_init);
 
 static void __exit spidev_exit(void)
 {
-	spi_unregister_driver(&spidev_spi);
+	spi_unregister_driver(&spidev_spi_driver);
 	class_destroy(spidev_class);
-	unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+	unregister_chrdev(SPIDEV_MAJOR, spidev_spi_driver.driver.name);
 }
 module_exit(spidev_exit);
 
-- 
1.6.5

