Return-Path: <linux-kernel-owner+w=401wt.eu-S1759474AbXFAJ20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759474AbXFAJ20 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXFAJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:28:20 -0400
Received: from nethservice.nethesis.it ([82.104.129.21]:52557 "HELO
	nethesis.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756777AbXFAJ2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:28:19 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 05:28:18 EDT
Message-ID: <465FE51E.2060705@mobilia.it>
Date: Fri, 01 Jun 2007 11:21:34 +0200
From: Filippo Carletti <carletti@mobilia.it>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] 2.4.34 - Add some ahci pci ids
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------070801030802000104030107"
X-Virus-Checked: Checked by ClamAV on nethesis.it
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070801030802000104030107
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch adds support for some chipsets in ahci driver.
The list comes from a patch for redhat kernel 2.6.9-34.
I only tested ICH8.

The original patch contained also this lines (that I omitted):
+       /* JMicron-specific fixup: make sure we're in AHCI mode */
+       if (pdev->vendor == 0x197b)
+               pci_write_config_byte(pdev, 0x41, 0xa1);
+


Ciao,
Filippo

--------------070801030802000104030107
Content-Type: text/x-patch;
 name="linux-2.4.34_ahci.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.4.34_ahci.patch"

--- drivers/scsi/ahci.c.orig	2006-12-23 20:34:20.000000000 +0000
+++ drivers/scsi/ahci.c	2007-05-11 22:11:52.000000000 +0000
@@ -275,6 +275,24 @@
 	  board_ahci }, /* ESB2 */
 	{ PCI_VENDOR_ID_INTEL, 0x27c6, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	  board_ahci }, /* ICH7-M DH */
+	{ PCI_VENDOR_ID_INTEL, 0x2821, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2822, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2824, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8 */
+	{ PCI_VENDOR_ID_INTEL, 0x2829, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8M */
+	{ PCI_VENDOR_ID_INTEL, 0x282a, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ICH8M */
+	{ 0x197b, 0x2360, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* JMicron JMB360 */
+	{ 0x197b, 0x2363, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* JMicron JMB363 */
+	{ PCI_VENDOR_ID_ATI, 0x4380, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VENDOR_ID_ATI, 0x4381, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	  board_ahci }, /* ATI SB600 raid */
 	{ }	/* terminate list */
 };
 

--------------070801030802000104030107--
