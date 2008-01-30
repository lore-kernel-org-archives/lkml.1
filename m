Return-Path: <linux-kernel-owner+w=401wt.eu-S1761380AbYA3LON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761380AbYA3LON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 06:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754596AbYA3LN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 06:13:58 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:44492 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbYA3LN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 06:13:57 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, dwmw2@infradead.org,
       Jiri Slaby <jirislaby@gmail.com>, WANG Cong <xiyou.wangcong@gmail.com>
Subject: [PATCH 2/2] Char: applicom, use pci_match_id
Date: Wed, 30 Jan 2008 12:13:15 +0100
Message-Id: <1201691595-11448-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080128054917.GA10504@hacking>
References: <20080128054917.GA10504@hacking>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of testing hardcoded values, use pci_match_id to reference the
pci_device_id table. Sideways, it allows easy new additions to the table.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
---
 drivers/char/applicom.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index b0bb71b..64bf71c 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -57,7 +57,6 @@
 #define PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN 0x0002
 #define PCI_DEVICE_ID_APPLICOM_PCI2000PFB     0x0003
 #endif
-#define MAX_PCI_DEVICE_NUM 3
 
 static char *applicom_pci_devnames[] = {
 	"PCI board",
@@ -66,12 +65,9 @@ static char *applicom_pci_devnames[] = {
 };
 
 static struct pci_device_id applicom_pci_tbl[] = {
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN) },
+	{ PCI_VDEVICE(APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000PFB) },
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
@@ -197,10 +193,7 @@ static int __init applicom_init(void)
 
 	while ( (dev = pci_get_class(PCI_CLASS_OTHERS << 16, dev))) {
 
-		if (dev->vendor != PCI_VENDOR_ID_APPLICOM)
-			continue;
-		
-		if (dev->device  > MAX_PCI_DEVICE_NUM || dev->device == 0)
+		if (!pci_match_id(applicom_pci_tbl, dev));
 			continue;
 		
 		if (pci_enable_device(dev))
-- 
1.5.3.8

