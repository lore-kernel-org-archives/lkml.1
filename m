Return-Path: <linux-kernel-owner+w=401wt.eu-S1946321AbXBCPNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946321AbXBCPNf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 10:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946323AbXBCPNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 10:13:35 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:53661 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946321AbXBCPNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 10:13:34 -0500
Message-id: <2657923269772116410@wsc.cz>
Subject: [PATCH 1/1] Char: cyclades, use pci_device_id
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Cyclades team <async@cyclades.com>
Date: Sat,  3 Feb 2007 16:13:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, use pci_device_id

Use pci_device_id struct instead of ushort array. Add MODULE_DEVICE_TABLE.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 19616d3278c941961db6344fb2217695c32d7b55
tree e42914f6edb4f350b86cb41e4dcd16b201d7b5c5
parent d90437a76c6514f1e6160ca75afa5597fd4a274c
author Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:23:17 +0100
committer Jiri Slaby <jirislaby@gmail.com> Sat, 03 Feb 2007 15:23:17 +0100

 drivers/char/cyclades.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 363beb1..54df355 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -829,17 +829,18 @@ static unsigned short cy_pci_nboard;
 static unsigned short cy_isa_nboard;
 static unsigned short cy_nboard;
 #ifdef CONFIG_PCI
-static unsigned short cy_pci_dev_id[] = {
-	PCI_DEVICE_ID_CYCLOM_Y_Lo,	/* PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Y_Hi,	/* PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_4Y_Lo,	/* 4Y PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_4Y_Hi,	/* 4Y PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_8Y_Lo,	/* 8Y PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_8Y_Hi,	/* 8Y PCI > 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Z_Lo,	/* Z PCI < 1Mb */
-	PCI_DEVICE_ID_CYCLOM_Z_Hi,	/* Z PCI > 1Mb */
-	0			/* end of table */
+static struct pci_device_id cy_pci_dev_id[] __devinitdata = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Lo) },	/* PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Y_Hi) },	/* PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Lo) },	/* 4Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_4Y_Hi) },	/* 4Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Lo) },	/* 8Y PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_8Y_Hi) },	/* 8Y PCI > 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Lo) },	/* Z PCI < 1Mb */
+	{ PCI_DEVICE(PCI_VENDOR_ID_CYCLADES, PCI_DEVICE_ID_CYCLOM_Z_Hi) },	/* Z PCI > 1Mb */
+	{ }			/* end of table */
 };
+MODULE_DEVICE_TABLE(pci, cy_pci_dev_id);
 #endif
 
 static void cy_start(struct tty_struct *);
@@ -4758,7 +4759,7 @@ static int __init cy_detect_pci(void)
 
 	for (i = 0; i < NR_CARDS; i++) {
 		/* look for a Cyclades card by vendor and device id */
-		while ((device_id = cy_pci_dev_id[dev_index]) != 0) {
+		while ((device_id = cy_pci_dev_id[dev_index].device) != 0) {
 			if ((pdev = pci_get_device(PCI_VENDOR_ID_CYCLADES,
 						   device_id, pdev)) == NULL) {
 				dev_index++;	/* try next device id */
