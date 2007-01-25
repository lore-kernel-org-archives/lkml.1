Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbXAYO6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbXAYO6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 09:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXAYO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 09:58:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45668 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965351AbXAYO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 09:58:13 -0500
Date: Thu, 25 Jan 2007 15:09:05 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
 controllers
Message-ID: <20070125150905.652f9ce2@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes bogus accesses to ports 0-15 with a non DMA capable controller.
This I think should go in for 2.6.20

Arguably it shouldn't be called for PIO commands at all but thats a
matter for Jeff to decide 

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c
--- linux.vanilla-2.6.20-rc4-mm1/drivers/ata/libata-sff.c	2007-01-22 16:26:50.000000000 +0000
+++ linux-2.6.20-rc4-mm1/drivers/ata/libata-sff.c	2007-01-24 17:31:40.000000000 +0000
@@ -827,7 +827,8 @@
  */
 void ata_bmdma_post_internal_cmd(struct ata_queued_cmd *qc)
 {
-	ata_bmdma_stop(qc);
+	if (qc->ap->ioaddr.bmdma_addr)
+		ata_bmdma_stop(qc);
 }
 
 #ifdef CONFIG_PCI
