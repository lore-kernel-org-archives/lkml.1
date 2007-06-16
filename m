Return-Path: <linux-kernel-owner+w=401wt.eu-S1755072AbXFPPqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbXFPPqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 11:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbXFPPqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 11:46:13 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35371 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751806AbXFPPqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 11:46:13 -0400
Message-id: <25346144272716812325@wsc.cz>
In-reply-to: <116342983010020429@wsc.cz>
Subject: [PATCH 3/6] ATM: lanai, change VENDOR to DEVICE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <chas@cmf.nrl.navy.mil>
Cc: Mitchell Blank Jr <mitch@sfgoth.com>
Date: Sat, 16 Jun 2007 17:46:14 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lanai, change VENDOR to DEVICE

There were 2 bad named macros in pci_ids (LANAI 2 and IHB). Rename it to
DEVICE, because it's device id. Also make some cleanpu in pci_device_id
table (use PCI_VDEVICE).

Cc: Mitchell Blank Jr <mitch@sfgoth.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 0046e56e3fb82170d030ae35aceecce9a87f1bfa
tree cf7931160ac3cac00ff62b9959416f0a920cbaf8
parent c6a5758632ca3e35aa299eb4a37ff615f19beb8b
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:25:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:25:08 +0200

 drivers/atm/lanai.c     |   14 ++++----------
 include/linux/pci_ids.h |    4 ++--
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/atm/lanai.c b/drivers/atm/lanai.c
index 09f477d..4e1fa50 100644
--- a/drivers/atm/lanai.c
+++ b/drivers/atm/lanai.c
@@ -246,8 +246,8 @@ struct lanai_vcc {
 };
 
 enum lanai_type {
-	lanai2	= PCI_VENDOR_ID_EF_ATM_LANAI2,
-	lanaihb	= PCI_VENDOR_ID_EF_ATM_LANAIHB
+	lanai2	= PCI_DEVICE_ID_EF_ATM_LANAI2,
+	lanaihb	= PCI_DEVICE_ID_EF_ATM_LANAIHB
 };
 
 struct lanai_dev_stats {
@@ -2631,14 +2631,8 @@ static int __devinit lanai_init_one(struct pci_dev *pci,
 }
 
 static struct pci_device_id lanai_pci_tbl[] = {
-	{
-		PCI_VENDOR_ID_EF, PCI_VENDOR_ID_EF_ATM_LANAI2,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0
-	},
-	{
-		PCI_VENDOR_ID_EF, PCI_VENDOR_ID_EF_ATM_LANAIHB,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0
-	},
+	{ PCI_VDEVICE(EF, PCI_DEVICE_ID_EF_ATM_LANAI2) },
+	{ PCI_VDEVICE(EF, PCI_DEVICE_ID_EF_ATM_LANAIHB) },
 	{ 0, }	/* terminal entry */
 };
 MODULE_DEVICE_TABLE(pci, lanai_pci_tbl);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index a402e52..df25c8a 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1362,8 +1362,8 @@
 #define PCI_VENDOR_ID_EF		0x111a
 #define PCI_DEVICE_ID_EF_ATM_FPGA	0x0000
 #define PCI_DEVICE_ID_EF_ATM_ASIC	0x0002
-#define PCI_VENDOR_ID_EF_ATM_LANAI2	0x0003
-#define PCI_VENDOR_ID_EF_ATM_LANAIHB	0x0005
+#define PCI_DEVICE_ID_EF_ATM_LANAI2	0x0003
+#define PCI_DEVICE_ID_EF_ATM_LANAIHB	0x0005
 
 #define PCI_VENDOR_ID_IDT		0x111d
 #define PCI_DEVICE_ID_IDT_IDT77201	0x0001
