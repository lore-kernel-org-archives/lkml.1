Return-Path: <linux-kernel-owner+w=401wt.eu-S1759580AbYBPQ1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbYBPQ1b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 11:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbYBPQZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 11:25:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:28570 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbYBPQZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 11:25:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=VBRLb0etlNX7wemcbqhv7KEQP+fqo5PvRq7xUH7lE86UjshAnzV1mLXbc1x+AXxkNG988hHd9fC53GZL5+ryBm7QIoqiThX50yMHDVrK3A8C7L554yP0Yvm/rNl1EsF+Wy8DZYzrZJOIrU3VWLaqKCopGviCSGU9IvJfewAkqtI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 16 Feb 2008 17:39:46 +0100
Message-Id: <20080216163946.10174.2795.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
References: <20080216163856.10174.72546.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/12] ide: remove needless hwif->irq check from ide_hwif_configure()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_init_default_irq() is always zero for CONFIG_PCI=y so hwif->irq
check in ide_hwif_configure() can be safely removed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -371,7 +371,7 @@ static ide_hwif_t *ide_hwif_configure(st
 		return NULL;	/* no room in ide_hwifs[] */
 
 	memset(&hw, 0, sizeof(hw));
-	hw.irq = hwif->irq ? hwif->irq : irq;
+	hw.irq = irq;
 	hw.dev = &dev->dev;
 	hw.chipset = d->chipset ? d->chipset : ide_pci;
 	ide_std_init_ports(&hw, base, ctl | 2);
