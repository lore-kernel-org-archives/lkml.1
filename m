Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbXIMEp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbXIMEp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 00:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXIMEpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 00:45:18 -0400
Received: from mylar.outflux.net ([69.93.193.226]:47606 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXIMEpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 00:45:17 -0400
Date: Wed, 12 Sep 2007 21:45:04 -0700
From: Kees Cook <kees@ubuntu.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Ben Collins <bcollins@ubuntu.com>
Subject: [PATCHv2] misc: fix unterminated *_device_id lists
Message-ID: <20070913044504.GP8183@outflux.net>
References: <20070913004709.GL8183@outflux.net> <46E88F1B.5050405@garzik.org> <20070913035407.GN8183@outflux.net> <46E8B64D.3030107@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E8B64D.3030107@garzik.org>
Organization: Ubuntu
X-HELO: gorgon.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes drivers that do not correctly terminate their *_device_id lists.
This results in garbage being spewed into modules.pcimap when the module
happens to not have 28 NULL bytes following the table, and/or the last PCI
ID is actually truncated from the table when calculating the modules.alias
PCI aliases, causing those unfortunate device IDs to not auto-load.

Signed-off-by: Kees Cook <kees@ubuntu.com>
---
Re-send, using recommended list termination code-style.
Diff is against 2.6.23-rc6.

 linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c                |    3 ++-
 linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c |    1 +
 linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c                    |    3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)
---
diff -uNrp linux-2.6.23-rc6~/drivers/char/ipmi/ipmi_si_intf.c linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c
--- linux-2.6.23-rc6~/drivers/char/ipmi/ipmi_si_intf.c	2007-09-11 23:17:13.000000000 -0700
+++ linux-2.6.23-rc6/drivers/char/ipmi/ipmi_si_intf.c	2007-09-11 23:21:51.000000000 -0700
@@ -2215,7 +2215,8 @@ static int ipmi_pci_resume(struct pci_de
 
 static struct pci_device_id ipmi_pci_devices[] = {
 	{ PCI_DEVICE(PCI_HP_VENDOR_ID, PCI_MMC_DEVICE_ID) },
-	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) }
+	{ PCI_DEVICE_CLASS(PCI_ERMC_CLASSCODE, PCI_ERMC_CLASSCODE_MASK) },
+	{ },    /* terminate list */
 };
 MODULE_DEVICE_TABLE(pci, ipmi_pci_devices);
 
diff -uNrp linux-2.6.23-rc6~/drivers/mtd/nand/cafe_nand.c linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c
--- linux-2.6.23-rc6~/drivers/mtd/nand/cafe_nand.c	2007-07-08 16:32:17.000000000 -0700
+++ linux-2.6.23-rc6/drivers/mtd/nand/cafe_nand.c	2007-09-11 23:22:11.000000000 -0700
@@ -816,7 +816,8 @@ static void __devexit cafe_nand_remove(s
 }
 
 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 }
+	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_MEMORY_FLASH << 8, 0xFFFF0 },
+	{ },    /* terminate list */
 };
 
 MODULE_DEVICE_TABLE(pci, cafe_nand_tbl);
diff -urp -x '*.o' linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c
--- linux-2.6.23-rc6~/drivers/media/video/usbvision/usbvision-cards.c	2007-09-11 23:17:19.000000000 -0700
+++ linux-2.6.23-rc6/drivers/media/video/usbvision/usbvision-cards.c	2007-09-12 17:26:46.000000000 -0700
@@ -1081,6 +1081,7 @@ struct usb_device_id usbvision_table [] 
 	{ USB_DEVICE(0x2304, 0x0301), .driver_info=PINNA_LINX_VD_IN_CAB_PAL },
 	{ USB_DEVICE(0x2304, 0x0419), .driver_info=PINNA_PCTV_BUNGEE_PAL_FM },
 	{ USB_DEVICE(0x2400, 0x4200), .driver_info=HPG_WINTV },
+	{ },    /* terminate list */
 };
 
 MODULE_DEVICE_TABLE (usb, usbvision_table);


-- 
Kees Cook
