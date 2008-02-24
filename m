Return-Path: <linux-kernel-owner+w=401wt.eu-S1760481AbYBXVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481AbYBXVLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760101AbYBXVLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:11:21 -0500
Received: from fk-out-0910.google.com ([209.85.128.187]:15460 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760022AbYBXVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:11:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=KWLPZRwsLnwHmdWa5UPaNnUBgP6LQYSHas/h6spY1jpreXlhXPZqlIVa72XCw0HLVU9ZwDLn6mfxCPqeeDpBgM4OScDbOv/imV+myrwSNPZrVN6Dn9BceeBlPyml7Oc5O3nBjKf3GqFjbycwmOXztxfYb32H1pG27TKCX5lv2j8=
Date: Sun, 24 Feb 2008 22:11:13 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: [PATCH 2/3] IDE: Replace __FUNCTION__ with __func__
Message-ID: <20080224221113.5ddfe371@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applies on top of the previous patch.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 drivers/ide/ide-cd.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 3181e71..76317ab 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -650,7 +650,7 @@ int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
 
 		/* Whoops... */
 		printk(KERN_ERR "%s: %s: wrong transfer direction!\n",
-				drive->name, __FUNCTION__);
+				drive->name, __func__);
 
 		xf = rw ? hwif->atapi_output_bytes : hwif->atapi_input_bytes;
 		ide_cd_pad_transfer(drive, xf, len);
@@ -663,7 +663,7 @@ int ide_cd_check_ireason(ide_drive_t *drive, int len, int ireason, int rw)
 	} else {
 		/* Drive wants a command packet, or invalid ireason... */
 		printk(KERN_ERR "%s: %s: bad interrupt reason 0x%02x\n",
-				drive->name, __FUNCTION__, ireason);
+				drive->name, __func__, ireason);
 	}
 
 	cdrom_end_request(drive, 0);
@@ -682,7 +682,7 @@ static int ide_cd_check_transfer_size(ide_drive_t *drive, int len)
 		return 0;
 
 	printk(KERN_ERR "%s: %s: Bad transfer size %d\n",
-			drive->name, __FUNCTION__, len);
+			drive->name, __func__, len);
 
 	if (cd->cd_flags & IDE_CD_FLAG_LIMIT_NFRAMES)
 		printk(KERN_ERR "  This drive is not supported by "
@@ -727,7 +727,7 @@ static ide_startstop_t cdrom_start_rw_cont(ide_drive_t *drive)
 			if (rq->current_nr_sectors !=
 			    bio_cur_sectors(rq->bio)) {
 				printk(KERN_ERR "%s: %s: buffer botch (%u)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				cdrom_end_request(drive, 0);
 				return ide_stopped;
@@ -961,7 +961,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 			if (rq->current_nr_sectors > 0) {
 				printk(KERN_ERR "%s: %s: data underrun "
 						"(%d blocks)\n",
-						drive->name, __FUNCTION__,
+						drive->name, __func__,
 						rq->current_nr_sectors);
 				if (!write)
 					rq->cmd_flags |= REQ_FAILED;
@@ -1018,7 +1018,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
 		printk(KERN_ERR "%s: %s: The drive "
 				"appears confused (ireason = 0x%02x). "
 				"Trying to recover by ending request.\n",
-				drive->name, __FUNCTION__, ireason);
+				drive->name, __func__, ireason);
 		goto end_request;
 	}
 
@@ -1936,7 +1936,7 @@ static void ide_cd_release(struct kref *kref)
 	kfree(info->toc);
 	if (devinfo->handle == drive && unregister_cdrom(devinfo))
 		printk(KERN_ERR "%s: %s failed to unregister device from the cdrom "
-				"driver.\n", __FUNCTION__, drive->name);
+				"driver.\n", __func__, drive->name);
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
 	blk_queue_prep_rq(drive->queue, NULL);
-- 
1.5.4.2.316.gf7a7

