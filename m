Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbZCYAeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbZCYAeB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbZCYA3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:47 -0400
Received: from kroah.org ([198.145.64.141]:54063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754979AbZCYA3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:44 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, macro@linux-mips.org
Subject: [PATCH 12/61] tc: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:16 -0700
Message-Id: <1237940825-22904-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090325001659.GA22461@kroah.com>
References: <20090325001659.GA22461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Cc: macro@linux-mips.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/tc/tc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/tc/tc.c b/drivers/tc/tc.c
index f77f62a..e5bd447 100644
--- a/drivers/tc/tc.c
+++ b/drivers/tc/tc.c
@@ -86,7 +86,7 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 			       slot);
 			goto out_err;
 		}
-		sprintf(tdev->dev.bus_id, "tc%x", slot);
+		dev_set_name(&tdev->dev, "tc%x", slot);
 		tdev->bus = tbus;
 		tdev->dev.parent = &tbus->dev;
 		tdev->dev.bus = &tc_bus_type;
@@ -104,7 +104,7 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 		tdev->vendor[8] = 0;
 		tdev->name[8] = 0;
 
-		pr_info("%s: %s %s %s\n", tdev->dev.bus_id, tdev->vendor,
+		pr_info("%s: %s %s %s\n", dev_name(&tdev->dev), tdev->vendor,
 			tdev->name, tdev->firmware);
 
 		devsize = readb(module + offset + TC_SLOT_SIZE);
@@ -118,7 +118,7 @@ static void __init tc_bus_add_devices(struct tc_bus *tbus)
 		} else {
 			printk(KERN_ERR "%s: Cannot provide slot space "
 			       "(%dMiB required, up to %dMiB supported)\n",
-			       tdev->dev.bus_id, devsize >> 20,
+			       dev_name(&tdev->dev), devsize >> 20,
 			       max(slotsize, extslotsize) >> 20);
 			kfree(tdev);
 			goto out_err;
@@ -146,7 +146,7 @@ static int __init tc_init(void)
 		return 0;
 
 	INIT_LIST_HEAD(&tc_bus.devices);
-	strcpy(tc_bus.dev.bus_id, "tc");
+	dev_set_name(&tc_bus.dev, "tc");
 	device_register(&tc_bus.dev);
 
 	if (tc_bus.info.slot_size) {
-- 
1.6.2

