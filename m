Return-Path: <linux-kernel-owner+w=401wt.eu-S1758525AbZAXOVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbZAXOVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 09:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755046AbZAXOVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 09:21:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:61796 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZAXOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 09:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=UAS8PHY3GmUQqi0OaSuz6r/sLDb/8d1rKmTJA+9ZlMHuPr8wkcaXzwNBcG9LpBMU/L
         kELObKeh+zHROJy/CcQOHuQLhIY3YBQzfl1reVJN/gcaOvVtDwtS3hkP6G4Zc3H4uwWt
         4s5f5utrLT6C330C5wU/dInfS/ePTvZ669nkE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5
Date: Sat, 24 Jan 2009 15:14:22 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc2-next-20090123; KDE/4.1.3; i686; ; )
Cc: linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901241514.23036.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] icside: use struct ide_port_info also for PCB version 5

This fixes hwif->channel and drive->dn assignments.

Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -419,6 +419,10 @@ static void icside_setup_ports(hw_regs_t
 	hw->chipset = ide_acorn;
 }
 
+static const struct ide_port_info icside_v5_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit
 icside_register_v5(struct icside_state *state, struct expansion_card *ec)
 {
@@ -445,7 +449,7 @@ icside_register_v5(struct icside_state *
 
 	icside_setup_ports(&hw, base, &icside_cardinfo_v5, ec);
 
-	host = ide_host_alloc(NULL, hws);
+	host = ide_host_alloc(&icside_v5_port_info, hws);
 	if (host == NULL)
 		return -ENODEV;
 
@@ -534,7 +538,7 @@ icside_register_v6(struct icside_state *
 		d.dma_ops = NULL;
 	}
 
-	ret = ide_host_register(host, NULL, hws);
+	ret = ide_host_register(host, &icside_v5_port_info, hws);
 	if (ret)
 		goto err_free;
 
