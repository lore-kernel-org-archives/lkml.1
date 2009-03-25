Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZCYAbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZCYAbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:31:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756371AbZCYA3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:29:37 -0400
Received: from kroah.org ([198.145.64.141]:54040 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755211AbZCYA3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:29:36 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 04/61] zorro: struct device - replace bus_id with dev_name(), dev_set_name()
Date: Tue, 24 Mar 2009 17:26:08 -0700
Message-Id: <1237940825-22904-4-git-send-email-gregkh@suse.de>
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
 drivers/zorro/zorro.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/zorro/zorro.c b/drivers/zorro/zorro.c
index a1585d6..d45fb34 100644
--- a/drivers/zorro/zorro.c
+++ b/drivers/zorro/zorro.c
@@ -140,7 +140,7 @@ static int __init zorro_init(void)
 
     /* Initialize the Zorro bus */
     INIT_LIST_HEAD(&zorro_bus.devices);
-    strcpy(zorro_bus.dev.bus_id, "zorro");
+    dev_set_name(&zorro_bus.dev, "zorro");
     error = device_register(&zorro_bus.dev);
     if (error) {
 	pr_err("Zorro: Error registering zorro_bus\n");
@@ -167,7 +167,7 @@ static int __init zorro_init(void)
 	if (request_resource(zorro_find_parent_resource(z), &z->resource))
 	    pr_err("Zorro: Address space collision on device %s %pR\n",
 		   z->name, &z->resource);
-	sprintf(z->dev.bus_id, "%02x", i);
+	dev_set_name(&z->dev, "%02x", i);
 	z->dev.parent = &zorro_bus.dev;
 	z->dev.bus = &zorro_bus_type;
 	error = device_register(&z->dev);
-- 
1.6.2

