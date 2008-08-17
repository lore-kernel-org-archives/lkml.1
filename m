Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbYHQRTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbYHQRTZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 13:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824AbYHQRSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 13:18:05 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:31116 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYHQRSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 13:18:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Lsry1ZMplSrprOscHbGtN381XghEIOqR/imieNhD8xfk15T2T/9+SIczIRZseT6Hwk
         K2y+ppSVwkcwQOb9SsM3u0UYjUwelKKVwVWx4UkIb1L5rFqUVqATQ0+15uklA8RuGA0f
         fXSYKZsHatydOdWabBUkUEWILKKy68dPF/JF4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 17 Aug 2008 19:15:36 +0200
Message-Id: <20080817171536.27943.15794.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
References: <20080817171454.27943.37234.sendpatchset@localhost.localdomain>
Subject: [PATCH 7/9] ide: remove superfluous ->media field from ide_driver_t
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    1 -
 drivers/ide/ide-disk.c   |    1 -
 drivers/ide/ide-floppy.c |    1 -
 drivers/ide/ide-tape.c   |    1 -
 drivers/scsi/ide-scsi.c  |    1 -
 include/linux/ide.h      |    1 -
 6 files changed, 6 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1967,7 +1967,6 @@ static ide_driver_t ide_cdrom_driver = {
 	.probe			= ide_cd_probe,
 	.remove			= ide_cd_remove,
 	.version		= IDECD_VERSION,
-	.media			= ide_cdrom,
 	.do_request		= ide_cd_do_request,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -932,7 +932,6 @@ static ide_driver_t idedisk_driver = {
 	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
-	.media			= ide_disk,
 	.do_request		= ide_do_rw_disk,
 	.end_request		= ide_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -664,7 +664,6 @@ static ide_driver_t idefloppy_driver = {
 	.probe			= ide_floppy_probe,
 	.remove			= ide_floppy_remove,
 	.version		= IDEFLOPPY_VERSION,
-	.media			= ide_floppy,
 	.do_request		= idefloppy_do_request,
 	.end_request		= idefloppy_end_request,
 	.error			= __ide_error,
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2324,7 +2324,6 @@ static ide_driver_t idetape_driver = {
 	.probe			= ide_tape_probe,
 	.remove			= ide_tape_remove,
 	.version		= IDETAPE_VERSION,
-	.media			= ide_tape,
 	.do_request		= idetape_do_request,
 	.end_request		= idetape_end_request,
 	.error			= __ide_error,
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -437,7 +437,6 @@ static ide_driver_t idescsi_driver = {
 	.probe			= ide_scsi_probe,
 	.remove			= ide_scsi_remove,
 	.version		= IDESCSI_VERSION,
-	.media			= ide_scsi,
 	.do_request		= idescsi_do_request,
 	.end_request		= idescsi_end_request,
 	.error                  = idescsi_atapi_error,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -998,7 +998,6 @@ enum {
  */
 struct ide_driver_s {
 	const char			*version;
-	u8				media;
 	ide_startstop_t	(*do_request)(ide_drive_t *, struct request *, sector_t);
 	int		(*end_request)(ide_drive_t *, int, int);
 	ide_startstop_t	(*error)(ide_drive_t *, struct request *rq, u8, u8);
