Return-Path: <linux-kernel-owner+w=401wt.eu-S1759348AbYBVTrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348AbYBVTrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764096AbYBVTqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:46:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:60714 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763754AbYBVTqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:46:40 -0500
Date: Fri, 22 Feb 2008 20:46:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH] hpt366: fix section mismatch warnings
Message-ID: <20080222194651.GA7154@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hpt366: fix section mismatch warnings

Fix following warnings:
WARNING: o-sparc64/vmlinux.o(.data+0x195a38): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370
WARNING: o-sparc64/vmlinux.o(.data+0x195a40): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt370a
WARNING: o-sparc64/vmlinux.o(.data+0x195a48): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372
WARNING: o-sparc64/vmlinux.o(.data+0x195a50): Section mismatch in reference from the variable hpt37x_info.0 to the variable .devinit.data:hpt372n

Replace a static array with a small switch resulting in
more readable code.
Be consistent in use of __devinitconst for const data
to avoid section type conflicts.
Mark the pci table __devinitconst.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
Only build tested but looks obviously correct.
I saw this doing a sparc64 build - dunno whit it did not
surface when I sweeped over an x86 64 bit allyesconfig.

	Sam

diff --git a/drivers/ide/pci/hpt366.c b/drivers/ide/pci/hpt366.c
index d0f7bb8..9911584 100644
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -513,7 +513,7 @@ static struct hpt_timings hpt37x_timings = {
 	}
 };
 
-static const struct hpt_info hpt36x __devinitdata = {
+static const struct hpt_info hpt36x __devinitconst = {
 	.chip_name	= "HPT36x",
 	.chip_type	= HPT36x,
 	.udma_mask	= HPT366_ALLOW_ATA66_3 ? (HPT366_ALLOW_ATA66_4 ? ATA_UDMA4 : ATA_UDMA3) : ATA_UDMA2,
@@ -521,7 +521,7 @@ static const struct hpt_info hpt36x __devinitdata = {
 	.timings	= &hpt36x_timings
 };
 
-static const struct hpt_info hpt370 __devinitdata = {
+static const struct hpt_info hpt370 __devinitconst = {
 	.chip_name	= "HPT370",
 	.chip_type	= HPT370,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -529,7 +529,7 @@ static const struct hpt_info hpt370 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt370a __devinitdata = {
+static const struct hpt_info hpt370a __devinitconst = {
 	.chip_name	= "HPT370A",
 	.chip_type	= HPT370A,
 	.udma_mask	= HPT370_ALLOW_ATA100_5 ? ATA_UDMA5 : ATA_UDMA4,
@@ -537,7 +537,7 @@ static const struct hpt_info hpt370a __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt374 __devinitdata = {
+static const struct hpt_info hpt374 __devinitconst = {
 	.chip_name	= "HPT374",
 	.chip_type	= HPT374,
 	.udma_mask	= ATA_UDMA5,
@@ -545,7 +545,7 @@ static const struct hpt_info hpt374 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372 __devinitdata = {
+static const struct hpt_info hpt372 __devinitconst = {
 	.chip_name	= "HPT372",
 	.chip_type	= HPT372,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -553,7 +553,7 @@ static const struct hpt_info hpt372 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372a __devinitdata = {
+static const struct hpt_info hpt372a __devinitconst = {
 	.chip_name	= "HPT372A",
 	.chip_type	= HPT372A,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -561,7 +561,7 @@ static const struct hpt_info hpt372a __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302 __devinitdata = {
+static const struct hpt_info hpt302 __devinitconst = {
 	.chip_name	= "HPT302",
 	.chip_type	= HPT302,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -569,7 +569,7 @@ static const struct hpt_info hpt302 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371 __devinitdata = {
+static const struct hpt_info hpt371 __devinitconst = {
 	.chip_name	= "HPT371",
 	.chip_type	= HPT371,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -577,7 +577,7 @@ static const struct hpt_info hpt371 __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt372n __devinitdata = {
+static const struct hpt_info hpt372n __devinitconst = {
 	.chip_name	= "HPT372N",
 	.chip_type	= HPT372N,
 	.udma_mask	= HPT372_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -585,7 +585,7 @@ static const struct hpt_info hpt372n __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt302n __devinitdata = {
+static const struct hpt_info hpt302n __devinitconst = {
 	.chip_name	= "HPT302N",
 	.chip_type	= HPT302N,
 	.udma_mask	= HPT302_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -593,7 +593,7 @@ static const struct hpt_info hpt302n __devinitdata = {
 	.timings	= &hpt37x_timings
 };
 
-static const struct hpt_info hpt371n __devinitdata = {
+static const struct hpt_info hpt371n __devinitconst = {
 	.chip_name	= "HPT371N",
 	.chip_type	= HPT371N,
 	.udma_mask	= HPT371_ALLOW_ATA133_6 ? ATA_UDMA6 : ATA_UDMA5,
@@ -1475,7 +1475,7 @@ static int __devinit hpt36x_init(struct pci_dev *dev, struct pci_dev *dev2)
 	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
-static const struct ide_port_info hpt366_chipsets[] __devinitdata = {
+static const struct ide_port_info hpt366_chipsets[] __devinitconst = {
 	{	/* 0 */
 		.name		= "HPT36x",
 		.init_chipset	= init_chipset_hpt366,
@@ -1570,11 +1570,13 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 		if (rev < 3)
 			info = &hpt36x;
 		else {
-			static const struct hpt_info *hpt37x_info[] =
-				{ &hpt370, &hpt370a, &hpt372, &hpt372n };
-
-			info = hpt37x_info[min_t(u8, rev, 6) - 3];
-			idx++;
+			switch (min_t(u8, rev, 6) - 3) {
+			case 0: info = &hpt370;  break;
+			case 1: info = &hpt370a; break;
+			case 2: info = &hpt372;  break;
+			case 3: info = &hpt372n; break;
+			}
+		idx++;
 		}
 		break;
 	case 1:
@@ -1626,7 +1628,7 @@ static int __devinit hpt366_init_one(struct pci_dev *dev, const struct pci_devic
 	return ide_setup_pci_device(dev, &d);
 }
 
-static const struct pci_device_id hpt366_pci_tbl[] = {
+static const struct pci_device_id hpt366_pci_tbl[] __devinitconst = {
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT366),  0 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT372),  1 },
 	{ PCI_VDEVICE(TTI, PCI_DEVICE_ID_TTI_HPT302),  2 },
