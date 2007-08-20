Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbXHTWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbXHTWwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXHTWw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:52:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53923 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbXHTWw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:52:27 -0400
Message-Id: <20070820225049.722180000@suse.de>
References: <20070820224806.154198000@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 20 Aug 2007 15:48:07 -0700
From: tonyj@suse.de
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, kay.sievers@vrfy.org
Subject: [patch 01/14] Convert from class_device to device for block/paride
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Content-Disposition: inline; filename=paride.patch

Convert from class_device to device for block/paride.  This is part of the
work to eliminate struct class_device.

Signed-off-by: Tony Jones <tonyj@suse.de>

---
 drivers/block/paride/pg.c |    6 +++---
 drivers/block/paride/pt.c |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -676,8 +676,8 @@ static int __init pg_init(void)
 	for (unit = 0; unit < PG_UNITS; unit++) {
 		struct pg *dev = &devices[unit];
 		if (dev->present)
-			class_device_create(pg_class, NULL, MKDEV(major, unit),
-					NULL, "pg%u", unit);
+			device_create(pg_class, NULL, MKDEV(major, unit),
+				      "pg%u", unit);
 	}
 	err = 0;
 	goto out;
@@ -695,7 +695,7 @@ static void __exit pg_exit(void)
 	for (unit = 0; unit < PG_UNITS; unit++) {
 		struct pg *dev = &devices[unit];
 		if (dev->present)
-			class_device_destroy(pg_class, MKDEV(major, unit));
+			device_destroy(pg_class, MKDEV(major, unit));
 	}
 	class_destroy(pg_class);
 	unregister_chrdev(major, name);
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -972,10 +972,10 @@ static int __init pt_init(void)
 
 	for (unit = 0; unit < PT_UNITS; unit++)
 		if (pt[unit].present) {
-			class_device_create(pt_class, NULL, MKDEV(major, unit),
-					NULL, "pt%d", unit);
-			class_device_create(pt_class, NULL, MKDEV(major, unit + 128),
-					NULL, "pt%dn", unit);
+			device_create(pt_class, NULL, MKDEV(major, unit),
+				      "pt%d", unit);
+			device_create(pt_class, NULL, MKDEV(major, unit + 128),
+				      "pt%dn", unit);
 		}
 	goto out;
 
@@ -990,8 +990,8 @@ static void __exit pt_exit(void)
 	int unit;
 	for (unit = 0; unit < PT_UNITS; unit++)
 		if (pt[unit].present) {
-			class_device_destroy(pt_class, MKDEV(major, unit));
-			class_device_destroy(pt_class, MKDEV(major, unit + 128));
+			device_destroy(pt_class, MKDEV(major, unit));
+			device_destroy(pt_class, MKDEV(major, unit + 128));
 		}
 	class_destroy(pt_class);
 	unregister_chrdev(major, name);

-- 
