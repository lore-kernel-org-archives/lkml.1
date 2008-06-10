Return-Path: <linux-kernel-owner+w=401wt.eu-S1758821AbYFJUw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821AbYFJUw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:52:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbYFJUur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:50:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:24076 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbYFJUup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=AHWGQaoeeqf7r1WOUq/Cnz4cNuFJtGEH91c3SZhJ3pt4xV+CFw5yUjckI+8MAimeqG
         IsXiJHh1EDHRFvGocxzh7iSYlgtO1Kn+uIcQdnm4lN2NCPpMvD13Cbv2Q64spKTYizj+
         cshzAj1n69r7TURR+9eAuelTH61SU5NPQqS6k=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:52:20 +0200
Message-Id: <20080610205220.18469.99649.sendpatchset@localhost.localdomain>
In-Reply-To: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
References: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/14] ide-pnp: print driver banner message early
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print driver banner message early and without interface number.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-pnp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-pnp.c
===================================================================
--- a/drivers/ide/ide-pnp.c
+++ b/drivers/ide/ide-pnp.c
@@ -33,6 +33,8 @@ static int idepnp_probe(struct pnp_dev *
 	ide_hwif_t *hwif;
 	unsigned long base, ctl;
 
+	printk(KERN_INFO DRV_NAME ": generic PnP IDE interface\n");
+
 	if (!(pnp_port_valid(dev, 0) && pnp_port_valid(dev, 1) && pnp_irq_valid(dev, 0)))
 		return -1;
 
@@ -64,7 +66,6 @@ static int idepnp_probe(struct pnp_dev *
 
 		ide_init_port_hw(hwif, &hw);
 
-		printk(KERN_INFO "ide%d: generic PnP IDE interface\n", index);
 		pnp_set_drvdata(dev, hwif);
 
 		ide_device_add(idx, NULL);
