Return-Path: <linux-kernel-owner+w=401wt.eu-S1764100AbYFHLoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764100AbYFHLoi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758369AbYFHLoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:44:30 -0400
Received: from mx1.wp.pl ([212.77.101.5]:50990 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758179AbYFHLo3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:44:29 -0400
Date: Sun, 8 Jun 2008 13:47:02 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       lm-sensors@lm-sensors.org
Cc: khali@linux-fr.org, <rh1985@wp.pl>
Subject: [PATCH] Unhide the SMBus on the Compaq Deskpro EN
Message-Id: <20080608134702.401b9fb5.krzysztof.h1@wp.pl>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [URPE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

This patch unhides the SMBus on Compaq Deskpro EN
SFF P667 with the Intel 815E chipset. Unhiding it reveals 
a THMC51 hardware monitoring chip.

Jean Delvare has checked that this machine has no ACPI
magic touching the SMBus nor the hardware monitoring chip,
so this should be safe.

The patch was tested on Fedora Core 9 with 2.6.25.4 kernel.

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
Tested-by: Rafa³ Ha³aduda <rh1985@wp.pl>
CC: Jean Delvare <khali@linux-fr.org>

---
If someone owns the Compaq Deskpro EN machine, please
test the patch as well.

diff -urp linux-2.6.25/drivers/pci/quirks.c linux-new/drivers/pci/quirks.c
--- linux-2.6.25/drivers/pci/quirks.c	2008-05-27 21:58:34.380144607 +0200
+++ linux-new/drivers/pci/quirks.c	2008-05-30 23:12:57.510219450 +0200
@@ -1054,6 +1054,14 @@ static void __init asus_hides_smbus_host
 				 * its on-board VGA controller */
 				asus_hides_smbus = 1;
 			}
+		else if (dev->device == PCI_DEVICE_ID_INTEL_82815_CGC)
+			switch (dev->subsystem_device) {
+			case 0x001A: /* Compaq Deskpro EN SSF P667 815E */
+				/* Motherboard doesn't have host bridge
+				 * subvendor/subdevice IDs, therefore checking
+				 * its on-board VGA controller */
+				asus_hides_smbus = 1;
+			}
 	}
 }
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82845_HB,	asus_hides_smbus_hostbridge);
@@ -1068,6 +1076,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_I
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82915GM_HB, asus_hides_smbus_hostbridge);
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82810_IG3,	asus_hides_smbus_hostbridge);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	PCI_DEVICE_ID_INTEL_82815_CGC,	asus_hides_smbus_hostbridge);
 
 static void asus_hides_smbus_lpc(struct pci_dev *dev)
 {

