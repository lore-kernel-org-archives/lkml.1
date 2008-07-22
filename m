Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYGVFcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYGVFcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 01:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbYGVFXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 01:23:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:43114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158AbYGVFXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 01:23:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 33/79] block: fix compiler warning in genhd.c
Date: Mon, 21 Jul 2008 22:18:57 -0700
Message-Id: <1216703983-21448-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <20080722051805.GA17373@suse.de>
References: <20080722051805.GA17373@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Warn if something really bad happens if we can't create this link.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/genhd.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 24e3fc9..3ccf5c0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -183,6 +183,7 @@ static int exact_lock(dev_t devt, void *data)
 void add_disk(struct gendisk *disk)
 {
 	struct backing_dev_info *bdi;
+	int retval;
 
 	disk->flags |= GENHD_FL_UP;
 	blk_register_region(MKDEV(disk->major, disk->first_minor),
@@ -193,7 +194,8 @@ void add_disk(struct gendisk *disk)
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
-	sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
+	retval = sysfs_create_link(&disk->dev.kobj, &bdi->dev->kobj, "bdi");
+	WARN_ON(retval);
 }
 
 EXPORT_SYMBOL(add_disk);
-- 
1.5.6.3

