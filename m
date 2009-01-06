Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbZAFSg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbZAFSg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754987AbZAFSfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:35:31 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63672 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZAFSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:35:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=iftaL465Q01bJYNhN5FM31Q/5zPuEkGPD4IoKWXi3xR6nJZiI7HHkIQ+3TAM3sXTPk
         yhngwuvuluBjQ+XkwONnayk3PDVSBH048m+W5IMctBdPpZhklM4I3rZuemmnqOMdWtIr
         y7yiC7tVbjM1UAARmCANQ0rZGZ3hohHRZOgJ0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:36:09 +0100
Message-Id: <20090106183609.21193.78752.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 8/9] ide: move ->lock and ->timer init from init_irq() to ide_init_port_data()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move ->lock and ->timer init from init_irq() to ide_init_port_data()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -939,11 +939,6 @@ static int init_irq (ide_hwif_t *hwif)
 	int sa = 0;
 
 	mutex_lock(&ide_cfg_mtx);
-	spin_lock_init(&hwif->lock);
-
-	init_timer(&hwif->timer);
-	hwif->timer.function = &ide_timer_expiry;
-	hwif->timer.data = (unsigned long)hwif;
 
 #if defined(__mc68000__)
 	sa = IRQF_SHARED;
@@ -1299,6 +1294,12 @@ static void ide_init_port_data(ide_hwif_
 	hwif->name[2]	= 'e';
 	hwif->name[3]	= '0' + index;
 
+	spin_lock_init(&hwif->lock);
+
+	init_timer(&hwif->timer);
+	hwif->timer.function = &ide_timer_expiry;
+	hwif->timer.data = (unsigned long)hwif;
+
 	init_completion(&hwif->gendev_rel_comp);
 
 	hwif->tp_ops = &default_tp_ops;
