Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbYGFRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbYGFRjw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758628AbYGFRfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059AbYGFRe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=HZToswZEESipyCMUCQxumMLsQ0z0sHHyIOrgagZsbwHAnhneqrr+enrOdeKIibafg8
         /CjbBRBAjnS/EhexmyQ5r0lW0qyGX+Os0sBrqQqa6cxwGItLV5o+WjwGIWgN5TqNxjkZ
         WIFtk9RiCdwGvWnKtMfl0DlXcNht8kjRaTmLI=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:25 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/50] amd74xx: cleanup ->init_chipset method
Content-Disposition: inline; filename=amd74xx-cleanup-init_chipset-method.patch
Message-ID: <4871023f.1ade660a.3458.628b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move amd_clock setup from init_chipset_amd74xx() to amd74xx_probe().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/amd74xx.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -173,24 +173,6 @@ static unsigned int __devinit init_chips
 		t |= 0xf0;
 	pci_write_config_byte(dev, AMD_IDE_CONFIG + offset, t);
 
-/*
- * Determine the system bus clock.
- */
-
-	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
-
-	switch (amd_clock) {
-		case 33000: amd_clock = 33333; break;
-		case 37000: amd_clock = 37500; break;
-		case 41000: amd_clock = 41666; break;
-	}
-
-	if (amd_clock < 20000 || amd_clock > 50000) {
-		printk(KERN_WARNING "%s: User given PCI clock speed impossible (%d), using 33 MHz instead.\n",
-				    name, amd_clock);
-		amd_clock = 33333;
-	}
-
 	return dev->irq;
 }
 
@@ -302,6 +284,24 @@ static int __devinit amd74xx_probe(struc
 			 d.name, pci_name(dev), dev->revision,
 			 amd_dma[fls(d.udma_mask) - 1]);
 
+	/*
+	* Determine the system bus clock.
+	*/
+	amd_clock = (ide_pci_clk ? ide_pci_clk : 33) * 1000;
+
+	switch (amd_clock) {
+	case 33000: amd_clock = 33333; break;
+	case 37000: amd_clock = 37500; break;
+	case 41000: amd_clock = 41666; break;
+	}
+
+	if (amd_clock < 20000 || amd_clock > 50000) {
+		printk(KERN_WARNING "%s: User given PCI clock speed impossible"
+				    " (%d), using 33 MHz instead.\n",
+				    d.name, amd_clock);
+		amd_clock = 33333;
+	}
+
 	return ide_pci_init_one(dev, &d, NULL);
 }
 

-- 

