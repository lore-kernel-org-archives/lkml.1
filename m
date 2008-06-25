Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbYFYL3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbYFYL3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYFYL27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:28:59 -0400
Received: from nebensachen.de ([195.34.83.29]:35090 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbYFYL25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:28:57 -0400
X-Hashcash: 1:20:080625:bzolnier@gmail.com::ACFnH4XRgrGaPMK2:000000000000000000000000000000000000000000002lg
X-Hashcash: 1:20:080625:alan@lxorguk.ukuu.org.uk::HD94+ktTn+WxmWVS:00000000000000000000000000000000000004QPK
X-Hashcash: 1:20:080625:linux-ide@vger.kernel.org::V2CTtePLG8zaBN12:00000000000000000000000000000000000093dW
X-Hashcash: 1:20:080625:linux-kernel@vger.kernel.org::mlIeHacN+0Hdp4qc:0000000000000000000000000000000000Ve2
X-Hashcash: 1:20:080625:randy.dunlap@oracle.com::vKNa07cqMupGohHc:000000000000000000000000000000000000002Fr0
From: Elias Oltmanns <eo@nebensachen.de>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: [PATCH 2/4 v2] IDE: Remove unused code
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
	<20080624133218.6bccab75@lxorguk.ukuu.org.uk>
	<58cb370e0806240621g61370f56j660e31790dad89c3@mail.gmail.com>
	<20080624143548.24dcf511@lxorguk.ukuu.org.uk>
	<58cb370e0806240719o4a70537p4a6fb64e9086e2d8@mail.gmail.com>
	<87k5gdn4fq.fsf@denkblock.local>
Date: Wed, 25 Jun 2008 13:28:49 +0200
In-Reply-To: <87k5gdn4fq.fsf@denkblock.local> (Elias Oltmanns's message of
	"Wed, 25 Jun 2008 13:23:53 +0200")
Message-ID: <87abh9n47i.fsf_-_@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some code which has been made obsolete and hasn't worked properly
before anyway.  Part of the infrastructure may be reintroduced in a
follow up patch to implement a working command aborting facility.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---

 drivers/ide/ide-cd.c     |    1 -
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-floppy.c |    1 -
 drivers/ide/ide-io.c     |   49 ----------------------------------------------
 drivers/ide/ide-tape.c   |    1 -
 drivers/scsi/ide-scsi.c  |   14 -------------
 include/linux/ide.h      |    7 -------
 7 files changed, 0 insertions(+), 74 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index b5ec249..26e8972 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1940,7 +1940,6 @@ static ide_driver_t ide_cdrom_driver = {
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idecd_proc,
 #endif
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 5f49a4a..3a2e802 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -985,7 +985,6 @@ static ide_driver_t idedisk_driver = {
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idedisk_proc,
 #endif
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index c7e4433..011d720 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1129,7 +1129,6 @@ static ide_driver_t idefloppy_driver = {
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idefloppy_proc,
 #endif
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2b33c12..661b75a 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -504,55 +504,6 @@ ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
 
 EXPORT_SYMBOL_GPL(ide_error);
 
-ide_startstop_t __ide_abort(ide_drive_t *drive, struct request *rq)
-{
-	if (drive->media != ide_disk)
-		rq->errors |= ERROR_RESET;
-
-	ide_kill_rq(drive, rq);
-
-	return ide_stopped;
-}
-
-EXPORT_SYMBOL_GPL(__ide_abort);
-
-/**
- *	ide_abort	-	abort pending IDE operations
- *	@drive: drive the error occurred on
- *	@msg: message to report
- *
- *	ide_abort kills and cleans up when we are about to do a 
- *	host initiated reset on active commands. Longer term we
- *	want handlers to have sensible abort handling themselves
- *
- *	This differs fundamentally from ide_error because in 
- *	this case the command is doing just fine when we
- *	blow it away.
- */
- 
-ide_startstop_t ide_abort(ide_drive_t *drive, const char *msg)
-{
-	struct request *rq;
-
-	if (drive == NULL || (rq = HWGROUP(drive)->rq) == NULL)
-		return ide_stopped;
-
-	/* retry only "normal" I/O: */
-	if (!blk_fs_request(rq)) {
-		rq->errors = 1;
-		ide_end_drive_cmd(drive, BUSY_STAT, 0);
-		return ide_stopped;
-	}
-
-	if (rq->rq_disk) {
-		ide_driver_t *drv;
-
-		drv = *(ide_driver_t **)rq->rq_disk->private_data;
-		return drv->abort(drive, rq);
-	} else
-		return __ide_abort(drive, rq);
-}
-
 static void ide_tf_set_specify_cmd(ide_drive_t *drive, struct ide_taskfile *tf)
 {
 	tf->nsect   = drive->sect;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2deb23d..353dd11 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2591,7 +2591,6 @@ static ide_driver_t idetape_driver = {
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
-	.abort			= __ide_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idetape_proc,
 #endif
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index 683bce3..f843c13 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -258,19 +258,6 @@ idescsi_atapi_error(ide_drive_t *drive, struct request *rq, u8 stat, u8 err)
 	return ide_stopped;
 }
 
-static ide_startstop_t
-idescsi_atapi_abort(ide_drive_t *drive, struct request *rq)
-{
-	debug_log("%s called for %lu\n", __func__,
-		((struct ide_atapi_pc *) rq->special)->scsi_cmd->serial_number);
-
-	rq->errors |= ERROR_MAX;
-
-	idescsi_end_request(drive, 0, 0);
-
-	return ide_stopped;
-}
-
 static int idescsi_end_request (ide_drive_t *drive, int uptodate, int nrsecs)
 {
 	idescsi_scsi_t *scsi = drive_to_idescsi(drive);
@@ -524,7 +511,6 @@ static ide_driver_t idescsi_driver = {
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
-	.abort                  = idescsi_atapi_abort,
 #ifdef CONFIG_IDE_PROC_FS
 	.proc			= idescsi_proc,
 #endif
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 8fbe838..25f4c65 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -556,8 +556,6 @@ typedef struct hwgroup_s {
 	unsigned int sleeping	: 1;
 		/* BOOL: polling active & poll_timeout field valid */
 	unsigned int polling	: 1;
-	 	/* BOOL: in a polling reset situation. Must not trigger another reset yet */
-	unsigned int resetting  : 1;
 
 		/* current drive */
 	ide_drive_t *drive;
@@ -777,7 +775,6 @@ struct ide_driver_s {
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
-	ide_startstop_t	(*abort)(ide_drive_t *, struct request *rq);
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
@@ -819,10 +816,6 @@ ide_startstop_t __ide_error(ide_drive_t *, struct request *, u8, u8);
 
 ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, byte stat);
 
-ide_startstop_t __ide_abort(ide_drive_t *, struct request *);
-
-extern ide_startstop_t ide_abort(ide_drive_t *, const char *);
-
 extern void ide_fix_driveid(struct hd_driveid *);
 
 extern void ide_fixstring(u8 *, const int, const int);
