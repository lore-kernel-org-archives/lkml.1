Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbYBGUFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbYBGUFq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 15:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933054AbYBGUDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:03:30 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:38630 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbYBGUD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oGfJ0SmINJ8MpuEuyZp6LVjoLDe8kpNAH8x3F9oLzBJfLnbJO1zBSv1a5AJbJ6WT6QmA4Ygbg05Y+7XgNJR3XGc/wLS4Fch3EoJq0MZxoC5vKCbQYXCEW/wXUWcSklBj8Gfq4Nn5yfWrARttHVjyqR15YRbw4CgyBSOyNCajPiw=
Message-ID: <6101e8c40802071203q71cf9401v6b84a589d69cf8dd@mail.gmail.com>
Date: Thu, 7 Feb 2008 21:03:26 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {06/14} - pci: fix unterminated pci_device_id lists - on top of 2.6.22.17
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

aka: pci-fix-unterminated-pci_device_id-lists.patch

From: Kees Cook <kees@ubuntu.com>
Date: Wed, 19 Sep 2007 05:46:32 +0000 (-0700)
Subject: pci: fix unterminated pci_device_id lists
Patch-mainline: 2.6.23-rc7
References: 340527
Git-commit: h=248bdd5efca5a113cbf443a993c69e53d370236b

pci: fix unterminated pci_device_id lists

mainline: 248bdd5efca5a113cbf443a993c69e53d370236b

Fix a couple drivers that do not correctly terminate their pci_device_id
lists.  This results in garbage being spewed into modules.pcimap when the
module happens to not have 28 NULL bytes following the table, and/or the
last PCI ID is actually truncated from the table when calculating the
modules.alias PCI aliases, cause those unfortunate device IDs to not
auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
Acked-by: Corey Minyard <minyard@acm.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Acked-by: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Jeff Mahoney <jeffm@suse.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>
---
 drivers/char/ipmi/ipmi_si_intf.c                |    3 ++-
 drivers/media/video/usbvision/usbvision-cards.c |    1 +
 drivers/mtd/nand/cafe_nand.c                    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 9b07f78..dd441ff 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2215,7 +2215,8 @@ static int ipmi_pci_resume(struct pci_de

 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);

diff --git a/drivers/media/video/usbvision/usbvision-cards.c
b/drivers/media/video/usbvision/usbvision-cards.c
index 380564c..f09eb10 100644
--- a/drivers/media/video/usbvision/usbvision-cards.c
+++ b/drivers/media/video/usbvision/usbvision-cards.c
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table []
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };

 MODULE_DEVICE_TABLE (usb, usbvision_table);
diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index cff969d..6f32a35 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(s
 }

 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH <<
8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH <<
8, 0xFFFF0 },
+	{ 0, }
 };

 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);


-- 
Thanks,
Oliver
