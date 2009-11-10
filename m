Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbZKJDVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbZKJDVK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 22:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755366AbZKJDVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 22:21:09 -0500
Received: from d1.icnet.pl ([212.160.220.21]:50337 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282AbZKJDVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 22:21:08 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: linux-omap@vger.kernel.org
Subject: [PATCH] OMAP: DMA: Use some define rather than a hexadecimal constant for LCD register
Date: Tue, 10 Nov 2009 04:20:16 +0100
User-Agent: KMail/1.9.10
Cc: Tony Lindgren <tony@atomide.com>, Imre Deak <imre.deak@nokia.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911100420.19786.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch corrects the issue introduced with my previous patch:
	"OMAP: DMA: Fix omapfb/lcdc on OMAP1510 broken when PM set"
as pointed out by OMAP subsystem maintainer.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
Hi,

I'd really like to have the first one get in as a fix in the -rc series,
that's why I decided to correct the issue in a follow up.

Thanks,
Janusz
---
diff -upr linux-2.6.32-rc6.orig/arch/arm/plat-omap/dma.c linux-2.6.32-rc6/arch/arm/plat-omap/dma.c
--- linux-2.6.32-rc6.orig/arch/arm/plat-omap/dma.c	2009-11-05 19:30:39.000000000 +0100
+++ linux-2.6.32-rc6/arch/arm/plat-omap/dma.c	2009-11-10 03:57:06.000000000 +0100
@@ -34,6 +34,7 @@
 #include <mach/hardware.h>
 #include <mach/dma.h>
 
+#include <mach/omapfb.h>
 #include <mach/tc.h>
 
 #undef DEBUG
@@ -1113,7 +1114,7 @@ int omap_dma_running(void)
 	 * when it gets enabled, so assume DMA running if LCD enabled.
 	 */
 	if (cpu_is_omap1510())
-		if (omap_readw(0xfffec000 + 0x00) & (1 << 0))
+		if (omap_readw(OMAP_LCDC_CONTROL) & OMAP_LCDC_CTRL_LCD_EN)
 			return 1;
 
 	/* Check if LCD DMA is running */
diff -upr linux-2.6.32-rc6.orig/arch/arm/plat-omap/include/mach/omapfb.h linux-2.6.32-rc6/arch/arm/plat-omap/include/mach/omapfb.h
--- linux-2.6.32-rc6.orig/arch/arm/plat-omap/include/mach/omapfb.h	2009-11-03 20:37:49.000000000 +0100
+++ linux-2.6.32-rc6/arch/arm/plat-omap/include/mach/omapfb.h	2009-11-10 03:52:00.000000000 +0100
@@ -170,6 +170,38 @@ enum omapfb_update_mode {
 
 #include <mach/board.h>
 
+#define OMAP_LCDC_BASE			0xfffec000
+#define OMAP_LCDC_SIZE			256
+#define OMAP_LCDC_IRQ			INT_LCD_CTRL
+
+#define OMAP_LCDC_CONTROL		(OMAP_LCDC_BASE + 0x00)
+#define OMAP_LCDC_TIMING0		(OMAP_LCDC_BASE + 0x04)
+#define OMAP_LCDC_TIMING1		(OMAP_LCDC_BASE + 0x08)
+#define OMAP_LCDC_TIMING2		(OMAP_LCDC_BASE + 0x0c)
+#define OMAP_LCDC_STATUS		(OMAP_LCDC_BASE + 0x10)
+#define OMAP_LCDC_SUBPANEL		(OMAP_LCDC_BASE + 0x14)
+#define OMAP_LCDC_LINE_INT		(OMAP_LCDC_BASE + 0x18)
+#define OMAP_LCDC_DISPLAY_STATUS	(OMAP_LCDC_BASE + 0x1c)
+
+#define OMAP_LCDC_STAT_DONE		(1 << 0)
+#define OMAP_LCDC_STAT_VSYNC		(1 << 1)
+#define OMAP_LCDC_STAT_SYNC_LOST	(1 << 2)
+#define OMAP_LCDC_STAT_ABC		(1 << 3)
+#define OMAP_LCDC_STAT_LINE_INT		(1 << 4)
+#define OMAP_LCDC_STAT_FUF		(1 << 5)
+#define OMAP_LCDC_STAT_LOADED_PALETTE	(1 << 6)
+
+#define OMAP_LCDC_CTRL_LCD_EN		(1 << 0)
+#define OMAP_LCDC_CTRL_LCD_TFT		(1 << 7)
+#define OMAP_LCDC_CTRL_LINE_IRQ_CLR_SEL	(1 << 10)
+
+#define OMAP_LCDC_IRQ_VSYNC		(1 << 2)
+#define OMAP_LCDC_IRQ_DONE		(1 << 3)
+#define OMAP_LCDC_IRQ_LOADED_PALETTE	(1 << 4)
+#define OMAP_LCDC_IRQ_LINE_NIRQ		(1 << 5)
+#define OMAP_LCDC_IRQ_LINE		(1 << 6)
+#define OMAP_LCDC_IRQ_MASK		(((1 << 5) - 1) << 2)
+
 #define OMAP_LCDC_INV_VSYNC             0x0001
 #define OMAP_LCDC_INV_HSYNC             0x0002
 #define OMAP_LCDC_INV_PIX_CLOCK         0x0004
diff -upr linux-2.6.32-rc6.orig/drivers/video/omap/lcdc.c linux-2.6.32-rc6/drivers/video/omap/lcdc.c
--- linux-2.6.32-rc6.orig/drivers/video/omap/lcdc.c	2009-11-03 20:37:49.000000000 +0100
+++ linux-2.6.32-rc6/drivers/video/omap/lcdc.c	2009-11-10 03:51:16.000000000 +0100
@@ -38,38 +38,6 @@
 
 #define MODULE_NAME			"lcdc"
 
-#define OMAP_LCDC_BASE			0xfffec000
-#define OMAP_LCDC_SIZE			256
-#define OMAP_LCDC_IRQ			INT_LCD_CTRL
-
-#define OMAP_LCDC_CONTROL		(OMAP_LCDC_BASE + 0x00)
-#define OMAP_LCDC_TIMING0		(OMAP_LCDC_BASE + 0x04)
-#define OMAP_LCDC_TIMING1		(OMAP_LCDC_BASE + 0x08)
-#define OMAP_LCDC_TIMING2		(OMAP_LCDC_BASE + 0x0c)
-#define OMAP_LCDC_STATUS		(OMAP_LCDC_BASE + 0x10)
-#define OMAP_LCDC_SUBPANEL		(OMAP_LCDC_BASE + 0x14)
-#define OMAP_LCDC_LINE_INT		(OMAP_LCDC_BASE + 0x18)
-#define OMAP_LCDC_DISPLAY_STATUS	(OMAP_LCDC_BASE + 0x1c)
-
-#define OMAP_LCDC_STAT_DONE		(1 << 0)
-#define OMAP_LCDC_STAT_VSYNC		(1 << 1)
-#define OMAP_LCDC_STAT_SYNC_LOST	(1 << 2)
-#define OMAP_LCDC_STAT_ABC		(1 << 3)
-#define OMAP_LCDC_STAT_LINE_INT		(1 << 4)
-#define OMAP_LCDC_STAT_FUF		(1 << 5)
-#define OMAP_LCDC_STAT_LOADED_PALETTE	(1 << 6)
-
-#define OMAP_LCDC_CTRL_LCD_EN		(1 << 0)
-#define OMAP_LCDC_CTRL_LCD_TFT		(1 << 7)
-#define OMAP_LCDC_CTRL_LINE_IRQ_CLR_SEL	(1 << 10)
-
-#define OMAP_LCDC_IRQ_VSYNC		(1 << 2)
-#define OMAP_LCDC_IRQ_DONE		(1 << 3)
-#define OMAP_LCDC_IRQ_LOADED_PALETTE	(1 << 4)
-#define OMAP_LCDC_IRQ_LINE_NIRQ		(1 << 5)
-#define OMAP_LCDC_IRQ_LINE		(1 << 6)
-#define OMAP_LCDC_IRQ_MASK		(((1 << 5) - 1) << 2)
-
 #define MAX_PALETTE_SIZE		PAGE_SIZE
 
 enum lcdc_load_mode {
