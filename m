Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbXL3N7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbXL3N7o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:59:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXL3N7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:59:10 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47431 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbXL3N7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:59:05 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/5] Char: mxser, reorder mxser_cardinfo fields
Date: Sun, 30 Dec 2007 14:58:56 +0100
Message-Id: <1199023138-27917-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder fields to save some memory and code on 64bit due to alignment as
suggested by Jan.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/char/mxser.c |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index a66ae57..7003855 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -106,41 +106,41 @@ static const struct {
 #define UART_INFO_NUM	ARRAY_SIZE(Gpci_uart_info)
 
 struct mxser_cardinfo {
-	unsigned int nports;
 	char *name;
+	unsigned int nports;
 	unsigned int flags;
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-/* 0*/	{ 8, "C168 series", },
-	{ 4, "C104 series", },
-	{ 4, "CI-104J series", },
-	{ 8, "C168H/PCI series", },
-	{ 4, "C104H/PCI series", },
-/* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
-	{ 4, "CI-132 series", MXSER_HAS2 },
-	{ 4, "CI-134 series", },
-	{ 2, "CP-132 series", },
-	{ 4, "CP-114 series", },
-/*10*/	{ 4, "CT-114 series", },
-	{ 2, "CP-102 series", MXSER_HIGHBAUD },
-	{ 4, "CP-104U series", },
-	{ 8, "CP-168U series", },
-	{ 2, "CP-132U series", },
-/*15*/	{ 4, "CP-134U series", },
-	{ 4, "CP-104JU series", },
-	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
-	{ 8, "CP-118U series", },
-	{ 2, "CP-102UL series", },
-/*20*/	{ 2, "CP-102U series", },
-	{ 8, "CP-118EL series", },
-	{ 8, "CP-168EL series", },
-	{ 4, "CP-104EL series", },
-	{ 8, "CB-108 series", },
-/*25*/	{ 4, "CB-114 series", },
-	{ 4, "CB-134I series", },
-	{ 8, "CP-138U series", },
-	{ 4, "POS-104UL series", }
+/* 0*/	{ "C168 series",	8, },
+	{ "C104 series",	4, },
+	{ "CI-104J series",	4, },
+	{ "C168H/PCI series",	8, },
+	{ "C104H/PCI series",	4, },
+/* 5*/	{ "C102 series",	4, MXSER_HAS2 },	/* C102-ISA */
+	{ "CI-132 series",	4, MXSER_HAS2 },
+	{ "CI-134 series",	4, },
+	{ "CP-132 series",	2, },
+	{ "CP-114 series",	4, },
+/*10*/	{ "CT-114 series",	4, },
+	{ "CP-102 series",	2, MXSER_HIGHBAUD },
+	{ "CP-104U series",	4, },
+	{ "CP-168U series",	8, },
+	{ "CP-132U series",	2, },
+/*15*/	{ "CP-134U series",	4, },
+	{ "CP-104JU series",	4, },
+	{ "Moxa UC7000 Serial",	8, },		/* RC7000 */
+	{ "CP-118U series",	8, },
+	{ "CP-102UL series",	2, },
+/*20*/	{ "CP-102U series",	2, },
+	{ "CP-118EL series",	8, },
+	{ "CP-168EL series",	8, },
+	{ "CP-104EL series",	4, },
+	{ "CB-108 series",	8, },
+/*25*/	{ "CB-114 series",	4, },
+	{ "CB-134I series",	4, },
+	{ "CP-138U series",	8, },
+	{ "POS-104UL series",	4, }
 };
 
 /* driver_data correspond to the lines in the structure above
-- 
1.5.3.6

