Return-Path: <linux-kernel-owner+w=401wt.eu-S1755264AbZFLPJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264AbZFLPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFLPJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:09:10 -0400
Received: from mail.atmel.fr ([81.80.104.162]:51148 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754733AbZFLPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:09:09 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: pierre@ossman.eu, haavard.skinnemoen@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk, poorarm@shoreis.com
Cc: linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: [PATCH 1/2] atmel-mci: Integrate AT91 specific definition in header file
Date: Fri, 12 Jun 2009 17:58:29 +0200
Message-Id: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.3.7
Message-Id: <81b92e58966b864e4a26004204f43d242d9cc8aa.1244821292.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MCI IP is shared among AVR32 and AT91 SOCs.
AT91 has specific bit definitions in the user interface of MCI SD/MMC IP.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
Thanks to Rob Emanuele who has begun this unification work. I take the hand on
this header file work as I have some bits to integrate for MCI2 support.

 drivers/mmc/host/atmel-mci-regs.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/atmel-mci-regs.h b/drivers/mmc/host/atmel-mci-regs.h
index b58364e..adfb885 100644
--- a/drivers/mmc/host/atmel-mci-regs.h
+++ b/drivers/mmc/host/atmel-mci-regs.h
@@ -7,6 +7,11 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+/*
+ * Superset of MCI IP registers integrated in Atmel AVR32 and AT91 Processors
+ */
+
 #ifndef __DRIVERS_MMC_ATMEL_MCI_H__
 #define __DRIVERS_MMC_ATMEL_MCI_H__
 
@@ -14,11 +19,17 @@
 #define MCI_CR			0x0000	/* Control */
 # define MCI_CR_MCIEN		(  1 <<  0)	/* MCI Enable */
 # define MCI_CR_MCIDIS		(  1 <<  1)	/* MCI Disable */
+# define MCI_CR_PWSEN		(  1 <<  2)	/* Power Save Enable */
+# define MCI_CR_PWSDIS		(  1 <<  3)	/* Power Save Disable */
 # define MCI_CR_SWRST		(  1 <<  7)	/* Software Reset */
 #define MCI_MR			0x0004	/* Mode */
 # define MCI_MR_CLKDIV(x)	((x) <<  0)	/* Clock Divider */
+# define MCI_MR_PWSDIV(x)	((x) <<  8)	/* Power Saving Divider */
 # define MCI_MR_RDPROOF		(  1 << 11)	/* Read Proof */
 # define MCI_MR_WRPROOF		(  1 << 12)	/* Write Proof */
+# define MCI_MR_PDCFBYTE	(  1 << 13)	/* Force Byte Transfer */
+# define MCI_MR_PDCPADV		(  1 << 14)	/* Padding Value */
+# define MCI_MR_PDCMODE		(  1 << 15)	/* PDC-oriented Mode */
 #define MCI_DTOR		0x0008	/* Data Timeout */
 # define MCI_DTOCYC(x)		((x) <<  0)	/* Data Timeout Cycles */
 # define MCI_DTOMUL(x)		((x) <<  4)	/* Data Timeout Multiplier */
-- 
1.5.3.7

