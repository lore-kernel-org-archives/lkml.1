Return-Path: <linux-kernel-owner+w=401wt.eu-S1756637AbZBARyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbZBARyR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 12:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755503AbZBARuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 12:50:04 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:6833 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756358AbZBARuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 12:50:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jKrnTa/ZW9kqeCN6gKAy4F4PTGGPi0iVgdvNR9EGWMwQ1eAYu5ypni1GHFx7nYpIER
         tcJEXNiDQ/zRMBQ39aw+F3UasKE50OoJpjdzEyv9/qmxOz91kKf0fkv22bOlgaWjTCXd
         RgriBW0P56skuBCbQcTejrqrlVxxmvBAgmxZU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 01 Feb 2009 18:50:54 +0100
Message-Id: <20090201175054.19144.79528.sendpatchset@localhost.localdomain>
In-Reply-To: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
Subject: [PATCH 15/15] ide: move smart_enable() call out from get_smart_data()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: move smart_enable() call out from get_smart_data()

Move smart_enable() call out from get_smart_data() to
proc_idedisk_read_smart().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk_proc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-disk_proc.c
===================================================================
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -31,7 +31,7 @@ static int get_smart_data(ide_drive_t *d
 	tf->command = ATA_CMD_SMART;
 	args.tf_flags	= IDE_TFLAG_TF | IDE_TFLAG_DEVICE;
 	args.data_phase	= TASKFILE_IN;
-	(void) smart_enable(drive);
+
 	return ide_raw_taskfile(drive, &args, buf, 1);
 }
 
@@ -67,6 +67,8 @@ static int proc_idedisk_read_smart(char 
 	ide_drive_t	*drive = (ide_drive_t *)data;
 	int		len = 0, i = 0;
 
+	(void)smart_enable(drive);
+
 	if (get_smart_data(drive, page, sub_cmd) == 0) {
 		unsigned short *val = (unsigned short *) page;
 		char *out = (char *)val + SECTOR_SIZE;
