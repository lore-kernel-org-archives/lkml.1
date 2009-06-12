Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZFLPJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZFLPJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZFLPI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:08:56 -0400
Received: from mail.atmel.fr ([81.80.104.162]:50865 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZFLPIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:08:55 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: pierre@ossman.eu, haavard.skinnemoen@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, poorarm@shoreis.com
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: [PATCH 2/2] atmel-mci: add MCI2 register definitions
Date: Fri, 12 Jun 2009 17:58:30 +0200
Message-Id: <1244822310-11562-2-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
References: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
Message-Id: <a54493d37159af0d7f118934e9e5599979fa2bef.1244821292.git.nicolas.ferre@atmel.com>
In-Reply-To: <81b92e58966b864e4a26004204f43d242d9cc8aa.1244821292.git.nicolas.ferre@atmel.com>
References: <81b92e58966b864e4a26004204f43d242d9cc8aa.1244821292.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New revision of Atmel MCI interface adds new features. This is a update of
register definition in header file. This new MCI IP is called MCI2.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Some of this work comes form Haavard Skinnemoen.
I take advantage of this MCI rework to integrate register definition for future
inclusion of MCI2 support.
MCI2 is included in at91sam9g45 which is being included on arm-linux-kernel
mailing list.

 drivers/mmc/host/atmel-mci-regs.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci-regs.h b/drivers/mmc/host/atmel-mci-regs.h
index adfb885..fc8a0fe 100644
--- a/drivers/mmc/host/atmel-mci-regs.h
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -10,6 +10,7 @@
 
 /*
  * Superset of MCI IP registers integrated in Atmel AVR32 and AT91 Processors
+ * Registers and bitfields marked with [2] are only available in MCI2
  */
 
 #ifndef __DRIVERS_MMC_ATMEL_MCI_H__
@@ -39,6 +40,7 @@
 # define MCI_SDCSEL_MASK	(  3 <<  0)
 # define MCI_SDCBUS_1BIT	(  0 <<  6)	/* 1-bit data bus */
 # define MCI_SDCBUS_4BIT	(  2 <<  6)	/* 4-bit data bus */
+# define MCI_SDCBUS_8BIT	(  3 <<  6)	/* 8-bit data bus[2] */
 # define MCI_SDCBUS_MASK	(  3 <<  6)
 #define MCI_ARGR		0x0010	/* Command Argument */
 #define MCI_CMDR		0x0014	/* Command */
@@ -67,6 +69,9 @@
 #define MCI_BLKR		0x0018	/* Block */
 # define MCI_BCNT(x)		((x) <<  0)	/* Data Block Count */
 # define MCI_BLKLEN(x)		((x) << 16)	/* Data Block Length */
+#define MCI_CSTOR		0x001c	/* Completion Signal Timeout[2] */
+# define MCI_CSTOCYC(x)		((x) <<  0)	/* CST cycles */
+# define MCI_CSTOMUL(x)		((x) <<  4)	/* CST multiplier */
 #define MCI_RSPR		0x0020	/* Response 0 */
 #define MCI_RSPR1		0x0024	/* Response 1 */
 #define MCI_RSPR2		0x0028	/* Response 2 */
@@ -94,7 +99,24 @@
 # define MCI_DTOE		(  1 <<  22)	/* Data Time-Out Error */
 # define MCI_OVRE		(  1 <<  30)	/* RX Overrun Error */
 # define MCI_UNRE		(  1 <<  31)	/* TX Underrun Error */
+#define MCI_DMA			0x0050	/* DMA Configuration[2] */
+# define MCI_DMA_OFFSET(x)	((x) <<  0)	/* DMA Write Buffer Offset */
+# define MCI_DMA_CHKSIZE(x)	((x) <<  4)	/* DMA Channel Read and Write Chunk Size */
+# define MCI_DMAEN		(  1 <<  8)	/* DMA Hardware Handshaking Enable */
+#define MCI_CFG			0x0054	/* Configuration[2] */
+# define MCI_CFG_FIFOMODE_1DATA	(  1 <<  0)	/* MCI Internal FIFO control mode */
+# define MCI_CFG_FERRCTRL_COR	(  1 <<  4)	/* Flow Error flag reset control mode */
+# define MCI_CFG_HSMODE		(  1 <<  8)	/* High Speed Mode */
+# define MCI_CFG_LSYNC		(  1 << 12)	/* Synchronize on the last block */
+#define MCI_WPMR		0x00e4	/* Write Protection Mode[2] */
+# define MCI_WP_EN		(  1 <<  0)	/* WP Enable */
+# define MCI_WP_KEY		(0x4d4349 << 8)	/* WP Key */
+#define MCI_WPSR		0x00e8	/* Write Protection Status[2] */
+# define MCI_GET_WP_VS(x)	((x) & 0x0f)
+# define MCI_GET_WP_VSRC(x)	(((x) >> 8) & 0xffff)
+#define MCI_FIFO_APERTURE	0x0200	/* FIFO Aperture[2] */
 
+/* This is not including the FIFO Aperture on MCI2 */
 #define MCI_REGS_SIZE		0x100
 
 /* Register access macros */
-- 
1.5.3.7

