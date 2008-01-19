Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbYASQKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbYASQKG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:10:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760045AbYASQJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:09:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50066 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759423AbYASQJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:09:53 -0500
Date: Sat, 19 Jan 2008 16:07:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata_generic: Cenatek support
Message-ID: <20080119160758.1d2c908a@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not much to do here. It's an ata memory as disk.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/drivers/ata/ata_generic.c linux-2.6.24-rc8-mm1/drivers/ata/ata_generic.c
--- linux.vanilla-2.6.24-rc8-mm1/drivers/ata/ata_generic.c	2008-01-19 14:47:56.000000000 +0000
+++ linux-2.6.24-rc8-mm1/drivers/ata/ata_generic.c	2008-01-19 14:55:18.000000000 +0000
@@ -26,7 +26,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "ata_generic"
-#define DRV_VERSION "0.2.13"
+#define DRV_VERSION "0.2.15"
 
 /*
  *	A generic parallel ATA driver using libata
@@ -48,10 +48,14 @@
 	struct ata_port *ap = link->ap;
 	int dma_enabled = 0;
 	struct ata_device *dev;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
 	/* Bits 5 and 6 indicate if DMA is active on master/slave */
 	if (ap->ioaddr.bmdma_addr)
 		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
+		
+	if (pdev->vendor == PCI_VENDOR_ID_CENATEK)
+		dma_enabled = 0xFF;
 
 	ata_link_for_each_dev(dev, link) {
 		if (!ata_dev_enabled(dev))
@@ -201,6 +205,7 @@
 	{ PCI_DEVICE(PCI_VENDOR_ID_HINT,   PCI_DEVICE_ID_HINT_VXPROII_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_VIA,    PCI_DEVICE_ID_VIA_82C561), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/include/linux/pci_ids.h linux-2.6.24-rc8-mm1/include/linux/pci_ids.h
--- linux.vanilla-2.6.24-rc8-mm1/include/linux/pci_ids.h	2008-01-19 14:48:09.000000000 +0000
+++ linux-2.6.24-rc8-mm1/include/linux/pci_ids.h	2008-01-19 15:08:10.000000000 +0000
@@ -2085,6 +2086,9 @@
 #define PCI_VENDOR_ID_NETCELL		0x169c
 #define PCI_DEVICE_ID_REVOLUTION	0x0044
 
+#define PCI_VENDOR_ID_CENATEK		0x16CA
+#define PCI_DEVICE_ID_CENATEK_IDE	0x0001
+
 #define PCI_VENDOR_ID_VITESSE		0x1725
 #define PCI_DEVICE_ID_VITESSE_VSC7174	0x7174
 
