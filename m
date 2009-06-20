Return-Path: <linux-kernel-owner+w=401wt.eu-S1760065AbZFTBTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065AbZFTBTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759322AbZFTBR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:17:59 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39079 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759282AbZFTBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:55 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: 3Z4wFAoVM1mKvUgrWXCJHV5bsF18nBgPr1pwbK.vySKGCV2U8BuKLsDZf2aRkNgvdxLHLc_0IEFwWRwyhnBLIcG4ZPJ1jw6f7FA6dzRsTJbeyR44T5PDh7KKdiMNX9KFflI2RtOxz2tELP3OQPTh1VSxda3eOx7MltEA9.VdkIailEu7ha9RV04baGaXgfn4Vy6xc99VmQ2vKyZFo1lH.txRh4gvhp2EvUVy6eA13mmbH9jtjHaPRoUok.08pzdm9xDpc6Id0M2axcq1d.OQxPmD5J_F9uTeFw.S40nQN89uXJZn2i0362SlyJGOcrPeVRJ6SEjpfIHT7q3xY6XubQoOy4GvHd3yNdk3TrTtx9FDD9mOWKLLLdk-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 04/13] generic GPIO support for the Freescale Coldfire 520x.
Date: Fri, 19 Jun 2009 18:11:03 -0700
Message-Id: <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 520x.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m520xsim.h      |   56 +++++++++
 arch/m68knommu/platform/520x/Makefile |    2 +-
 arch/m68knommu/platform/520x/gpio.c   |  211 +++++++++++++++++++++++++++++++++
 3 files changed, 268 insertions(+), 1 deletions(-)
 create mode 100644 arch/m68knommu/platform/520x/gpio.c

diff --git a/arch/m68k/include/asm/m520xsim.h b/arch/m68k/include/asm/m520xsim.h
index 49d016e..efdff3b 100644
--- a/arch/m68k/include/asm/m520xsim.h
+++ b/arch/m68k/include/asm/m520xsim.h
@@ -41,6 +41,62 @@
 #define MCFSIM_SDCS0        0x000a8110	/* SDRAM Chip Select 0 Configuration */
 #define MCFSIM_SDCS1        0x000a8114	/* SDRAM Chip Select 1 Configuration */
 
+#define MCFEPORT_EPDDR			0xFC088002
+#define MCFEPORT_EPDR			0xFC088004
+#define MCFEPORT_EPPDR			0xFC088005
+
+#define MCFGPIO_PODR_BUSCTL		0xFC0A4000
+#define MCFGPIO_PODR_BE			0xFC0A4001
+#define MCFGPIO_PODR_CS			0xFC0A4002
+#define MCFGPIO_PODR_FECI2C		0xFC0A4003
+#define MCFGPIO_PODR_QSPI		0xFC0A4004
+#define MCFGPIO_PODR_TIMER		0xFC0A4005
+#define MCFGPIO_PODR_UART		0xFC0A4006
+#define MCFGPIO_PODR_FECH		0xFC0A4007
+#define MCFGPIO_PODR_FECL		0xFC0A4008
+
+#define MCFGPIO_PDDR_BUSCTL		0xFC0A400C
+#define MCFGPIO_PDDR_BE			0xFC0A400D
+#define MCFGPIO_PDDR_CS			0xFC0A400E
+#define MCFGPIO_PDDR_FECI2C		0xFC0A400F
+#define MCFGPIO_PDDR_QSPI		0xFC0A4010
+#define MCFGPIO_PDDR_TIMER		0xFC0A4011
+#define MCFGPIO_PDDR_UART		0xFC0A4012
+#define MCFGPIO_PDDR_FECH		0xFC0A4013
+#define MCFGPIO_PDDR_FECL		0xFC0A4014
+
+#define MCFGPIO_PPDSDR_BUSCTL		0xFC0A401A
+#define MCFGPIO_PPDSDR_BE		0xFC0A401B
+#define MCFGPIO_PPDSDR_CS		0xFC0A401C
+#define MCFGPIO_PPDSDR_FECI2C		0xFC0A401D
+#define MCFGPIO_PPDSDR_QSPI		0xFC0A401E
+#define MCFGPIO_PPDSDR_TIMER		0xFC0A401F
+#define MCFGPIO_PPDSDR_UART		0xFC0A4021
+#define MCFGPIO_PPDSDR_FECH		0xFC0A4021
+#define MCFGPIO_PPDSDR_FECL		0xFC0A4022
+
+#define MCFGPIO_PCLRR_BUSCTL		0xFC0A4024
+#define MCFGPIO_PCLRR_BE		0xFC0A4025
+#define MCFGPIO_PCLRR_CS		0xFC0A4026
+#define MCFGPIO_PCLRR_FECI2C		0xFC0A4027
+#define MCFGPIO_PCLRR_QSPI		0xFC0A4028
+#define MCFGPIO_PCLRR_TIMER		0xFC0A4029
+#define MCFGPIO_PCLRR_UART		0xFC0A402A
+#define MCFGPIO_PCLRR_FECH		0xFC0A402B
+#define MCFGPIO_PCLRR_FECL		0xFC0A402C
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_BUSCTL
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_BUSCTL
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_BUSCTL
+
+#define MCFGPIO_PIN_MAX			80
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+/****************************************************************************/
 
 #define MCF_GPIO_PAR_UART                   (0xA4036)
 #define MCF_GPIO_PAR_FECI2C                 (0xA4033)
diff --git a/arch/m68knommu/platform/520x/Makefile b/arch/m68knommu/platform/520x/Makefile
index a50e76a..435ab34 100644
--- a/arch/m68knommu/platform/520x/Makefile
+++ b/arch/m68knommu/platform/520x/Makefile
@@ -14,4 +14,4 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
diff --git a/arch/m68knommu/platform/520x/gpio.c b/arch/m68knommu/platform/520x/gpio.c
new file mode 100644
index 0000000..76fd4f9
--- /dev/null
+++ b/arch/m68knommu/platform/520x/gpio.c
@@ -0,0 +1,211 @@
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
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
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
+			.base			= 16,
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
+			.base			= 25,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
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
+			.base			= 32,
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
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
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
+			.base			= 48,
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
+			.label			= "UART",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
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
+			.label			= "FECH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
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
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECL,
+		.podr				= MCFGPIO_PODR_FECL,
+		.ppdr				= MCFGPIO_PPDSDR_FECL,
+		.setr				= MCFGPIO_PPDSDR_FECL,
+		.clrr				= MCFGPIO_PCLRR_FECL,
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

