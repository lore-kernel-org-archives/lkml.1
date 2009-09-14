Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbZINURA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbZINURA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZINUQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:16:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54102 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933572AbZINUIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:08:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 40/72] Blackfin: drop unused MMR defines that only cause bad code to be written
Date: Mon, 14 Sep 2009 16:07:44 -0400
Message-Id: <1252958896-25150-41-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/include/mach/blackfin.h |   10 ---
 arch/blackfin/mach-bf527/include/mach/blackfin.h |   10 ---
 arch/blackfin/mach-bf533/dma.c                   |    8 +-
 arch/blackfin/mach-bf533/include/mach/blackfin.h |    7 --
 arch/blackfin/mach-bf537/dma.c                   |    8 +-
 arch/blackfin/mach-bf537/include/mach/blackfin.h |   90 ----------------------
 arch/blackfin/mach-bf538/include/mach/blackfin.h |   10 ---
 arch/blackfin/mach-bf548/include/mach/blackfin.h |   89 ---------------------
 8 files changed, 8 insertions(+), 224 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/blackfin.h b/arch/blackfin/mach-bf518/include/mach/blackfin.h
index e8e14c2..83421d3 100644
--- a/arch/blackfin/mach-bf518/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf518/include/mach/blackfin.h
@@ -68,11 +68,6 @@
 #endif
 #endif
 
-/* UART_IIR Register */
-#define STATUS(x)	((x << 1) & 0x06)
-#define STATUS_P1	0x02
-#define STATUS_P0	0x01
-
 #define BFIN_UART_NR_PORTS	2
 
 #define OFFSET_THR              0x00	/* Transmit Holding register            */
@@ -88,11 +83,6 @@
 #define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
 #define OFFSET_GCTL             0x24	/* Global Control Register              */
 
-/* DPMC*/
-#define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
-#define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
-#define STOPCK_OFF STOPCK
-
 /* PLL_DIV Masks													*/
 #define CCLK_DIV1 CSEL_DIV1	/*          CCLK = VCO / 1                                  */
 #define CCLK_DIV2 CSEL_DIV2	/*          CCLK = VCO / 2                                  */
diff --git a/arch/blackfin/mach-bf527/include/mach/blackfin.h b/arch/blackfin/mach-bf527/include/mach/blackfin.h
index 03665a8..ea9cb0f 100644
--- a/arch/blackfin/mach-bf527/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf527/include/mach/blackfin.h
@@ -56,11 +56,6 @@
 #endif
 #endif
 
-/* UART_IIR Register */
-#define STATUS(x)	((x << 1) & 0x06)
-#define STATUS_P1	0x02
-#define STATUS_P0	0x01
-
 #define BFIN_UART_NR_PORTS	2
 
 #define OFFSET_THR              0x00	/* Transmit Holding register            */
@@ -76,11 +71,6 @@
 #define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
 #define OFFSET_GCTL             0x24	/* Global Control Register              */
 
-/* DPMC*/
-#define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
-#define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
-#define STOPCK_OFF STOPCK
-
 /* PLL_DIV Masks													*/
 #define CCLK_DIV1 CSEL_DIV1	/*          CCLK = VCO / 1                                  */
 #define CCLK_DIV2 CSEL_DIV2	/*          CCLK = VCO / 2                                  */
diff --git a/arch/blackfin/mach-bf533/dma.c b/arch/blackfin/mach-bf533/dma.c
index 0a6eb8f..7a443c3 100644
--- a/arch/blackfin/mach-bf533/dma.c
+++ b/arch/blackfin/mach-bf533/dma.c
@@ -76,12 +76,12 @@ int channel2irq(unsigned int channel)
 		ret_irq = IRQ_SPI;
 		break;
 
-	case CH_UART_RX:
-		ret_irq = IRQ_UART_RX;
+	case CH_UART0_RX:
+		ret_irq = IRQ_UART0_RX;
 		break;
 
-	case CH_UART_TX:
-		ret_irq = IRQ_UART_TX;
+	case CH_UART0_TX:
+		ret_irq = IRQ_UART0_TX;
 		break;
 
 	case CH_MEM_STREAM0_SRC:
diff --git a/arch/blackfin/mach-bf533/include/mach/blackfin.h b/arch/blackfin/mach-bf533/include/mach/blackfin.h
index 39aa175..499e897 100644
--- a/arch/blackfin/mach-bf533/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf533/include/mach/blackfin.h
@@ -43,13 +43,6 @@
 
 #define BFIN_UART_NR_PORTS      1
 
-#define CH_UART_RX CH_UART0_RX
-#define CH_UART_TX CH_UART0_TX
-
-#define IRQ_UART_ERROR IRQ_UART0_ERROR
-#define IRQ_UART_RX    IRQ_UART0_RX
-#define IRQ_UART_TX    IRQ_UART0_TX
-
 #define OFFSET_THR              0x00	/* Transmit Holding register            */
 #define OFFSET_RBR              0x00	/* Receive Buffer register              */
 #define OFFSET_DLL              0x00	/* Divisor Latch (Low-Byte)             */
diff --git a/arch/blackfin/mach-bf537/dma.c b/arch/blackfin/mach-bf537/dma.c
index 8118505..d23fc0e 100644
--- a/arch/blackfin/mach-bf537/dma.c
+++ b/arch/blackfin/mach-bf537/dma.c
@@ -96,12 +96,12 @@ int channel2irq(unsigned int channel)
 		ret_irq = IRQ_SPI;
 		break;
 
-	case CH_UART_RX:
-		ret_irq = IRQ_UART_RX;
+	case CH_UART0_RX:
+		ret_irq = IRQ_UART0_RX;
 		break;
 
-	case CH_UART_TX:
-		ret_irq = IRQ_UART_TX;
+	case CH_UART0_TX:
+		ret_irq = IRQ_UART0_TX;
 		break;
 
 	case CH_MEM_STREAM0_SRC:
diff --git a/arch/blackfin/mach-bf537/include/mach/blackfin.h b/arch/blackfin/mach-bf537/include/mach/blackfin.h
index f5e5015..9ee8834 100644
--- a/arch/blackfin/mach-bf537/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf537/include/mach/blackfin.h
@@ -45,96 +45,11 @@
 #if !defined(__ASSEMBLY__)
 #include "cdefBF534.h"
 
-/* UART 0*/
-#define bfin_read_UART_THR() bfin_read_UART0_THR()
-#define bfin_write_UART_THR(val) bfin_write_UART0_THR(val)
-#define bfin_read_UART_RBR() bfin_read_UART0_RBR()
-#define bfin_write_UART_RBR(val) bfin_write_UART0_RBR(val)
-#define bfin_read_UART_DLL() bfin_read_UART0_DLL()
-#define bfin_write_UART_DLL(val) bfin_write_UART0_DLL(val)
-#define bfin_read_UART_IER() bfin_read_UART0_IER()
-#define bfin_write_UART_IER(val) bfin_write_UART0_IER(val)
-#define bfin_read_UART_DLH() bfin_read_UART0_DLH()
-#define bfin_write_UART_DLH(val) bfin_write_UART0_DLH(val)
-#define bfin_read_UART_IIR() bfin_read_UART0_IIR()
-#define bfin_write_UART_IIR(val) bfin_write_UART0_IIR(val)
-#define bfin_read_UART_LCR() bfin_read_UART0_LCR()
-#define bfin_write_UART_LCR(val) bfin_write_UART0_LCR(val)
-#define bfin_read_UART_MCR() bfin_read_UART0_MCR()
-#define bfin_write_UART_MCR(val) bfin_write_UART0_MCR(val)
-#define bfin_read_UART_LSR() bfin_read_UART0_LSR()
-#define bfin_write_UART_LSR(val) bfin_write_UART0_LSR(val)
-#define bfin_read_UART_SCR() bfin_read_UART0_SCR()
-#define bfin_write_UART_SCR(val) bfin_write_UART0_SCR(val)
-#define bfin_read_UART_GCTL() bfin_read_UART0_GCTL()
-#define bfin_write_UART_GCTL(val) bfin_write_UART0_GCTL(val)
-
 #if defined(CONFIG_BF537) || defined(CONFIG_BF536)
 #include "cdefBF537.h"
 #endif
 #endif
 
-/* MAP used DEFINES from BF533 to BF537 - so we don't need to change them in the driver, kernel, etc. */
-
-/* UART_IIR Register */
-#define STATUS(x)	((x << 1) & 0x06)
-#define STATUS_P1	0x02
-#define STATUS_P0	0x01
-
-/* DMA Channel */
-#define bfin_read_CH_UART_RX() bfin_read_CH_UART0_RX()
-#define bfin_write_CH_UART_RX(val) bfin_write_CH_UART0_RX(val)
-#define CH_UART_RX CH_UART0_RX
-#define bfin_read_CH_UART_TX() bfin_read_CH_UART0_TX()
-#define bfin_write_CH_UART_TX(val) bfin_write_CH_UART0_TX(val)
-#define CH_UART_TX CH_UART0_TX
-
-/* System Interrupt Controller */
-#define bfin_read_IRQ_UART_RX() bfin_read_IRQ_UART0_RX()
-#define bfin_write_IRQ_UART_RX(val) bfin_write_IRQ_UART0_RX(val)
-#define IRQ_UART_RX IRQ_UART0_RX
-#define bfin_read_IRQ_UART_TX() bfin_read_IRQ_UART0_TX()
-#define bfin_write_IRQ_UART_TX(val) bfin_write_IRQ_UART0_TX(val)
-#define	IRQ_UART_TX IRQ_UART0_TX
-#define bfin_read_IRQ_UART_ERROR() bfin_read_IRQ_UART0_ERROR()
-#define bfin_write_IRQ_UART_ERROR(val) bfin_write_IRQ_UART0_ERROR(val)
-#define	IRQ_UART_ERROR IRQ_UART0_ERROR
-
-/* MMR Registers*/
-#define bfin_read_UART_THR() bfin_read_UART0_THR()
-#define bfin_write_UART_THR(val) bfin_write_UART0_THR(val)
-#define BFIN_UART_THR UART0_THR
-#define bfin_read_UART_RBR() bfin_read_UART0_RBR()
-#define bfin_write_UART_RBR(val) bfin_write_UART0_RBR(val)
-#define BFIN_UART_RBR UART0_RBR
-#define bfin_read_UART_DLL() bfin_read_UART0_DLL()
-#define bfin_write_UART_DLL(val) bfin_write_UART0_DLL(val)
-#define BFIN_UART_DLL UART0_DLL
-#define bfin_read_UART_IER() bfin_read_UART0_IER()
-#define bfin_write_UART_IER(val) bfin_write_UART0_IER(val)
-#define BFIN_UART_IER UART0_IER
-#define bfin_read_UART_DLH() bfin_read_UART0_DLH()
-#define bfin_write_UART_DLH(val) bfin_write_UART0_DLH(val)
-#define BFIN_UART_DLH UART0_DLH
-#define bfin_read_UART_IIR() bfin_read_UART0_IIR()
-#define bfin_write_UART_IIR(val) bfin_write_UART0_IIR(val)
-#define BFIN_UART_IIR UART0_IIR
-#define bfin_read_UART_LCR() bfin_read_UART0_LCR()
-#define bfin_write_UART_LCR(val) bfin_write_UART0_LCR(val)
-#define BFIN_UART_LCR UART0_LCR
-#define bfin_read_UART_MCR() bfin_read_UART0_MCR()
-#define bfin_write_UART_MCR(val) bfin_write_UART0_MCR(val)
-#define BFIN_UART_MCR UART0_MCR
-#define bfin_read_UART_LSR() bfin_read_UART0_LSR()
-#define bfin_write_UART_LSR(val) bfin_write_UART0_LSR(val)
-#define BFIN_UART_LSR UART0_LSR
-#define bfin_read_UART_SCR() bfin_read_UART0_SCR()
-#define bfin_write_UART_SCR(val) bfin_write_UART0_SCR(val)
-#define BFIN_UART_SCR  UART0_SCR
-#define bfin_read_UART_GCTL() bfin_read_UART0_GCTL()
-#define bfin_write_UART_GCTL(val) bfin_write_UART0_GCTL(val)
-#define BFIN_UART_GCTL UART0_GCTL
-
 #define BFIN_UART_NR_PORTS	2
 
 #define OFFSET_THR              0x00	/* Transmit Holding register            */
@@ -150,11 +65,6 @@
 #define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
 #define OFFSET_GCTL             0x24	/* Global Control Register              */
 
-/* DPMC*/
-#define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
-#define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
-#define STOPCK_OFF STOPCK
-
 /* PLL_DIV Masks													*/
 #define CCLK_DIV1 CSEL_DIV1	/*          CCLK = VCO / 1                                  */
 #define CCLK_DIV2 CSEL_DIV2	/*          CCLK = VCO / 2                                  */
diff --git a/arch/blackfin/mach-bf538/include/mach/blackfin.h b/arch/blackfin/mach-bf538/include/mach/blackfin.h
index 9496196..5ecee16 100644
--- a/arch/blackfin/mach-bf538/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf538/include/mach/blackfin.h
@@ -47,11 +47,6 @@
 #endif
 #endif
 
-/* UART_IIR Register */
-#define STATUS(x)	((x << 1) & 0x06)
-#define STATUS_P1	0x02
-#define STATUS_P0	0x01
-
 #define BFIN_UART_NR_PORTS	3
 
 #define OFFSET_THR              0x00	/* Transmit Holding register            */
@@ -67,11 +62,6 @@
 #define OFFSET_SCR              0x1C	/* SCR Scratch Register                 */
 #define OFFSET_GCTL             0x24	/* Global Control Register              */
 
-/* DPMC*/
-#define bfin_read_STOPCK_OFF() bfin_read_STOPCK()
-#define bfin_write_STOPCK_OFF(val) bfin_write_STOPCK(val)
-#define STOPCK_OFF STOPCK
-
 /* PLL_DIV Masks													*/
 #define CCLK_DIV1 CSEL_DIV1	/*          CCLK = VCO / 1                                  */
 #define CCLK_DIV2 CSEL_DIV2	/*          CCLK = VCO / 2                                  */
diff --git a/arch/blackfin/mach-bf548/include/mach/blackfin.h b/arch/blackfin/mach-bf548/include/mach/blackfin.h
index 6b97396..318667b 100644
--- a/arch/blackfin/mach-bf548/include/mach/blackfin.h
+++ b/arch/blackfin/mach-bf548/include/mach/blackfin.h
@@ -72,97 +72,8 @@
 #include "cdefBF549.h"
 #endif
 
-/* UART 1*/
-#define bfin_read_UART_THR()		bfin_read_UART1_THR()
-#define bfin_write_UART_THR(val)	bfin_write_UART1_THR(val)
-#define bfin_read_UART_RBR()		bfin_read_UART1_RBR()
-#define bfin_write_UART_RBR(val)	bfin_write_UART1_RBR(val)
-#define bfin_read_UART_DLL()		bfin_read_UART1_DLL()
-#define bfin_write_UART_DLL(val)	bfin_write_UART1_DLL(val)
-#define bfin_read_UART_IER()		bfin_read_UART1_IER()
-#define bfin_write_UART_IER(val)	bfin_write_UART1_IER(val)
-#define bfin_read_UART_DLH()		bfin_read_UART1_DLH()
-#define bfin_write_UART_DLH(val)	bfin_write_UART1_DLH(val)
-#define bfin_read_UART_IIR()		bfin_read_UART1_IIR()
-#define bfin_write_UART_IIR(val)	bfin_write_UART1_IIR(val)
-#define bfin_read_UART_LCR()		bfin_read_UART1_LCR()
-#define bfin_write_UART_LCR(val)	bfin_write_UART1_LCR(val)
-#define bfin_read_UART_MCR()		bfin_read_UART1_MCR()
-#define bfin_write_UART_MCR(val)	bfin_write_UART1_MCR(val)
-#define bfin_read_UART_LSR()		bfin_read_UART1_LSR()
-#define bfin_write_UART_LSR(val)	bfin_write_UART1_LSR(val)
-#define bfin_read_UART_SCR()		bfin_read_UART1_SCR()
-#define bfin_write_UART_SCR(val)	bfin_write_UART1_SCR(val)
-#define bfin_read_UART_GCTL()		bfin_read_UART1_GCTL()
-#define bfin_write_UART_GCTL(val)	bfin_write_UART1_GCTL(val)
-
 #endif
 
-/* MAP used DEFINES from BF533 to BF54x - so we don't need to change 
- * them in the driver, kernel, etc. */
-
-/* UART_IIR Register */
-#define STATUS(x)	((x << 1) & 0x06)
-#define STATUS_P1	0x02
-#define STATUS_P0	0x01
-
-/* UART 0*/
-
-/* DMA Channel */
-#define bfin_read_CH_UART_RX()		bfin_read_CH_UART1_RX()
-#define bfin_write_CH_UART_RX(val)	bfin_write_CH_UART1_RX(val)
-#define bfin_read_CH_UART_TX()		bfin_read_CH_UART1_TX()
-#define bfin_write_CH_UART_TX(val)	bfin_write_CH_UART1_TX(val)
-#define CH_UART_RX			CH_UART1_RX
-#define CH_UART_TX			CH_UART1_TX
-
-/* System Interrupt Controller */
-#define bfin_read_IRQ_UART_RX()		bfin_read_IRQ_UART1_RX()
-#define bfin_write_IRQ_UART_RX(val)	bfin_write_IRQ_UART1_RX(val)
-#define bfin_read_IRQ_UART_TX()		bfin_read_IRQ_UART1_TX()
-#define bfin_write_IRQ_UART_TX(val)	bfin_write_IRQ_UART1_TX(val)
-#define bfin_read_IRQ_UART_ERROR()	bfin_read_IRQ_UART1_ERROR()
-#define bfin_write_IRQ_UART_ERROR(val)	bfin_write_IRQ_UART1_ERROR(val)
-#define IRQ_UART_RX			IRQ_UART1_RX
-#define	IRQ_UART_TX			IRQ_UART1_TX
-#define	IRQ_UART_ERROR			IRQ_UART1_ERROR
-
-/* MMR Registers*/
-#define bfin_read_UART_THR()		bfin_read_UART1_THR()
-#define bfin_write_UART_THR(val)	bfin_write_UART1_THR(val)
-#define bfin_read_UART_RBR()		bfin_read_UART1_RBR()
-#define bfin_write_UART_RBR(val)	bfin_write_UART1_RBR(val)
-#define bfin_read_UART_DLL()		bfin_read_UART1_DLL()
-#define bfin_write_UART_DLL(val)	bfin_write_UART1_DLL(val)
-#define bfin_read_UART_IER()		bfin_read_UART1_IER()
-#define bfin_write_UART_IER(val)	bfin_write_UART1_IER(val)
-#define bfin_read_UART_DLH()		bfin_read_UART1_DLH()
-#define bfin_write_UART_DLH(val)	bfin_write_UART1_DLH(val)
-#define bfin_read_UART_IIR()		bfin_read_UART1_IIR()
-#define bfin_write_UART_IIR(val)	bfin_write_UART1_IIR(val)
-#define bfin_read_UART_LCR()		bfin_read_UART1_LCR()
-#define bfin_write_UART_LCR(val)	bfin_write_UART1_LCR(val)
-#define bfin_read_UART_MCR()		bfin_read_UART1_MCR()
-#define bfin_write_UART_MCR(val)	bfin_write_UART1_MCR(val)
-#define bfin_read_UART_LSR()		bfin_read_UART1_LSR()
-#define bfin_write_UART_LSR(val)	bfin_write_UART1_LSR(val)
-#define bfin_read_UART_SCR()		bfin_read_UART1_SCR()
-#define bfin_write_UART_SCR(val)	bfin_write_UART1_SCR(val)
-#define bfin_read_UART_GCTL()		bfin_read_UART1_GCTL()
-#define bfin_write_UART_GCTL(val)	bfin_write_UART1_GCTL(val)
-
-#define BFIN_UART_THR			UART1_THR
-#define BFIN_UART_RBR			UART1_RBR
-#define BFIN_UART_DLL			UART1_DLL
-#define BFIN_UART_IER			UART1_IER
-#define BFIN_UART_DLH			UART1_DLH
-#define BFIN_UART_IIR			UART1_IIR
-#define BFIN_UART_LCR			UART1_LCR
-#define BFIN_UART_MCR			UART1_MCR
-#define BFIN_UART_LSR			UART1_LSR
-#define BFIN_UART_SCR			UART1_SCR
-#define BFIN_UART_GCTL			UART1_GCTL
-
 #define BFIN_UART_NR_PORTS	4
 
 #define OFFSET_DLL              0x00	/* Divisor Latch (Low-Byte)             */
-- 
1.6.4.2

