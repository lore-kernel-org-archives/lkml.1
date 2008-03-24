Return-Path: <linux-kernel-owner+w=401wt.eu-S1762250AbYCXSie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762250AbYCXSie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759467AbYCXSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:38:22 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:36760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759111AbYCXSiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:38:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:cc:date:message-id:subject;
        b=ZfjlyWL35VLo30qg+tHKFq79GNHHinR++2oREzs+W2cRZtly/Vi6CaeeC6QrcYvFN9Ny2560FHgvX+Puj4p1GLjqMYbugiVmJ4OJ+u+usSPJ/f0VnyRyiMmmOpWd/E43upJ6tghsNjoimdkDxokafqs0VXKmNqFMGEnDhjNuQsg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 24 Mar 2008 19:53:24 +0100
Message-Id: <20080324185324.15320.23248.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/5] mpc8xx-ide: use ide_find_port()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/mpc8xx.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ppc/mpc8xx.c
===================================================================
--- a/drivers/ide/ppc/mpc8xx.c
+++ b/drivers/ide/ppc/mpc8xx.c
@@ -811,24 +811,28 @@ static int __init mpc8xx_ide_probe(void)
 #ifdef IDE0_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
 	if (!m8xx_ide_init_ports(&hw, 0)) {
-		ide_hwif_t *hwif = &ide_hwifs[0];
+		ide_hwif_t *hwif = ide_find_port();
 
-		ide_init_port_hw(hwif, &hw);
-		hwif->pio_mask = ATA_PIO4;
-		hwif->port_ops = &m8xx_port_ops;
+		if (hwif) {
+			ide_init_port_hw(hwif, &hw);
+			hwif->pio_mask = ATA_PIO4;
+			hwif->port_ops = &m8xx_port_ops;
 
-		idx[0] = 0;
+			idx[0] = hwif->index;
+		}
 	}
 #ifdef IDE1_BASE_OFFSET
 	memset(&hw, 0, sizeof(hw));
 	if (!m8xx_ide_init_ports(&hw, 1)) {
-		ide_hwif_t *mate = &ide_hwifs[1];
+		ide_hwif_t *mate = ide_find_port();
 
-		ide_init_port_hw(mate, &hw);
-		mate->pio_mask = ATA_PIO4;
-		mate->port_ops = &m8xx_port_ops;
+		if (mate) {
+			ide_init_port_hw(mate, &hw);
+			mate->pio_mask = ATA_PIO4;
+			mate->port_ops = &m8xx_port_ops;
 
-		idx[1] = 1;
+			idx[1] = mate->index;
+		}
 	}
 #endif
 #endif
