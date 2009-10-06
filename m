Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbZJFO2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbZJFO2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 10:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932779AbZJFO2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 10:28:38 -0400
Received: from firewall1.addi-data.de ([62.154.208.154]:44701 "EHLO
	addi-data.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932778AbZJFO2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 10:28:37 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Oct 2009 10:28:37 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] serial: Add ADDI-DATA GmbH PCI-Express communication cards in
 8250_pci.c and pci_ids.h
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 6 Oct 2009 16:21:19 +0200
Message-ID: <DD0BA80209AFF04091B518EA708D0A0B013D20F0@ffserver>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] serial: Add ADDI-DATA GmbH PCI-Express communication 
    cards in 8250_pci.c and pci_ids.h
Thread-Index: AcpGkEWziXcGpulQQNOJl84b4SCxxQ==
From: "Krauth.Julien" <Krauth.Julien@addi-data.com>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ADDI-DATA GmbH PCI-Express communication cards:

APCIe-7300
APCIe-7420
APCIe-7500
APCIe-7800

Warning: 8250_pci.c depends on pci_ids.h. 8250_pci.c


Signed-off-by: Krauth Julien <Krauth.Julien@addi-data.com>
---

These patches applies on kernel 2.6.31.1

--- linux-2.6.31.1-vanilla/include/linux/pci_ids.h	2009-09-24
17:45:25.000000000 +0200
+++ linux-2.6.31.1/include/linux/pci_ids.h	2009-09-29
11:30:06.000000000 +0200
@@ -2149,6 +2149,10 @@
 #define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
 #define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
 #define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7300       0x7010
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7420       0x7011
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7500       0x7012
+#define PCI_DEVICE_ID_ADDIDATA_APCIe7800       0x7013
 
 #define PCI_VENDOR_ID_PDC		0x15e9


--- linux-2.6.31.1-vanilla/drivers/serial/8250_pci.c	2009-09-24
17:45:25.000000000 +0200
+++ linux-2.6.31.1/drivers/serial/8250_pci.c	2009-09-29
16:59:44.000000000 +0200
@@ -1566,6 +1566,10 @@ enum pci_board_num_t {
 	pbn_ni8430_4,
 	pbn_ni8430_8,
 	pbn_ni8430_16,
+	pbn_ADDIDATA_PCIe_1_3906250,
+	pbn_ADDIDATA_PCIe_2_3906250,
+	pbn_ADDIDATA_PCIe_4_3906250,
+	pbn_ADDIDATA_PCIe_8_3906250,
 };
 
 /*
@@ -2185,6 +2189,37 @@ static struct pciserial_board pci_boards
 		.uart_offset	= 0x10,
 		.first_offset	= 0x800,
 	},
+	/*
+	 * ADDI-DATA GmbH PCI-Express communication cards
<info@addi-data.com>
+	 */
+	[pbn_ADDIDATA_PCIe_1_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_2_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 2,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_4_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 4,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
+	[pbn_ADDIDATA_PCIe_8_3906250] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 8,
+		.base_baud	= 3906250,
+		.uart_offset	= 0x200,
+		.first_offset	= 0x1000,
+	},
 };
 
 static const struct pci_device_id softmodem_blacklist[] = {
@@ -3556,6 +3591,38 @@ static struct pci_device_id serial_pci_t
 		0,
 		pbn_b0_8_115200 },
 
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7500,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_4_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7420,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_2_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7300,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_1_3906250 },
+
+	{	PCI_VENDOR_ID_ADDIDATA,
+		PCI_DEVICE_ID_ADDIDATA_APCIe7800,
+		PCI_ANY_ID,
+		PCI_ANY_ID,
+		0,
+		0,
+		pbn_ADDIDATA_PCIe_8_3906250 },
+
 	{	PCI_VENDOR_ID_NETMOS, PCI_DEVICE_ID_NETMOS_9835,
 		PCI_VENDOR_ID_IBM, 0x0299,
 		0, 0, pbn_b0_bt_2_115200 },




Besuchen Sie uns auf der SMART Automation in Linz vom 7. bis 9. Oktober 2009!
Wir präsentieren Ihnen innovative Lösungen für die industrielle Mess-, Steuer- und Automatisierungstechnik:
- Intelligente Ethernet-Systeme, IP 65
- Störsichere PC-Karten für PCI-Express, PCI, CompactPCI und PC/104-PLUS
- Echtzeit Open Source PAC*-Systeme mit PCI- oder CompactPCI-Backplane
(*PAC = Programmable Automation Controller)
Wir freuen uns auf Ihren Besuch am Stand 615 (Empore)!


Visit us at the SMART Automation in Linz (Austria) from 7 - 9 October 2009!
We will present you innovative solutions for industrial measurement, control and automation:
- Intelligent Ethernet systems, IP 65
- Interference-free PC boards for PCI-Express, PCI, CompactPCI and PC/104-PLUS
- Real-time open source PAC* systems with PCI or CompactPCI backplane
(*PAC = Programmable Automation Controller)
We look forward to welcoming you at our booth 615 (gallery)!


ADDI-DATA GmbH - Airport Boulevard B210 - 77836 Rheinmünster (Germany)
Amtsgericht Mannheim HRB210433
Geschäftsführer René Ohlmann
UST-ID-Nr.: DE 143754253 WEEE-Reg.-Nr. DE 65862200

This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. If you have received this email in error please notify the system manager.
This footnote confirms that this email message has been scanned for the presence of computer viruses.

