Return-Path: <linux-kernel-owner+w=401wt.eu-S1763971AbZFRPNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763971AbZFRPNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 11:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760453AbZFRPNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 11:13:09 -0400
Received: from mail.atmel.fr ([81.80.104.162]:38462 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761719AbZFRPNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 11:13:07 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: avictor.za@gmail.com, linux-arm-kernel@lists.arm.linux.org.uk
Cc: patrice.vilchez@atmel.com, linux-kernel@vger.kernel.org,
       Hong Xu <hong.xu@atmel.com>
Subject: [PATCH 5/5] at91/atmel_lcdfb: add at91sam9g10 support to atmel LCD driver
Date: Thu, 18 Jun 2009 18:16:12 +0200
Message-Id: <1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hong Xu <hong.xu@atmel.com>

Modify atmel LCD driver: atmel_lcdfb for at91sam9g10.  This add a clock
management equivalent to at91sam9261.

Signed-off-by: Hong Xu <hong.xu@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/video/Kconfig           |    4 ++--
 drivers/video/atmel_lcdfb.c     |    6 ++++--
 drivers/video/backlight/Kconfig |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 5152168..2dbede4 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -933,7 +933,7 @@ config FB_S1D13XXX
 
 config FB_ATMEL
 	tristate "AT91/AT32 LCD Controller support"
-	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
+	depends on FB && (ARCH_AT91SAM9261 || ARCH_AT91SAM9G10 || ARCH_AT91SAM9263 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45 || ARCH_AT91CAP9 || AVR32)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
@@ -949,7 +949,7 @@ config FB_INTSRAM
 
 config FB_ATMEL_STN
 	bool "Use a STN display with AT91/AT32 LCD Controller"
-	depends on FB_ATMEL && MACH_AT91SAM9261EK
+	depends on FB_ATMEL && (MACH_AT91SAM9261EK || MACH_AT91SAM9G10EK)
 	default n
 	help
 	  Say Y if you want to connect a STN LCD display to the AT91/AT32 LCD
diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 9a577a8..fc10ac5 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -188,7 +188,8 @@ static unsigned long compute_hozval(unsigned long xres, unsigned long lcdcon2)
 {
 	unsigned long value;
 
-	if (!(cpu_is_at91sam9261() || cpu_is_at32ap7000()))
+	if (!(cpu_is_at91sam9261() || cpu_is_at91sam9g10()
+		|| cpu_is_at32ap7000()))
 		return xres;
 
 	value = xres;
@@ -827,7 +828,8 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 	info->fix = atmel_lcdfb_fix;
 
 	/* Enable LCDC Clocks */
-	if (cpu_is_at91sam9261() || cpu_is_at32ap7000()) {
+	if (cpu_is_at91sam9261() || cpu_is_at91sam9g10()
+	 || cpu_is_at32ap7000()) {
 		sinfo->bus_clk = clk_get(dev, "hck1");
 		if (IS_ERR(sinfo->bus_clk)) {
 			ret = PTR_ERR(sinfo->bus_clk);
diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index f9d19be..90861cd 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -110,7 +110,7 @@ config BACKLIGHT_CLASS_DEVICE
 config BACKLIGHT_ATMEL_LCDC
 	bool "Atmel LCDC Contrast-as-Backlight control"
 	depends on BACKLIGHT_CLASS_DEVICE && FB_ATMEL
-	default y if MACH_SAM9261EK || MACH_SAM9263EK
+	default y if MACH_SAM9261EK || MACH_SAM9G10EK || MACH_SAM9263EK
 	help
 	  This provides a backlight control internal to the Atmel LCDC
 	  driver.  If the LCD "contrast control" on your board is wired
-- 
1.5.3.7

