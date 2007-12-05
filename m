Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbXLEPOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbXLEPOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 10:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXLEPOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 10:14:30 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:50915 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXLEPO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 10:14:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=RYWmr3BOcAK+b9Qr9pW1or845ZTJ348s4R1f8wuJB4CW0/+Z/6Oe8wo+K7CH8qYznrQzaZPnIz9ft6+wA/PHZExMabkICx2ed9D3V8/9oEFkZtoOnNXMcvIv8P/QnZcxBmWTV8HrcsBByD+XGVihj9ulasyPaFSLDa0mjaGrZ0U=
Message-ID: <cfa21c860712050714h248e4f8bvf0ecd918a987163c@mail.gmail.com>
Date: Wed, 5 Dec 2007 15:14:26 +0000
From: "=?ISO-8859-1?Q?Lu=EDs_Mendes?=" <luis.p.mendes@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 001/001] parport: Added support for the Quatech SPPXP-100 Parallel port PCI ExpressCard
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luís Mendes <luis.p.mendes@gmail.com>

Added pci vendor id Quatech - 0x135c - to include/linux/pci_id.h
Added pci device id for the Quatech SPPXP-100 ExpressCard - 0x278 - to
include/linux/pci_id.h
Modified drivers/parport/parport_pc.c to support the Quatech SPPXP-100
Parallel port PCI Expresscard
Sucessfully compiled kernel modules against 2.6.23.9 vanilla kernel
and tested the parport_pc module
Signed-off-by: Luís P Mendes <luis.p.mendes@gmail.com>
---
I added this driver because I bought a Quatech SPPXP-100 card and the
manufacturer doesn't supply drivers for linux,
 I'm not affiliated in any way with Quatech or DPAC Technologies.
This card is a ECP+EPP PCI Parallel port with standard registers but
at a different offset like many other PCI parallel ports.

diff -uprN -X linux-2.6.23.9-vanilla/Documentation/dontdiff
linux-2.6.23.9-vanilla/drivers/parport/parport_pc.c
linux-2.6.23.9_mod/drivers/parport/parport_pc.c
--- linux-2.6.23.9-vanilla/drivers/parport/parport_pc.c	2007-11-26
17:51:43.000000000 +0000
+++ linux-2.6.23.9_mod/drivers/parport/parport_pc.c	2007-12-04
23:22:38.000000000 +0000
@@ -2774,6 +2774,7 @@ enum parport_pc_pci_cards {
 	netmos_9755,
 	netmos_9805,
 	netmos_9815,
+	quatech_sppxp100,
 };


@@ -2850,6 +2851,7 @@ static struct parport_pc_pci {
         /* netmos_9755 */               { 2, { { 0, 1 }, { 2, 3 },}
}, /* untested */
 	/* netmos_9805 */               { 1, { { 0, -1 }, } }, /* untested */
 	/* netmos_9815 */               { 2, { { 0, -1 }, { 2, -1 }, } }, /*
untested */
+	/* quatech_sppxp100 */		{ 1, { { 0, 1 }, } },
 };

 static const struct pci_device_id parport_pc_pci_tbl[] = {
@@ -2933,6 +2935,9 @@ static const struct pci_device_id parpor
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9805 },
 	{ PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9815,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, netmos_9815 },
+	/* Quatech SPPXP-100 Parallel port PCI ExpressCard */
+	{ PCI_VENDOR_ID_QUATECH, PCI_DEVICE_ID_QUATECH_SPPXP_100,
+	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, quatech_sppxp100 },
 	{ 0, } /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci,parport_pc_pci_tbl);
diff -uprN -X linux-2.6.23.9-vanilla/Documentation/dontdiff
linux-2.6.23.9-vanilla/include/linux/pci_ids.h
linux-2.6.23.9_mod/include/linux/pci_ids.h
--- linux-2.6.23.9-vanilla/include/linux/pci_ids.h	2007-11-26
17:51:43.000000000 +0000
+++ linux-2.6.23.9_mod/include/linux/pci_ids.h	2007-12-05
00:04:09.000000000 +0000
@@ -2423,3 +2423,6 @@
 #define PCI_DEVICE_ID_RME_DIGI32	0x9896
 #define PCI_DEVICE_ID_RME_DIGI32_PRO	0x9897
 #define PCI_DEVICE_ID_RME_DIGI32_8	0x9898
+
+#define PCI_VENDOR_ID_QUATECH		0x135c
+#define PCI_DEVICE_ID_QUATECH_SPPXP_100 0x0278
