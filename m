Return-Path: <linux-kernel-owner+w=401wt.eu-S1760294AbZFTBUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294AbZFTBUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbZFTBSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:18:11 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39120 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759325AbZFTBSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:18:01 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: VBN9zIQVM1lj_usnVvTnf7bpAHCb7yFBQj9S96EOTOfQU0E7UrkZABJsY84PzPjZaBeQa6c5zSxHoMLlVQITRGMAUOH0fMlNwTC_Oy1z1PTRKa5pqlhT.dfENLhTK0ruBiA8ewJ_iaDpTDe.VCU2IxJAEVQ3Otfnz2f5uKBjMQAnDNC9uNSFEFkXE9DHzEDB1Ci5NN2x0KjvqG.1dL_40D0UYfeDOMxR12d4TGDb0mE49rtRhL1ds.7R60_x1.2BZsM3tIImaxvS3EUTpjb80Bs9SL7sTjmmKw25v9VZwKKb_QWodwYJzmiRQ6HkXRUZxf8UGfLDYAN8NQKbpX0FNo.ESGyKpnwTRJytPWpenm0hSy6_jY5N458-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 09/13] generic GPIO support for the Freescale Coldfire 528x.
Date: Fri, 19 Jun 2009 18:11:08 -0700
Message-Id: <1245460272-4329-10-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-9-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-3-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-4-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-5-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-6-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-7-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-8-git-send-email-sfking@fdwdc.com>
 <1245460272-4329-9-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the 528x.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/m528xsim.h      |  151 +++++++++++
 arch/m68knommu/platform/528x/Makefile |    2 +-
 arch/m68knommu/platform/528x/gpio.c   |  438 +++++++++++++++++++++++++++++++++
 3 files changed, 590 insertions(+), 1 deletions(-)
 create mode 100644 arch/m68knommu/platform/528x/gpio.c

diff --git a/arch/m68k/include/asm/m528xsim.h b/arch/m68k/include/asm/m528xsim.h
index 28bf783..db3e22e 100644
--- a/arch/m68k/include/asm/m528xsim.h
+++ b/arch/m68k/include/asm/m528xsim.h
@@ -41,6 +41,157 @@
 #define	MCFSIM_DMR1		0x54		/* SDRAM address mask 1 */
 
 /*
+ * 	GPIO registers
+ */
+#define MCFGPIO_PORTA		(MCF_IPSBAR + 0x00100000)
+#define MCFGPIO_PORTB		(MCF_IPSBAR + 0x00100001)
+#define MCFGPIO_PORTC		(MCF_IPSBAR + 0x00100002)
+#define MCFGPIO_PORTD		(MCF_IPSBAR + 0x00100003)
+#define MCFGPIO_PORTE		(MCF_IPSBAR + 0x00100004)
+#define MCFGPIO_PORTF		(MCF_IPSBAR + 0x00100005)
+#define MCFGPIO_PORTG		(MCF_IPSBAR + 0x00100006)
+#define MCFGPIO_PORTH		(MCF_IPSBAR + 0x00100007)
+#define MCFGPIO_PORTJ		(MCF_IPSBAR + 0x00100008)
+#define MCFGPIO_PORTDD		(MCF_IPSBAR + 0x00100009)
+#define MCFGPIO_PORTEH		(MCF_IPSBAR + 0x0010000A)
+#define MCFGPIO_PORTEL		(MCF_IPSBAR + 0x0010000B)
+#define MCFGPIO_PORTAS		(MCF_IPSBAR + 0x0010000C)
+#define MCFGPIO_PORTQS		(MCF_IPSBAR + 0x0010000D)
+#define MCFGPIO_PORTSD		(MCF_IPSBAR + 0x0010000E)
+#define MCFGPIO_PORTTC		(MCF_IPSBAR + 0x0010000F)
+#define MCFGPIO_PORTTD		(MCF_IPSBAR + 0x00100010)
+#define MCFGPIO_PORTUA		(MCF_IPSBAR + 0x00100011)
+
+#define MCFGPIO_DDRA		(MCF_IPSBAR + 0x00100014)
+#define MCFGPIO_DDRB		(MCF_IPSBAR + 0x00100015)
+#define MCFGPIO_DDRC		(MCF_IPSBAR + 0x00100016)
+#define MCFGPIO_DDRD		(MCF_IPSBAR + 0x00100017)
+#define MCFGPIO_DDRE		(MCF_IPSBAR + 0x00100018)
+#define MCFGPIO_DDRF		(MCF_IPSBAR + 0x00100019)
+#define MCFGPIO_DDRG		(MCF_IPSBAR + 0x0010001A)
+#define MCFGPIO_DDRH		(MCF_IPSBAR + 0x0010001B)
+#define MCFGPIO_DDRJ		(MCF_IPSBAR + 0x0010001C)
+#define MCFGPIO_DDRDD		(MCF_IPSBAR + 0x0010001D)
+#define MCFGPIO_DDREH		(MCF_IPSBAR + 0x0010001E)
+#define MCFGPIO_DDREL		(MCF_IPSBAR + 0x0010001F)
+#define MCFGPIO_DDRAS		(MCF_IPSBAR + 0x00100020)
+#define MCFGPIO_DDRQS		(MCF_IPSBAR + 0x00100021)
+#define MCFGPIO_DDRSD		(MCF_IPSBAR + 0x00100022)
+#define MCFGPIO_DDRTC		(MCF_IPSBAR + 0x00100023)
+#define MCFGPIO_DDRTD		(MCF_IPSBAR + 0x00100024)
+#define MCFGPIO_DDRUA		(MCF_IPSBAR + 0x00100025)
+
+#define MCFGPIO_PORTAP		(MCF_IPSBAR + 0x00100028)
+#define MCFGPIO_PORTBP		(MCF_IPSBAR + 0x00100029)
+#define MCFGPIO_PORTCP		(MCF_IPSBAR + 0x0010002A)
+#define MCFGPIO_PORTDP		(MCF_IPSBAR + 0x0010002B)
+#define MCFGPIO_PORTEP		(MCF_IPSBAR + 0x0010002C)
+#define MCFGPIO_PORTFP		(MCF_IPSBAR + 0x0010002D)
+#define MCFGPIO_PORTGP		(MCF_IPSBAR + 0x0010002E)
+#define MCFGPIO_PORTHP		(MCF_IPSBAR + 0x0010002F)
+#define MCFGPIO_PORTJP		(MCF_IPSBAR + 0x00100030)
+#define MCFGPIO_PORTDDP		(MCF_IPSBAR + 0x00100031)
+#define MCFGPIO_PORTEHP		(MCF_IPSBAR + 0x00100032)
+#define MCFGPIO_PORTELP		(MCF_IPSBAR + 0x00100033)
+#define MCFGPIO_PORTASP		(MCF_IPSBAR + 0x00100034)
+#define MCFGPIO_PORTQSP		(MCF_IPSBAR + 0x00100035)
+#define MCFGPIO_PORTSDP		(MCF_IPSBAR + 0x00100036)
+#define MCFGPIO_PORTTCP		(MCF_IPSBAR + 0x00100037)
+#define MCFGPIO_PORTTDP		(MCF_IPSBAR + 0x00100038)
+#define MCFGPIO_PORTUAP		(MCF_IPSBAR + 0x00100039)
+
+#define MCFGPIO_SETA		(MCF_IPSBAR + 0x00100028)
+#define MCFGPIO_SETB		(MCF_IPSBAR + 0x00100029)
+#define MCFGPIO_SETC		(MCF_IPSBAR + 0x0010002A)
+#define MCFGPIO_SETD		(MCF_IPSBAR + 0x0010002B)
+#define MCFGPIO_SETE		(MCF_IPSBAR + 0x0010002C)
+#define MCFGPIO_SETF		(MCF_IPSBAR + 0x0010002D)
+#define MCFGPIO_SETG		(MCF_IPSBAR + 0x0010002E)
+#define MCFGPIO_SETH		(MCF_IPSBAR + 0x0010002F)
+#define MCFGPIO_SETJ		(MCF_IPSBAR + 0x00100030)
+#define MCFGPIO_SETDD		(MCF_IPSBAR + 0x00100031)
+#define MCFGPIO_SETEH		(MCF_IPSBAR + 0x00100032)
+#define MCFGPIO_SETEL		(MCF_IPSBAR + 0x00100033)
+#define MCFGPIO_SETAS		(MCF_IPSBAR + 0x00100034)
+#define MCFGPIO_SETQS		(MCF_IPSBAR + 0x00100035)
+#define MCFGPIO_SETSD		(MCF_IPSBAR + 0x00100036)
+#define MCFGPIO_SETTC		(MCF_IPSBAR + 0x00100037)
+#define MCFGPIO_SETTD		(MCF_IPSBAR + 0x00100038)
+#define MCFGPIO_SETUA		(MCF_IPSBAR + 0x00100039)
+
+#define MCFGPIO_CLRA		(MCF_IPSBAR + 0x0010003C)
+#define MCFGPIO_CLRB		(MCF_IPSBAR + 0x0010003D)
+#define MCFGPIO_CLRC		(MCF_IPSBAR + 0x0010003E)
+#define MCFGPIO_CLRD		(MCF_IPSBAR + 0x0010003F)
+#define MCFGPIO_CLRE		(MCF_IPSBAR + 0x00100040)
+#define MCFGPIO_CLRF		(MCF_IPSBAR + 0x00100041)
+#define MCFGPIO_CLRG		(MCF_IPSBAR + 0x00100042)
+#define MCFGPIO_CLRH		(MCF_IPSBAR + 0x00100043)
+#define MCFGPIO_CLRJ		(MCF_IPSBAR + 0x00100044)
+#define MCFGPIO_CLRDD		(MCF_IPSBAR + 0x00100045)
+#define MCFGPIO_CLREH		(MCF_IPSBAR + 0x00100046)
+#define MCFGPIO_CLREL		(MCF_IPSBAR + 0x00100047)
+#define MCFGPIO_CLRAS		(MCF_IPSBAR + 0x00100048)
+#define MCFGPIO_CLRQS		(MCF_IPSBAR + 0x00100049)
+#define MCFGPIO_CLRSD		(MCF_IPSBAR + 0x0010004A)
+#define MCFGPIO_CLRTC		(MCF_IPSBAR + 0x0010004B)
+#define MCFGPIO_CLRTD		(MCF_IPSBAR + 0x0010004C)
+#define MCFGPIO_CLRUA		(MCF_IPSBAR + 0x0010004D)
+
+#define MCFGPIO_PBCDPAR		(MCF_IPSBAR + 0x00100050)
+#define MCFGPIO_PFPAR		(MCF_IPSBAR + 0x00100051)
+#define MCFGPIO_PEPAR		(MCF_IPSBAR + 0x00100052)
+#define MCFGPIO_PJPAR		(MCF_IPSBAR + 0x00100054)
+#define MCFGPIO_PSDPAR		(MCF_IPSBAR + 0x00100055)
+#define MCFGPIO_PASPAR		(MCF_IPSBAR + 0x00100056)
+#define MCFGPIO_PEHLPAR		(MCF_IPSBAR + 0x00100058)
+#define MCFGPIO_PQSPAR		(MCF_IPSBAR + 0x00100059)
+#define MCFGPIO_PTCPAR		(MCF_IPSBAR + 0x0010005A)
+#define MCFGPIO_PTDPAR		(MCF_IPSBAR + 0x0010005B)
+#define MCFGPIO_PUAPAR		(MCF_IPSBAR + 0x0010005C)
+
+/*
+ * 	Edge Port registers
+ */
+#define MCFEPORT_EPPAR		(MCF_IPSBAR + 0x00130000)
+#define MCFEPORT_EPDDR		(MCF_IPSBAR + 0x00130002)
+#define MCFEPORT_EPIER		(MCF_IPSBAR + 0x00130003)
+#define MCFEPORT_EPDR		(MCF_IPSBAR + 0x00130004)
+#define MCFEPORT_EPPDR		(MCF_IPSBAR + 0x00130005)
+#define MCFEPORT_EPFR		(MCF_IPSBAR + 0x00130006)
+
+/*
+ * 	Queued ADC registers
+ */
+#define MCFQADC_PORTQA		(MCF_IPSBAR + 0x00190006)
+#define MCFQADC_PORTQB		(MCF_IPSBAR + 0x00190007)
+#define MCFQADC_DDRQA		(MCF_IPSBAR + 0x00190008)
+#define MCFQADC_DDRQB		(MCF_IPSBAR + 0x00190009)
+
+/*
+ * 	General Purpose Timers registers
+ */
+#define MCFGPTA_GPTPORT		(MCF_IPSBAR + 0x001A001D)
+#define MCFGPTA_GPTDDR		(MCF_IPSBAR + 0x001A001E)
+#define MCFGPTB_GPTPORT		(MCF_IPSBAR + 0x001B001D)
+#define MCFGPTB_GPTDDR		(MCF_IPSBAR + 0x001B001E)
+/*
+ *
+ * definitions for generic gpio support
+ *
+ */
+#define MCFGPIO_PODR		MCFGPIO_PORTA	/* port output data */
+#define MCFGPIO_PDDR		MCFGPIO_DDRA	/* port data direction */
+#define MCFGPIO_PPDR		MCFGPIO_PORTAP	/* port pin data */
+#define MCFGPIO_SETR		MCFGPIO_SETA	/* set output */
+#define MCFGPIO_CLRR		MCFGPIO_CLRA	/* clr output */
+
+#define MCFGPIO_IRQ_MAX		8
+#define MCFGPIO_IRQ_VECBASE	MCFINT_VECBASE
+#define MCFGPIO_PIN_MAX		180
+
+
+/*
  *	Derek Cheung - 6 Feb 2005
  *		add I2C and QSPI register definition using Freescale's MCF5282
  */
diff --git a/arch/m68knommu/platform/528x/Makefile b/arch/m68knommu/platform/528x/Makefile
index 26135d9..3d90e6d 100644
--- a/arch/m68knommu/platform/528x/Makefile
+++ b/arch/m68knommu/platform/528x/Makefile
@@ -14,5 +14,5 @@
 
 asflags-$(CONFIG_FULLDEBUG) := -DDEBUGGER_COMPATIBLE_CACHE=1
 
-obj-y := config.o
+obj-y := config.o gpio.o
 
diff --git a/arch/m68knommu/platform/528x/gpio.c b/arch/m68knommu/platform/528x/gpio.c
new file mode 100644
index 0000000..af0376e
--- /dev/null
+++ b/arch/m68knommu/platform/528x/gpio.c
@@ -0,0 +1,438 @@
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
+			.label			= "NQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 1,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPTA_GPTDDR,
+		.podr				= MCFGPTA_GPTPORT,
+		.ppdr				= MCFGPTB_GPTPORT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPTB_GPTDDR,
+		.podr				= MCFGPTB_GPTPORT,
+		.ppdr				= MCFGPTB_GPTPORT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFQADC_DDRQA,
+		.podr				= MCFQADC_PORTQA,
+		.ppdr				= MCFQADC_PORTQA,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFQADC_DDRQB,
+		.podr				= MCFQADC_PORTQB,
+		.ppdr				= MCFQADC_PORTQB,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "A",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRA,
+		.podr				= MCFGPIO_PORTA,
+		.ppdr				= MCFGPIO_PORTAP,
+		.setr				= MCFGPIO_SETA,
+		.clrr				= MCFGPIO_CLRA,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "B",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 48,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRB,
+		.podr				= MCFGPIO_PORTB,
+		.ppdr				= MCFGPIO_PORTBP,
+		.setr				= MCFGPIO_SETB,
+		.clrr				= MCFGPIO_CLRB,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRC,
+		.podr				= MCFGPIO_PORTC,
+		.ppdr				= MCFGPIO_PORTCP,
+		.setr				= MCFGPIO_SETC,
+		.clrr				= MCFGPIO_CLRC,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "D",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRD,
+		.podr				= MCFGPIO_PORTD,
+		.ppdr				= MCFGPIO_PORTDP,
+		.setr				= MCFGPIO_SETD,
+		.clrr				= MCFGPIO_CLRD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "E",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRE,
+		.podr				= MCFGPIO_PORTE,
+		.ppdr				= MCFGPIO_PORTEP,
+		.setr				= MCFGPIO_SETE,
+		.clrr				= MCFGPIO_CLRE,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "F",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRF,
+		.podr				= MCFGPIO_PORTF,
+		.ppdr				= MCFGPIO_PORTFP,
+		.setr				= MCFGPIO_SETF,
+		.clrr				= MCFGPIO_CLRF,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "G",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRG,
+		.podr				= MCFGPIO_PORTG,
+		.ppdr				= MCFGPIO_PORTGP,
+		.setr				= MCFGPIO_SETG,
+		.clrr				= MCFGPIO_CLRG,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRH,
+		.podr				= MCFGPIO_PORTH,
+		.ppdr				= MCFGPIO_PORTHP,
+		.setr				= MCFGPIO_SETH,
+		.clrr				= MCFGPIO_CLRH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "J",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRJ,
+		.podr				= MCFGPIO_PORTJ,
+		.ppdr				= MCFGPIO_PORTJP,
+		.setr				= MCFGPIO_SETJ,
+		.clrr				= MCFGPIO_CLRJ,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 112,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRDD,
+		.podr				= MCFGPIO_PORTDD,
+		.ppdr				= MCFGPIO_PORTDDP,
+		.setr				= MCFGPIO_SETDD,
+		.clrr				= MCFGPIO_CLRDD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "EH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 120,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDREH,
+		.podr				= MCFGPIO_PORTEH,
+		.ppdr				= MCFGPIO_PORTEHP,
+		.setr				= MCFGPIO_SETEH,
+		.clrr				= MCFGPIO_CLREH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "EL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDREL,
+		.podr				= MCFGPIO_PORTEL,
+		.ppdr				= MCFGPIO_PORTELP,
+		.setr				= MCFGPIO_SETEL,
+		.clrr				= MCFGPIO_CLREL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "AS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 136,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_DDRAS,
+		.podr				= MCFGPIO_PORTAS,
+		.ppdr				= MCFGPIO_PORTASP,
+		.setr				= MCFGPIO_SETAS,
+		.clrr				= MCFGPIO_CLRAS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 144,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_DDRQS,
+		.podr				= MCFGPIO_PORTQS,
+		.ppdr				= MCFGPIO_PORTQSP,
+		.setr				= MCFGPIO_SETQS,
+		.clrr				= MCFGPIO_CLRQS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 152,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_DDRSD,
+		.podr				= MCFGPIO_PORTSD,
+		.ppdr				= MCFGPIO_PORTSDP,
+		.setr				= MCFGPIO_SETSD,
+		.clrr				= MCFGPIO_CLRSD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TC",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 160,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRTC,
+		.podr				= MCFGPIO_PORTTC,
+		.ppdr				= MCFGPIO_PORTTCP,
+		.setr				= MCFGPIO_SETTC,
+		.clrr				= MCFGPIO_CLRTC,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 168,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRTD,
+		.podr				= MCFGPIO_PORTTD,
+		.ppdr				= MCFGPIO_PORTTDP,
+		.setr				= MCFGPIO_SETTD,
+		.clrr				= MCFGPIO_CLRTD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 176,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRUA,
+		.podr				= MCFGPIO_PORTUA,
+		.ppdr				= MCFGPIO_PORTUAP,
+		.setr				= MCFGPIO_SETUA,
+		.clrr				= MCFGPIO_CLRUA,
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

