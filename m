Return-Path: <linux-kernel-owner+w=401wt.eu-S965397AbXCARAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965397AbXCARAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXCARAV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:00:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50168 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965061AbXCARAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:00:20 -0500
Date: Thu, 1 Mar 2007 18:03:24 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_hpt3x3: clean up by using cable method
Message-ID: <20070301180324.72065df3@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_hpt3x3.c linux-2.6.21-rc2/drivers/ata/pata_hpt3x3.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_hpt3x3.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_hpt3x3.c	2007-03-01 15:37:02.236887688 +0000
@@ -25,25 +25,6 @@
 #define DRV_NAME	"pata_hpt3x3"
 #define DRV_VERSION	"0.4.2"
 
-static int hpt3x3_probe_init(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA40;
-	return ata_std_prereset(ap);
-}
-
-/**
- *	hpt3x3_probe_reset	-	reset the hpt3x3 bus
- *	@ap: ATA port to reset
- *
- *	Perform the housekeeping when doing an ATA bus reeset. We just
- *	need to force the cable type.
- */
-
-static void hpt3x3_error_handler(struct ata_port *ap)
-{
-	return ata_bmdma_drive_eh(ap, hpt3x3_probe_init, ata_std_softreset, NULL, ata_std_postreset);
-}
-
 /**
  *	hpt3x3_set_piomode		-	PIO setup
  *	@ap: ATA interface
@@ -137,8 +118,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= hpt3x3_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= ata_bmdma_start,
