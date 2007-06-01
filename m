Return-Path: <linux-kernel-owner+w=401wt.eu-S1759854AbXFAJcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759854AbXFAJcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbXFAJb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:31:58 -0400
Received: from nethservice.nethesis.it ([82.104.129.21]:52626 "HELO
	nethesis.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755788AbXFAJb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:31:57 -0400
Message-ID: <465FE5FA.9040709@mobilia.it>
Date: Fri, 01 Jun 2007 11:25:14 +0200
From: Filippo Carletti <carletti@mobilia.it>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.4.34 - VIA VT8237A support
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------080604060004070407080100"
X-Virus-Checked: Checked by ClamAV on nethesis.it
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080604060004070407080100
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch adds support for VIA VT8237A.
It enables DMA on IDE and it makes sata drives work.
Tested on an Asus VINTAGE V2-P5V90.

Ciao,
Filippo

--------------080604060004070407080100
Content-Type: text/x-patch;
 name="linux-2.4.34_VT8237A.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.34_VT8237A.patch"

--- include/linux/pci_ids.h.orig	2007-05-21 20:05:22.000000000 +0200
+++ include/linux/pci_ids.h	2007-05-25 00:53:14.000000000 +0200
@@ -1160,6 +1160,7 @@
 #define PCI_DEVICE_ID_VIA_8377_0	0x3189
 #define PCI_DEVICE_ID_VIA_K8T400M_0	0x3188
 #define PCI_DEVICE_ID_VIA_8237		0x3227
+#define PCI_DEVICE_ID_VIA_8237A		0x3337
 #define PCI_DEVICE_ID_VIA_86C100A	0x6100
 #define PCI_DEVICE_ID_VIA_8231		0x8231
 #define PCI_DEVICE_ID_VIA_8231_4	0x8235
--- drivers/scsi/sata_via.c.orig	2006-12-23 21:34:20.000000000 +0100
+++ drivers/scsi/sata_via.c	2007-05-25 00:41:26.000000000 +0200
@@ -76,6 +76,7 @@
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id svia_pci_tbl[] = {
+	{ 0x1106, 0x0591, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6420 },
 	{ 0x1106, 0x3149, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6420 },
 	{ 0x1106, 0x3249, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6421 },
 
--- drivers/ide/pci/via82cxxx.c.orig	2006-12-23 21:34:20.000000000 +0100
+++ drivers/ide/pci/via82cxxx.c	2007-05-25 00:39:20.000000000 +0200
@@ -75,6 +75,7 @@
 	u16 flags;
 } via_isa_bridges[] = {
 	{ "vt8237",	PCI_DEVICE_ID_VIA_8237,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
+	{ "vt8237a",	PCI_DEVICE_ID_VIA_8237A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8235",	PCI_DEVICE_ID_VIA_8235,     0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8233a",	PCI_DEVICE_ID_VIA_8233A,    0x00, 0x2f, VIA_UDMA_133 | VIA_BAD_AST },
 	{ "vt8233c",	PCI_DEVICE_ID_VIA_8233C_0,  0x00, 0x2f, VIA_UDMA_100 },

--------------080604060004070407080100--
