Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZCBIvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZCBIvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 03:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756605AbZCBIv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 03:51:28 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:27225 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbZCBIv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 03:51:28 -0500
Date: Mon, 2 Mar 2009 09:51:13 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] PCI: Compaq Evo D510 SMBus quirk using USB instead of VGA
Message-ID: <20090302095113.46661b9d@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David O'Shea <dcoshea@hotmail.com>
Subject: PCI: Compaq Evo D510 SMBus quirk using USB instead of VGA

On the Compaq Evo D510 SFF/CMT, a PCI quirk activated the SMBus device
based on detection of the on-board VGA controller, but the on-board
VGA is disabled if an AGP card is inserted, so look for one of the USB
controllers instead.

Signed-off-by: David O'Shea <dcoshea@hotmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/pci/quirks.c    |    9 +++++++--
 include/linux/pci_ids.h |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

--- linux-2.6.29-rc6.orig/drivers/pci/quirks.c	2009-03-02 08:46:20.000000000 +0100
+++ linux-2.6.29-rc6/drivers/pci/quirks.c	2009-03-02 09:17:16.000000000 +0100
@@ -1125,10 +1125,15 @@ static void __init asus_hides_smbus_host
 				 * its on-board VGA controller */
 				asus_hides_smbus = 1;
 			}
-		else if (dev->device == PCI_DEVICE_ID_INTEL_82845G_IG)
+		else if (dev->device == PCI_DEVICE_ID_INTEL_82801DB_2)
 			switch(dev->subsystem_device) {
 			case 0x00b8: /* Compaq Evo D510 CMT */
 			case 0x00b9: /* Compaq Evo D510 SFF */
+				/* Motherboard doesn't have Host bridge
+				 * subvendor/subdevice IDs and on-board VGA
+				 * controller is disabled if an AGP card is
+				 * inserted, therefore checking USB UHCI
+				 * Controller #1 */
 				asus_hides_smbus = 1;
 			}
 		else if (dev->device == PCI_DEVICE_ID_INTEL_82815_CGC)
@@ -1153,7 +1158,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82915GM_HB, asus_hides_smbus_hostbridge);
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82810_IG3,	asus_hides_smbus_hostbridge);
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82845G_IG,	asus_hides_smbus_hostbridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82801DB_2,	asus_hides_smbus_hostbridge);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82815_CGC,	asus_hides_smbus_hostbridge);
 
 static void asus_hides_smbus_lpc(struct pci_dev *dev)
--- linux-2.6.29-rc6.orig/include/linux/pci_ids.h	2009-03-02 08:46:20.000000000 +0100
+++ linux-2.6.29-rc6/include/linux/pci_ids.h	2009-03-02 09:17:16.000000000 +0100
@@ -2373,6 +2373,7 @@
 #define PCI_DEVICE_ID_INTEL_82801CA_12	0x248c
 #define PCI_DEVICE_ID_INTEL_82801DB_0	0x24c0
 #define PCI_DEVICE_ID_INTEL_82801DB_1	0x24c1
+#define PCI_DEVICE_ID_INTEL_82801DB_2	0x24c2
 #define PCI_DEVICE_ID_INTEL_82801DB_3	0x24c3
 #define PCI_DEVICE_ID_INTEL_82801DB_5	0x24c5
 #define PCI_DEVICE_ID_INTEL_82801DB_6	0x24c6


-- 
Jean Delvare
