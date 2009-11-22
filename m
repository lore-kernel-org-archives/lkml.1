Return-Path: <linux-kernel-owner+w=401wt.eu-S1755266AbZKVQCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266AbZKVQCm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbZKVQCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:02:42 -0500
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:58313 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbZKVQCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:02:41 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4B0960CD.7020302@cam.ac.uk>
Date: Sun, 22 Nov 2009 16:03:25 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20091029)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Amit Kucheria <amit.kucheria@verdurent.com>
Subject: [PATCH 2/2] Staging: IIO: Add tsl2560-2 support to tsl2563 driver.
References: <4B06EA3B.10500@cam.ac.uk> <20091120191739.GA16233@suse.de> <4B096002.6060702@cam.ac.uk>
In-Reply-To: <4B096002.6060702@cam.ac.uk>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
Minimal changes to driver. Just adds the device to the id
table and adjusts the Kconfig elements appropriately.

Adding further similar chips from TAOS is complicated by their
different conversion functions (and hence left for now).

 drivers/staging/iio/light/Kconfig   |    6 +++---
 drivers/staging/iio/light/tsl2563.c |   11 ++++++-----
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index ab54191..80cb6e5 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -4,11 +4,11 @@
 comment "Light sensors"
 
 config SENSORS_TSL2563
-	tristate "TAOS TSL2563 ambient light sensor"
+	tristate "TAOS TSL256[0-3] ambient light sensor"
 	depends on I2C
 	help
-	 If you say yes here you get support for the Taos TSL2563
-	 ambient light sensor (found in N900).
+	 If you say yes here you get support for the Taos TSL2560,
+	 TSL2561, TSL2562 and TSL2563 ambient light sensors.
 
 	 This driver can also be built as a module.  If so, the module
 	 will be called tsl2563.
diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 3e812b2..78b9432 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -38,8 +38,6 @@
 #include "../iio.h"
 #include "tsl2563.h"
 
-#define DRIVER_NAME  "tsl2563"
-
 /* Use this many bits for fraction part. */
 #define ADC_FRAC_BITS		(14)
 
@@ -738,14 +736,17 @@ out:
 }
 
 static const struct i2c_device_id tsl2563_id[] = {
-	{ DRIVER_NAME, 0 },
-	{ },
+	{ "tsl2560", 0 },
+	{ "tsl2561", 1 },
+	{ "tsl2562", 2 },
+	{ "tsl2563", 3 },
+	{}
 };
 MODULE_DEVICE_TABLE(i2c, tsl2563_id);
 
 static struct i2c_driver tsl2563_i2c_driver = {
 	.driver = {
-		.name	 = DRIVER_NAME,
+		.name	 = "tsl2563",
 	},
 	.suspend	= tsl2563_suspend,
 	.resume		= tsl2563_resume,
-- 
1.6.4.4

