Return-Path: <linux-kernel-owner+w=401wt.eu-S1760217AbXK1KZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760217AbXK1KZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754685AbXK1KZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:25:26 -0500
Received: from firewall1.addi-data.de ([62.154.208.154]:61956 "EHLO
	firewal1.addi-data.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753967AbXK1KZZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:25:25 -0500
X-Greylist: delayed 1716 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 05:25:25 EST
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] serial: add ADDI-DATA GmbH Communication cards in 8250_pci.c
 and pci_ids.h.
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Wed, 28 Nov 2007 10:57:02 +0100
Message-ID: <DD0BA80209AFF04091B518EA708D0A0B9F91BF@exchange01.addi-data.intra>
Thread-Topic: [PATCH] serial: add ADDI-DATA GmbH Communication cards in 
    8250_pci.c and pci_ids.h.
Thread-Index: AcgxpQYujS+t3T39R3y+G9yHslxGJQ==
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krauth Julien <krauth.julien@addi-data.com>

Add ADDI-DATA GmbH communication cards to 8250_pci driver.
Supported cards are:

APCI-7300, APCI-7420, APCI-7500, APCI-7800
APCI-7300-2, APCI-7420-2, APCI-7500-2
APCI-7300-3, APCI-7420-3, APCI-7500-3, APCI-7800-3

8250_pci.c.patch
================
Add ADDI-DATA GmbH communication cards to 8250_pci.c.

pci_ids.h.patch
===============
Add ADDI-DATA GmbH communication cards Vendor and Device IDs to
pci_ids.h.

WARNING:
========
8250_pci.c.patch depend on pci_ids.h.patch.
8250_pci.c is using Vendor and Device ID defined in pci_ids.h.


Signed-off-by: Krauth J. <krauth.julien@addi-data.com>
---

This patch applies to kernel 2.6.23.9.

--- linux-2.6.23.9-vanilla/include/linux/pci_ids.h	2007-11-26
18:51:43.000000000 +0100
+++ linux-2.6.23.9/include/linux/pci_ids.h	2007-11-27
10:55:12.000000000 +0100
@@ -2019,6 +2019,23 @@
 #define PCI_VENDOR_ID_QUICKNET		0x15e2
 #define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
 
+/*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>
+ */
+#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
+#define PCI_VENDOR_ID_ADDIDATA                 0x15B8
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
+#define PCI_DEVICE_ID_ADDIDATA_APCI7500_3      0x700C
+#define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
+#define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
+#define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+
 #define PCI_VENDOR_ID_PDC		0x15e9
 
 #define PCI_VENDOR_ID_FARSITE           0x1619

--- linux-2.6.23.9-vanilla/drivers/serial/8250_pci.c	2007-11-26
18:51:43.000000000 +0100
+++ linux-2.6.23.9/drivers/serial/8250_pci.c	2007-11-27
10:53:09.000000000 +0100
@@ -106,6 +106,51 @@ setup_port(struct serial_private *priv, 
 }
 
 /*
+ * ADDI-DATA GmbH communication cards <info@addi-data.com>
+ */
+static int
+addidata_setup(struct serial_private *priv, struct pciserial_board
*board,
+               struct uart_port *port, int idx)
+{
+       unsigned int bar = 0, offset = board->first_offset;
+       bar = FL_GET_BASE(board->flags);
+
+       switch (priv->dev->device) {
+       case PCI_DEVICE_ID_ADDIDATA_APCI7500:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7420:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7300:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7500_2:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7420_2:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7300_2:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7500_3:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7420_3:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7300_3:
+       case PCI_DEVICE_ID_ADDIDATA_APCI7800_3:
+               offset += idx * board->uart_offset;
+               break;
+
+       case PCI_DEVICE_ID_ADDIDATA_APCI7800:
+               if (idx < 2 ) {
+                       bar += 0;
+                       offset += idx * board->uart_offset;
+               } else if ((idx >= 2) && (idx < 4)) {
+                       bar += 1;
+                       offset += ((idx - 2) * board->uart_offset);
+               } else if ((idx >= 4) && (idx < 6 )) {
+                       bar += 2;
+                       offset += ((idx - 4) * board->uart_offset);
+               } else if (idx >= 6) {
+                       bar += 3;
+                       offset += ((idx - 6) * board->uart_offset);
+               }
+
+               break;
+       }
+
+       return setup_port(priv, port, bar, offset, board->reg_shift);
+}
+
+/*
  * AFAVLAB uses a different mixture of BARs and offsets
  * Not that ugly ;) -- HW
  */
@@ -752,6 +797,86 @@ pci_default_setup(struct serial_private 
  */
 static struct pci_serial_quirk pci_serial_quirks[] = {
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7500,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7420,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7300,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA_OLD,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	{
+		.vendor         = PCI_VENDOR_ID_ADDIDATA,
+		.device         = PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
+		.subvendor      = PCI_ANY_ID,
+		.subdevice      = PCI_ANY_ID,
+		.setup          = addidata_setup,
+	},
+	/*
 	 * AFAVLAB cards - these may be called via parport_serial
 	 *  It is not clear whether this applies to all products.
 	 */
@@ -2574,6 +2699,97 @@ static struct pci_device_id serial_pci_t
 		pbn_pasemi_1682M },
 
 	/*
+	* ADDI-DATA GmbH communication cards <info@addi-data.com>
+	*/
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA_OLD,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b1_8_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_4_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_2_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_1_115200 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_b0_bt_8_115200 },
+
+	/*
 	 * These entries match devices with class COMMUNICATION_SERIAL,
 	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
 	 */


--------------------------------------------------------------------------
Besuchen Sie uns auf der SPS/IPC/Drives in Nürnberg vom 27. bis 29. November 2007.
Diese aktuellen Themen haben wir für Sie vorbereitet:
- neue Digital- und Zählerkarte für den PCI-Express-Bus,
- neue, intelligente Ethernet  E/A-Module mit SPS-Anbindung,
- Neue Live-DVD mit Entwicklungswerkzeugen für das PAC-System MSX-Box.
Sie finden uns in Halle 7,  Stand 123.
Vorbeischauen lohnt sich: Jeden Tag können Sie einen elektronischen 
Bilderrahmen von Samsung gewinnen!
--------------------------------------------------------------------------

ADDI-DATA GmbH - Dieselstraße 3 - 77833 Ottersweier (Germany)
Amtsgericht Mannheim HRB210433
Geschäftsführer Antonio Agnetti, René Ohlmann 
UST-ID-Nr.: DE 143754253 WEEE-Reg.-Nr. DE 65862200

This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. If you have received this email in error please notify the system manager.
This footnote confirms that this email message has been scanned for the presence of computer viruses.

