Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYGZNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYGZNoi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYGZNm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:42:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.184]:42093 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755961AbYGZNmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:42:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TrSYa4Li2E04Ogh9aA8uPkgi4JXEbx3x7m5p7Z/80hnqWq7QT/qwo/gbX59n6EkPEu
         Vl8HBqJK+Nx5+pnnZ+8F37SzejSLLxbM+zehMUptoGQAuanwSt/pVfxji9F064xx7LuQ
         eg9Zkgjyf3dfyIVsmVEJtisQozP+LSxDhVmzE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sat, 26 Jul 2008 15:40:51 +0200
Message-Id: <20080726134051.10589.14729.sendpatchset@localhost.localdomain>
In-Reply-To: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
References: <20080726134010.10589.51679.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/10] ide: remove needless drive->present checks from device drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove needless drive->present checks from ->probe methods
(device model takes care of that).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c     |    4 ++--
 drivers/ide/ide-disk.c   |    3 +--
 drivers/ide/ide-floppy.c |    4 ++--
 drivers/ide/ide-tape.c   |    4 ++--
 drivers/scsi/ide-scsi.c  |    1 -
 5 files changed, 7 insertions(+), 9 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -2105,10 +2105,10 @@ static int ide_cd_probe(ide_drive_t *dri
 
 	if (!strstr("ide-cdrom", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_cdrom && drive->media != ide_optical)
 		goto failed;
+
 	/* skip drives that we were told to ignore */
 	if (ignore != NULL) {
 		if (strstr(ignore, drive->name)) {
Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1143,8 +1143,7 @@ static int ide_disk_probe(ide_drive_t *d
 	/* strstr("foo", "") is non-NULL */
 	if (!strstr("ide-disk", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_disk)
 		goto failed;
 
Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1389,10 +1389,10 @@ static int ide_floppy_probe(ide_drive_t 
 
 	if (!strstr("ide-floppy", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_floppy)
 		goto failed;
+
 	if (!idefloppy_identify_device(drive, drive->id)) {
 		printk(KERN_ERR "ide-floppy: %s: not supported by this version"
 				" of ide-floppy\n", drive->name);
Index: b/drivers/ide/ide-tape.c
===================================================================
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2645,10 +2645,10 @@ static int ide_tape_probe(ide_drive_t *d
 
 	if (!strstr("ide-tape", drive->driver_req))
 		goto failed;
-	if (!drive->present)
-		goto failed;
+
 	if (drive->media != ide_tape)
 		goto failed;
+
 	if (!idetape_identify_device(drive)) {
 		printk(KERN_ERR "ide-tape: %s: not supported by this version of"
 				" the driver\n", drive->name);
Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -821,7 +821,6 @@ static int ide_scsi_probe(ide_drive_t *d
 		return -ENODEV;
 
 	if (!strstr("ide-scsi", drive->driver_req) ||
-	    !drive->present ||
 	    drive->media == ide_disk ||
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
