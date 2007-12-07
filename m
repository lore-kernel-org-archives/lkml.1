Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbXLGRgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbXLGRgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbXLGRgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:36:42 -0500
Received: from msg.vodafone.pt ([212.18.167.162]:41860 "EHLO msg.vodafone.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbXLGRgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:36:42 -0500
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Dec 2007 12:36:41 EST
From: =?iso-8859-1?q?Lu=EDs_Mendes?= <luis.mendes@ist.utl.pt>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.23.9 001/001] parport: Added support for the Quatech SPPXP-100 Parallel port PCI ExpressCard
Date: Fri, 7 Dec 2007 17:31:02 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712071731.02799.luis.mendes@ist.utl.pt>
X-OriginalArrivalTime: 07 Dec 2007 17:30:05.0093 (UTC) FILETIME=[CE193D50:01C838F6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luís P Mendes <luis.p.mendes@gmail.com>

Added pci device id for the Quatech SPPXP-100 ExpressCard - 0x278 - in include/linux/pci_ids.h
Modified drivers/parport/parport_pc.c to support the Quatech SPPXP-100 Parallel port PCI ExpressCard
Sucessfully compiled kernel modules against 2.6.23.9 vanilla kernel and tested the parport_pc module
Signed-off-by: Luís P Mendes <luis.p.mendes@gmail.com>
---
This is a corrected version of the patch, the previous version had a problem, I didn't notice that the Quatech PCI vendor id
was already present in the pci_ids.h file, and that caused a lot of warnings.
I'm not affiliated in any way with Quatech or DPAC Technologies.
This card is a ECP+EPP PCI Parallel port with standard registers but at a different offset like many other PCI parallel ports, as such
the addition of this card required a small amount of modifications/code to get it to work under Linux.
diff -uprN -X linux-2.6.23.9-vanilla/Documentation/dontdiff linux-2.6.23.9-vanilla/drivers/parport/parport_pc.c linux-2.6.23.9_mod/drivers/parport/parport_pc.c
--- linux-2.6.23.9-vanilla/drivers/parport/parport_pc.c	2007-11-26 17:51:43.000000000 +0000
+++ linux-2.6.23.9_mod/drivers/parport/parport_pc.c	2007-12-06 00:16:54.000000000 +0000
@@ -2774,6 +2774,7 @@ enum parport_pc_pci_cards {
 	netmos_9755,
 	netmos_9805,
 	netmos_9815,
+	quatech_sppxp100,
 };
 
 
@@ -2850,6 +2851,7 @@ static struct parport_pc_pci {
         /* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },} }, /* untested */
 	/* netmos_9805 */               { 1, { { 0, -1 }, } }, /* untested */
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } }, /* untested */
+	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };
 
 static const struct pci_device_id parport_pc_pci_tbl[] = {
@@ -2933,6 +2935,9 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
+	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
+	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP100,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci,parport_pc_pci_tbl);
diff -uprN -X linux-2.6.23.9-vanilla/Documentation/dontdiff linux-2.6.23.9-vanilla/include/linux/pci_ids.h linux-2.6.23.9_mod/include/linux/pci_ids.h
--- linux-2.6.23.9-vanilla/include/linux/pci_ids.h	2007-11-26 17:51:43.000000000 +0000
+++ linux-2.6.23.9_mod/include/linux/pci_ids.h	2007-12-06 00:16:27.000000000 +0000
@@ -1751,6 +1751,7 @@
 #define PCI_DEVICE_ID_QUATECH_DSC100	0x0020
 #define PCI_DEVICE_ID_QUATECH_ESC100D	0x0050
 #define PCI_DEVICE_ID_QUATECH_ESC100M	0x0060
+#define PCI_DEVICE_ID_QUATECH_SPPXP100  0x0278
 
 #define PCI_VENDOR_ID_SEALEVEL		0x135e
 #define PCI_DEVICE_ID_SEALEVEL_U530	0x7101
