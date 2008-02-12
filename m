Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbYBLOh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbYBLOh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761871AbYBLOhN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:37:13 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:44104 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761717AbYBLOhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:37:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent:from;
        b=rrfW/XpwsFtzGGGa2moxuiIVQL4lDwl1Psrr6rXzF+7+PlAnpWeLvCmqfiAnasmQzJMgFmQB2hOCOoiYFka6b9aFATFTrF7IYKM33oBDFIPvPARxJA+ajj0fpCgNdJy38SERZDFKeDqaF3vPF4G26jkuBiNuAZdrwYRBeUDT3lA=
Date: Tue, 12 Feb 2008 15:36:35 +0100
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH] ide-floppy: rename end_request handler properly
Message-ID: <20080212143635.GA4530@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 48f9b88d491aa478ffcf21e2f523e3665db0770b
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Tue Feb 12 09:42:19 2008 +0100

    ide-floppy: rename end_request handler properly
    
    mv idefloppy_do_end_request -> idefloppy_end_request as is the case with ide-cd
    
    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 7e62dfc..bf1ef60 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -213,7 +213,7 @@ static void ide_floppy_put(struct ide_floppy_obj *floppy)
  * Used to finish servicing a request. For read/write requests, we will call
  * ide_end_request to pass to the next buffer.
  */
-static int idefloppy_do_end_request(ide_drive_t *drive, int uptodate, int nsecs)
+static int idefloppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
@@ -270,7 +270,7 @@ static void ide_floppy_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
 		done += count;
 	}
 
-	idefloppy_do_end_request(drive, 1, done >> 9);
+	idefloppy_end_request(drive, 1, done >> 9);
 
 	if (bcount) {
 		printk(KERN_ERR "%s: leftover data in %s, bcount == %d\n",
@@ -289,7 +289,7 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
 	struct bio *bio = rq->bio;
 
 	while ((bio = rq->bio) != NULL)
-		idefloppy_do_end_request(drive, 1, 0);
+		idefloppy_end_request(drive, 1, 0);
 }
 
 /*
@@ -355,11 +355,11 @@ static void idefloppy_request_sense_callback(ide_drive_t *drive)
 					floppy->ascq);
 
 
-		idefloppy_do_end_request(drive, 1, 0);
+		idefloppy_end_request(drive, 1, 0);
 	} else {
 		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
 				" request!\n");
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 	}
 }
 
@@ -370,7 +370,7 @@ static void idefloppy_pc_callback(ide_drive_t *drive)
 
 	debug_log("Reached %s\n", __func__);
 
-	idefloppy_do_end_request(drive, floppy->pc->error ? 0 : 1, 0);
+	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
 }
 
 static void idefloppy_init_pc(struct ide_atapi_pc *pc)
@@ -715,7 +715,7 @@ static void idefloppy_rw_callback(ide_drive_t *drive)
 {
 	debug_log("Reached %s\n", __func__);
 
-	idefloppy_do_end_request(drive, 1, 0);
+	idefloppy_end_request(drive, 1, 0);
 	return;
 }
 
@@ -863,7 +863,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		else
 			printk(KERN_ERR "ide-floppy: %s: I/O error\n",
 				drive->name);
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 	if (blk_fs_request(rq)) {
@@ -871,7 +871,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 		    (rq->nr_sectors % floppy->bs_factor)) {
 			printk(KERN_ERR "%s: unsupported r/w request size\n",
 					drive->name);
-			idefloppy_do_end_request(drive, 0, 0);
+			idefloppy_end_request(drive, 0, 0);
 			return ide_stopped;
 		}
 		pc = idefloppy_next_pc_storage(drive);
@@ -884,7 +884,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
 	} else {
 		blk_dump_rq_flags(rq,
 			"ide-floppy: unsupported command in queue");
-		idefloppy_do_end_request(drive, 0, 0);
+		idefloppy_end_request(drive, 0, 0);
 		return ide_stopped;
 	}
 
@@ -1359,7 +1359,7 @@ static ide_driver_t idefloppy_driver = {
 	.media			= ide_floppy,
 	.supports_dsc_overlap	= 0,
 	.do_request		= idefloppy_do_request,
-	.end_request		= idefloppy_do_end_request,
+	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
 	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
-- 
Regards/Gruﬂ,
    Boris.
