Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbXLSIpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbXLSIpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXLSIpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:45:04 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:10705 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbXLSIpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:45:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wJeaaSkxcf3lFoDyDKWssnNRYOPn8Ruk9fTVLqO+X1tgBaW457jIdsaYbgkAO9Qc272954Eo6rpVQhaKGT4+tcpKHb1XpFlarROu6zsVFjB2dHztSUybSoCkhQcRQR/FggYSbc3RA+FniygXS2XEpNNa/nDGaWi5xg6Yfth6Jc0=
Message-ID: <f17812d70712190045m1542fc04x34e471daf02df1bf@mail.gmail.com>
Date: Wed, 19 Dec 2007 16:45:00 +0800
From: "eric miao" <eric.y.miao@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [PATCH 2.6.24-rc5-mm 3/3] gpiolib: obsolete drivers/i2c/chips/pca9539.c
Cc: "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org, bgardner@wabtec.com
In-Reply-To: <20071218154004.738e7894@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70712142016q73abffc2w99174c40f847152c@mail.gmail.com>
	 <20071216204214.01fd7a16@hyperion.delvare>
	 <f17812d70712162233h759432a9i15b8e12d1a5fb828@mail.gmail.com>
	 <20071217180953.1BB8E16AF21@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <20071217212953.260f7826@hyperion.delvare>
	 <f17812d70712171754q3b71a39dl7d17f5d9e5b8014c@mail.gmail.com>
	 <20071218154004.738e7894@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated as follows, the driver name is left unchanged, while
Kconfig and Documentation are modified so that
1. mark it as deprecated
2. exclusive selection of SENSOR_PCA9539 and GPIO_PCA9539

>From c58dc1119355dc94d80763aef9d9bc999abda6df Mon Sep 17 00:00:00 2001
From: eric miao <eric.miao@marvell.com>
Date: Wed, 19 Dec 2007 16:40:04 +0800
Subject: [PATCH] gpiolib: mark drivers/i2c/chips/pca9539.c as deprecated

use drivers/gpio/pca9539.c instead.

Signed-off-by: eric miao <eric.miao@marvell.com>
Acked-by: Ben Gardner <bgardner@wabtec.com>
---
 Documentation/i2c/chips/pca9539 |    3 +++
 drivers/i2c/chips/Kconfig       |    7 +++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/i2c/chips/pca9539 b/Documentation/i2c/chips/pca9539
index c4fce6a..1d81c53 100644
--- a/Documentation/i2c/chips/pca9539
+++ b/Documentation/i2c/chips/pca9539
@@ -1,6 +1,9 @@
 Kernel driver pca9539
 =====================

+NOTE: this driver is deprecated and will be dropped soon, use
+drivers/gpio/pca9539.c instead.
+
 Supported chips:
   * Philips PCA9539
     Prefix: 'pca9539'
diff --git a/drivers/i2c/chips/Kconfig b/drivers/i2c/chips/Kconfig
index 2e1c24f..54fd302 100644
--- a/drivers/i2c/chips/Kconfig
+++ b/drivers/i2c/chips/Kconfig
@@ -66,8 +66,8 @@ config SENSORS_PCF8574
 	  hardware.  If unsure, say N.

 config SENSORS_PCA9539
-	tristate "Philips PCA9539 16-bit I/O port"
-	depends on EXPERIMENTAL
+	tristate "Philips PCA9539 16-bit I/O port (DEPRECATED)"
+	depends on EXPERIMENTAL && !GPIO_PCA9539
 	help
 	  If you say yes here you get support for the Philips PCA9539
 	  16-bit I/O port.
@@ -75,6 +75,9 @@ config SENSORS_PCA9539
 	  This driver can also be built as a module.  If so, the module
 	  will be called pca9539.

+	  This driver is deprecated and will be dropped soon. Use
+	  drivers/gpio/pca9539.c instead.
+
 config SENSORS_PCF8591
 	tristate "Philips PCF8591"
 	depends on EXPERIMENTAL
-- 
1.5.2.5.GIT

Cheers
- eric
