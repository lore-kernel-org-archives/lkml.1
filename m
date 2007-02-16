Return-Path: <linux-kernel-owner+w=401wt.eu-S1946310AbXBPXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946310AbXBPXjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946308AbXBPXjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:39555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946307AbXBPXjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:14 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/10] Driver: remove redundant kobject_unregister checks
Date: Fri, 16 Feb 2007 15:37:31 -0800
Message-Id: <11716690692008-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690662679-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Here is a patch that removes all redundant kobject_unregister argument checks.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/class.c  |    3 +--
 fs/partitions/check.c |    9 +++------
 kernel/module.c       |    7 ++-----
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 96def1d..1417e5c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -163,8 +163,7 @@ int class_register(struct class * cls)
 void class_unregister(struct class * cls)
 {
 	pr_debug("device class '%s': unregistering\n", cls->name);
-	if (cls->virtual_dir)
-		kobject_unregister(cls->virtual_dir);
+	kobject_unregister(cls->virtual_dir);
 	remove_class_attrs(cls);
 	subsystem_unregister(&cls->subsys);
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ac32a2e..22d38ff 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -358,8 +358,7 @@ void delete_partition(struct gendisk *disk, int part)
 	p->ios[0] = p->ios[1] = 0;
 	p->sectors[0] = p->sectors[1] = 0;
 	sysfs_remove_link(&p->kobj, "subsystem");
-	if (p->holder_dir)
-		kobject_unregister(p->holder_dir);
+	kobject_unregister(p->holder_dir);
 	kobject_uevent(&p->kobj, KOBJ_REMOVE);
 	kobject_del(&p->kobj);
 	kobject_put(&p->kobj);
@@ -603,10 +602,8 @@ void del_gendisk(struct gendisk *disk)
 	disk->stamp = 0;
 
 	kobject_uevent(&disk->kobj, KOBJ_REMOVE);
-	if (disk->holder_dir)
-		kobject_unregister(disk->holder_dir);
-	if (disk->slave_dir)
-		kobject_unregister(disk->slave_dir);
+	kobject_unregister(disk->holder_dir);
+	kobject_unregister(disk->slave_dir);
 	if (disk->driverfs_dev) {
 		char *disk_name = make_block_name(disk);
 		sysfs_remove_link(&disk->kobj, "device");
diff --git a/kernel/module.c b/kernel/module.c
index 225501f..e06b77a 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1180,11 +1180,8 @@ static void mod_kobject_remove(struct module *mod)
 {
 	module_remove_modinfo_attrs(mod);
 	module_param_sysfs_remove(mod);
-	if (mod->mkobj.drivers_dir)
-		kobject_unregister(mod->mkobj.drivers_dir);
-	if (mod->holders_dir)
-		kobject_unregister(mod->holders_dir);
-
+	kobject_unregister(mod->mkobj.drivers_dir);
+	kobject_unregister(mod->holders_dir);
 	kobject_unregister(&mod->mkobj.kobj);
 }
 
-- 
1.5.0

