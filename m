Return-Path: <linux-kernel-owner+w=401wt.eu-S936159AbXGMJXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936159AbXGMJXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763391AbXGMJWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:22:11 -0400
Received: from www.osadl.org ([213.239.205.134]:55612 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763283AbXGMJWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:22:09 -0400
Subject: [PATCH] Fix compile error for MMC_AT91
From: Jan Altenberg <jan.altenberg@linutronix.de>
To: andrew@sanpeople.com
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 11:23:06 +0200
Message-Id: <1184318587.5934.8.camel@jan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

latest git doesn't compile for me with CONFIG_MMC_AT91 enabled:

/home/jan/work/linutronix/linux-2.6/drivers/mmc/host/at91_mci.c: In function `at91_mci_enable':
/home/jan/work/linutronix/linux-2.6/drivers/mmc/host/at91_mci.c:375: error: `AT91_MCI_RDPROOF' undeclared (first use in this function)
/home/jan/work/linutronix/linux-2.6/drivers/mmc/host/at91_mci.c:375: error: (Each undeclared identifier is reported only once
/home/jan/work/linutronix/linux-2.6/drivers/mmc/host/at91_mci.c:375: error: for each function it appears in.)
/home/jan/work/linutronix/linux-2.6/drivers/mmc/host/at91_mci.c:375: error: `AT91_MCI_WRPROOF' undeclared (first use in this function)
make[4]: *** [drivers/mmc/host/at91_mci.o] Error 1

This patch introduces the necessary defines (which are already present
in your tree).

Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>

---
 include/asm-arm/arch-at91/at91_mci.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/include/asm-arm/arch-at91/at91_mci.h
===================================================================
--- linux-2.6.orig/include/asm-arm/arch-at91/at91_mci.h
+++ linux-2.6/include/asm-arm/arch-at91/at91_mci.h
@@ -26,6 +26,9 @@
 #define AT91_MCI_MR		0x04		/* Mode Register */
 #define		AT91_MCI_CLKDIV		(0xff  <<  0)	/* Clock Divider */
 #define		AT91_MCI_PWSDIV		(7     <<  8)	/* Power Saving Divider */
+#define		AT91_MCI_RDPROOF	(1     << 11)	/* Read Proof Enable [SAM926[03] only] */
+#define		AT91_MCI_WRPROOF	(1     << 12)	/* Write Proof Enable [SAM926[03] only] */
+#define		AT91_MCI_PDCFBYTE	(1     << 13)	/* PDC Force Byte Transfer [SAM926[03] only] */
 #define		AT91_MCI_PDCPADV	(1     << 14)	/* PDC Padding Value */
 #define		AT91_MCI_PDCMODE	(1     << 15)	/* PDC-orientated Mode */
 #define		AT91_MCI_BLKLEN		(0xfff << 18)	/* Data Block Length */


