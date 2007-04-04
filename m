Return-Path: <linux-kernel-owner+w=401wt.eu-S966248AbXDDSUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966248AbXDDSUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422717AbXDDSTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:19:55 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39830 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100AbXDDSNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:48 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 77/90] ARM: OMAP: Add apollon gpio keys using gpio-keys input
Date: Wed,  4 Apr 2007 14:05:56 -0400
Message-Id: <11757101803962-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101783149-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Add apollon gpio keys using gpio-keys input

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/Makefile             |    3 +-
 arch/arm/mach-omap2/board-apollon-keys.c |   79 ++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/board-apollon.c      |   53 --------------------
 3 files changed, 81 insertions(+), 54 deletions(-)

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 60373f5..31993f3 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -19,7 +19,8 @@ mailbox_mach-objs	:= mailbox.o
 obj-$(CONFIG_MACH_OMAP_GENERIC)		+= board-generic.o
 obj-$(CONFIG_MACH_OMAP_H4)		+= board-h4.o
 obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o
-obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
+obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o \
+					   board-apollon-keys.o
 obj-$(CONFIG_MACH_NOKIA_N800)		+= board-n800.o board-n800-flash.o \
 					   board-n800-mmc.o board-n800-bt.o \
 					   board-n800-audio.o board-n800-usb.o \
diff --git a/arch/arm/mach-omap2/board-apollon-keys.c b/arch/arm/mach-omap2/board-apollon-keys.c
new file mode 100644
index 0000000..6cd29ec
--- /dev/null
+++ b/arch/arm/mach-omap2/board-apollon-keys.c
@@ -0,0 +1,79 @@
+/*
+ * linux/arch/arm/mach-omap2/board-apollon-keys.c
+ *
+ * Copyright (C) 2007 Samsung Electronics
+ * Author: Kyungmin Park <kyungmin.park@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/gpio_keys.h>
+
+#include <asm/arch/gpio.h>
+#include <asm/arch/mux.h>
+
+#define SW_ENTER_GPIO16		16
+#define SW_UP_GPIO17		17
+#define SW_DOWN_GPIO58		58
+
+static struct gpio_keys_button apollon_gpio_keys_buttons[] = {
+	[0] = {
+		.keycode	= KEY_ENTER,
+		.gpio		= SW_ENTER_GPIO16,
+		.desc		= "enter sw",
+	},
+	[1] = {
+		.keycode	= KEY_UP,
+		.gpio		= SW_UP_GPIO17,
+		.desc		= "up sw",
+	},
+	[2] = {
+		.keycode	= KEY_DOWN,
+		.gpio		= SW_DOWN_GPIO58,
+		.desc		= "down sw",
+	},
+};
+
+static struct gpio_keys_platform_data apollon_gpio_keys = {
+	.buttons		= apollon_gpio_keys_buttons,
+	.nbuttons		= ARRAY_SIZE(apollon_gpio_keys_buttons),
+};
+
+static struct platform_device apollon_gpio_keys_device = {
+	.name			= "gpio-keys",
+	.id			= -1,
+	.dev			= {
+		.platform_data	= &apollon_gpio_keys,
+	},
+};
+
+static void __init apollon_sw_init(void)
+{
+	/* Enter SW - Y11 */
+	omap_cfg_reg(Y11_242X_GPIO16);
+	omap_request_gpio(SW_ENTER_GPIO16);
+	omap_set_gpio_direction(SW_ENTER_GPIO16, 1);
+	/* Up SW - AA12 */
+	omap_cfg_reg(AA12_242X_GPIO17);
+	omap_request_gpio(SW_UP_GPIO17);
+	omap_set_gpio_direction(SW_UP_GPIO17, 1);
+	/* Down SW - AA8 */
+	omap_cfg_reg(AA8_242X_GPIO58);
+	omap_request_gpio(SW_DOWN_GPIO58);
+	omap_set_gpio_direction(SW_DOWN_GPIO58, 1);
+}
+
+static int __init omap_apollon_keys_init(void)
+{
+	apollon_sw_init();
+
+	return platform_device_register(&apollon_gpio_keys_device);
+}
+
+arch_initcall(omap_apollon_keys_init);
diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index 5488961..9e6dd0b 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -22,11 +22,8 @@
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/onenand.h>
-#include <linux/irq.h>
-#include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/leds.h>
-#include <linux/irq.h>
 #include <linux/err.h>
 #include <linux/clk.h>
 
@@ -48,9 +45,6 @@
 #define LED0_GPIO13		13
 #define LED1_GPIO14		14
 #define LED2_GPIO15		15
-#define SW_ENTER_GPIO16		16
-#define SW_UP_GPIO17		17
-#define SW_DOWN_GPIO58		58
 
 #define APOLLON_FLASH_CS	0
 #define APOLLON_ETH_CS		1
@@ -302,52 +296,6 @@ static void __init apollon_led_init(void)
 	omap_set_gpio_dataout(LED2_GPIO15, 0);
 }
 
-static irqreturn_t apollon_sw_interrupt(int irq, void *ignored)
-{
-	static unsigned int led0, led1, led2;
-
-	if (irq == OMAP_GPIO_IRQ(SW_ENTER_GPIO16))
-		omap_set_gpio_dataout(LED0_GPIO13, led0 ^= 1);
-	else if (irq == OMAP_GPIO_IRQ(SW_UP_GPIO17))
-		omap_set_gpio_dataout(LED1_GPIO14, led1 ^= 1);
-	else if (irq == OMAP_GPIO_IRQ(SW_DOWN_GPIO58))
-		omap_set_gpio_dataout(LED2_GPIO15, led2 ^= 1);
-
-	return IRQ_HANDLED;
-}
-
-static void __init apollon_sw_init(void)
-{
-	/* Enter SW - Y11 */
-	omap_cfg_reg(Y11_242X_GPIO16);
-	omap_request_gpio(SW_ENTER_GPIO16);
-	omap_set_gpio_direction(SW_ENTER_GPIO16, 1);
-	/* Up SW - AA12 */
-	omap_cfg_reg(AA12_242X_GPIO17);
-	omap_request_gpio(SW_UP_GPIO17);
-	omap_set_gpio_direction(SW_UP_GPIO17, 1);
-	/* Down SW - AA8 */
-	omap_cfg_reg(AA8_242X_GPIO58);
-	omap_request_gpio(SW_DOWN_GPIO58);
-	omap_set_gpio_direction(SW_DOWN_GPIO58, 1);
-
-	set_irq_type(OMAP_GPIO_IRQ(SW_ENTER_GPIO16), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_ENTER_GPIO16), &apollon_sw_interrupt,
-				IRQF_SHARED, "enter sw",
-				&apollon_sw_interrupt))
-		return;
-	set_irq_type(OMAP_GPIO_IRQ(SW_UP_GPIO17), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_UP_GPIO17), &apollon_sw_interrupt,
-				IRQF_SHARED, "up sw",
-				&apollon_sw_interrupt))
-		return;
-	set_irq_type(OMAP_GPIO_IRQ(SW_DOWN_GPIO58), IRQT_RISING);
-	if (request_irq(OMAP_GPIO_IRQ(SW_DOWN_GPIO58), &apollon_sw_interrupt,
-				IRQF_SHARED, "down sw",
-				&apollon_sw_interrupt))
-		return;
-}
-
 static void __init apollon_usb_init(void)
 {
 	/* USB device */
@@ -361,7 +309,6 @@ static void __init apollon_usb_init(void)
 static void __init omap_apollon_init(void)
 {
 	apollon_led_init();
-	apollon_sw_init();
 	apollon_flash_init();
 	apollon_usb_init();
 
-- 
1.4.4.2

