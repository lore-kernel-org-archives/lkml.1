Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbYJOTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbYJOTw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYJOTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 15:50:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:23714 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYJOTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 15:50:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Hv7Yz0nU4wIifTrIGTsUaWtriJaMtJUMfEYfxdPF8viyJXgbM2oBclEQ3C6ljYTAz5
         WvvsXo6cdD7i0M0PEwvn9hO52X77uTNkFqNDuJz7pRA8oZLc2EEpkDawT6s0GlMCi3VT
         uzLZyL8bxqx1g0pOiIWRixlxtKgKE2ouhriMw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-floppy: remove idefloppy_floppy_t typedef
Date: Wed, 15 Oct 2008 21:36:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810152136.48019.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@googlemail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
against pata tree

 drivers/ide/ide-floppy.c       |   18 +++++++++---------
 drivers/ide/ide-floppy.h       |    2 --
 drivers/ide/ide-floppy_ioctl.c |    8 ++++----
 3 files changed, 13 insertions(+), 15 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -70,7 +70,7 @@
  */
 static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct request *rq = HWGROUP(drive)->rq;
 	int error;
 
@@ -117,7 +117,7 @@ static void idefloppy_update_buffers(ide
 
 static void ide_floppy_callback(ide_drive_t *drive, int dsc)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->pc;
 	int uptodate = pc->error ? 0 : 1;
 
@@ -154,7 +154,7 @@ static void ide_floppy_callback(ide_driv
 	ide_floppy_end_request(drive, uptodate, 0);
 }
 
-static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
+static void ide_floppy_report_error(struct ide_disk_obj *floppy,
 				    struct ide_atapi_pc *pc)
 {
 	/* supress error messages resulting from Medium not present */
@@ -173,7 +173,7 @@ static void ide_floppy_report_error(idef
 static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
 		struct ide_atapi_pc *pc)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 
 	if (floppy->failed_pc == NULL &&
 	    pc->c[0] != GPCMD_REQUEST_SENSE)
@@ -237,7 +237,7 @@ static void idefloppy_create_rw_cmd(ide_
 				    struct ide_atapi_pc *pc, struct request *rq,
 				    unsigned long sector)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	int block = sector / floppy->bs_factor;
 	int blocks = rq->nr_sectors / floppy->bs_factor;
 	int cmd = rq_data_dir(rq);
@@ -261,7 +261,7 @@ static void idefloppy_create_rw_cmd(ide_
 	pc->flags |= PC_FLAG_DMA_OK;
 }
 
-static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
+static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
 		struct ide_atapi_pc *pc, struct request *rq)
 {
 	ide_init_pc(pc);
@@ -283,7 +283,7 @@ static void idefloppy_blockpc_cmd(ideflo
 static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
 					     struct request *rq, sector_t block)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 	struct ide_atapi_pc *pc;
 
@@ -344,7 +344,7 @@ static ide_startstop_t ide_floppy_do_req
  */
 static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *page;
@@ -407,7 +407,7 @@ static int ide_floppy_get_flexible_disk_
  */
 static int ide_floppy_get_capacity(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
 	struct ide_atapi_pc pc;
 	u8 *cap_desc;
Index: b/drivers/ide/ide-floppy.h
===================================================================
--- a/drivers/ide/ide-floppy.h
+++ b/drivers/ide/ide-floppy.h
@@ -4,8 +4,6 @@
 #include "ide-gd.h"
 
 #ifdef CONFIG_IDE_GD_ATAPI
-typedef struct ide_disk_obj idefloppy_floppy_t;
-
 /*
  * Pages of the SELECT SENSE / MODE SENSE packet commands.
  * See SFF-8070i spec.
Index: b/drivers/ide/ide-floppy_ioctl.c
===================================================================
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -113,7 +113,7 @@ static void ide_floppy_create_format_uni
 
 static int ide_floppy_get_sfrp_bit(ide_drive_t *drive)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 
 	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
@@ -132,7 +132,7 @@ static int ide_floppy_get_sfrp_bit(ide_d
 
 static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 	int blocks, length, flags, err = 0;
 
@@ -190,7 +190,7 @@ out:
 
 static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct ide_atapi_pc pc;
 	int progress_indication = 0x10000;
 
@@ -226,7 +226,7 @@ static int ide_floppy_get_format_progres
 static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
 			       unsigned long arg, unsigned int cmd)
 {
-	idefloppy_floppy_t *floppy = drive->driver_data;
+	struct ide_disk_obj *floppy = drive->driver_data;
 	struct gendisk *disk = floppy->disk;
 	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
 
