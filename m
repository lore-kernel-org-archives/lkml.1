Return-Path: <linux-kernel-owner+w=401wt.eu-S1759912AbZKFWFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759912AbZKFWFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759895AbZKFWFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:05:41 -0500
Received: from kroah.org ([198.145.64.141]:39698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758835AbZKFWFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:50 2009
Message-Id: <20091106215950.184976817@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@linux.intel.com>, Michael Reed <mreed10@us.ibm.com>
Subject: [01/30] 8250_pci: add IBM Saturn serial card
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=8250_pci-add-ibm-saturn-serial-card.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit c68d2b1594548cda7f6dbac6a4d9d30a9b01558c upstream.

The IBM Saturn serial card has only one port. Without that fixup,
the kernel thinks it has two, which confuses userland setup and
admin tools as well.

[akpm@linux-foundation.org: fix pci-ids.h layout]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Michael Reed <mreed10@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250_pci.c |   11 +++++++++++
 include/linux/pci_ids.h   |    3 +++
 2 files changed, 14 insertions(+)

--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -1218,6 +1218,7 @@ enum pci_board_num_t {
 	pbn_exar_XR17C152,
 	pbn_exar_XR17C154,
 	pbn_exar_XR17C158,
+	pbn_exar_ibm_saturn,
 	pbn_pasemi_1682M,
 };
 
@@ -1746,6 +1747,13 @@ static struct pciserial_board pci_boards
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
@@ -2217,6 +2225,9 @@ static struct pci_device_id serial_pci_t
 		PCI_SUBVENDOR_ID_CONNECT_TECH,
 		PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_485, 0, 0,
 		pbn_b0_8_1843200_200 },
+	{	PCI_VENDOR_ID_EXAR, PCI_DEVICE_ID_EXAR_XR17C152,
+		PCI_VENDOR_ID_IBM, PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT,
+		0, 0, pbn_exar_ibm_saturn },
 
 	{	PCI_VENDOR_ID_SEALEVEL, PCI_DEVICE_ID_SEALEVEL_U530,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -478,6 +478,9 @@
 #define PCI_DEVICE_ID_IBM_ICOM_V2_ONE_PORT_RVX_ONE_PORT_MDM_PCIE 0x0361
 #define PCI_DEVICE_ID_IBM_ICOM_FOUR_PORT_MODEL	0x252
 
+#define PCI_SUBVENDOR_ID_IBM		0x1014
+#define PCI_SUBDEVICE_ID_IBM_SATURN_SERIAL_ONE_PORT	0x03d4
+
 #define PCI_VENDOR_ID_UNISYS		0x1018
 #define PCI_DEVICE_ID_UNISYS_DMA_DIRECTOR 0x001C
 


