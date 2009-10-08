Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbZJHGFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbZJHGFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754502AbZJHGFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34590 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbZJHGFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:37 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 07/13] Blackfin: convert adv7393 resources to new i2c framework
Date: Thu,  8 Oct 2009 02:04:23 -0400
Message-Id: <1254981869-21586-8-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Now that the driver has been updated, convert the board resources to the
new i2c framework for managing slaves.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf527/boards/cm_bf527.c |   15 +++++----------
 arch/blackfin/mach-bf527/boards/ezkit.c    |   15 +++++----------
 arch/blackfin/mach-bf533/boards/ezkit.c    |   21 +++++++++++----------
 arch/blackfin/mach-bf533/boards/stamp.c    |   15 +++++----------
 arch/blackfin/mach-bf537/boards/stamp.c    |   15 +++++----------
 5 files changed, 31 insertions(+), 50 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 0c6d292..1c4f9e2 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -595,12 +595,6 @@ static struct platform_device bfin_spi0_device = {
 };
 #endif  /* spi master and devices */
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
 #if defined(CONFIG_MTD_GPIO_ADDR) || defined(CONFIG_MTD_GPIO_ADDR_MODULE)
 static struct mtd_partition cm_partitions[] = {
 	{
@@ -765,6 +759,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = IRQ_PF8,
 	},
 #endif
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	{
+		I2C_BOARD_INFO("bfin-adv7393", 0x2B),
+	},
+#endif
 };
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
@@ -888,10 +887,6 @@ static struct platform_device *cmbf527_devices[] __initdata = {
 	&bfin_spi0_device,
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index b7574b4..9fbdebe 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -694,12 +694,6 @@ static struct platform_device bfin_fb_device = {
 };
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 static struct resource bfin_uart_resources[] = {
 #ifdef CONFIG_SERIAL_BFIN_UART0
@@ -815,6 +809,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = IRQ_PF8,
 	},
 #endif
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	{
+		I2C_BOARD_INFO("bfin-adv7393", 0x2B),
+	},
+#endif
 };
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
@@ -979,10 +978,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bf52x_t350mcqb_device,
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 64816b0..9ffcd63 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -17,6 +17,7 @@
 #include <linux/usb/isp1362.h>
 #endif
 #include <linux/irq.h>
+#include <linux/i2c.h>
 #include <asm/dma.h>
 #include <asm/bfin5xx_spi.h>
 #include <asm/portmux.h>
@@ -34,12 +35,6 @@ static struct platform_device rtc_device = {
 };
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
 /*
  *  USB-LAN EzExtender board
  *  Driver needs to know address, irq and flag pin.
@@ -438,6 +433,14 @@ static struct platform_device bfin_dpmc = {
 	},
 };
 
+static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	{
+		I2C_BOARD_INFO("bfin-adv7393", 0x2B),
+	},
+#endif
+};
+
 static struct platform_device *ezkit_devices[] __initdata = {
 
 	&bfin_dpmc,
@@ -460,10 +463,6 @@ static struct platform_device *ezkit_devices[] __initdata = {
 	&bfin_spi0_device,
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
 #if defined(CONFIG_RTC_DRV_BFIN) || defined(CONFIG_RTC_DRV_BFIN_MODULE)
 	&rtc_device,
 #endif
@@ -494,6 +493,8 @@ static int __init ezkit_init(void)
 	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
+	i2c_register_board_info(0, bfin_i2c_board_info,
+				ARRAY_SIZE(bfin_i2c_board_info));
 	return 0;
 }
 
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index 1a995d1..ff1fd93 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -73,12 +73,6 @@ static struct platform_device smc91x_device = {
 };
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
 #if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
 static struct resource net2272_bfin_resources[] = {
 	{
@@ -465,6 +459,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.irq = 39,
 	},
 #endif
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	{
+		I2C_BOARD_INFO("bfin-adv7393", 0x2B),
+	},
+#endif
 };
 
 static const unsigned int cclk_vlev_datasheet[] =
@@ -506,10 +505,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&smc91x_device,
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
 #if defined(CONFIG_USB_NET2272) || defined(CONFIG_USB_NET2272_MODULE)
 	&net2272_bfin_device,
 #endif
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 1cb72a8..3091a14 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1056,12 +1056,6 @@ static struct platform_device bfin_fb_device = {
 };
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-static struct platform_device bfin_fb_adv7393_device = {
-	.name = "bfin-adv7393",
-};
-#endif
-
 #if defined(CONFIG_FB_BFIN_LQ035Q1) || defined(CONFIG_FB_BFIN_LQ035Q1_MODULE)
 #include <asm/bfin-lq035q1.h>
 
@@ -1476,6 +1470,11 @@ static struct i2c_board_info __initdata bfin_i2c_board_info[] = {
 		.platform_data = (void *)&adp5588_gpio_data,
 	},
 #endif
+#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
+	{
+		I2C_BOARD_INFO("bfin-adv7393", 0x2B),
+	},
+#endif
 };
 
 #if defined(CONFIG_SERIAL_BFIN_SPORT) || defined(CONFIG_SERIAL_BFIN_SPORT_MODULE)
@@ -1646,10 +1645,6 @@ static struct platform_device *stamp_devices[] __initdata = {
 	&bfin_lq035q1_device,
 #endif
 
-#if defined(CONFIG_FB_BFIN_7393) || defined(CONFIG_FB_BFIN_7393_MODULE)
-	&bfin_fb_adv7393_device,
-#endif
-
 #if defined(CONFIG_SERIAL_BFIN) || defined(CONFIG_SERIAL_BFIN_MODULE)
 	&bfin_uart_device,
 #endif
-- 
1.6.5.rc2

