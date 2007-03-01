Return-Path: <linux-kernel-owner+w=401wt.eu-S965447AbXCARXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447AbXCARXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 12:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965449AbXCARXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 12:23:20 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965447AbXCARXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 12:23:19 -0500
Date: Thu, 1 Mar 2007 18:27:26 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_sl82c105: Missing methods, cable
Message-ID: <20070301182726.5b93435d@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Missing freeze, thaw, post_internal methods, also switch to new cable method in passing.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_sl82c105.c linux-2.6.21-rc2/drivers/ata/pata_sl82c105.c
--- linux.vanilla-2.6.21-rc2/drivers/ata/pata_sl82c105.c	2007-03-01 13:36:03.000000000 +0000
+++ linux-2.6.21-rc2/drivers/ata/pata_sl82c105.c	2007-03-01 15:14:28.670661032 +0000
@@ -58,7 +58,6 @@
 
 	if (ap->port_no && !pci_test_config_bits(pdev, &sl82c105_enable_bits[ap->port_no]))
 		return -ENOENT;
-	ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
@@ -234,7 +233,11 @@
 	.exec_command	= ata_exec_command,
 	.dev_select 	= ata_std_dev_select,
 
+	.freeze		= ata_bmdma_freeze,
+	.thaw		= ata_bmdma_thaw,
 	.error_handler	= sl82c105_error_handler,
+	.post_internal_cmd = ata_bmdma_post_internal_cmd,
+	.cable_detect	= ata_cable_40wire,
 
 	.bmdma_setup 	= ata_bmdma_setup,
 	.bmdma_start 	= sl82c105_bmdma_start,
