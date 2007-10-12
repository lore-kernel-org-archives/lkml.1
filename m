Return-Path: <linux-kernel-owner+w=401wt.eu-S934478AbXJLWvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934478AbXJLWvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932696AbXJLWWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:22:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:49958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932818AbXJLWWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:22:01 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/75] sysfs: kill sysfs_update_file()
Date: Fri, 12 Oct 2007 15:17:00 -0700
Message-Id: <11922277041450-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922276993289-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
 <1192227527856-git-send-email-gregkh@suse.de>
 <11922275312531-git-send-email-gregkh@suse.de>
 <11922275371856-git-send-email-gregkh@suse.de>
 <11922275413548-git-send-email-gregkh@suse.de>
 <11922275462233-git-send-email-gregkh@suse.de>
 <1192227551156-git-send-email-gregkh@suse.de>
 <11922275552558-git-send-email-gregkh@suse.de>
 <119222756066-git-send-email-gregkh@suse.de>
 <11922275642378-git-send-email-gregkh@suse.de>
 <11922275693989-git-send-email-gregkh@suse.de>
 <1192227574129-git-send-email-gregkh@suse.de>
 <11922275781508-git-send-email-gregkh@suse.de>
 <11922275843236-git-send-email-gregkh@suse.de>
 <1192227589276-git-send-email-gregkh@suse.de>
 <1192227593813-git-send-email-gregkh@suse.de>
 <1192227598106-git-send-email-gregkh@suse.de>
 <1192227603335-git-send-email-gregkh@suse.de>
 <1192227611369-git-send-email-gregkh@suse.de>
 <11922276163147-git-send-email-gregkh@suse.de>
 <11922276201219-git-send-email-gregkh@suse.de>
 <11922276254051-git-send-email-gregkh@suse.de>
 <11922276302338-git-send-email-gregkh@suse.de>
 <1192227634772-git-send-email-gregkh@suse.de>
 <11922276392200-git-send-email-gregkh@suse.de>
 <11922276433594-git-send-email-gregkh@suse.de>
 <11922276471365-git-send-email-gregkh@suse.de>
 <1192227653165-git-send-email-gregkh@suse.de>
 <11922276572176-git-send-email-gregkh@suse.de>
 <11922276622731-git-send-email-gregkh@suse.de>
 <11922276672660-git-send-email-gregkh@suse.de>
 <1192227671143-git-send-email-gregkh@suse.de>
 <11922276763650-git-send-email-gregkh@suse.de>
 <1192227681926-git-send-email-gregkh@suse.de>
 <11922276862914-git-send-email-gregkh@suse.de>
 <11922276913288-git-send-email-gregkh@suse.de>
 <1192227695547-git-send-email-gregkh@suse.de>
 <11922276993289-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs_update_file() depends on inode->i_mtime but sysfs iondes are now
reclaimable making the reported modification time unreliable.  There's
only one user (pci hotplug) of this notification mechanism and it
reportedly isn't utilized from userland.

Kill sysfs_update_file().

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/pci_hotplug_core.c |   60 --------------------------------
 fs/sysfs/file.c                        |   40 ---------------------
 include/linux/sysfs.h                  |    7 ----
 3 files changed, 0 insertions(+), 107 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index bd433ef..f0eba53 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -694,66 +694,6 @@ int __must_check pci_hp_change_slot_info(struct hotplug_slot *slot,
 	if ((slot == NULL) || (info == NULL))
 		return -ENODEV;
 
-	/*
-	* check all fields in the info structure, and update timestamps
-	* for the files referring to the fields that have now changed.
-	*/
-	if ((has_power_file(slot) == 0) &&
-	    (slot->info->power_status != info->power_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_power.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_attention_file(slot) == 0) &&
-	    (slot->info->attention_status != info->attention_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_attention.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_latch_file(slot) == 0) &&
-	    (slot->info->latch_status != info->latch_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_latch.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_adapter_file(slot) == 0) &&
-	    (slot->info->adapter_status != info->adapter_status)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_presence.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_address_file(slot) == 0) &&
-	    (slot->info->address != info->address)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_address.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_max_bus_speed_file(slot) == 0) &&
-	    (slot->info->max_bus_speed != info->max_bus_speed)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_max_bus_speed.attr);
-		if (retval)
-			return retval;
-	}
-
-	if ((has_cur_bus_speed_file(slot) == 0) &&
-	    (slot->info->cur_bus_speed != info->cur_bus_speed)) {
-		retval = sysfs_update_file(&slot->kobj,
-					   &hotplug_slot_attr_cur_bus_speed.attr);
-		if (retval)
-			return retval;
-	}
-
 	memcpy (slot->info, info, sizeof (struct hotplug_slot_info));
 
 	return 0;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 9fdf8da..61a8c19 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/fsnotify.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
@@ -453,44 +452,6 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 }
 EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
 
-
-/**
- * sysfs_update_file - update the modified timestamp on an object attribute.
- * @kobj: object we're acting for.
- * @attr: attribute descriptor.
- */
-int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
-{
-	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	int rc;
-
-	rc = -ENOENT;
-	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
-	if (!victim_sd)
-		goto out;
-
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
-	}
-
-	mutex_lock(&victim->d_inode->i_mutex);
-	victim->d_inode->i_mtime = CURRENT_TIME;
-	fsnotify_modify(victim);
-	mutex_unlock(&victim->d_inode->i_mutex);
-	rc = 0;
- out:
-	dput(victim);
-	sysfs_put(victim_sd);
-	return rc;
-}
-
-
 /**
  * sysfs_chmod_file - update the modified mode value on an object attribute.
  * @kobj: object we're acting for.
@@ -641,4 +602,3 @@ EXPORT_SYMBOL_GPL(sysfs_schedule_callback);
 
 EXPORT_SYMBOL_GPL(sysfs_create_file);
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
-EXPORT_SYMBOL_GPL(sysfs_update_file);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index b393bb4..db5dd24 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -87,8 +87,6 @@ int __must_check sysfs_move_dir(struct kobject *kobj,
 
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
-int __must_check sysfs_update_file(struct kobject *kobj,
-				   const struct attribute *attr);
 int __must_check sysfs_chmod_file(struct kobject *kobj, struct attribute *attr,
 				  mode_t mode);
 void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr);
@@ -149,11 +147,6 @@ static inline int sysfs_create_file(struct kobject *kobj,
 	return 0;
 }
 
-static inline int sysfs_update_file(struct kobject *kobj,
-				    const struct attribute *attr)
-{
-	return 0;
-}
 static inline int sysfs_chmod_file(struct kobject *kobj,
 				   struct attribute *attr, mode_t mode)
 {
-- 
1.5.3.4

