Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYFJUu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYFJUu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYFJUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:49:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:23258 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbYFJUt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:49:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=d3hWuJvhuzTdQ1PvX9D4sOQmEVWgBUm7nyQqoWS1OM6od2pShanMSarI0r75Ra+37l
         OOb0TPEasLjyNEqQtjLHe1p/+lYcztEyO3aeXxzn0k0o/akaHNbFiFth1mQrxAayFb32
         S8MhuRmN4nfMEjeTxMp4i6sTG9eTi7pDs/rXw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:51:29 +0200
Message-Id: <20080610205129.18469.30843.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/14] rapide: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/rapide.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/drivers/ide/arm/rapide.c
===================================================================
--- a/drivers/ide/arm/rapide.c
+++ b/drivers/ide/arm/rapide.c
@@ -11,6 +11,10 @@
 
 #include <asm/ecard.h>
 
+static struct const ide_port_info rapide_port_info = {
+	.host_flags		= IDE_HFLAG_MMIO | IDE_HFLAG_NO_DMA,
+};
+
 static void rapide_setup_ports(hw_regs_t *hw, void __iomem *base,
 			       void __iomem *ctrl, unsigned int sz, int irq)
 {
@@ -53,12 +57,11 @@ rapide_probe(struct expansion_card *ec, 
 
 		ide_init_port_hw(hwif, &hw);
 
-		hwif->host_flags = IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 
 		idx[0] = hwif->index;
 
-		ide_device_add(idx, NULL);
+		ide_device_add(idx, &rapide_port_info);
 
 		ecard_set_drvdata(ec, hwif);
 		goto out;
