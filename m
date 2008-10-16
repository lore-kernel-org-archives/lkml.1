Return-Path: <linux-kernel-owner+w=401wt.eu-S1757861AbYJPRUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861AbYJPRUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:20:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbYJPROW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:22 -0400
Received: from kroah.org ([198.145.64.141]:46953 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756123AbYJPROU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:20 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 14/46] device create: ide: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:15 -0700
Message-Id: <1224177047-11859-14-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-probe.c |    4 ++--
 drivers/ide/ide-tape.c  |   11 +++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index f27baa5..19f8c77 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -657,8 +657,8 @@ static int ide_register_port(ide_hwif_t *hwif)
 		goto out;
 	}
 
-	hwif->portdev = device_create_drvdata(ide_port_class, &hwif->gendev,
-					      MKDEV(0, 0), hwif, hwif->name);
+	hwif->portdev = device_create(ide_port_class, &hwif->gendev,
+				      MKDEV(0, 0), hwif, hwif->name);
 	if (IS_ERR(hwif->portdev)) {
 		ret = PTR_ERR(hwif->portdev);
 		device_unregister(&hwif->gendev);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 25ac60f..d879c77 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2420,12 +2420,11 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	idetape_setup(drive, tape, minor);
 
-	device_create_drvdata(idetape_sysfs_class, &drive->gendev,
-			      MKDEV(IDETAPE_MAJOR, minor), NULL,
-			      "%s", tape->name);
-	device_create_drvdata(idetape_sysfs_class, &drive->gendev,
-			      MKDEV(IDETAPE_MAJOR, minor + 128), NULL,
-			      "n%s", tape->name);
+	device_create(idetape_sysfs_class, &drive->gendev,
+		      MKDEV(IDETAPE_MAJOR, minor), NULL, "%s", tape->name);
+	device_create(idetape_sysfs_class, &drive->gendev,
+		      MKDEV(IDETAPE_MAJOR, minor + 128), NULL,
+		      "n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
-- 
1.6.0.2

