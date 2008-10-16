Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbYJPRQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbYJPRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbYJPROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:14:05 -0400
Received: from kroah.org ([198.145.64.141]:46922 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756046AbYJPROD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:14:03 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 03/46] device create: block: convert device_create_drvdata to device_create
Date: Thu, 16 Oct 2008 10:10:04 -0700
Message-Id: <1224177047-11859-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081016170954.GA11824@kroah.com>
References: <20081016170954.GA11824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that device_create() has been audited, rename things back to the
original call to be sane.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 block/bsg.c                |    3 +--
 drivers/block/aoe/aoechr.c |    6 +++---
 drivers/block/paride/pg.c  |    5 ++---
 drivers/block/paride/pt.c  |   10 ++++------
 drivers/block/pktcdvd.c    |    5 ++---
 5 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 56cb343..034112b 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -1024,8 +1024,7 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
 	bcd->release = release;
 	kref_init(&bcd->ref);
 	dev = MKDEV(bsg_major, bcd->minor);
-	class_dev = device_create_drvdata(bsg_class, parent, dev, NULL,
-					  "%s", devname);
+	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
 	if (IS_ERR(class_dev)) {
 		ret = PTR_ERR(class_dev);
 		goto put_dev;
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 1f56d2c..200efc4 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -284,9 +284,9 @@ aoechr_init(void)
 		return PTR_ERR(aoe_class);
 	}
 	for (i = 0; i < ARRAY_SIZE(chardevs); ++i)
-		device_create_drvdata(aoe_class, NULL,
-				      MKDEV(AOE_MAJOR, chardevs[i].minor),
-				      NULL, chardevs[i].name);
+		device_create(aoe_class, NULL,
+			      MKDEV(AOE_MAJOR, chardevs[i].minor), NULL,
+			      chardevs[i].name);
 
 	return 0;
 }
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index d731ca4..9dfa271 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -686,9 +686,8 @@ static int __init pg_init(void)
 	for (unit = 0; unit < PG_UNITS; unit++) {
 		struct pg *dev = &devices[unit];
 		if (dev->present)
-			device_create_drvdata(pg_class, NULL,
-					      MKDEV(major, unit), NULL,
-					      "pg%u", unit);
+			device_create(pg_class, NULL, MKDEV(major, unit), NULL,
+				      "pg%u", unit);
 	}
 	err = 0;
 	goto out;
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index 673b8b2..5ae2296 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -979,12 +979,10 @@ static int __init pt_init(void)
 
 	for (unit = 0; unit < PT_UNITS; unit++)
 		if (pt[unit].present) {
-			device_create_drvdata(pt_class, NULL,
-					      MKDEV(major, unit), NULL,
-					      "pt%d", unit);
-			device_create_drvdata(pt_class, NULL,
-					      MKDEV(major, unit + 128), NULL,
-					      "pt%dn", unit);
+			device_create(pt_class, NULL, MKDEV(major, unit), NULL,
+				      "pt%d", unit);
+			device_create(pt_class, NULL, MKDEV(major, unit + 128),
+				      NULL, "pt%dn", unit);
 		}
 	goto out;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 0e07715..195ca7c 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -302,9 +302,8 @@ static struct kobj_type kobj_pkt_type_wqueue = {
 static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
 {
 	if (class_pktcdvd) {
-		pd->dev = device_create_drvdata(class_pktcdvd, NULL,
-						pd->pkt_dev, NULL,
-						"%s", pd->name);
+		pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, NULL,
+					"%s", pd->name);
 		if (IS_ERR(pd->dev))
 			pd->dev = NULL;
 	}
-- 
1.6.0.2

