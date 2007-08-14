Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXHNV2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXHNV2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbXHNVXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:23:01 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38413 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755636AbXHNVW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:22:57 -0400
Date: Tue, 14 Aug 2007 23:22:48 +0200
From: Adrian Bunk <bunk@kernel.org>
To: johnpol@2ka.mipt.ru
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] w1_remove_master_device(): fix check-after-use
Message-ID: <20070814212248.GD18945@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The Coverity checker spotted that we'd have already oops'ed if "dev"
was NULL.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
--- linux-2.6.23-rc1-mm2/drivers/w1/w1_int.c.old	2007-08-08 14:38:50.000000000 +0200
+++ linux-2.6.23-rc1-mm2/drivers/w1/w1_int.c	2007-08-08 14:38:58.000000000 +0200
@@ -171,22 +171,17 @@
 void w1_remove_master_device(struct w1_bus_master *bm)
 {
 	struct w1_master *dev = NULL;
 
 	list_for_each_entry(dev, &w1_masters, w1_master_entry) {
 		if (!dev->initialized)
 			continue;
 
 		if (dev->bus_master->data == bm->data)
 			break;
 	}
 
-	if (!dev) {
-		printk(KERN_ERR "Device doesn't exist.\n");
-		return;
-	}
-
 	__w1_remove_master_device(dev);
 }
 
 EXPORT_SYMBOL(w1_add_master_device);
 EXPORT_SYMBOL(w1_remove_master_device);
