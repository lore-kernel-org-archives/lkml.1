Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbYAYIQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbYAYIQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758648AbYAYIAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:43 -0500
Received: from mail.suse.de ([195.135.220.2]:59432 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758233AbYAYH7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:48 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 130/196] Kobject: convert drivers/base/core.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:39 -0800
Message-Id: <1201246425-5058-51-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts the code to use the new kobject functions, cleaning up the
logic in doing so.

Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/core.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b3a931f..beb3516 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -523,8 +523,7 @@ static void klist_children_put(struct klist_node *n)
 void device_initialize(struct device *dev)
 {
 	dev->kobj.kset = devices_kset;
-	dev->kobj.ktype = &device_ktype;
-	kobject_init(&dev->kobj);
+	kobject_init_ng(&dev->kobj, &device_ktype);
 	klist_init(&dev->klist_children, klist_children_get,
 		   klist_children_put);
 	INIT_LIST_HEAD(&dev->dma_pools);
@@ -729,7 +728,7 @@ static void device_remove_class_symlinks(struct device *dev)
  *	This is part 2 of device_register(), though may be called
  *	separately _iff_ device_initialize() has been called separately.
  *
- *	This adds it to the kobject hierarchy via kobject_add(), adds it
+ *	This adds it to the kobject hierarchy via kobject_add_ng(), adds it
  *	to the global and sibling lists for the device, then
  *	adds it to the other relevant subsystems of the driver model.
  */
@@ -760,8 +759,7 @@ int device_add(struct device *dev)
 		goto Error;
 
 	/* first, register with generic layer. */
-	kobject_set_name(&dev->kobj, "%s", dev->bus_id);
-	error = kobject_add(&dev->kobj);
+	error = kobject_add_ng(&dev->kobj, dev->kobj.parent, "%s", dev->bus_id);
 	if (error)
 		goto Error;
 
-- 
1.5.3.8

