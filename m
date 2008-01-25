Return-Path: <linux-kernel-owner+w=401wt.eu-S1762641AbYAYIfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762641AbYAYIfq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764149AbYAYIBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:01:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:53702 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763922AbYAYH75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:57 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 129/196] Kobject: convert drivers/base/class.c to use kobject_init/add_ng()
Date: Thu, 24 Jan 2008 23:32:38 -0800
Message-Id: <1201246425-5058-50-git-send-email-gregkh@suse.de>
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
 drivers/base/class.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 3ffcda7..ba6745b 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -546,8 +546,7 @@ static struct class_device_attribute class_uevent_attr =
 void class_device_initialize(struct class_device *class_dev)
 {
 	class_dev->kobj.kset = &class_obj_subsys;
-	class_dev->kobj.ktype = &class_device_ktype;
-	kobject_init(&class_dev->kobj);
+	kobject_init_ng(&class_dev->kobj, &class_device_ktype);
 	INIT_LIST_HEAD(&class_dev->node);
 }
 
@@ -575,16 +574,13 @@ int class_device_add(struct class_device *class_dev)
 		 class_dev->class_id);
 
 	/* first, register with generic layer. */
-	error = kobject_set_name(&class_dev->kobj, "%s", class_dev->class_id);
-	if (error)
-		goto out2;
-
 	if (parent_class_dev)
 		class_dev->kobj.parent = &parent_class_dev->kobj;
 	else
 		class_dev->kobj.parent = &parent_class->subsys.kobj;
 
-	error = kobject_add(&class_dev->kobj);
+	error = kobject_add_ng(&class_dev->kobj, class_dev->kobj.parent,
+			       "%s", class_dev->class_id);
 	if (error)
 		goto out2;
 
-- 
1.5.3.8

