Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbZIXK1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbZIXK1j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZIXK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:27:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57506 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbZIXK1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:27:23 -0400
Message-ID: <65265.192.168.10.89.1253788046.squirrel@dbdmail.itg.ti.com>
Date: Thu, 24 Sep 2009 15:57:26 +0530 (IST)
Subject: [PATCHv1 2/3] OMAP UART: Add platform data for omap-serial driver.
From: "Govindraj.R" <govindraj.raja@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Govindraj R <govindraj.raja@ti.com>

This patch adds platform data support for omap-serial driver.

Signed-off-by:	Govindraj R <govindraj.raja@ti.com>
---
 arch/arm/mach-omap2/serial.c |  140 +++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index 021130d..0730f9d 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -13,6 +13,9 @@
  * Copyright (C) 2009 Texas Instruments
  * Added OMAP4 support - Santosh Shilimkar <santosh.shilimkar@ti.com
  *
+ * Copyright (C) 2009 Texas Instruments
+ * Added support for Omap-Serial driver - Govindraj R <govindraj.raja@ti.com>
+ *
  * This file is subject to the terms and conditions of the GNU General Public
  * License. See the file "COPYING" in the main directory of this archive
  * for more details.
@@ -29,6 +32,10 @@
 #include <mach/clock.h>
 #include <mach/control.h>

+#ifdef CONFIG_SERIAL_OMAP
+#include <mach/dma.h>
+#include <mach/omap-serial.h>
+#endif
 #include "prm.h"
 #include "pm.h"
 #include "prm-regbits-34xx.h"
@@ -37,6 +44,7 @@

 #define DEFAULT_TIMEOUT (5 * HZ)

+#ifdef CONFIG_SERIAL_8250
 struct omap_uart_state {
 	int num;
 	int can_sleep;
@@ -648,3 +656,135 @@ void __init omap_serial_init(void)
 		}
 	}
 }
+#endif
+
+#ifdef CONFIG_SERIAL_OMAP
+
+static struct uart_dma_info uart1_dma_state = {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART1
+		.dma_enabled	= 1,
+		.rx_dma_bufsize	= 4096,
+		.rx_timeout	= 1,
+#endif
+};
+
+static struct uart_dma_info uart2_dma_state = {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART2
+		.dma_enabled	= 1,
+		.rx_dma_bufsize	= 4096,
+		.rx_timeout	= 1,
+#endif
+};
+
+static struct uart_dma_info uart3_dma_state = {
+#ifdef CONFIG_SERIAL_OMAP_DMA_UART3
+		.dma_enabled	= 1,
+		.rx_dma_bufsize	= 4096,
+		.rx_timeout	= 1,
+#endif
+};
+
+static struct resource omap2_uart1_resources[] = {
+	{
+		.start          = OMAP_UART1_BASE,
+		.end            = OMAP_UART1_BASE + 0x3ff,
+		.flags          = IORESOURCE_MEM,
+	}, {
+		/* UART1 IRQ - 72*/
+		.start          = INT_24XX_UART1_IRQ,
+		.flags          = IORESOURCE_IRQ,
+	}, {
+		/* UART1 TX DMA CHANNEL -S_DMA_48- */
+		.start		= OMAP24XX_DMA_UART1_TX,
+		.flags		= IORESOURCE_DMA,
+	}, {
+		/* UART1 RX DMA CHANNEL -S_DMA_49- */
+		.start		= OMAP24XX_DMA_UART1_RX,
+		.flags		= IORESOURCE_DMA,
+	}
+};
+
+static struct resource omap2_uart2_resources[] = {
+	{
+		.start          = OMAP_UART2_BASE,
+		.end            = OMAP_UART2_BASE + 0x3ff,
+		.flags          = IORESOURCE_MEM,
+	}, {
+		/* UART2 IRQ - 73*/
+		.start          = INT_24XX_UART2_IRQ,
+		.flags          = IORESOURCE_IRQ,
+	}, {
+		/* UART2 TX DMA CHANNEL -S_DMA_50- */
+		.start		= OMAP24XX_DMA_UART2_TX,
+		.flags		= IORESOURCE_DMA,
+	}, {
+		/* UART2 RX DMA CHANNEL -S_DMA_51- */
+		.start		= OMAP24XX_DMA_UART2_RX,
+		.flags		= IORESOURCE_DMA,
+	}
+};
+
+static struct resource omap2_uart3_resources[] = {
+	{
+		.start          = OMAP_UART3_BASE,
+		.end            = OMAP_UART3_BASE + 0x3ff,
+		.flags          = IORESOURCE_MEM,
+	}, {
+		/* UART3 IRQ - 74*/
+		.start          = INT_24XX_UART3_IRQ,
+		.flags          = IORESOURCE_IRQ,
+	}, {
+		/* UART3 TX DMA CHANNEL -S_DMA_52- */
+		.start		= OMAP24XX_DMA_UART3_TX,
+		.flags		= IORESOURCE_DMA,
+	}, {
+		/* UART3 RX DMA CHANNEL -S_DMA_53- */
+		.start		= OMAP24XX_DMA_UART3_RX,
+		.flags		= IORESOURCE_DMA,
+	}
+};
+
+/* OMAP UART platform structure */
+static struct platform_device uart1_device = {
+	.name			= "omap-uart",
+	.id			= 1,
+	.num_resources		= ARRAY_SIZE(omap2_uart1_resources),
+	.resource		= omap2_uart1_resources,
+	.dev			= {
+		.platform_data  = &uart1_dma_state,
+	},
+};
+static struct platform_device uart2_device = {
+	.name			= "omap-uart",
+	.id			= 2,
+	.num_resources		= ARRAY_SIZE(omap2_uart2_resources),
+	.resource		= omap2_uart2_resources,
+	.dev			= {
+		.platform_data  = &uart2_dma_state,
+	},
+};
+static struct platform_device uart3_device = {
+	.name			= "omap-uart",
+	.id			= 3,
+	.num_resources		= ARRAY_SIZE(omap2_uart3_resources),
+	.resource		= omap2_uart3_resources,
+	.dev			= {
+		.platform_data  = &uart3_dma_state,
+	},
+};
+
+static struct platform_device *uart_devices[] = {
+	&uart1_device,
+	&uart2_device,
+	&uart3_device,
+};
+
+void __init omap_serial_init(void)
+{
+	int ret = 0, i;
+	for (i = 0; i < OMAP_MAX_NR_PORTS; i++)
+		omap_uart_idle_init(i);
+
+	ret = platform_add_devices(uart_devices, ARRAY_SIZE(uart_devices));
+}
+#endif /* CONFIG_SERIAL_OMAP */

