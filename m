Return-Path: <linux-kernel-owner+w=401wt.eu-S1759579AbYAYHUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579AbYAYHUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:20:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbYAYHPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:09 -0500
Received: from cantor.suse.de ([195.135.220.2]:52493 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219AbYAYHPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Gadi Oxman <gadio@netvision.net.il>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 020/196] IDE: Convert from class_device to device for ide-tape
Date: Thu, 24 Jan 2008 23:09:18 -0800
Message-Id: <1201245134-4876-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Gadi Oxman <gadio@netvision.net.il>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-tape.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 7b9181b..1495792 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -4724,10 +4724,8 @@ static void ide_tape_release(struct kref *kref)
 
 	drive->dsc_overlap = 0;
 	drive->driver_data = NULL;
-	class_device_destroy(idetape_sysfs_class,
-			MKDEV(IDETAPE_MAJOR, tape->minor));
-	class_device_destroy(idetape_sysfs_class,
-			MKDEV(IDETAPE_MAJOR, tape->minor + 128));
+	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor));
+	device_destroy(idetape_sysfs_class, MKDEV(IDETAPE_MAJOR, tape->minor + 128));
 	idetape_devs[tape->minor] = NULL;
 	g->private_data = NULL;
 	put_disk(g);
@@ -4884,10 +4882,10 @@ static int ide_tape_probe(ide_drive_t *drive)
 
 	idetape_setup(drive, tape, minor);
 
-	class_device_create(idetape_sysfs_class, NULL,
-			MKDEV(IDETAPE_MAJOR, minor), &drive->gendev, "%s", tape->name);
-	class_device_create(idetape_sysfs_class, NULL,
-			MKDEV(IDETAPE_MAJOR, minor + 128), &drive->gendev, "n%s", tape->name);
+	device_create(idetape_sysfs_class, &drive->gendev,
+		      MKDEV(IDETAPE_MAJOR, minor), "%s", tape->name);
+	device_create(idetape_sysfs_class, &drive->gendev,
+			MKDEV(IDETAPE_MAJOR, minor + 128), "n%s", tape->name);
 
 	g->fops = &idetape_block_ops;
 	ide_register_region(g);
-- 
1.5.3.8

