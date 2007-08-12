Return-Path: <linux-kernel-owner+w=401wt.eu-S965094AbXHLPZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965094AbXHLPZQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762022AbXHLPYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:24:33 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:59657 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759622AbXHLPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:24:32 -0400
Message-id: <261712744987112084@wsc.cz>
Subject: [PATCH 1/3] Char: mxser_new, upgrade to 1.10
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 12 Aug 2007 17:25:37 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, upgrade to 1.10

This adds support for new (5 cards) hardware.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 77a1c21e95d4f0eb4f4dc1d98463bb4046e033bd
tree 55c2e4011ca5e49455061d03d1c8756e790a1360
parent 7129cd56f4f7f8d9f7cc9deb9a62291fc989cf91
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:19:23 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:19:23 +0200

 drivers/char/mxser_new.c |   32 ++++++++++++++++++++++++--------
 1 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 6a56393..7677df3 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -2,7 +2,7 @@
  *          mxser.c  -- MOXA Smartio/Industio family multiport serial driver.
  *
  *      Copyright (C) 1999-2006  Moxa Technologies (support@moxa.com.tw).
- *	Copyright (C) 2006       Jiri Slaby <jirislaby@gmail.com>
+ *	Copyright (C) 2006-2007  Jiri Slaby <jirislaby@gmail.com>
  *
  *      This code is loosely based on the 1.8 moxa driver which is based on
  *	Linux serial driver, written by Linus Torvalds, Theodore T'so and
@@ -48,7 +48,7 @@
 
 #include "mxser_new.h"
 
-#define	MXSER_VERSION	"2.0.1"		/* 1.9.15 */
+#define	MXSER_VERSION	"2.0.2"		/* 1.10 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -72,6 +72,12 @@
 #define UART_MCR_AFE		0x20
 #define UART_LSR_SPECIAL	0x1E
 
+#define PCI_DEVICE_ID_CB108	0x1080
+#define PCI_DEVICE_ID_CB114	0x1142
+#define PCI_DEVICE_ID_CB134I	0x1341
+#define PCI_DEVICE_ID_CP138U	0x1380
+#define PCI_DEVICE_ID_POS104UL	0x1044
+
 
 #define C168_ASIC_ID    1
 #define C104_ASIC_ID    2
@@ -107,30 +113,35 @@ struct mxser_cardinfo {
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-	{ 8, "C168 series", },			/* C168-ISA */
+/* 0*/	{ 8, "C168 series", },			/* C168-ISA */
 	{ 4, "C104 series", },			/* C104-ISA */
 	{ 4, "CI-104J series", },		/* CI104J */
 	{ 8, "C168H/PCI series", },		/* C168-PCI */
 	{ 4, "C104H/PCI series", },		/* C104-PCI */
-	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
+/* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
 	{ 4, "CI-132 series", MXSER_HAS2 },	/* CI132 */
 	{ 4, "CI-134 series", },		/* CI134 */
 	{ 2, "CP-132 series", },		/* CP132 */
 	{ 4, "CP-114 series", },		/* CP114 */
-	{ 4, "CT-114 series", },		/* CT114 */
+/*10*/	{ 4, "CT-114 series", },		/* CT114 */
 	{ 2, "CP-102 series", MXSER_HIGHBAUD },	/* CP102 */
 	{ 4, "CP-104U series", },		/* CP104U */
 	{ 8, "CP-168U series", },		/* CP168U */
 	{ 2, "CP-132U series", },		/* CP132U */
-	{ 4, "CP-134U series", },		/* CP134U */
+/*15*/	{ 4, "CP-134U series", },		/* CP134U */
 	{ 4, "CP-104JU series", },		/* CP104JU */
 	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
 	{ 8, "CP-118U series", },		/* CP118U */
 	{ 2, "CP-102UL series", },		/* CP102UL */
-	{ 2, "CP-102U series", },		/* CP102U */
+/*20*/	{ 2, "CP-102U series", },		/* CP102U */
 	{ 8, "CP-118EL series", },		/* CP118EL */
 	{ 8, "CP-168EL series", },		/* CP168EL */
-	{ 4, "CP-104EL series", }		/* CP104EL */
+	{ 4, "CP-104EL series", },
+	{ 8, "CB-108 series", },
+/*25*/	{ 4, "CB-114 series", },
+	{ 4, "CB-134I series", },
+	{ 8, "CP-138U series", },
+	{ 4, "POS-104UL series", }
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -172,6 +183,11 @@ static struct pci_device_id mxser_pcibrds[] = {
 		.driver_data = 22 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MOXA, PCI_DEVICE_ID_MOXA_CP104EL),
 		.driver_data = 23 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB108),	.driver_data = 24 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB114),	.driver_data = 25 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CB134I),	.driver_data = 26 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
