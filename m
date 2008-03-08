Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756AbYCHVVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756AbYCHVVq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYCHVVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:31 -0500
Received: from gv-out-0910.google.com ([216.239.58.185]:48365 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbYCHVVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=gD97JPX6If2edZL1bEXm72h1h4VAk07IkJXy+KRmkE+5vx9JxIVY+PGyb3FwNQr6uZNYKLjQlAac/s1nYo+ti1pfb3mznY15iE20Ri9EG8WyCS/58GQROh3hk9YQceL+4Ypq+UQ6nt3fZjClRu8KIttGnW4fvkt6r/m7Yz/FfS8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/7] ide: don't display "BIOS" settings in ide_setup_dma()
Date: Sat, 8 Mar 2008 22:29:34 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082229.34542.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays BIOS info is not very useful and only confuses users since:

- IDE always tries to use DMA

- BIOS info may not be accurate with modular IDE/libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -840,12 +840,10 @@ static int ide_allocate_dma_engine(ide_h
 
 void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
-	u8 dma_stat;
-
 	if (hwif->mmio)
-		printk(KERN_INFO "    %s: MMIO-DMA ", hwif->name);
+		printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
 	else
-		printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
+		printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx\n",
 				 hwif->name, base, base + 7);
 
 	hwif->extra_base = base + (hwif->channel ? 8 : 16);
@@ -884,11 +882,6 @@ void ide_setup_dma(ide_hwif_t *hwif, uns
 		hwif->dma_timeout = &ide_dma_timeout;
 	if (!hwif->dma_lost_irq)
 		hwif->dma_lost_irq = &ide_dma_lost_irq;
-
-	dma_stat = hwif->INB(hwif->dma_status);
-	printk(KERN_CONT ", BIOS settings: %s:%s, %s:%s\n",
-	       hwif->drives[0].name, (dma_stat & 0x20) ? "DMA" : "PIO",
-	       hwif->drives[1].name, (dma_stat & 0x40) ? "DMA" : "PIO");
 }
 
 EXPORT_SYMBOL_GPL(ide_setup_dma);
