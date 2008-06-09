Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYFIKMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYFIKMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 06:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbYFIKMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 06:12:23 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:58563 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753789AbYFIKMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 06:12:22 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Char: mxser, add CP-102UF support
Date: Mon,  9 Jun 2008 12:08:28 +0200
Message-Id: <1213006112-25965-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
References: <1213006112-25965-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for CP-102UF moxa card (update to 1.12 original driver) and
increment this driver version.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 0fedb1c..060fee9 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -46,7 +46,7 @@
 
 #include "mxser.h"
 
-#define	MXSER_VERSION	"2.0.3"		/* 1.11 */
+#define	MXSER_VERSION	"2.0.4"		/* 1.12 */
 #define	MXSERMAJOR	 174
 #define	MXSERCUMAJOR	 175
 
@@ -72,10 +72,11 @@
 
 #define PCI_DEVICE_ID_CB108	0x1080
 #define PCI_DEVICE_ID_CB114	0x1142
-#define PCI_DEVICE_ID_CP114UL	0x1143
 #define PCI_DEVICE_ID_CB134I	0x1341
-#define PCI_DEVICE_ID_CP138U	0x1380
+#define PCI_DEVICE_ID_CP102UF	0x1023
 #define PCI_DEVICE_ID_POS104UL	0x1044
+#define PCI_DEVICE_ID_CP114UL	0x1143
+#define PCI_DEVICE_ID_CP138U	0x1380
 
 
 #define C168_ASIC_ID    1
@@ -141,7 +142,8 @@ static const struct mxser_cardinfo mxser_cards[] = {
 	{ "CB-134I series",	4, },
 	{ "CP-138U series",	8, },
 	{ "POS-104UL series",	4, },
-	{ "CP-114UL series",	4, }
+	{ "CP-114UL series",	4, },
+/*30*/	{ "CP-102UF series",	2, },
 };
 
 /* driver_data correspond to the lines in the structure above
@@ -171,6 +173,7 @@ static struct pci_device_id mxser_pcibrds[] = {
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP138U),	.driver_data = 27 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_POS104UL),	.driver_data = 28 },
 	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP114UL),	.driver_data = 29 },
+	{ PCI_VDEVICE(MOXA, PCI_DEVICE_ID_CP102UF),	.driver_data = 30 },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
@@ -1418,7 +1421,6 @@ static int mxser_set_serial_info(struct mxser_port *info,
 		info->closing_wait = new_serial.closing_wait * HZ / 100;
 		info->tty->low_latency =
 				(info->flags & ASYNC_LOW_LATENCY) ? 1 : 0;
-		info->tty->low_latency = 0;
 		if ((info->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(new_serial.baud_base != info->baud_base ||
 				new_serial.custom_divisor !=
-- 
1.5.4.5

