Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbYJHH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbYJHH1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 03:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbYJHH1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 03:27:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60438 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYJHH1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 03:27:00 -0400
From: "Gadiyar, Anand" <gadiyar@ti.com>
To: "johnpol@2ka.mipt.ru" <johnpol@2ka.mipt.ru>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "Chikkature Rajashekar, Madhusudhan" <madhu.cr@ti.com>
Date: Wed, 8 Oct 2008 12:53:57 +0530
Subject: [PATCH 3/5] HDQ: OMAP: Add HDQ Device
Thread-Topic: [PATCH 3/5] HDQ: OMAP: Add HDQ Device
Thread-Index: AckpFtPv8pTj4195Tke8n+nk3fgaIQ==
Message-ID: <5A47E75E594F054BAF48C5E4FC4B92AB02D6107AF4@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Madhusudhan Chikkature <madhu.cr@ti.com>

Device registeration for the TI OMAP2430/3430 HDQ driver.

Signed-off-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
Acked-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 arch/arm/mach-omap2/devices.c          |   33 +++++++++++++++++++++++++++++++++
 arch/arm/plat-omap/include/mach/irqs.h |    1 +
 2 files changed, 34 insertions(+)

Index: linux-2.6/arch/arm/mach-omap2/devices.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-omap2/devices.c	2008-09-19 13:39:38.000000000 +0530
+++ linux-2.6/arch/arm/mach-omap2/devices.c	2008-09-30 10:07:51.000000000 +0530
@@ -201,6 +201,38 @@ static void omap_init_mcspi(void)
 static inline void omap_init_mcspi(void) {}
 #endif
 
+#if defined(CONFIG_HDQ_MASTER_OMAP) || defined(CONFIG_HDQ_MASTER_OMAP_MODULE)
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3430)
+#define OMAP_HDQ_BASE		0x480B2000
+#endif
+static struct resource omap_hdq_resources[] = {
+	{
+		.start		= OMAP_HDQ_BASE,
+		.end		= OMAP_HDQ_BASE + 0x1C,
+		.flags		= IORESOURCE_MEM,
+	},
+	{
+		.start		= INT_24XX_HDQ_IRQ,
+		.flags		= IORESOURCE_IRQ,
+	},
+};
+static struct platform_device omap_hdq_dev = {
+	.name		= "omap_hdq",
+	.id = 0,
+	.dev = {
+		.platform_data = NULL,
+	},
+	.num_resources		= ARRAY_SIZE(omap_hdq_resources),
+	.resource		= omap_hdq_resources,
+};
+static inline void omap_hdq_init(void)
+{
+	(void) platform_device_register(&omap_hdq_dev);
+}
+#else
+static inline void omap_hdq_init(void) {}
+#endif
+
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
@@ -212,6 +244,7 @@ static int __init omap2_init_devices(voi
 	omap_init_mbox();
 	omap_init_mcspi();
 	omap_init_sti();
+	omap_hdq_init();
 
 	return 0;
 }
Index: linux-2.6/arch/arm/plat-omap/include/mach/irqs.h
===================================================================
--- linux-2.6.orig/arch/arm/plat-omap/include/mach/irqs.h	2008-09-26 14:34:25.000000000 +0530
+++ linux-2.6/arch/arm/plat-omap/include/mach/irqs.h	2008-09-26 14:55:19.000000000 +0530
@@ -265,6 +265,7 @@
 #define INT_24XX_GPTIMER12	48
 #define INT_24XX_I2C1_IRQ	56
 #define INT_24XX_I2C2_IRQ	57
+#define INT_24XX_HDQ_IRQ	58
 #define INT_24XX_MCBSP1_IRQ_TX	59
 #define INT_24XX_MCBSP1_IRQ_RX	60
 #define INT_24XX_MCBSP2_IRQ_TX	62