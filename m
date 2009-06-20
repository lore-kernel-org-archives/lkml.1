Return-Path: <linux-kernel-owner+w=401wt.eu-S1760655AbZFTBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655AbZFTBUu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbZFTBSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:17 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39139 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753252AbZFTBSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:18:03 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: fJKITqAVM1kaDhPFaMxj1t8GN44ZltmXQpwNCW0I_35pBcd_V7UX4f_HcQYOzOndCCAtqqhzJzcYeouS5H2ZhPgwthLY5Rka8I4zKss_WHomOYFeuJtwVpvui9h5FqkMV45xN3TmmLMkca9c.eZVQtwUbPKgpgYfrSmgtAKQagQHvJ.El5_nhkkcrHrwjonkkpvIojZwu144k6oyzTg2AI0ia2oIKS2jlYzqILFAfvmvVz4xTKtLsAo42BnVODeu4tfIgoWKkqZueVlEg0CeBWMyUdEnFjMGwsTT5n1PXUV14v6HfBtX4z79CL2aH0gdjLfwABEz.avKNct.ffyH6cnjO8.S9f4uS.fbCVhyOrYLOtAUB.O2pI8-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 11/13] generic GPIO support for the Freescale Coldfire 532x.
Date: Fri, 19 Jun 2009 18:11:10 -0700
Message-Id: <1245460272-4329-12-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-11-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-9-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-10-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-11-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 532x.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m532xsim.h      |  154 ++++++++-------
 arch/m68knommu/platform/532x/Makefile |    2 +-
 arch/m68knommu/platform/532x/config.c |    4 +-
 arch/m68knommu/platform/532x/gpio.c   |  337 +++++++++++++++++++++++++++++++++
 4 files changed, 424 insertions(+), 73 deletions(-)
 create mode 100644 arch/m68knommu/platform/532x/gpio.c

diff --git a/arch/m68k/include/asm/m532xsim.h b/arch/m68k/include/asm/m532xsim.h
index ce60345..931cf5f 100644
--- a/arch/m68k/include/asm/m532xsim.h
+++ b/arch/m68k/include/asm/m532xsim.h
@@ -410,70 +410,70 @@
  *********************************************************************/
 
 /* Register read/write macros */
-#define MCF_GPIO_PODR_FECH		MCF_REG08(0xFC0A4000)
-#define MCF_GPIO_PODR_FECL		MCF_REG08(0xFC0A4001)
-#define MCF_GPIO_PODR_SSI		MCF_REG08(0xFC0A4002)
-#define MCF_GPIO_PODR_BUSCTL		MCF_REG08(0xFC0A4003)
-#define MCF_GPIO_PODR_BE		MCF_REG08(0xFC0A4004)
-#define MCF_GPIO_PODR_CS		MCF_REG08(0xFC0A4005)
-#define MCF_GPIO_PODR_PWM		MCF_REG08(0xFC0A4006)
-#define MCF_GPIO_PODR_FECI2C		MCF_REG08(0xFC0A4007)
-#define MCF_GPIO_PODR_UART		MCF_REG08(0xFC0A4009)
-#define MCF_GPIO_PODR_QSPI		MCF_REG08(0xFC0A400A)
-#define MCF_GPIO_PODR_TIMER		MCF_REG08(0xFC0A400B)
-#define MCF_GPIO_PODR_LCDDATAH		MCF_REG08(0xFC0A400D)
-#define MCF_GPIO_PODR_LCDDATAM		MCF_REG08(0xFC0A400E)
-#define MCF_GPIO_PODR_LCDDATAL		MCF_REG08(0xFC0A400F)
-#define MCF_GPIO_PODR_LCDCTLH		MCF_REG08(0xFC0A4010)
-#define MCF_GPIO_PODR_LCDCTLL		MCF_REG08(0xFC0A4011)
-#define MCF_GPIO_PDDR_FECH		MCF_REG08(0xFC0A4014)
-#define MCF_GPIO_PDDR_FECL		MCF_REG08(0xFC0A4015)
-#define MCF_GPIO_PDDR_SSI		MCF_REG08(0xFC0A4016)
-#define MCF_GPIO_PDDR_BUSCTL		MCF_REG08(0xFC0A4017)
-#define MCF_GPIO_PDDR_BE		MCF_REG08(0xFC0A4018)
-#define MCF_GPIO_PDDR_CS		MCF_REG08(0xFC0A4019)
-#define MCF_GPIO_PDDR_PWM		MCF_REG08(0xFC0A401A)
-#define MCF_GPIO_PDDR_FECI2C		MCF_REG08(0xFC0A401B)
-#define MCF_GPIO_PDDR_UART		MCF_REG08(0xFC0A401C)
-#define MCF_GPIO_PDDR_QSPI		MCF_REG08(0xFC0A401E)
-#define MCF_GPIO_PDDR_TIMER		MCF_REG08(0xFC0A401F)
-#define MCF_GPIO_PDDR_LCDDATAH		MCF_REG08(0xFC0A4021)
-#define MCF_GPIO_PDDR_LCDDATAM		MCF_REG08(0xFC0A4022)
-#define MCF_GPIO_PDDR_LCDDATAL		MCF_REG08(0xFC0A4023)
-#define MCF_GPIO_PDDR_LCDCTLH		MCF_REG08(0xFC0A4024)
-#define MCF_GPIO_PDDR_LCDCTLL		MCF_REG08(0xFC0A4025)
-#define MCF_GPIO_PPDSDR_FECH		MCF_REG08(0xFC0A4028)
-#define MCF_GPIO_PPDSDR_FECL		MCF_REG08(0xFC0A4029)
-#define MCF_GPIO_PPDSDR_SSI		MCF_REG08(0xFC0A402A)
-#define MCF_GPIO_PPDSDR_BUSCTL		MCF_REG08(0xFC0A402B)
-#define MCF_GPIO_PPDSDR_BE		MCF_REG08(0xFC0A402C)
-#define MCF_GPIO_PPDSDR_CS		MCF_REG08(0xFC0A402D)
-#define MCF_GPIO_PPDSDR_PWM		MCF_REG08(0xFC0A402E)
-#define MCF_GPIO_PPDSDR_FECI2C		MCF_REG08(0xFC0A402F)
-#define MCF_GPIO_PPDSDR_UART		MCF_REG08(0xFC0A4031)
-#define MCF_GPIO_PPDSDR_QSPI		MCF_REG08(0xFC0A4032)
-#define MCF_GPIO_PPDSDR_TIMER		MCF_REG08(0xFC0A4033)
-#define MCF_GPIO_PPDSDR_LCDDATAH	MCF_REG08(0xFC0A4035)
-#define MCF_GPIO_PPDSDR_LCDDATAM	MCF_REG08(0xFC0A4036)
-#define MCF_GPIO_PPDSDR_LCDDATAL	MCF_REG08(0xFC0A4037)
-#define MCF_GPIO_PPDSDR_LCDCTLH		MCF_REG08(0xFC0A4038)
-#define MCF_GPIO_PPDSDR_LCDCTLL		MCF_REG08(0xFC0A4039)
-#define MCF_GPIO_PCLRR_FECH		MCF_REG08(0xFC0A403C)
-#define MCF_GPIO_PCLRR_FECL		MCF_REG08(0xFC0A403D)
-#define MCF_GPIO_PCLRR_SSI		MCF_REG08(0xFC0A403E)
-#define MCF_GPIO_PCLRR_BUSCTL		MCF_REG08(0xFC0A403F)
-#define MCF_GPIO_PCLRR_BE		MCF_REG08(0xFC0A4040)
-#define MCF_GPIO_PCLRR_CS		MCF_REG08(0xFC0A4041)
-#define MCF_GPIO_PCLRR_PWM		MCF_REG08(0xFC0A4042)
-#define MCF_GPIO_PCLRR_FECI2C		MCF_REG08(0xFC0A4043)
-#define MCF_GPIO_PCLRR_UART		MCF_REG08(0xFC0A4045)
-#define MCF_GPIO_PCLRR_QSPI		MCF_REG08(0xFC0A4046)
-#define MCF_GPIO_PCLRR_TIMER		MCF_REG08(0xFC0A4047)
-#define MCF_GPIO_PCLRR_LCDDATAH		MCF_REG08(0xFC0A4049)
-#define MCF_GPIO_PCLRR_LCDDATAM		MCF_REG08(0xFC0A404A)
-#define MCF_GPIO_PCLRR_LCDDATAL		MCF_REG08(0xFC0A404B)
-#define MCF_GPIO_PCLRR_LCDCTLH		MCF_REG08(0xFC0A404C)
-#define MCF_GPIO_PCLRR_LCDCTLL		MCF_REG08(0xFC0A404D)
+#define MCFGPIO_PODR_FECH		(0xFC0A4000)
+#define MCFGPIO_PODR_FECL		(0xFC0A4001)
+#define MCFGPIO_PODR_SSI		(0xFC0A4002)
+#define MCFGPIO_PODR_BUSCTL		(0xFC0A4003)
+#define MCFGPIO_PODR_BE			(0xFC0A4004)
+#define MCFGPIO_PODR_CS			(0xFC0A4005)
+#define MCFGPIO_PODR_PWM		(0xFC0A4006)
+#define MCFGPIO_PODR_FECI2C		(0xFC0A4007)
+#define MCFGPIO_PODR_UART		(0xFC0A4009)
+#define MCFGPIO_PODR_QSPI		(0xFC0A400A)
+#define MCFGPIO_PODR_TIMER		(0xFC0A400B)
+#define MCFGPIO_PODR_LCDDATAH		(0xFC0A400D)
+#define MCFGPIO_PODR_LCDDATAM		(0xFC0A400E)
+#define MCFGPIO_PODR_LCDDATAL		(0xFC0A400F)
+#define MCFGPIO_PODR_LCDCTLH		(0xFC0A4010)
+#define MCFGPIO_PODR_LCDCTLL		(0xFC0A4011)
+#define MCFGPIO_PDDR_FECH		(0xFC0A4014)
+#define MCFGPIO_PDDR_FECL		(0xFC0A4015)
+#define MCFGPIO_PDDR_SSI		(0xFC0A4016)
+#define MCFGPIO_PDDR_BUSCTL		(0xFC0A4017)
+#define MCFGPIO_PDDR_BE			(0xFC0A4018)
+#define MCFGPIO_PDDR_CS			(0xFC0A4019)
+#define MCFGPIO_PDDR_PWM		(0xFC0A401A)
+#define MCFGPIO_PDDR_FECI2C		(0xFC0A401B)
+#define MCFGPIO_PDDR_UART		(0xFC0A401C)
+#define MCFGPIO_PDDR_QSPI		(0xFC0A401E)
+#define MCFGPIO_PDDR_TIMER		(0xFC0A401F)
+#define MCFGPIO_PDDR_LCDDATAH		(0xFC0A4021)
+#define MCFGPIO_PDDR_LCDDATAM		(0xFC0A4022)
+#define MCFGPIO_PDDR_LCDDATAL		(0xFC0A4023)
+#define MCFGPIO_PDDR_LCDCTLH		(0xFC0A4024)
+#define MCFGPIO_PDDR_LCDCTLL		(0xFC0A4025)
+#define MCFGPIO_PPDSDR_FECH		(0xFC0A4028)
+#define MCFGPIO_PPDSDR_FECL		(0xFC0A4029)
+#define MCFGPIO_PPDSDR_SSI		(0xFC0A402A)
+#define MCFGPIO_PPDSDR_BUSCTL		(0xFC0A402B)
+#define MCFGPIO_PPDSDR_BE		(0xFC0A402C)
+#define MCFGPIO_PPDSDR_CS		(0xFC0A402D)
+#define MCFGPIO_PPDSDR_PWM		(0xFC0A402E)
+#define MCFGPIO_PPDSDR_FECI2C		(0xFC0A402F)
+#define MCFGPIO_PPDSDR_UART		(0xFC0A4031)
+#define MCFGPIO_PPDSDR_QSPI		(0xFC0A4032)
+#define MCFGPIO_PPDSDR_TIMER		(0xFC0A4033)
+#define MCFGPIO_PPDSDR_LCDDATAH		(0xFC0A4035)
+#define MCFGPIO_PPDSDR_LCDDATAM		(0xFC0A4036)
+#define MCFGPIO_PPDSDR_LCDDATAL		(0xFC0A4037)
+#define MCFGPIO_PPDSDR_LCDCTLH		(0xFC0A4038)
+#define MCFGPIO_PPDSDR_LCDCTLL		(0xFC0A4039)
+#define MCFGPIO_PCLRR_FECH		(0xFC0A403C)
+#define MCFGPIO_PCLRR_FECL		(0xFC0A403D)
+#define MCFGPIO_PCLRR_SSI		(0xFC0A403E)
+#define MCFGPIO_PCLRR_BUSCTL		(0xFC0A403F)
+#define MCFGPIO_PCLRR_BE		(0xFC0A4040)
+#define MCFGPIO_PCLRR_CS		(0xFC0A4041)
+#define MCFGPIO_PCLRR_PWM		(0xFC0A4042)
+#define MCFGPIO_PCLRR_FECI2C		(0xFC0A4043)
+#define MCFGPIO_PCLRR_UART		(0xFC0A4045)
+#define MCFGPIO_PCLRR_QSPI		(0xFC0A4046)
+#define MCFGPIO_PCLRR_TIMER		(0xFC0A4047)
+#define MCFGPIO_PCLRR_LCDDATAH		(0xFC0A4049)
+#define MCFGPIO_PCLRR_LCDDATAM		(0xFC0A404A)
+#define MCFGPIO_PCLRR_LCDDATAL		(0xFC0A404B)
+#define MCFGPIO_PCLRR_LCDCTLH		(0xFC0A404C)
+#define MCFGPIO_PCLRR_LCDCTLL		(0xFC0A404D)
 #define MCF_GPIO_PAR_FEC		MCF_REG08(0xFC0A4050)
 #define MCF_GPIO_PAR_PWM		MCF_REG08(0xFC0A4051)
 #define MCF_GPIO_PAR_BUSCTL		MCF_REG08(0xFC0A4052)
@@ -1175,6 +1175,20 @@
 /* Bit definitions and macros for MCF_GPIO_DSCR_IRQ */
 #define MCF_GPIO_DSCR_IRQ_IRQ_DSE(x)               (((x)&0x03)<<0)
 
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_FECH
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_FECH
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_FECH
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_FECH
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_FECH
+
+#define MCFGPIO_PIN_MAX			136
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+
+
 /*********************************************************************
  *
  * Interrupt Controller (INTC)
@@ -2142,12 +2156,12 @@
  *********************************************************************/
 
 /* Register read/write macros */
-#define MCF_EPORT_EPPAR                MCF_REG16(0xFC094000)
-#define MCF_EPORT_EPDDR                MCF_REG08(0xFC094002)
-#define MCF_EPORT_EPIER                MCF_REG08(0xFC094003)
-#define MCF_EPORT_EPDR                 MCF_REG08(0xFC094004)
-#define MCF_EPORT_EPPDR                MCF_REG08(0xFC094005)
-#define MCF_EPORT_EPFR                 MCF_REG08(0xFC094006)
+#define MCFEPORT_EPPAR                (0xFC094000)
+#define MCFEPORT_EPDDR                (0xFC094002)
+#define MCFEPORT_EPIER                (0xFC094003)
+#define MCFEPORT_EPDR                 (0xFC094004)
+#define MCFEPORT_EPPDR                (0xFC094005)
+#define MCFEPORT_EPFR                 (0xFC094006)
 
 /* Bit definitions and macros for MCF_EPORT_EPPAR */
 #define MCF_EPORT_EPPAR_EPPA1(x)       (((x)&0x0003)<<2)
diff --git a/arch/m68knommu/platform/532x/Makefile b/arch/m68knommu/platform/532x/Makefile
index e431912..4cc2324 100644
--- a/arch/m68knommu/platform/532x/Makefile
+++ b/arch/m68knommu/platform/532x/Makefile
@@ -15,4 +15,4 @@
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
 #obj-y := config.o usb-mcf532x.o spi-mcf532x.o
-obj-y := config.o
+obj-y := config.o gpio.o
diff --git a/arch/m68knommu/platform/532x/config.c b/arch/m68knommu/platform/532x/config.c
index 591f2f8..6dd035f 100644
--- a/arch/m68knommu/platform/532x/config.c
+++ b/arch/m68knommu/platform/532x/config.c
@@ -432,8 +432,8 @@ void gpio_init(void)
 	/* Initialize TIN3 as a GPIO output to enable the write
 	   half of the latch */
 	MCF_GPIO_PAR_TIMER = 0x00;
-	MCF_GPIO_PDDR_TIMER = 0x08;
-	MCF_GPIO_PCLRR_TIMER = 0x0;
+	__raw_writeb(0x08, MCFGPIO_PDDR_TIMER);
+	__raw_writeb(0x00, MCFGPIO_PCLRR_TIMER);
 
 }
 
diff --git a/arch/m68knommu/platform/532x/gpio.c b/arch/m68knommu/platform/532x/gpio.c
new file mode 100644
index 0000000..73d911b
--- /dev/null
+++ b/arch/m68knommu/platform/532x/gpio.c
@@ -0,0 +1,337 @@
+/*
+ * Coldfire generic GPIO support
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+*/
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+#include <asm/mcfgpio.h>
+ 
+static struct mcf_gpio_chip mcf_gpio_chips[] = {
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECH,
+		.podr				= MCFGPIO_PODR_FECH,
+		.ppdr				= MCFGPIO_PPDSDR_FECH,
+		.setr				= MCFGPIO_PPDSDR_FECH,
+		.clrr				= MCFGPIO_PCLRR_FECH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECL,
+		.podr				= MCFGPIO_PODR_FECL,
+		.ppdr				= MCFGPIO_PPDSDR_FECL,
+		.setr				= MCFGPIO_PPDSDR_FECL,
+		.clrr				= MCFGPIO_PCLRR_FECL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SSI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_SSI,
+		.podr				= MCFGPIO_PODR_SSI,
+		.ppdr				= MCFGPIO_PPDSDR_SSI,
+		.setr				= MCFGPIO_PPDSDR_SSI,
+		.clrr				= MCFGPIO_PCLRR_SSI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BE",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BE,
+		.podr				= MCFGPIO_PODR_BE,
+		.ppdr				= MCFGPIO_PPDSDR_BE,
+		.setr				= MCFGPIO_PPDSDR_BE,
+		.clrr				= MCFGPIO_PCLRR_BE,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 49,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PWM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 58,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_PWM,
+		.podr				= MCFGPIO_PODR_PWM,
+		.ppdr				= MCFGPIO_PPDSDR_PWM,
+		.setr				= MCFGPIO_PPDSDR_PWM,
+		.clrr				= MCFGPIO_PCLRR_PWM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UART",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UART,
+		.podr				= MCFGPIO_PODR_UART,
+		.ppdr				= MCFGPIO_PPDSDR_UART,
+		.setr				= MCFGPIO_PPDSDR_UART,
+		.clrr				= MCFGPIO_PCLRR_UART,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMER",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAH,
+		.podr				= MCFGPIO_PODR_LCDDATAH,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAH,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAH,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAM,
+		.podr				= MCFGPIO_PODR_LCDDATAM,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAM,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAM,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 112,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAL,
+		.podr				= MCFGPIO_PODR_LCDDATAL,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAL,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAL,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDCTLH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 120,
+			.ngpio			= 1,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDCTLH,
+		.podr				= MCFGPIO_PODR_LCDCTLH,
+		.ppdr				= MCFGPIO_PPDSDR_LCDCTLH,
+		.setr				= MCFGPIO_PPDSDR_LCDCTLH,
+		.clrr				= MCFGPIO_PCLRR_LCDCTLH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDCTLL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDCTLL,
+		.podr				= MCFGPIO_PODR_LCDCTLL,
+		.ppdr				= MCFGPIO_PPDSDR_LCDCTLL,
+		.setr				= MCFGPIO_PPDSDR_LCDCTLL,
+		.clrr				= MCFGPIO_PCLRR_LCDCTLL,
+	},
+};
+
+static int __init mcf_gpio_init(void)
+{
+	unsigned i = 0;
+	while (i < ARRAY_SIZE(mcf_gpio_chips))
+		(void)gpiochip_add((struct gpio_chip *)&mcf_gpio_chips[i++]);
+	return 0;
+}
+
+core_initcall(mcf_gpio_init);
-- 
1.5.6.5

