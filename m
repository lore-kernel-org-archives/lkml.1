Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbXFRIy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbXFRIy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbXFRIyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:54:19 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:36974 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752406AbXFRIyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:54:18 -0400
Message-id: <29285162611339719891@wsc.cz>
Subject: [PATCH 1/5] ATM: lanai, change VENDOR to DEVICE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Greg KH <greg@kroah.com>
Cc: Mitchell Blank Jr <mitch@sfgoth.com>
Date: Mon, 18 Jun 2007 10:54:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lanai, change VENDOR to DEVICE

There were 2 bad named macros in pci_ids (LANAI 2 and IHB). Rename it to
DEVICE, because it's device id. Also make some cleanpu in pci_device_id
table (use PCI_VDEVICE).

Cc: Mitchell Blank Jr <mitch@sfgoth.com>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 96eaa9b8796ffe32733a4a25794854d8621433ee
tree 3736cc65098b89bbb1f7a9cb563f87e0dcca7c9c
parent 427d2812b00e5dcd2ed94c82fb7215f4d86b0530
author Jiri Slaby <jirislaby@gmail.com> Sat, 16 Jun 2007 17:25:08 +0200
committer Jiri Slaby <jirislaby@gmail.com> Mon, 18 Jun 2007 10:46:38 +0200

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
index 24a5f46..62eec56 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1384,8 +1384,8 @@
 #define PCI_VENDOR_ID_EF		0x111a
 #define PCI_DEVICE_ID_EF_ATM_FPGA	0x0000
 #define PCI_DEVICE_ID_EF_ATM_ASIC	0x0002
-#define PCI_VENDOR_ID_EF_ATM_LANAI2	0x0003
-#define PCI_VENDOR_ID_EF_ATM_LANAIHB	0x0005
+#define PCI_DEVICE_ID_EF_ATM_LANAI2	0x0003
+#define PCI_DEVICE_ID_EF_ATM_LANAIHB	0x0005
 
 #define PCI_VENDOR_ID_IDT		0x111d
 #define PCI_DEVICE_ID_IDT_IDT77201	0x0001
