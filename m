Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZBARua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZBARua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbZBARsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:48:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:43113 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbZBARsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:48:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=tViRGjxT94FHymLfEhbzwaEYxoQgNCWniC+jK4w6vg2EqVenLNoLUF5lMuwfgoePTS
         ZuMN+ao5VfSu1eypPFH2HfMKsORnEr927tHZna6rZmhNPob2L8Zjk/7N0LB7Q7KjInTR
         9iEPEi44adGXT6Ri7D5rhfHJiNFTkj/uxIkg8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:49:37 +0100
Message-Id: <20090201174937.19144.31260.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/15] ide: fix error message in pre_task_out_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix error message in pre_task_out_intr()

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -419,12 +419,14 @@ static ide_startstop_t task_out_intr (id
 
 static ide_startstop_t pre_task_out_intr(ide_drive_t *drive, struct request *rq)
 {
+	ide_hwif_t *hwif = drive->hwif;
 	ide_startstop_t startstop;
 
 	if (ide_wait_stat(&startstop, drive, ATA_DRQ,
 			  drive->bad_wstat, WAIT_DRQ)) {
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
-			drive->name, drive->hwif->data_phase ? "MULT" : "",
+			drive->name,
+			hwif->data_phase == TASKFILE_MULTI_OUT ? "MULT" : "",
 			(drive->dev_flags & IDE_DFLAG_LBA48) ? "_EXT" : "");
 		return startstop;
 	}
