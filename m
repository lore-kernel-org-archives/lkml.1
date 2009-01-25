Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZAYXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZAYXA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 18:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbZAYXAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 18:00:18 -0500
Received: from mu-out-0910.google.com ([209.85.134.189]:24396 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbZAYXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 18:00:17 -0500
Subject: tc: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: macro@linux-mips.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 25 Jan 2009 23:59:25 +0100
Message-Id: <1232924365.2924.25.camel@nga>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>
Subject: tc: struct device - replace bus_id with dev_name(), dev_set_name()

Cc: macro@linux-mips.org
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/tc/tc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/tc/tc.c
+++ b/drivers/tc/tc.c
@@ -86,7 +86,7 @@ static void __init tc_bus_add_devices(st
 			       slot);
 			goto out_err;
 		}
-		sprintf(tdev->dev.bus_id, "tc%x", slot);
+		dev_set_name(&tdev->dev, "tc%x", slot);
 		tdev->bus = tbus;
 		tdev->dev.parent = &tbus->dev;
 		tdev->dev.bus = &tc_bus_type;
@@ -104,7 +104,7 @@ static void __init tc_bus_add_devices(st
 		tdev->vendor[8] = 0;
 		tdev->name[8] = 0;
 
-		pr_info("%s: %s %s %s\n", tdev->dev.bus_id, tdev->vendor,
+		pr_info("%s: %s %s %s\n", dev_name(&tdev->dev), tdev->vendor,
 			tdev->name, tdev->firmware);
 
 		devsize = readb(module + offset + TC_SLOT_SIZE);
@@ -118,7 +118,7 @@ static void __init tc_bus_add_devices(st
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


