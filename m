Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZCYAdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZCYAdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZCYA3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:46 -0400
Received: from kroah.org ([198.145.64.141]:54061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753763AbZCYA3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 11/61] sh: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:15 -0700
Message-Id: <1237940825-22904-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/sh/maple/maple.c           |    8 ++++----
 drivers/sh/superhyway/superhyway.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/sh/maple/maple.c b/drivers/sh/maple/maple.c
index 63f0de2..7e1257a 100644
--- a/drivers/sh/maple/maple.c
+++ b/drivers/sh/maple/maple.c
@@ -424,7 +424,7 @@ static void maple_attach_driver(struct maple_device *mdev)
 		/* Do this silently - as not a real device */
 		function = 0;
 		mdev->driver = &maple_dummy_driver;
-		sprintf(mdev->dev.bus_id, "%d:0.port", mdev->port);
+		dev_set_name(&mdev->dev, "%d:0.port", mdev->port);
 	} else {
 		printk(KERN_INFO
 			"Maple bus at (%d, %d): Function 0x%lX\n",
@@ -440,8 +440,8 @@ static void maple_attach_driver(struct maple_device *mdev)
 				"No maple driver found.\n");
 			mdev->driver = &maple_dummy_driver;
 		}
-		sprintf(mdev->dev.bus_id, "%d:0%d.%lX", mdev->port,
-			mdev->unit, function);
+		dev_set_name(&mdev->dev, "%d:0%d.%lX", mdev->port,
+			     mdev->unit, function);
 	}
 	mdev->function = function;
 	mdev->dev.release = &maple_release_device;
@@ -780,7 +780,7 @@ struct bus_type maple_bus_type = {
 EXPORT_SYMBOL_GPL(maple_bus_type);
 
 static struct device maple_bus = {
-	.bus_id = "maple",
+	.init_name = "maple",
 	.release = maple_bus_release,
 };
 
diff --git a/drivers/sh/superhyway/superhyway.c b/drivers/sh/superhyway/superhyway.c
index 4d0282b..2d9e7f3 100644
--- a/drivers/sh/superhyway/superhyway.c
+++ b/drivers/sh/superhyway/superhyway.c
@@ -22,7 +22,7 @@
 static int superhyway_devices;
 
 static struct device superhyway_bus_device = {
-	.bus_id = "superhyway",
+	.init_name = "superhyway",
 };
 
 static void superhyway_device_release(struct device *dev)
@@ -83,7 +83,7 @@ int superhyway_add_device(unsigned long base, struct superhyway_device *sdev,
 	dev->id.id		= dev->vcr.mod_id;
 
 	sprintf(dev->name, "SuperHyway device %04x", dev->id.id);
-	sprintf(dev->dev.bus_id, "%02x", superhyway_devices);
+	dev_set_name(&dev->dev, "%02x", superhyway_devices);
 
 	superhyway_devices++;
 
-- 
1.6.2

