Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZJMXmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZJMXmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 19:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbZJMXmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 19:42:09 -0400
Received: from gate.crashing.org ([63.228.1.57]:47202 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbZJMXmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 19:42:08 -0400
Subject: [PATCH] 8250_pci: Add IBM Saturn serial card
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Russell King <linux@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Michael Reed <mreed10@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 10:40:53 +1100
Message-Id: <1255477253.2347.22.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IBM Saturn serial card has only one port. Without that fixup,
the kernel thinks it has two, which confuses userland setup and
admin tools as well.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Andrew & Others on CC... not sure who takes care of patches to
that driver nowadays. Should I send directly to Linus ?

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index e7108e7..7b5ff09 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1561,6 +1561,7 @@ enum pci_board_num_t {
 	pbn_exar_XR17C152,
 	pbn_exar_XR17C154,
 	pbn_exar_XR17C158,
+	pbn_exar_ibm_saturn,
 	pbn_pasemi_1682M,
 	pbn_ni8430_2,
 	pbn_ni8430_4,
@@ -2146,6 +2147,13 @@ static struct pciserial_board pci_boards[] __devinitdata = {
 		.base_baud	= 921600,
 		.uart_offset	= 0x200,
 	},
+	[pbn_exar_ibm_saturn] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.uart_offset	= 0x200,
+	},
+
 	/*
 	 * PA Semi PWRficient PA6T-1682M on-chip UART
 	 */
@@ -2649,6 +2657,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 		PCI_SUBVENDOR_ID_CONNECT_TECH,
 		PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_485, 0, 0,
 		pbn_b0_8_1843200_200 },
+	{	PCI_VENDOR_ID_EXAR, PCI_DEVICE_ID_EXAR_XR17C152,
+		PCI_VENDOR_ID_IBM, PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT,
+		0, 0, pbn_exar_ibm_saturn },
 
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_U530,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 0d96be9..06a7b94 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -481,6 +481,8 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM	0x0251
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
+#define PCI_SUBVENDOR_ID_IBM		0x1014
+#define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
 
 #define PCI_VENDOR_ID_UNISYS		0x1018
 #define PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR 0x001C






