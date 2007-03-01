Return-Path: <linux-kernel-owner+w=401wt.eu-S965346AbXCAQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346AbXCAQev (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXCAQev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:34:51 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:53462 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965334AbXCAQeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:34:50 -0500
Date: Thu, 1 Mar 2007 17:38:57 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] ata_generic: Remove lots of code using the new cable_detect
 method
Message-ID: <20070301173857.665dcb74@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(And correct the cable type to unknown while we are at it)

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/ata_generic.c linux-2.6.21-rc2/drivers/ata/ata_generic.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/ata_generic.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/ata_generic.c	2007-03-01 15:30:11.664304208 +0000
@@ -33,35 +33,6 @@
  */
 
 /**
- *	generic_pre_reset		-	probe begin
- *	@ap: ATA port
- *
- *	Set up cable type and use generic probe init
- */
-
-static int generic_pre_reset(struct ata_port *ap)
-{
-	ap->cbl = ATA_CBL_PATA80;
-	return ata_std_prereset(ap);
-}
-
-
-/**
- *	generic_error_handler - Probe specified port on PATA host controller
- *	@ap: Port to probe
- *	@classes:
- *
- *	LOCKING:
- *	None (inherited from caller).
- */
-
-
-static void generic_error_handler(struct ata_port *ap)
-{
-	ata_bmdma_drive_eh(ap, generic_pre_reset, ata_std_softreset, NULL, ata_std_postreset);
-}
-
-/**
  *	generic_set_mode	-	mode setting
  *	@ap: interface to set up
  *	@unused: returned device on error
@@ -142,8 +113,9 @@
 
 	.freeze		= ata_bmdma_freeze,
 	.thaw		= ata_bmdma_thaw,
-	.error_handler	= generic_error_handler,
+	.error_handler	= ata_bmdma_error_handler,
 	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_unknown,
 
 	.qc_prep 	= ata_qc_prep,
 	.qc_issue	= ata_qc_issue_prot,
