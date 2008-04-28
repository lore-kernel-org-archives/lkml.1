Return-Path: <linux-kernel-owner+w=401wt.eu-S934397AbYD1Pcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934397AbYD1Pcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933941AbYD1Pca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 11:32:30 -0400
Received: from mail29.messagelabs.com ([216.82.249.147]:56715 "HELO
	mail29.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932349AbYD1Pc2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 11:32:28 -0400
X-VirusChecked: Checked
X-Env-Sender: Scott.Kilau@digi.com
X-Msg-Ref: server-4.tower-29.messagelabs.com!1209396746!12578347!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] Add new supported board to jsm serial driver.
Date: Mon, 28 Apr 2008 10:32:24 -0500
Message-ID: <335DD0B75189FB428E5C32680089FB9F01DF1A49@mtk-sms-mail01.digi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Add new supported board to jsm serial driver.
Thread-Index: AcipRQ7Igih596PtQjWK2JTwrX3OSQ==
From: "Kilau, Scott" <Scott.Kilau@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: <akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Kilau <scottk@digi.com>

[PATCH] Add new supported board to jsm serial driver.
Add new PCI Express Neo/JSM board to the supported list of drivers in
the JSM driver.

Signed-off-by: Scott Kilau <scottk@digi.com>


diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
/usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm_driver.c
/usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm_driver.c
--- /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm_driver.c
2008-04-16 21:49:44.000000000 -0500
+++ /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm_driver.c
2008-04-25 11:35:31.000000000 -0500
@@ -82,7 +82,10 @@ static int jsm_probe_one(struct pci_dev 
 	/* store the info for the board we've found */
 	brd->boardnum = adapter_count++;
 	brd->pci_dev = pdev;
-	brd->maxports = 2;
+	if (pdev->device == PCIE_DEVICE_ID_NEO_4_IBM)
+		brd->maxports = 4;
+	else
+		brd->maxports = 2;
 
 	spin_lock_init(&brd->bd_lock);
 	spin_lock_init(&brd->bd_intr_lock);
@@ -208,6 +211,7 @@ static struct pci_device_id jsm_pci_tbl[
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2DB9PRI), 0,
0, 1 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45), 0, 0,
2 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_NEO_2RJ45PRI), 0,
0, 3 },
+	{ PCI_DEVICE(PCI_VENDOR_ID_DIGI, PCIE_DEVICE_ID_NEO_4_IBM), 0,
0, 4 },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, jsm_pci_tbl);
diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
/usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm.h
/usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm.h
--- /usr/src/kernels/linux-2.6.25.orig/drivers/serial/jsm/jsm.h
2008-04-16 21:49:44.000000000 -0500
+++ /usr/src/kernels/linux-2.6.25/drivers/serial/jsm/jsm.h
2008-04-25 10:08:04.000000000 -0500
@@ -373,6 +373,7 @@ struct neo_uart_struct {
 #define PCI_DEVICE_NEO_2DB9PRI_PCI_NAME		"Neo 2 - DB9
Universal PCI - Powered Ring Indicator"
 #define PCI_DEVICE_NEO_2RJ45_PCI_NAME		"Neo 2 - RJ45 Universal
PCI"
 #define PCI_DEVICE_NEO_2RJ45PRI_PCI_NAME	"Neo 2 - RJ45 Universal
PCI - Powered Ring Indicator"
+#define PCIE_DEVICE_NEO_IBM_PCI_NAME		"Neo 4 - PCI Express -
IBM"
 
 /*
  * Our Global Variables.
diff -uprN -X /usr/src/kernels/linux-2.6.25.orig/Documentation/dontdiff
/usr/src/kernels/linux-2.6.25.orig/include/linux/pci_ids.h
/usr/src/kernels/linux-2.6.25/include/linux/pci_ids.h
--- /usr/src/kernels/linux-2.6.25.orig/include/linux/pci_ids.h
2008-04-16 21:49:44.000000000 -0500
+++ /usr/src/kernels/linux-2.6.25/include/linux/pci_ids.h
2008-04-25 10:10:32.000000000 -0500
@@ -1429,6 +1429,7 @@
 #define PCI_DEVICE_ID_NEO_2DB9PRI       0x00C9
 #define PCI_DEVICE_ID_NEO_2RJ45         0x00CA
 #define PCI_DEVICE_ID_NEO_2RJ45PRI      0x00CB
+#define PCIE_DEVICE_ID_NEO_4_IBM        0x00F4
 
 #define PCI_VENDOR_ID_XIRCOM		0x115d
 #define PCI_DEVICE_ID_XIRCOM_RBM56G	0x0101
