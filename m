Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYFJUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYFJUvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756690AbYFJUuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:17 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:27835 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbYFJUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=lJ4gkG3hJAVt53xlWBsciEFLYH2LgDqjf4YGyT6LS+8S8PmFCmeKv5QkdpUmwaS6zH
         y0nclTX3v6V2bgpN8iXS9WkLmkD74xrt3hHDzvRWSSlJxe0wLmtki/jcY16eD4D3uGmU
         AbIKea6n3RRuQUCcsDA90hwpx3oayuWLJQy6Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:51:49 +0200
Message-Id: <20080610205149.18469.97463.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/14] ide_platform: use struct ide_port_info
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the driver to use struct ide_port_info.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/ide_platform.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/legacy/ide_platform.c
===================================================================
--- a/drivers/ide/legacy/ide_platform.c
+++ b/drivers/ide/legacy/ide_platform.c
@@ -44,6 +44,10 @@ static void __devinit plat_ide_setup_por
 	hw->chipset = ide_generic;
 }
 
+static const struct ide_port_info platform_ide_port_info = {
+	.host_flags		= IDE_HFLAG_NO_DMA,
+};
+
 static int __devinit plat_ide_probe(struct platform_device *pdev)
 {
 	struct resource *res_base, *res_alt, *res_irq;
@@ -54,6 +58,7 @@ static int __devinit plat_ide_probe(stru
 	int ret = 0;
 	int mmio = 0;
 	hw_regs_t hw;
+	struct ide_port_info d = platform_ide_port_info;
 
 	pdata = pdev->dev.platform_data;
 
@@ -102,13 +107,13 @@ static int __devinit plat_ide_probe(stru
 	ide_init_port_hw(hwif, &hw);
 
 	if (mmio) {
-		hwif->host_flags = IDE_HFLAG_MMIO;
+		d.host_flags |= IDE_HFLAG_MMIO;
 		default_hwif_mmiops(hwif);
 	}
 
 	idx[0] = hwif->index;
 
-	ide_device_add(idx, NULL);
+	ide_device_add(idx, &d);
 
 	platform_set_drvdata(pdev, hwif);
 
