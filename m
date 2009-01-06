Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZAFSh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZAFSh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755175AbZAFSfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:35:37 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:63672 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167AbZAFSff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:35:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=NBKI6ZylVbUpD++UH7OFS32MvwCjfSNobKOQfozubaIVGGsZc3OKiQg8/nOAK5uc5o
         0MzZOos44mWxadC8//Hf3QqkzEGG9A7eaOW4BJ577mp9MKm+vYDpuxL/UBgo2QMnZwtQ
         2T6kkLoisMpEIs8B6Cfsxt/Y0FuKGyRScdbH4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:36:18 +0100
Message-Id: <20090106183618.21193.63493.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 9/9] ide: init_irq() doesn't need to hold ide_cfg_mtx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: init_irq() doesn't need to hold ide_cfg_mtx

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 ----
 1 file changed, 4 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -938,8 +938,6 @@ static int init_irq (ide_hwif_t *hwif)
 	struct ide_io_ports *io_ports = &hwif->io_ports;
 	int sa = 0;
 
-	mutex_lock(&ide_cfg_mtx);
-
 #if defined(__mc68000__)
 	sa = IRQF_SHARED;
 #endif /* __mc68000__ */
@@ -965,10 +963,8 @@ static int init_irq (ide_hwif_t *hwif)
 		printk(KERN_CONT " (serialized)");
 	printk(KERN_CONT "\n");
 
-	mutex_unlock(&ide_cfg_mtx);
 	return 0;
 out_up:
-	mutex_unlock(&ide_cfg_mtx);
 	return 1;
 }
 
