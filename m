Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbXETMkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbXETMkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 08:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbXETMk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 08:40:29 -0400
Received: from vsmtp12.tin.it ([212.216.176.206]:33702 "EHLO vsmtp12.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbXETMk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 08:40:29 -0400
Date: Sun, 20 May 2007 14:40:23 +0200 (CEST)
From: l.genoni@oltrelinux.com
X-X-Sender: venom@Phoenix.oltrelinux.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, htejun@gmail.com
cc: l.genoni@oltrelinux.com, linux-kernel@vger.kernel.org
Subject: something strange in libata-core.c for kernel 2.6.22-rc3
In-Reply-To: <20070418162525.423b2e7e@the-village.bc.nu>
Message-ID: <Pine.LNX.4.64.0705201434380.30264@Phoenix.oltrelinux.com>
References: <Pine.LNX.4.64.0704181704270.1663@Phoenix.oltrelinux.com>
 <20070418162525.423b2e7e@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Mybe I am wrong, but if you are detecting 40-wire cable to set them to 
DMA/33, why the check includes also 80-wire cables configuring them to 
DMA/33 too?

With this patch my nvidia4 IDE controllers detects correctly and configure 
correctly DMA/100 for my HD and DMA/33 for my DVD (the first uses a 
80-wire cable, the second a 40-wire cable).

Am I wrong somewhere?

--- libata-core.c.orig  2007-05-20 14:31:25.000000000 +0200
+++ libata-core.c       2007-05-20 14:34:01.000000000 +0200
@@ -3901,8 +3901,7 @@
                 /* UDMA/44 or higher would be available */
                 if((ap->cbl == ATA_CBL_PATA40) ||
                     (ata_drive_40wire(dev->id) &&
-                    (ap->cbl == ATA_CBL_PATA_UNK ||
-                     ap->cbl == ATA_CBL_PATA80))) {
+                    (ap->cbl == ATA_CBL_PATA_UNK))) {
                         ata_dev_printk(dev, KERN_WARNING,
                                  "limited to UDMA/33 due to 40-wire cable\n");
                         xfer_mask &= ~(0xF8 << ATA_SHIFT_UDMA);

regards

Luigi
