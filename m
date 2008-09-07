Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYIGWTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYIGWTb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 18:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYIGWRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 18:17:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:54949 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755850AbYIGWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 18:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Yf5qTtX5Y/8m8vIP+7A5JnL6XzHMXr8FhZR7rborj2sTOQVKnuPsq5XwFhXfi9qgod
         Xs+7s+nMUYev8AG72iWJWLBhWhfWJjcAiWYAO7QStJsID4k+Bv0pGrd5oZ14LO4bmwYu
         Hkgu4CRDZCCD/ncNrc+OZITPTBuAeGcPaE5AA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 08 Sep 2008 00:15:12 +0200
Message-Id: <20080907221512.24285.56064.sendpatchset@localhost.localdomain>
In-Reply-To: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
References: <20080907221424.24285.81137.sendpatchset@localhost.localdomain>
Subject: [PATCH 07/18] ide-floppy: drop 'floppy' argument from idefloppy_setup()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-floppy.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-floppy.c
===================================================================
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -560,8 +560,9 @@ sector_t ide_floppy_capacity(ide_drive_t
 	return capacity;
 }
 
-static void idefloppy_setup(ide_drive_t *drive, idefloppy_floppy_t *floppy)
+static void idefloppy_setup(ide_drive_t *drive)
 {
+	struct ide_floppy_obj *floppy = drive->driver_data;
 	u16 *id = drive->id;
 
 	drive->pc_callback	 = ide_floppy_callback;
@@ -808,7 +809,7 @@ static int ide_floppy_probe(ide_drive_t 
 
 	drive->debug_mask = debug_mask;
 
-	idefloppy_setup(drive, floppy);
+	idefloppy_setup(drive);
 
 	g->minors = 1 << PARTN_BITS;
 	g->driverfs_dev = &drive->gendev;
