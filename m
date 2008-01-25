Return-Path: <linux-kernel-owner+w=401wt.eu-S1759981AbYAYHWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759981AbYAYHWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:22:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758391AbYAYHPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:15:30 -0500
Received: from mx1.suse.de ([195.135.220.2]:52524 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758360AbYAYHP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:15:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tony Jones <tonyj@suse.de>, Tim Waugh <tim@cyberelk.net>,
       Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 025/196] paride: Convert from class_device to device for block/paride
Date: Thu, 24 Jan 2008 23:09:23 -0800
Message-Id: <1201245134-4876-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

struct class_device is going away, this converts the code to use struct
device instead.

Signed-off-by: Tony Jones <tonyj@suse.de>
Cc: Tim Waugh <tim@cyberelk.net>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/block/paride/pg.c |    6 +++---
 drivers/block/paride/pt.c |   12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index d89e7d3..ab86e23 100644
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
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index b91accf..76096ca 100644
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
1.5.3.8

