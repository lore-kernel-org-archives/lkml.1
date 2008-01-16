Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbYAPXS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbYAPXS6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbYAPXPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:15:07 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:10937 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbYAPXPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:15:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=G8uU2a80k1dq9tt73AJsHv382yJaaR/cDu3zpSm/bmJyPdO7W3BjWnn0UqLhauna7S6RKXeO6849O4jWFYtQP0lUCIZUK1qtbByEAHPb9zd+6BmshQje8D35sJFq2MDOlmNzG4f0b/XO60y5H5/I4Kpw9cozyXW5P8HDWZH0bUM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2008 00:27:43 +0100
Message-Id: <20080116232743.9166.66740.sendpatchset@localhost.localdomain>
In-Reply-To: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
References: <20080116232556.9166.13457.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/22] ide: move hwif->rqsize init from ide_init_queue() to init_irq()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move hwif->rqsize init from ide_init_queue() to init_irq().

There should be no functionality changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -881,13 +881,6 @@ static int ide_init_queue(ide_drive_t *d
 	q->queuedata = drive;
 	blk_queue_segment_boundary(q, 0xffff);
 
-	if (!hwif->rqsize) {
-		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
-		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
-			hwif->rqsize = 256;
-		else
-			hwif->rqsize = 65536;
-	}
 	if (hwif->rqsize < max_sectors)
 		max_sectors = hwif->rqsize;
 	blk_queue_max_sectors(q, max_sectors);
@@ -1019,6 +1012,14 @@ static int init_irq (ide_hwif_t *hwif)
 	       		goto out_unlink;
 	}
 
+	if (!hwif->rqsize) {
+		if ((hwif->host_flags & IDE_HFLAG_NO_LBA48) ||
+		    (hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA))
+			hwif->rqsize = 256;
+		else
+			hwif->rqsize = 65536;
+	}
+
 	/*
 	 * For any present drive:
 	 * - allocate the block device queue
