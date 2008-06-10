Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYFJUvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYFJUvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757297AbYFJUuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:07 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:29680 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754416AbYFJUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=PmgzHsLcYQyup+Ih0YUOP8wOZlKoEpN05iCTATAsRGqSRnuKLLv609k4OYCpv1dX0r
         1L2oJYKGIR5vzKmuNvI06GHi3vmBmJGaWyg/dNSKCtvEwlh5dbhvFmipct+rFXj8I2sv
         K3pa3A23HId/haJUXZoPxPi38gcu6vklae7h0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:51:40 +0200
Message-Id: <20080610205140.18469.72633.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 05/14] ide-h8300: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/h8300/ide-h8300.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ide/h8300/ide-h8300.c
===================================================================
--- a/drivers/ide/h8300/ide-h8300.c
+++ b/drivers/ide/h8300/ide-h8300.c
@@ -176,6 +176,10 @@ static inline void hwif_setup(ide_hwif_t
 	hwif->output_data = h8300_output_data;
 }
 
+static const struct ide_port_info h8300_port_info = {
+	.host_flags		= IDE_HFLAG_NO_IO_32BIT | IDE_HFLAG_NO_DMA,
+};
+
 static int __init h8300_ide_init(void)
 {
 	hw_regs_t hw;
@@ -201,12 +205,11 @@ static int __init h8300_ide_init(void)
 	index = hwif->index;
 	ide_init_port_hw(hwif, &hw);
 	hwif_setup(hwif);
-	hwif->host_flags = IDE_HFLAG_NO_IO_32BIT;
 	printk(KERN_INFO "ide%d: H8/300 generic IDE interface\n", index);
 
 	idx[0] = index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &h8300_port_info);
 
 	return 0;
 
