Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbXL2EH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbXL2EH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbXL2EEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:48 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21957 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755433AbXL2EEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=mr0fvnGUfWc5XMKfKt6x0XzGRFygElE8L676rejclbOIFF5qDwjlF5n6neEPiOwTI5ucbCBOuWNHQrzy++n+2WCg5KEIutuFtk3fuqqx0ChfrrxN1Pnjss5CdNDjmKjDKnvijlxYnQjIzSzCCJmtECX0Vr1GQOYyUyaNeT4ckyg=  ;
X-YMail-OSG: ywtUF_kVM1krlbjThF0j8IdXsdBtLz3vUOe5h53qletCvw6cX_JvObdUvVW6Bt9aqcanDBwJNg--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 9/9] gpiolib: deprecate obsolete pca9539 driver
Date: Fri, 28 Dec 2007 19:59:49 -0800
User-Agent: KMail/1.9.6
Cc: Jean Delvare <khali@linux-fr.org>, eric miao <eric.y.miao@gmail.com>,
       Ben Gardner <bgardner@wabtec.com>
References: <200712281927.32575.david-b@pacbell.net>
In-Reply-To: <200712281927.32575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281959.50000.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: eric miao <eric.miao@marvell.com>

Use drivers/gpio/pca9539.c instead.

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 Documentation/i2c/chips/pca9539 |    3 +++
 drivers/i2c/chips/Kconfig       |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- at91.orig/Documentation/i2c/chips/pca9539
+++ at91/Documentation/i2c/chips/pca9539
@@ -1,6 +1,9 @@
 Kernel driver pca9539
 =====================
 
+NOTE: this driver is deprecated and will be dropped soon, use
+drivers/gpio/pca9539.c instead.
+
 Supported chips:
   * Philips PCA9539
     Prefix: 'pca9539'
--- at91.orig/drivers/i2c/chips/Kconfig
+++ at91/drivers/i2c/chips/Kconfig
@@ -92,8 +92,8 @@ config SENSORS_PCF8574
 	  hardware.  If unsure, say N.
 
 config SENSORS_PCA9539
-	tristate "Philips PCA9539 16-bit I/O port"
-	depends on EXPERIMENTAL
+	tristate "Philips PCA9539 16-bit I/O port (DEPRECATED)"
+	depends on EXPERIMENTAL && GPIO_PCA9539 = "n"
 	help
 	  If you say yes here you get support for the Philips PCA9539
 	  16-bit I/O port.
@@ -101,6 +101,9 @@ config SENSORS_PCA9539
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca9539.
 
+	  This driver is deprecated and will be dropped soon. Use
+	  drivers/gpio/pca9539.c instead.
+
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
 	depends on EXPERIMENTAL
