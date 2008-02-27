Return-Path: <linux-kernel-owner+w=401wt.eu-S1757285AbYB0SVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbYB0SVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 13:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbYB0SVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 13:21:15 -0500
Received: from ik-out-1112.google.com ([66.249.90.177]:49410 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbYB0SVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 13:21:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Cp3PyFfJYUk7mc8w5kONRqXEgGmeV/UxU7mPVC9ilWJloo6g3Fmp6Tgff2oeWj00eUvaZJtakyg3ZvvMJKyuyhynjiHOIXtuKGnRweWnQl4tLWQw8XwDz3hxHAhY0vYR7sUXQL06DWo0IwswzVjPfVgpYQhoj/wsr3HUTDMrAfg=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 5/5] ide-cd: fix remaining checkpatch.pl issues
Date: Wed, 27 Feb 2008 19:20:49 +0100
Message-Id: <1204136449-9490-6-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of them are:
WARNING: braces {} are not necessary for single statement blocks
CHECK: multiple assignments should be avoided
WARNING: printk() should include KERN_ facility level
WARNING: no space between function name and open parenthesis '('

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   46 ++++++++++++++++++++++------------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 84415cd..30cf097 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -136,8 +136,7 @@ static int cdrom_log_sense(ide_drive_t *drive, struct request *rq,
 	return log;
 }
 
-static
-void cdrom_analyze_sense_data(ide_drive_t *drive,
+static void cdrom_analyze_sense_data(ide_drive_t *drive,
 			      struct request *failed_command,
 			      struct request_sense *sense)
 {
@@ -186,9 +185,9 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
 			if (valid < 0)
 				valid = 0;
 			if (sector < get_capacity(info->disk) &&
-				drive->probed_capacity - sector < 4 * 75) {
+				drive->probed_capacity - sector < 4 * 75)
+
 				set_capacity(info->disk, sector);
-			}
 		}
 	}
 
@@ -219,7 +218,8 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
 
 	rq->data = sense;
 	rq->cmd[0] = GPCMD_REQUEST_SENSE;
-	rq->cmd[4] = rq->data_len = 18;
+	rq->cmd[4]   = 18;
+	rq->data_len = 18;
 
 	rq->cmd_type = REQ_TYPE_SENSE;
 
@@ -310,7 +310,8 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 	sense_key = err >> 4;
 
 	if (rq == NULL) {
-		printk("%s: missing rq in cdrom_decode_status\n", drive->name);
+		printk(KERN_ERR "%s: missing rq in cdrom_decode_status\n",
+			drive->name);
 		return 1;
 	}
 
@@ -379,7 +380,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 				cdrom_saw_media_change(drive);
 
 				/* fail the request. */
-				printk("%s: tray open\n", drive->name);
+				printk(KERN_ERR "%s: tray open\n", drive->name);
 				do_end_request = 1;
 			} else {
 				struct cdrom_info *info = drive->driver_data;
@@ -411,7 +412,7 @@ static int cdrom_decode_status(ide_drive_t *drive, int good_stat, int *stat_ret)
 			}
 		} else if (sense_key == UNIT_ATTENTION) {
 			/* media change. */
-			cdrom_saw_media_change (drive);
+			cdrom_saw_media_change(drive);
 
 			/*
 			 * Arrange to retry the request but be sure to give up
@@ -780,11 +781,10 @@ static ide_startstop_t cdrom_seek_intr(ide_drive_t *drive)
 
 	info->cd_flags |= IDE_CD_FLAG_SEEKING;
 
-	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER)) {
-		if (--retry == 0) {
-				drive->dsc_overlap = 0;
-		}
-	}
+	if (retry && time_after(jiffies, info->start_seek + IDECD_SEEK_TIMER))
+		if (--retry == 0)
+			drive->dsc_overlap = 0;
+
 	return ide_stopped;
 }
 
@@ -1216,8 +1216,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
 /*
  * cdrom driver request routine.
  */
-static ide_startstop_t
-ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
+static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
+					sector_t block)
 {
 	ide_startstop_t action;
 	struct cdrom_info *info = drive->driver_data;
@@ -1275,8 +1275,7 @@ ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq, sector_t block)
  * subsequent request sense command. The pointer can also be NULL, in which case
  * no sense information is returned.
  */
-static
-void msf_from_bcd(struct atapi_msf *msf)
+static void msf_from_bcd(struct atapi_msf *msf)
 {
 	msf->minute = BCD2BIN(msf->minute);
 	msf->second = BCD2BIN(msf->second);
@@ -1491,7 +1490,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 
 		toc->last_session_lba = be32_to_cpu(ms_tmp.ent.addr.lba);
 	} else {
-		ms_tmp.hdr.first_track = ms_tmp.hdr.last_track = CDROM_LEADOUT;
+		ms_tmp.hdr.last_track = CDROM_LEADOUT;
+		ms_tmp.hdr.first_track = ms_tmp.hdr.last_track;
 		toc->last_session_lba = msf_to_lba(0, 2, 0); /* 0m 2s 0f */
 	}
 
@@ -1605,8 +1605,7 @@ static int ide_cdrom_register(ide_drive_t *drive, int nslots)
 	return register_cdrom(devinfo);
 }
 
-static
-int ide_cdrom_probe_capabilities(ide_drive_t *drive)
+static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
@@ -1796,8 +1795,8 @@ static sector_t ide_cdrom_capacity(ide_drive_t *drive)
 	return capacity * sectors_per_frame;
 }
 
-static int proc_idecd_read_capacity
-	(char *page, char **start, off_t off, int count, int *eof, void *data)
+static int proc_idecd_read_capacity(char *page, char **start, off_t off,
+					int count, int *eof, void *data)
 {
 	ide_drive_t *drive = data;
 	int len;
@@ -1877,8 +1876,7 @@ static unsigned int ide_cd_flags(struct hd_driveid *id)
 	return 0;
 }
 
-static
-int ide_cdrom_setup(ide_drive_t *drive)
+static int ide_cdrom_setup(ide_drive_t *drive)
 {
 	struct cdrom_info *cd = drive->driver_data;
 	struct cdrom_device_info *cdi = &cd->devinfo;
-- 
1.5.4.1

