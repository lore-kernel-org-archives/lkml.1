Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbYFDLxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbYFDLxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 07:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760467AbYFDLxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 07:53:42 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:6764 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYFDLxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 07:53:40 -0400
Date: Wed, 4 Jun 2008 13:53:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH] PCI: Unhide the SMBus on the Compaq Evo D510
Message-ID: <20080604135331.3fb6f284@hyperion.delvare>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One more machine with a hidden Intel SMBus. Unhiding it reveals a SMSC
EMC6D100 hardware monitoring chip. I have checked that this machine
has no ACPI magic touching the SMBus nor the hardware monitoring chip,
so this should be safe.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
Patch already sent on:
 * 2008-04-17

 drivers/pci/quirks.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- linux-2.6.25.orig/drivers/pci/quirks.c	2008-04-17 16:39:59.000000000 +0200
+++ linux-2.6.25/drivers/pci/quirks.c	2008-04-17 16:40:29.000000000 +0200
@@ -1054,6 +1054,12 @@ static void __init asus_hides_smbus_host
 				 * its on-board VGA controller */
 				asus_hides_smbus = 1;
 			}
+		else if (dev->device == PCI_DEVICE_ID_INTEL_82845G_IG)
+			switch(dev->subsystem_device) {
+			case 0x00b8: /* Compaq Evo D510 CMT */
+			case 0x00b9: /* Compaq Evo D510 SFF */
+				asus_hides_smbus = 1;
+			}
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82845_HB,	asus_hides_smbus_hostbridge);
@@ -1068,6 +1074,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82915GM_HB, asus_hides_smbus_hostbridge);
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82810_IG3,	asus_hides_smbus_hostbridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82845G_IG,	asus_hides_smbus_hostbridge);
 
 static void asus_hides_smbus_lpc(struct pci_dev *dev)
 {


-- 
Jean Delvare
