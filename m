Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbZFGNKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbZFGNKW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 09:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbZFGNHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 09:07:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:1307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756537AbZFGNH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 09:07:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=BEBmi5xnegR2O427lXzEJXjoalrVX8VKY4eKrutNZH1je5Kwb3+ozuJovJWYuU5Fu7
         hJ1E1UQEMbD9KbLs2AuDUGCcfN/6Cb4J+BIZ/qE/xZz51/qNM1xylgzgkj417MTdNXIJ
         jgZlgg6yZ0jFBr/MKQe+kMnOlGoVxwoF4jqac=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: ben-linux@fluff.org, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Cc: wookey@wookware.org, Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] serial: samsung.c: mark s3c24xx_serial_remove as __devexit
Date: Sun,  7 Jun 2009 15:07:15 +0200
Message-Id: <1244380035-23717-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the remove function as __devexit so it gets eliminated in
CONFIG_HOTPLUG=n builds. Saves ~100 bytes.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/serial/s3c2400.c |    2 +-
 drivers/serial/s3c2410.c |    2 +-
 drivers/serial/s3c2412.c |    2 +-
 drivers/serial/s3c2440.c |    2 +-
 drivers/serial/s3c24a0.c |    2 +-
 drivers/serial/s3c6400.c |    2 +-
 drivers/serial/samsung.c |    2 +-
 drivers/serial/samsung.h |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/serial/s3c2400.c b/drivers/serial/s3c2400.c
index 4873f29..fb00ed5 100644
--- a/drivers/serial/s3c2400.c
+++ b/drivers/serial/s3c2400.c
@@ -78,7 +78,7 @@ static int s3c2400_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2400_serial_drv = {
 	.probe		= s3c2400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2400-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2410.c b/drivers/serial/s3c2410.c
index 87c182e..b5d7cbc 100644
--- a/drivers/serial/s3c2410.c
+++ b/drivers/serial/s3c2410.c
@@ -90,7 +90,7 @@ static int s3c2410_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2410_serial_drv = {
 	.probe		= s3c2410_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2410-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2412.c b/drivers/serial/s3c2412.c
index fd017b3..11dcb90 100644
--- a/drivers/serial/s3c2412.c
+++ b/drivers/serial/s3c2412.c
@@ -123,7 +123,7 @@ static int s3c2412_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2412_serial_drv = {
 	.probe		= s3c2412_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2412-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c2440.c b/drivers/serial/s3c2440.c
index 29cbb0a..06c5b0c 100644
--- a/drivers/serial/s3c2440.c
+++ b/drivers/serial/s3c2440.c
@@ -153,7 +153,7 @@ static int s3c2440_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c2440_serial_drv = {
 	.probe		= s3c2440_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c2440-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c24a0.c b/drivers/serial/s3c24a0.c
index ebf2fd3..786a067 100644
--- a/drivers/serial/s3c24a0.c
+++ b/drivers/serial/s3c24a0.c
@@ -94,7 +94,7 @@ static int s3c24a0_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c24a0_serial_drv = {
 	.probe		= s3c24a0_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c24a0-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/s3c6400.c b/drivers/serial/s3c6400.c
index 3e37852..48f1a37 100644
--- a/drivers/serial/s3c6400.c
+++ b/drivers/serial/s3c6400.c
@@ -124,7 +124,7 @@ static int s3c6400_serial_probe(struct platform_device *dev)
 
 static struct platform_driver s3c6400_serial_drv = {
 	.probe		= s3c6400_serial_probe,
-	.remove		= s3c24xx_serial_remove,
+	.remove		= __devexit_p(s3c24xx_serial_remove),
 	.driver		= {
 		.name	= "s3c6400-uart",
 		.owner	= THIS_MODULE,
diff --git a/drivers/serial/samsung.c b/drivers/serial/samsung.c
index 93b5d75..c8851a0 100644
--- a/drivers/serial/samsung.c
+++ b/drivers/serial/samsung.c
@@ -1174,7 +1174,7 @@ int s3c24xx_serial_probe(struct platform_device *dev,
 
 EXPORT_SYMBOL_GPL(s3c24xx_serial_probe);
 
-int s3c24xx_serial_remove(struct platform_device *dev)
+int __devexit s3c24xx_serial_remove(struct platform_device *dev)
 {
 	struct uart_port *port = s3c24xx_dev_to_port(&dev->dev);
 
diff --git a/drivers/serial/samsung.h b/drivers/serial/samsung.h
index 7afb948..d3fe315 100644
--- a/drivers/serial/samsung.h
+++ b/drivers/serial/samsung.h
@@ -72,7 +72,7 @@ struct s3c24xx_uart_port {
 extern int s3c24xx_serial_probe(struct platform_device *dev,
 				struct s3c24xx_uart_info *uart);
 
-extern int s3c24xx_serial_remove(struct platform_device *dev);
+extern int __devexit s3c24xx_serial_remove(struct platform_device *dev);
 
 extern int s3c24xx_serial_initconsole(struct platform_driver *drv,
 				      struct s3c24xx_uart_info *uart);
-- 
1.6.2

