Return-Path: <linux-kernel-owner+w=401wt.eu-S1762801AbYBFXCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762801AbYBFXCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757781AbYBFXCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:02:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:34798 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757932AbYBFXCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:02:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uQgE/Gp5r6xlrLO9qM5g5WOBKkR7fiAfCAroDaYPgaBgZdyGK2YvRElfXRKNM0E0zk0lSXPlgRHB8DR5NqdPiNpK5ctzdM7htap03vmxGCV/CqTOaVFEu1E531XfwG8aQoHewls0NTrzNDqiFCCweO0THb2h0B+SbXOwmCyTbCg=
Message-ID: <6101e8c40802061502s4f65fe2eodd85527cbdd4ca9b@mail.gmail.com>
Date: Thu, 7 Feb 2008 00:02:29 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: Re: [2.6.22.y] {03/17} - pci-fix-unterminated-pci_device_id-lists - series for stable kernel #2
In-Reply-To: <6101e8c40802011733g44bc6035v53821f1200f2dde4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <6101e8c40802011733g44bc6035v53821f1200f2dde4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <kees@ubuntu.com>
Date: Wed, 19 Sep 2007 05:46:32 +0000 (-0700)
Subject: pci: fix unterminated pci_device_id lists
Patch-mainline: 2.6.23-rc7
References: 340527
Git-commit: h=248bdd5efca5a113cbf443a993c69e53d370236b

pci: fix unterminated pci_device_id lists

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


On 2/2/08, Oliver Pinter (Pintér Olivér) <oliver.pntr@gmail.com> wrote:
> mainline: 248bdd5efca5a113cbf443a993c69e53d370236b
>
>
> --
> Thanks,
> Oliver
>


-- 
Thanks,
Oliver
