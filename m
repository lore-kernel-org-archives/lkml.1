Return-Path: <linux-kernel-owner+w=401wt.eu-S1754739AbXL0TCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbXL0TCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 14:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbXL0TBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 14:01:24 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:6105 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbXL0TBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 14:01:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=LWJ0AsxEpwgIS28UEzW9FCMfTEAuFf1VERg4LbmFPquy2anLinkT6UONbfmNC/dE+/asf2QDH206Rv6B75rK4e0PX1Ly+YYqqmteUJt+2rjipiwgYCiKYA9Pp8PbL6Dl8xQU0UN8a7sVfJlRzNv1bgQ/NNdOo2KdCpl9IMUm5qc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org, bzolnier@gmail.com
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 27 Dec 2007 20:12:15 +0100
Message-Id: <20071227191215.1357.35247.sendpatchset@localhost.localdomain>
In-Reply-To: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
References: <20071227191153.1357.63211.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/9] ide: remove BUG_ON() from ide_build_sglist()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_rw_taskfile() has been fixed to check the return value
of ->dma_setup method so this BUG_ON() is no longer needed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |    2 --
 1 file changed, 2 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -186,8 +186,6 @@ int ide_build_sglist(ide_drive_t *drive,
 	ide_hwif_t *hwif = HWIF(drive);
 	struct scatterlist *sg = hwif->sg_table;
 
-	BUG_ON((rq->cmd_type == REQ_TYPE_ATA_TASKFILE) && rq->nr_sectors > 256);
-
 	ide_map_sg(drive, rq);
 
 	if (rq_data_dir(rq) == READ)
