Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYGVF0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYGVF0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbYGVFW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:22:28 -0400
Received: from mail.suse.de ([195.135.220.2]:53756 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756734AbYGVFW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:22:27 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 14/79] device create: ide: convert device_create to device_create_drvdata
Date: Mon, 21 Jul 2008 22:18:38 -0700
Message-Id: <1216703983-21448-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_create() is race-prone, so use the race-free
device_create_drvdata() instead as device_create() is going away.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-tape.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b711ab9..353dd11 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2697,10 +2697,12 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	idetape_setup(drive, tape, minor);
 
-	device_create(idetape_sysfs_class, &drive->gendev,
-		      MKDEV(IDETAPE_MAJOR, minor), "%s", tape->name);
-	device_create(idetape_sysfs_class, &drive->gendev,
-			MKDEV(IDETAPE_MAJOR, minor + 128), "n%s", tape->name);
+	device_create_drvdata(idetape_sysfs_class, &drive->gendev,
+			      MKDEV(IDETAPE_MAJOR, minor), NULL,
+			      "%s", tape->name);
+	device_create_drvdata(idetape_sysfs_class, &drive->gendev,
+			      MKDEV(IDETAPE_MAJOR, minor + 128), NULL,
+			      "n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
-- 
1.5.6.3

