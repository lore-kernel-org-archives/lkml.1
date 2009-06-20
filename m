Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbZFTBTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbZFTBTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759378AbZFTBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:06 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39105 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759279AbZFTBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:18:00 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: FllnC1AVM1nbVzoPm9XPCA6PAHy4YJC8detdRXs_.YmyGi6x_HaA7wPI5uiEORx04pY2f4k1VMAAEyrUrxU7571m9PisTl8AzbMG4Ae6lziDjQQTIFDfksmNocq74NfpPwlbrviMEXZ0GWiWx1apRsnM2t9U9bYpr_Wp9GXau_NO72oPWvyb3y0L.vlEvvkWxidIIah3ROGbTc4UfzgcV8fTTXtiX0TQ9JSIRUXINKm.bi6m7xY.PNF9cJ6BA3wdfudsqeq8MQEeeDl8mrSFXnxspEUXQ2ymk.tjxA0ks.Ddeqtx65Mm7UCiVxwLwBCypS59jsz1Pw9Rbx5pP8.uVx4XsdghPf.Tsn.1wfekiC0xqZ1FJ45Nvgc-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 07/13] generic GPIO support for the Freescale Coldfire 527x.
Date: Fri, 19 Jun 2009 18:11:06 -0700
Message-Id: <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 5271 & 5275.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m527xsim.h      |  169 +++++++++
 arch/m68knommu/platform/527x/Makefile |    2 +-
 arch/m68knommu/platform/527x/gpio.c   |  607 +++++++++++++++++++++++++++++++++
 3 files changed, 777 insertions(+), 1 deletions(-)
 create mode 100644 arch/m68knommu/platform/527x/gpio.c

diff --git a/arch/m68k/include/asm/m527xsim.h b/arch/m68k/include/asm/m527xsim.h
index 1f63ab3..8471ead 100644
--- a/arch/m68k/include/asm/m527xsim.h
+++ b/arch/m68k/include/asm/m527xsim.h
@@ -54,6 +54,175 @@
 #define	MCFSIM_DMR1		0x5c		/* SDRAM address mask 1 */
 #endif
 
+
+#ifdef CONFIG_M5271
+#define MCFGPIO_PODR_ADDR	(MCF_IPSBAR + 0x100000)
+#define MCFGPIO_PODR_DATAH	(MCF_IPSBAR + 0x100001)
+#define MCFGPIO_PODR_DATAL	(MCF_IPSBAR + 0x100002)
+#define MCFGPIO_PODR_BUSCTL	(MCF_IPSBAR + 0x100003)
+#define MCFGPIO_PODR_BS		(MCF_IPSBAR + 0x100004)
+#define MCFGPIO_PODR_CS		(MCF_IPSBAR + 0x100005)
+#define MCFGPIO_PODR_SDRAM	(MCF_IPSBAR + 0x100006)
+#define MCFGPIO_PODR_FECI2C	(MCF_IPSBAR + 0x100007)
+#define MCFGPIO_PODR_UARTH	(MCF_IPSBAR + 0x100008)
+#define MCFGPIO_PODR_UARTL	(MCF_IPSBAR + 0x100009)
+#define MCFGPIO_PODR_QSPI	(MCF_IPSBAR + 0x10000A)
+#define MCFGPIO_PODR_TIMER	(MCF_IPSBAR + 0x10000B)
+
+#define MCFGPIO_PDDR_ADDR	(MCF_IPSBAR + 0x100010)
+#define MCFGPIO_PDDR_DATAH	(MCF_IPSBAR + 0x100011)
+#define MCFGPIO_PDDR_DATAL	(MCF_IPSBAR + 0x100012)
+#define MCFGPIO_PDDR_BUSCTL	(MCF_IPSBAR + 0x100013)
+#define MCFGPIO_PDDR_BS		(MCF_IPSBAR + 0x100014)
+#define MCFGPIO_PDDR_CS		(MCF_IPSBAR + 0x100015)
+#define MCFGPIO_PDDR_SDRAM	(MCF_IPSBAR + 0x100016)
+#define MCFGPIO_PDDR_FECI2C	(MCF_IPSBAR + 0x100017)
+#define MCFGPIO_PDDR_UARTH	(MCF_IPSBAR + 0x100018)
+#define MCFGPIO_PDDR_UARTL	(MCF_IPSBAR + 0x100019)
+#define MCFGPIO_PDDR_QSPI	(MCF_IPSBAR + 0x10001A)
+#define MCFGPIO_PDDR_TIMER	(MCF_IPSBAR + 0x10001B)
+
+#define MCFGPIO_PPDSDR_ADDR	(MCF_IPSBAR + 0x100020)
+#define MCFGPIO_PPDSDR_DATAH	(MCF_IPSBAR + 0x100021)
+#define MCFGPIO_PPDSDR_DATAL	(MCF_IPSBAR + 0x100022)
+#define MCFGPIO_PPDSDR_BUSCTL	(MCF_IPSBAR + 0x100023)
+#define MCFGPIO_PPDSDR_BS	(MCF_IPSBAR + 0x100024)
+#define MCFGPIO_PPDSDR_CS	(MCF_IPSBAR + 0x100025)
+#define MCFGPIO_PPDSDR_SDRAM	(MCF_IPSBAR + 0x100026)
+#define MCFGPIO_PPDSDR_FECI2C	(MCF_IPSBAR + 0x100027)
+#define MCFGPIO_PPDSDR_UARTH	(MCF_IPSBAR + 0x100028)
+#define MCFGPIO_PPDSDR_UARTL	(MCF_IPSBAR + 0x100029)
+#define MCFGPIO_PPDSDR_QSPI	(MCF_IPSBAR + 0x10002A)
+#define MCFGPIO_PPDSDR_TIMER	(MCF_IPSBAR + 0x10002B)
+
+#define MCFGPIO_PCLRR_ADDR	(MCF_IPSBAR + 0x100030)
+#define MCFGPIO_PCLRR_DATAH	(MCF_IPSBAR + 0x100031)
+#define MCFGPIO_PCLRR_DATAL	(MCF_IPSBAR + 0x100032)
+#define MCFGPIO_PCLRR_BUSCTL	(MCF_IPSBAR + 0x100033)
+#define MCFGPIO_PCLRR_BS	(MCF_IPSBAR + 0x100034)
+#define MCFGPIO_PCLRR_CS	(MCF_IPSBAR + 0x100035)
+#define MCFGPIO_PCLRR_SDRAM	(MCF_IPSBAR + 0x100036)
+#define MCFGPIO_PCLRR_FECI2C	(MCF_IPSBAR + 0x100037)
+#define MCFGPIO_PCLRR_UARTH	(MCF_IPSBAR + 0x100038)
+#define MCFGPIO_PCLRR_UARTL	(MCF_IPSBAR + 0x100039)
+#define MCFGPIO_PCLRR_QSPI	(MCF_IPSBAR + 0x10003A)
+#define MCFGPIO_PCLRR_TIMER	(MCF_IPSBAR + 0x10003B)
+
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_ADDR
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_ADDR
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_ADDR
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_ADDR
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_ADDR
+
+#define MCFGPIO_PIN_MAX			100
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+#endif
+
+#ifdef CONFIG_M5275
+#define MCFGPIO_PODR_BUSCTL	(MCF_IPSBAR + 0x100004)
+#define MCFGPIO_PODR_ADDR	(MCF_IPSBAR + 0x100005)
+#define MCFGPIO_PODR_CS		(MCF_IPSBAR + 0x100008)
+#define MCFGPIO_PODR_FEC0H	(MCF_IPSBAR + 0x10000A)
+#define MCFGPIO_PODR_FEC0L	(MCF_IPSBAR + 0x10000B)
+#define MCFGPIO_PODR_FECI2C	(MCF_IPSBAR + 0x10000C)
+#define MCFGPIO_PODR_QSPI	(MCF_IPSBAR + 0x10000D)
+#define MCFGPIO_PODR_SDRAM	(MCF_IPSBAR + 0x10000E)
+#define MCFGPIO_PODR_TIMERH	(MCF_IPSBAR + 0x10000F)
+#define MCFGPIO_PODR_TIMERL	(MCF_IPSBAR + 0x100010)
+#define MCFGPIO_PODR_UARTL	(MCF_IPSBAR + 0x100011)
+#define MCFGPIO_PODR_FEC1H	(MCF_IPSBAR + 0x100012)
+#define MCFGPIO_PODR_FEC1L	(MCF_IPSBAR + 0x100013)
+#define MCFGPIO_PODR_BS		(MCF_IPSBAR + 0x100014)
+#define MCFGPIO_PODR_IRQ	(MCF_IPSBAR + 0x100015)
+#define MCFGPIO_PODR_USBH	(MCF_IPSBAR + 0x100016)
+#define MCFGPIO_PODR_USBL	(MCF_IPSBAR + 0x100017)
+#define MCFGPIO_PODR_UARTH	(MCF_IPSBAR + 0x100018)
+
+#define MCFGPIO_PDDR_BUSCTL	(MCF_IPSBAR + 0x100020)
+#define MCFGPIO_PDDR_ADDR	(MCF_IPSBAR + 0x100021)
+#define MCFGPIO_PDDR_CS		(MCF_IPSBAR + 0x100024)
+#define MCFGPIO_PDDR_FEC0H	(MCF_IPSBAR + 0x100026)
+#define MCFGPIO_PDDR_FEC0L	(MCF_IPSBAR + 0x100027)
+#define MCFGPIO_PDDR_FECI2C	(MCF_IPSBAR + 0x100028)
+#define MCFGPIO_PDDR_QSPI	(MCF_IPSBAR + 0x100029)
+#define MCFGPIO_PDDR_SDRAM	(MCF_IPSBAR + 0x10002A)
+#define MCFGPIO_PDDR_TIMERH	(MCF_IPSBAR + 0x10002B)
+#define MCFGPIO_PDDR_TIMERL	(MCF_IPSBAR + 0x10002C)
+#define MCFGPIO_PDDR_UARTL	(MCF_IPSBAR + 0x10002D)
+#define MCFGPIO_PDDR_FEC1H	(MCF_IPSBAR + 0x10002E)
+#define MCFGPIO_PDDR_FEC1L	(MCF_IPSBAR + 0x10002F)
+#define MCFGPIO_PDDR_BS		(MCF_IPSBAR + 0x100030)
+#define MCFGPIO_PDDR_IRQ	(MCF_IPSBAR + 0x100031)
+#define MCFGPIO_PDDR_USBH	(MCF_IPSBAR + 0x100032)
+#define MCFGPIO_PDDR_USBL	(MCF_IPSBAR + 0x100033)
+#define MCFGPIO_PDDR_UARTH	(MCF_IPSBAR + 0x100034)
+
+#define MCFGPIO_PPDSDR_BUSCTL	(MCF_IPSBAR + 0x10003C)
+#define MCFGPIO_PPDSDR_ADDR	(MCF_IPSBAR + 0x10003D)
+#define MCFGPIO_PPDSDR_CS	(MCF_IPSBAR + 0x100040)
+#define MCFGPIO_PPDSDR_FEC0H	(MCF_IPSBAR + 0x100042)
+#define MCFGPIO_PPDSDR_FEC0L	(MCF_IPSBAR + 0x100043)
+#define MCFGPIO_PPDSDR_FECI2C	(MCF_IPSBAR + 0x100044)
+#define MCFGPIO_PPDSDR_QSPI	(MCF_IPSBAR + 0x100045)
+#define MCFGPIO_PPDSDR_SDRAM	(MCF_IPSBAR + 0x100046)
+#define MCFGPIO_PPDSDR_TIMERH	(MCF_IPSBAR + 0x100047)
+#define MCFGPIO_PPDSDR_TIMERL	(MCF_IPSBAR + 0x100048)
+#define MCFGPIO_PPDSDR_UARTL	(MCF_IPSBAR + 0x100049)
+#define MCFGPIO_PPDSDR_FEC1H	(MCF_IPSBAR + 0x10004A)
+#define MCFGPIO_PPDSDR_FEC1L	(MCF_IPSBAR + 0x10004B)
+#define MCFGPIO_PPDSDR_BS	(MCF_IPSBAR + 0x10004C)
+#define MCFGPIO_PPDSDR_IRQ	(MCF_IPSBAR + 0x10004D)
+#define MCFGPIO_PPDSDR_USBH	(MCF_IPSBAR + 0x10004E)
+#define MCFGPIO_PPDSDR_USBL	(MCF_IPSBAR + 0x10004F)
+#define MCFGPIO_PPDSDR_UARTH	(MCF_IPSBAR + 0x100050)
+
+#define MCFGPIO_PCLRR_BUSCTL	(MCF_IPSBAR + 0x100058)
+#define MCFGPIO_PCLRR_ADDR	(MCF_IPSBAR + 0x100059)
+#define MCFGPIO_PCLRR_CS	(MCF_IPSBAR + 0x10005C)
+#define MCFGPIO_PCLRR_FEC0H	(MCF_IPSBAR + 0x10005E)
+#define MCFGPIO_PCLRR_FEC0L	(MCF_IPSBAR + 0x10005F)
+#define MCFGPIO_PCLRR_FECI2C	(MCF_IPSBAR + 0x100060)
+#define MCFGPIO_PCLRR_QSPI	(MCF_IPSBAR + 0x100061)
+#define MCFGPIO_PCLRR_SDRAM	(MCF_IPSBAR + 0x100062)
+#define MCFGPIO_PCLRR_TIMERH	(MCF_IPSBAR + 0x100063)
+#define MCFGPIO_PCLRR_TIMERL	(MCF_IPSBAR + 0x100064)
+#define MCFGPIO_PCLRR_UARTL	(MCF_IPSBAR + 0x100065)
+#define MCFGPIO_PCLRR_FEC1H	(MCF_IPSBAR + 0x100066)
+#define MCFGPIO_PCLRR_FEC1L	(MCF_IPSBAR + 0x100067)
+#define MCFGPIO_PCLRR_BS	(MCF_IPSBAR + 0x100068)
+#define MCFGPIO_PCLRR_IRQ	(MCF_IPSBAR + 0x100069)
+#define MCFGPIO_PCLRR_USBH	(MCF_IPSBAR + 0x10006A)
+#define MCFGPIO_PCLRR_USBL	(MCF_IPSBAR + 0x10006B)
+#define MCFGPIO_PCLRR_UARTH	(MCF_IPSBAR + 0x10006C)
+
+
+/*
+ * Generic GPIO support
+ */
+#define MCFGPIO_PODR			MCFGPIO_PODR_BUSCTL
+#define MCFGPIO_PDDR			MCFGPIO_PDDR_BUSCTL
+#define MCFGPIO_PPDR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_SETR			MCFGPIO_PPDSDR_BUSCTL
+#define MCFGPIO_CLRR			MCFGPIO_PCLRR_BUSCTL
+
+#define MCFGPIO_PIN_MAX			148
+#define MCFGPIO_IRQ_MAX			8
+#define MCFGPIO_IRQ_VECBASE		MCFINT_VECBASE
+#endif
+
+/*
+ * EPort
+ */
+
+#define MCFEPORT_EPDDR		(MCF_IPSBAR + 0x130002)
+#define MCFEPORT_EPDR		(MCF_IPSBAR + 0x130004)
+#define MCFEPORT_EPPDR		(MCF_IPSBAR + 0x130005)
+
+
 /*
  *	GPIO pins setups to enable the UARTs.
  */
diff --git a/arch/m68knommu/platform/527x/Makefile b/arch/m68knommu/platform/527x/Makefile
index 26135d9..3d90e6d 100644
--- a/arch/m68knommu/platform/527x/Makefile
+++ b/arch/m68knommu/platform/527x/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/527x/gpio.c b/arch/m68knommu/platform/527x/gpio.c
new file mode 100644
index 0000000..4365a75
--- /dev/null
+++ b/arch/m68knommu/platform/527x/gpio.c
@@ -0,0 +1,607 @@
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
+#if defined(CONFIG_M5271)
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
+			.label			= "ADDR",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 13,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ADDR,
+		.podr				= MCFGPIO_PODR_ADDR,
+		.ppdr				= MCFGPIO_PPDSDR_ADDR,
+		.setr				= MCFGPIO_PPDSDR_ADDR,
+		.clrr				= MCFGPIO_PCLRR_ADDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAH,
+		.podr				= MCFGPIO_PODR_DATAH,
+		.ppdr				= MCFGPIO_PPDSDR_DATAH,
+		.setr				= MCFGPIO_PPDSDR_DATAH,
+		.clrr				= MCFGPIO_PCLRR_DATAH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAL,
+		.podr				= MCFGPIO_PODR_DATAL,
+		.ppdr				= MCFGPIO_PPDSDR_DATAL,
+		.setr				= MCFGPIO_PPDSDR_DATAL,
+		.clrr				= MCFGPIO_PCLRR_DATAL,
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
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BS,
+		.podr				= MCFGPIO_PODR_BS,
+		.ppdr				= MCFGPIO_PPDSDR_BS,
+		.setr				= MCFGPIO_PPDSDR_BS,
+		.clrr				= MCFGPIO_PCLRR_BS,
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
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SDRAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_SDRAM,
+		.podr				= MCFGPIO_PODR_SDRAM,
+		.ppdr				= MCFGPIO_PPDSDR_SDRAM,
+		.setr				= MCFGPIO_PPDSDR_SDRAM,
+		.clrr				= MCFGPIO_PCLRR_SDRAM,
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
+			.label			= "UARTH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTH,
+		.podr				= MCFGPIO_PODR_UARTH,
+		.ppdr				= MCFGPIO_PPDSDR_UARTH,
+		.setr				= MCFGPIO_PPDSDR_UARTH,
+		.clrr				= MCFGPIO_PCLRR_UARTH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTL,
+		.podr				= MCFGPIO_PODR_UARTL,
+		.ppdr				= MCFGPIO_PPDSDR_UARTL,
+		.setr				= MCFGPIO_PPDSDR_UARTL,
+		.clrr				= MCFGPIO_PCLRR_UARTL,
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
+			.base			= 88,
+			.ngpio			= 5,
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
+			.base			= 96,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+#elif defined(CONFIG_M5275)
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
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "ADDR",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 21,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ADDR,
+		.podr				= MCFGPIO_PODR_ADDR,
+		.ppdr				= MCFGPIO_PPDSDR_ADDR,
+		.setr				= MCFGPIO_PPDSDR_ADDR,
+		.clrr				= MCFGPIO_PCLRR_ADDR,
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
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC0H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC0H,
+		.podr				= MCFGPIO_PODR_FEC0H,
+		.ppdr				= MCFGPIO_PPDSDR_FEC0H,
+		.setr				= MCFGPIO_PPDSDR_FEC0H,
+		.clrr				= MCFGPIO_PCLRR_FEC0H,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC0L",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC0L,
+		.podr				= MCFGPIO_PODR_FEC0L,
+		.ppdr				= MCFGPIO_PPDSDR_FEC0L,
+		.setr				= MCFGPIO_PPDSDR_FEC0L,
+		.clrr				= MCFGPIO_PCLRR_FEC0L,
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
+			.base			= 48,
+			.ngpio			= 6,
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
+			.base			= 56,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SDRAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_SDRAM,
+		.podr				= MCFGPIO_PODR_SDRAM,
+		.ppdr				= MCFGPIO_PPDSDR_SDRAM,
+		.setr				= MCFGPIO_PPDSDR_SDRAM,
+		.clrr				= MCFGPIO_PCLRR_SDRAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMERH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMERH,
+		.podr				= MCFGPIO_PODR_TIMERH,
+		.ppdr				= MCFGPIO_PPDSDR_TIMERH,
+		.setr				= MCFGPIO_PPDSDR_TIMERH,
+		.clrr				= MCFGPIO_PCLRR_TIMERH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMERL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMERL,
+		.podr				= MCFGPIO_PODR_TIMERL,
+		.ppdr				= MCFGPIO_PPDSDR_TIMERL,
+		.setr				= MCFGPIO_PPDSDR_TIMERL,
+		.clrr				= MCFGPIO_PCLRR_TIMERL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTL,
+		.podr				= MCFGPIO_PODR_UARTL,
+		.ppdr				= MCFGPIO_PPDSDR_UARTL,
+		.setr				= MCFGPIO_PPDSDR_UARTL,
+		.clrr				= MCFGPIO_PCLRR_UARTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC1H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC1H,
+		.podr				= MCFGPIO_PODR_FEC1H,
+		.ppdr				= MCFGPIO_PPDSDR_FEC1H,
+		.setr				= MCFGPIO_PPDSDR_FEC1H,
+		.clrr				= MCFGPIO_PCLRR_FEC1H,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC1L",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC1L,
+		.podr				= MCFGPIO_PODR_FEC1L,
+		.ppdr				= MCFGPIO_PPDSDR_FEC1L,
+		.setr				= MCFGPIO_PPDSDR_FEC1L,
+		.clrr				= MCFGPIO_PCLRR_FEC1L,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 114,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_BS,
+		.podr				= MCFGPIO_PODR_BS,
+		.ppdr				= MCFGPIO_PPDSDR_BS,
+		.setr				= MCFGPIO_PPDSDR_BS,
+		.clrr				= MCFGPIO_PCLRR_BS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "IRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 121,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_IRQ,
+		.podr				= MCFGPIO_PODR_IRQ,
+		.ppdr				= MCFGPIO_PPDSDR_IRQ,
+		.setr				= MCFGPIO_PPDSDR_IRQ,
+		.clrr				= MCFGPIO_PCLRR_IRQ,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "USBH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 1,
+		},
+		.pddr				= MCFGPIO_PDDR_USBH,
+		.podr				= MCFGPIO_PODR_USBH,
+		.ppdr				= MCFGPIO_PPDSDR_USBH,
+		.setr				= MCFGPIO_PPDSDR_USBH,
+		.clrr				= MCFGPIO_PCLRR_USBH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "USBL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 136,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_USBL,
+		.podr				= MCFGPIO_PODR_USBL,
+		.ppdr				= MCFGPIO_PPDSDR_USBL,
+		.setr				= MCFGPIO_PPDSDR_USBL,
+		.clrr				= MCFGPIO_PCLRR_USBL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 144,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTH,
+		.podr				= MCFGPIO_PODR_UARTH,
+		.ppdr				= MCFGPIO_PPDSDR_UARTH,
+		.setr				= MCFGPIO_PPDSDR_UARTH,
+		.clrr				= MCFGPIO_PCLRR_UARTH,
+	},
+#endif
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

