Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbXHTWy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbXHTWy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760208AbXHTWwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:46 -0400
Received: from ns1.suse.de ([195.135.220.2]:60155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760125AbXHTWwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:45 -0400
Message-Id: <20070820225109.888306000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:12 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, kay.sievers@vrfy.org
Subject: [patch 06/14] Convert from class_device to device for MTD/mtdchar
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=mtd.patch

Convert from class_device to device for drivers/mtd/mtdchar.  This is part of 
the work to eliminate struct class_device.

---
 drivers/mtd/mtdchar.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -27,12 +27,10 @@ static void mtd_notify_add(struct mtd_in
 	if (!mtd)
 		return;
 
-	class_device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2),
-			    NULL, "mtd%d", mtd->index);
+	device_create(mtd_class, NULL, MKDEV(MTD_CHAR_MAJOR, mtd->index*2), "mtd%d", mtd->index);
 
-	class_device_create(mtd_class, NULL,
-			    MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1),
-			    NULL, "mtd%dro", mtd->index);
+	device_create(mtd_class, NULL,
+		      MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1), "mtd%dro", mtd->index);
 }
 
 static void mtd_notify_remove(struct mtd_info* mtd)
@@ -40,8 +38,8 @@ static void mtd_notify_remove(struct mtd
 	if (!mtd)
 		return;
 
-	class_device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2));
-	class_device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1));
+	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2));
+	device_destroy(mtd_class, MKDEV(MTD_CHAR_MAJOR, mtd->index*2+1));
 }
 
 static struct mtd_notifier notifier = {

-- 
