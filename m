Return-Path: <linux-kernel-owner+w=401wt.eu-S1762436AbYD2UcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762436AbYD2UcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 16:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYD2Ub4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 16:31:56 -0400
Received: from naru.obs2.net ([84.20.150.76]:45454 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756757AbYD2Uby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:31:54 -0400
Date: Tue, 29 Apr 2008 23:08:53 +0300
From: Riku Voipio <riku.voipio@iki.fi>
To: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       buytenh@wantstofly.org, tbm@cyrius.com
Subject: [PATCH] Add pca9532 platform data for Thecus N2100
Message-ID: <20080429200853.GB20889@kos.to>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thecus N2100 has leds and a buzzer attached to a pca9532
controller. Attach the driver to the i2c bus and define
the pca9532 pin coniguration for this platform in n2100_leds.

With this patch, support for N2100 should be complete in mainline
Linux.

Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
---
 arch/arm/mach-iop32x/n2100.c |   52 ++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
index bc91d6e..029d234 100644
--- a/arch/arm/mach-iop32x/n2100.c
+++ b/arch/arm/mach-iop32x/n2100.c
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 #include <linux/f75375s.h>
+#include <linux/leds-pca9532.h>
 #include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -206,6 +207,53 @@ static struct f75375s_platform_data n2100_f75375s = {
 	.pwm_enable = { 0, 0 },
 };
 
+static struct pca9532_platform_data n2100_leds = {
+	.leds = {
+	{	.name = "n2100:red:satafail0",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:red:satafail1",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:blue:usb",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{ 	.type = PCA9532_TYPE_NONE },
+
+	{ 	.type = PCA9532_TYPE_NONE },
+	{ 	.type = PCA9532_TYPE_NONE },
+	{ 	.type = PCA9532_TYPE_NONE },
+	{	.name = "n2100:red:usb",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+
+	{	.type = PCA9532_TYPE_NONE }, /* power OFF gpio */
+	{	.type = PCA9532_TYPE_NONE }, /* reset gpio */
+	{	.type = PCA9532_TYPE_NONE },
+	{	.type = PCA9532_TYPE_NONE },
+
+	{	.type = PCA9532_TYPE_NONE },
+	{	.name = "n2100:orange:system",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "n2100:red:system",
+		.state = PCA9532_OFF,
+		.type = PCA9532_TYPE_LED,
+	},
+	{	.name = "N2100 beeper"  ,
+		.state =  PCA9532_OFF,
+		.type = PCA9532_TYPE_N2100_BEEP,
+	},
+	},
+	.psc = { 0, 0 },
+	.pwm = { 0, 0 },
+};
+
 static struct i2c_board_info __initdata n2100_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("rtc-rs5c372", 0x32),
@@ -216,6 +264,10 @@ static struct i2c_board_info __initdata n2100_i2c_devices[] = {
 		.type = "f75375",
 		.platform_data = &n2100_f75375s,
 	},
+	{
+		I2C_BOARD_INFO("pca9532", 0x60),
+		.platform_data = &n2100_leds,
+	},
 };
 
 /*
-- 
1.5.4.5


-- 
"rm -rf" only sounds scary if you don't have backups
