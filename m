Return-Path: <linux-kernel-owner+w=401wt.eu-S1756492AbYJUMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbYJUMus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbYJUMuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 08:50:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45173 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753799AbYJUMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 08:50:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] 8250: Add more OxSemi devices
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Tue, 21 Oct 2008 13:50:14 +0100
Message-ID: <20081021124908.5113.50743.stgit@localhost.localdomain>
In-Reply-To: <20081021124849.5113.26613.stgit@localhost.localdomain>
References: <20081021124849.5113.26613.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lee Howard <lee.howard@mainpine.com>

These have the Mainpine PCI identifier on however

Additional paranoia check for Tornado versions added by Alan Cox

(and this time I remembered to do an stg refresh so that the corrections ended
 up in these patches not randomly attached to another diff -- Alan)

Signed-off-by: Lee Howard <lee.howard@mainpine.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/8250_pci.c |   30 +++++++++++++++++++++++++-----
 1 files changed, 25 insertions(+), 5 deletions(-)


diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 43c990a..a8818b7 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1865,6 +1865,11 @@ static int pci_oxsemi_tornado_init(struct pci_dev *dev, struct pciserial_board *
 	unsigned long deviceID;
 	unsigned int  number_uarts;
 
+	/* OxSemi Tornado devices are all 0xCxxx */
+	if (dev->vendor == PCI_VENDOR_ID_OXSEMI &&
+	    (dev->device & 0xF000) != 0xC000)
+	    	return 0;
+
 	p = pci_iomap(dev, 0, 5);
 	if (p == NULL)
 		return -ENOMEM;
@@ -1893,7 +1898,8 @@ pciserial_init_ports(struct pci_dev *dev, struct pciserial_board *board)
 	/*
 	 * Find number of ports on board
 	 */
-	 if (dev->vendor == PCI_VENDOR_ID_OXSEMI)
+	if (dev->vendor == PCI_VENDOR_ID_OXSEMI ||
+	    dev->vendor == PCI_VENDOR_ID_MAINPINE)
 	 	pci_oxsemi_tornado_init(dev, board);
     
 	nr_ports = board->num_ports;
@@ -2375,9 +2381,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_bt_2_921600 },
 
-    /*
-     * Oxford Semiconductor Inc. Tornado PCI express device range.
-     */
+	/*
+	 * Oxford Semiconductor Inc. Tornado PCI express device range.
+	 */
  	{	PCI_VENDOR_ID_OXSEMI, 0xc101,    /* OXPCIe952 1 Legacy UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_1_4000000 },
@@ -2510,7 +2516,21 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, 0xc4cf,    /* OXPCIe200 1 Native UART */
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_oxsemi_1_4000000 },
-
+	/*
+	 * Mainpine Inc. IQ Express "Rev3" utilizing OxSemi Tornado
+	 */
+ 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 1 Port V.34 Super-G3 Fax */
+		PCI_VENDOR_ID_MAINPINE, 0x4001, 0, 0,
+		pbn_oxsemi_1_4000000 },
+ 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 2 Port V.34 Super-G3 Fax */
+		PCI_VENDOR_ID_MAINPINE, 0x4002, 0, 0,
+		pbn_oxsemi_2_4000000 },
+ 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 4 Port V.34 Super-G3 Fax */
+		PCI_VENDOR_ID_MAINPINE, 0x4004, 0, 0,
+		pbn_oxsemi_4_4000000 },
+ 	{	PCI_VENDOR_ID_MAINPINE, 0x4000,	/* IQ Express 8 Port V.34 Super-G3 Fax */
+		PCI_VENDOR_ID_MAINPINE, 0x4008, 0, 0,
+		pbn_oxsemi_8_4000000 },
 	/*
 	 * SBS Technologies, Inc. P-Octal and PMC-OCTPRO cards,
 	 * from skokodyn@yahoo.com

