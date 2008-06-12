Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYFLKVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYFLKVU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 06:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbYFLKVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 06:21:07 -0400
Received: from vigor.karmaclothing.net ([217.169.26.28]:37726 "EHLO
	vigor.karmaclothing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYFLKVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 06:21:06 -0400
Date: Thu, 12 Jun 2008 11:18:39 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: linux-mips@linux-mips.org, sshtylyov@ru.mvista.com, drzeus@drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Alchemy: register mmc platform device for
	db1200/pb1200 boards.
Message-ID: <20080612101839.GC21601@linux-mips.org>
References: <20080609063521.GA8724@roarinelk.homelinux.net> <20080609063702.GC8724@roarinelk.homelinux.net> <20080612090206.GB21601@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612090206.GB21601@linux-mips.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 10:02:06AM +0100, Ralf Baechle wrote:

I cleaned the numerals for the DMA constants with below patch which now
is in the 2.6.27 patch queue.

  Ralf

From: Ralf Baechle <ralf@linux-mips.org>

[MIPS] Alchemy, PNX: Use symbolic constants for DMA masks.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 arch/mips/au1000/common/platform.c      |   29 +++++++++++++++--------------
 arch/mips/au1000/pb1200/platform.c      |    5 +++--
 arch/mips/nxp/pnx8550/common/platform.c |    9 +++++----
 3 files changed, 23 insertions(+), 20 deletions(-)

Index: linux-queue/arch/mips/au1000/common/platform.c
===================================================================
--- linux-queue.orig/arch/mips/au1000/common/platform.c
+++ linux-queue/arch/mips/au1000/common/platform.c
@@ -11,6 +11,7 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 #include <linux/init.h>
@@ -77,14 +78,14 @@ static struct resource au1xxx_usb_ohci_r
 };
 
 /* The dmamask must be set for OHCI to work */
-static u64 ohci_dmamask = ~(u32)0;
+static u64 ohci_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_usb_ohci_device = {
 	.name		= "au1xxx-ohci",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &ohci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_ohci_resources),
 	.resource	= au1xxx_usb_ohci_resources,
@@ -106,14 +107,14 @@ static struct resource au1100_lcd_resour
 	}
 };
 
-static u64 au1100_lcd_dmamask = ~(u32)0;
+static u64 au1100_lcd_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1100_lcd_device = {
 	.name           = "au1100-lcd",
 	.id             = 0,
 	.dev = {
 		.dma_mask               = &au1100_lcd_dmamask,
-		.coherent_dma_mask      = 0xffffffff,
+		.coherent_dma_mask      = DMA_32BIT_MASK,
 	},
 	.num_resources  = ARRAY_SIZE(au1100_lcd_resources),
 	.resource       = au1100_lcd_resources,
@@ -135,14 +136,14 @@ static struct resource au1xxx_usb_ehci_r
 	},
 };
 
-static u64 ehci_dmamask = ~(u32)0;
+static u64 ehci_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_usb_ehci_device = {
 	.name		= "au1xxx-ehci",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &ehci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_ehci_resources),
 	.resource	= au1xxx_usb_ehci_resources,
@@ -180,14 +181,14 @@ static struct resource au1xxx_mmc_resour
 	}
 };
 
-static u64 udc_dmamask = ~(u32)0;
+static u64 udc_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_usb_gdt_device = {
 	.name		= "au1xxx-udc",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &udc_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_gdt_resources),
 	.resource	= au1xxx_usb_gdt_resources,
@@ -207,14 +208,14 @@ static struct resource au1xxx_usb_otg_re
 	},
 };
 
-static u64 uoc_dmamask = ~(u32)0;
+static u64 uoc_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_usb_otg_device = {
 	.name		= "au1xxx-uoc",
 	.id		= 0,
 	.dev = {
 		.dma_mask		= &uoc_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(au1xxx_usb_otg_resources),
 	.resource	= au1xxx_usb_otg_resources,
@@ -233,27 +234,27 @@ static struct resource au1200_lcd_resour
 	}
 };
 
-static u64 au1200_lcd_dmamask = ~(u32)0;
+static u64 au1200_lcd_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device au1200_lcd_device = {
 	.name           = "au1200-lcd",
 	.id             = 0,
 	.dev = {
 		.dma_mask               = &au1200_lcd_dmamask,
-		.coherent_dma_mask      = 0xffffffff,
+		.coherent_dma_mask      = DMA_32BIT_MASK,
 	},
 	.num_resources  = ARRAY_SIZE(au1200_lcd_resources),
 	.resource       = au1200_lcd_resources,
 };
 
-static u64 au1xxx_mmc_dmamask =  ~(u32)0;
+static u64 au1xxx_mmc_dmamask =  DMA_32BIT_MASK;
 
 static struct platform_device au1xxx_mmc_device = {
 	.name = "au1xxx-mmc",
 	.id = 0,
 	.dev = {
 		.dma_mask               = &au1xxx_mmc_dmamask,
-		.coherent_dma_mask      = 0xffffffff,
+		.coherent_dma_mask      = DMA_32BIT_MASK,
 	},
 	.num_resources  = ARRAY_SIZE(au1xxx_mmc_resources),
 	.resource       = au1xxx_mmc_resources,
Index: linux-queue/arch/mips/au1000/pb1200/platform.c
===================================================================
--- linux-queue.orig/arch/mips/au1000/pb1200/platform.c
+++ linux-queue/arch/mips/au1000/pb1200/platform.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
@@ -36,14 +37,14 @@ static struct resource ide_resources[] =
 	}
 };
 
-static u64 ide_dmamask = ~(u32)0;
+static u64 ide_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device ide_device = {
 	.name		= "au1200-ide",
 	.id		= 0,
 	.dev = {
 		.dma_mask 		= &ide_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(ide_resources),
 	.resource	= ide_resources
Index: linux-queue/arch/mips/nxp/pnx8550/common/platform.c
===================================================================
--- linux-queue.orig/arch/mips/nxp/pnx8550/common/platform.c
+++ linux-queue/arch/mips/nxp/pnx8550/common/platform.c
@@ -13,6 +13,7 @@
  * warranty of any kind, whether express or implied.
  */
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/resource.h>
@@ -91,16 +92,16 @@ struct pnx8xxx_port pnx8xxx_ports[] = {
 };
 
 /* The dmamask must be set for OHCI to work */
-static u64 ohci_dmamask = ~(u32)0;
+static u64 ohci_dmamask = DMA_32BIT_MASK;
 
-static u64 uart_dmamask = ~(u32)0;
+static u64 uart_dmamask = DMA_32BIT_MASK;
 
 static struct platform_device pnx8550_usb_ohci_device = {
 	.name		= "pnx8550-ohci",
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &ohci_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 	},
 	.num_resources	= ARRAY_SIZE(pnx8550_usb_ohci_resources),
 	.resource	= pnx8550_usb_ohci_resources,
@@ -111,7 +112,7 @@ static struct platform_device pnx8550_ua
 	.id		= -1,
 	.dev = {
 		.dma_mask		= &uart_dmamask,
-		.coherent_dma_mask	= 0xffffffff,
+		.coherent_dma_mask	= DMA_32BIT_MASK,
 		.platform_data = pnx8xxx_ports,
 	},
 	.num_resources	= ARRAY_SIZE(pnx8550_uart_resources),
