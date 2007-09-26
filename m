Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbXIZV5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbXIZV5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 17:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbXIZV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 17:57:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57531 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbXIZV47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 17:56:59 -0400
Date: Wed, 26 Sep 2007 23:02:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] pata_atiixp: Audit notes on locking
Message-ID: <20070926230252.45fb49d5@the-village.bc.nu>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.23rc8-mm1/drivers/ata/pata_atiixp.c linux-2.6.23rc8-mm1/drivers/ata/pata_atiixp.c
--- linux.vanilla-2.6.23rc8-mm1/drivers/ata/pata_atiixp.c	2007-09-26 16:46:48.000000000 +0100
+++ linux-2.6.23rc8-mm1/drivers/ata/pata_atiixp.c	2007-09-25 23:59:17.000000000 +0100
@@ -173,6 +173,9 @@
  *
  *	When DMA begins we need to ensure that the UDMA control
  *	register for the channel is correctly set.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void atiixp_bmdma_start(struct ata_queued_cmd *qc)
@@ -199,6 +202,9 @@
  *
  *	DMA has completed. Clear the UDMA flag as the next operations will
  *	be PIO ones not UDMA data transfer.
+ *
+ *	Note: The host lock held by the libata layer protects
+ *	us from two channels both trying to set DMA bits at once
  */
 
 static void atiixp_bmdma_stop(struct ata_queued_cmd *qc)
