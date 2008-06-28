Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYF2FDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYF2FDh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 01:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751405AbYF2FDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 01:03:17 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:26937 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751071AbYF2FDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 01:03:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=eqxpTWGs92se5LasWAacwfc6AZXgbapMkksL3AO6k1wT+YIsXYjTkhrSiJw+14v7qj9w6CpKIfLcPqmV0tZBwGW3NHdrKf5RFhUWkYkeHt9yk1bRki+umLYyHUJMQAg8P4lP7HLcXhbijCkivTDV3F5sKpTXvDIyAhVW2MKpdDY=  ;
X-YMail-OSG: A_HzGLIVM1mvbexXjbps9uW9a0L8TZSgJg6nGpH0AXL6itW47n4W3er9LDxV6AC7plgibbvh4sEJFwhpuLS.wkf04mNpvB8C9eGPmNsndW35UpeeRhk8OVuhxSAFhSi59GU-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 2.6.26-rc8] gpio: pca953x (i2c) handles max7310 too
Date: Fri, 27 Jun 2008 18:37:05 -0700
User-Agent: KMail/1.9.9
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806271837.05296.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pca953x driver can handle another 8-bit I/O expander, the
max7310.  This patch adds that chip to the list of supported IDs
in that driver, and expands the Kconfig helptext accordingly.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Yes:  the max7310 is I2C, the max7310 is SPI.
Almost like they're trying to spread confusion...

 drivers/gpio/Kconfig   |   14 ++++++++++----
 drivers/gpio/pca953x.c |    2 +-
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpio/Kconfig	2008-06-18 19:40:30.000000000 -0700
+++ b/drivers/gpio/Kconfig	2008-06-18 19:48:04.000000000 -0700
@@ -43,12 +43,18 @@ config GPIO_SYSFS
 comment "I2C GPIO expanders:"
 
 config GPIO_PCA953X
-	tristate "PCA953x I/O ports"
+	tristate "PCA953x, PCA955x, and MAX7310 I/O ports"
 	depends on I2C
 	help
-	  Say yes here to support the PCA9534 (8-bit), PCA9535 (16-bit),
-	  PCA9536 (4-bit), PCA9537 (4-bit), PCA9538 (8-bit), and PCA9539
-	  (16-bit) I/O ports. These parts are made by NXP and TI.
+	  Say yes here to provide access to several register-oriented
+	  SMBus I/O expanders, made mostly by NXP or TI.  Compatible
+	  models include:
+
+	  4 bits:	pca9536, pca9537
+
+	  8 bits:	max7310, pca9534, pca9538, pca9554, pca9557
+
+	  16 bits:	pca9535, pca9539, pca9555
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca953x.
--- a/drivers/gpio/pca953x.c	2008-06-18 19:08:22.000000000 -0700
+++ b/drivers/gpio/pca953x.c	2008-06-18 19:08:30.000000000 -0700
@@ -33,7 +33,7 @@ static const struct i2c_device_id pca953
 	{ "pca9554", 8, },
 	{ "pca9555", 16, },
 	{ "pca9557", 8, },
-	/* REVISIT several pca955x parts should work here too */
+	{ "max7310", 8, },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, pca953x_id);
