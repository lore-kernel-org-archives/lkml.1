Return-Path: <linux-kernel-owner+w=401wt.eu-S1761758AbXHTWym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761758AbXHTWym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760620AbXHTWwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbXHTWwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:49 -0400
Message-Id: <20070820225113.959198000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:13 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: gadio@netvision.net.il, kay.sievers@vrfy.org
Subject: [patch 07/14] Convert from class_device to device for IDE/ide-tape
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=ide.patch

Convert from class_device to device for drivers/drivers/ide/ide-tape.  This is 
part of the work to eliminate struct class_device.

---
 drivers/ide/ide-tape.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -4725,10 +4725,8 @@ static void ide_tape_release(struct kref
 
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
@@ -4885,10 +4883,10 @@ static int ide_tape_probe(ide_drive_t *d
 
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
