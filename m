Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbXGCOF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbXGCOF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXGCOFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:05:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58832 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753669AbXGCOFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:05:20 -0400
Date: Tue, 3 Jul 2007 15:11:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: Check the right register for the DMA enabled flags
Message-ID: <20070703151130.513fe2df@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mirrors change in IT821X

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/ata_generic.c	2007-07-02 21:02:10.000000000 +0100
@@ -50,7 +50,7 @@
 
 	/* Bits 5 and 6 indicate if DMA is active on master/slave */
 	if (ap->ioaddr.bmdma_addr)
-		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_CMD);
+		dma_enabled = ioread8(ap->ioaddr.bmdma_addr + ATA_DMA_STATUS);
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++) {
 		struct ata_device *dev = &ap->device[i];
