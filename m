Return-Path: <linux-kernel-owner+w=401wt.eu-S1760100AbYAKIkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760100AbYAKIkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755817AbYAKIke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:40:34 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30503
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbYAKIkd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:40:33 -0500
Message-Id: <478739A5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:40:53 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, <tony.luck@intel.com>, <axboe@kernel.dk>,
       <gregkh@suse.de>
Subject: [PATCH 3/3] constify struct sysfs_ops
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.. as again all consumers of it don't require it to be modifiable.

As before, the patch doesn't change all instances where 'const' could
have been added as a result of the base structure changes, only where
either the change has a real effect (the module loader doesn't enforce
read-only section attributes at present, so only built-in files matter)
or where compiler warnings would result otherwise.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/kobject.txt               |    2 +-
 arch/ia64/kernel/topology.c             |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c   |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c |    2 +-
 block/elevator.c                        |    2 +-
 block/genhd.c                           |    2 +-
 block/ll_rw_blk.c                       |    2 +-
 drivers/base/bus.c                      |    4 ++--
 drivers/base/class.c                    |    4 ++--
 drivers/base/core.c                     |    2 +-
 drivers/base/sys.c                      |    4 ++--
 drivers/cpufreq/cpufreq.c               |    2 +-
 drivers/cpuidle/sysfs.c                 |    4 ++--
 drivers/pci/pci-driver.c                |    2 +-
 fs/partitions/check.c                   |    2 +-
 fs/sysfs/file.c                         |   10 +++++-----
 include/linux/kobject.h                 |    2 +-
 kernel/params.c                         |   10 +---------
 mm/slub.c                               |    2 +-
 19 files changed, 27 insertions(+), 35 deletions(-)

--- 2.6.24-rc7-const.orig/Documentation/kobject.txt
+++ 2.6.24-rc7-const/Documentation/kobject.txt
@@ -262,7 +262,7 @@ embedded in a subsystem itself. 
 
 struct kobj_type {
 	void (*release)(struct kobject *);
-	struct sysfs_ops	* sysfs_ops;
+	const struct sysfs_ops	*sysfs_ops;
 	struct attribute	*const *default_attrs;
 };
 
--- 2.6.24-rc7-const.orig/arch/ia64/kernel/topology.c
+++ 2.6.24-rc7-const/arch/ia64/kernel/topology.c
@@ -267,7 +267,7 @@ static ssize_t cache_show(struct kobject
 	return ret;
 }
 
-static struct sysfs_ops cache_sysfs_ops = {
+static const struct sysfs_ops cache_sysfs_ops = {
 	.show   = cache_show
 };
 
--- 2.6.24-rc7-const.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 2.6.24-rc7-const/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -668,7 +668,7 @@ static ssize_t store(struct kobject * ko
 	return 0;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show   = show,
 	.store  = store,
 };
--- 2.6.24-rc7-const.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ 2.6.24-rc7-const/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -377,7 +377,7 @@ static ssize_t store(struct kobject *kob
 	return ret;
 }
 
-static struct sysfs_ops threshold_ops = {
+static const struct sysfs_ops threshold_ops = {
 	.show = show,
 	.store = store,
 };
--- 2.6.24-rc7-const.orig/block/elevator.c
+++ 2.6.24-rc7-const/block/elevator.c
@@ -916,7 +916,7 @@ elv_attr_store(struct kobject *kobj, str
 	return error;
 }
 
-static struct sysfs_ops elv_sysfs_ops = {
+static const struct sysfs_ops elv_sysfs_ops = {
 	.show	= elv_attr_show,
 	.store	= elv_attr_store,
 };
--- 2.6.24-rc7-const.orig/block/genhd.c
+++ 2.6.24-rc7-const/block/genhd.c
@@ -389,7 +389,7 @@ static ssize_t disk_attr_store(struct ko
 	return ret;
 }
 
-static struct sysfs_ops disk_sysfs_ops = {
+static const struct sysfs_ops disk_sysfs_ops = {
 	.show	= &disk_attr_show,
 	.store	= &disk_attr_store,
 };
--- 2.6.24-rc7-const.orig/block/ll_rw_blk.c
+++ 2.6.24-rc7-const/block/ll_rw_blk.c
@@ -4162,7 +4162,7 @@ queue_attr_store(struct kobject *kobj, s
 	return res;
 }
 
-static struct sysfs_ops queue_sysfs_ops = {
+static const struct sysfs_ops queue_sysfs_ops = {
 	.show	= queue_attr_show,
 	.store	= queue_attr_store,
 };
--- 2.6.24-rc7-const.orig/drivers/base/bus.c
+++ 2.6.24-rc7-const/drivers/base/bus.c
@@ -66,7 +66,7 @@ drv_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops driver_sysfs_ops = {
+static const struct sysfs_ops driver_sysfs_ops = {
 	.show	= drv_attr_show,
 	.store	= drv_attr_store,
 };
@@ -125,7 +125,7 @@ bus_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops bus_sysfs_ops = {
+static const struct sysfs_ops bus_sysfs_ops = {
 	.show	= bus_attr_show,
 	.store	= bus_attr_store,
 };
--- 2.6.24-rc7-const.orig/drivers/base/class.c
+++ 2.6.24-rc7-const/drivers/base/class.c
@@ -60,7 +60,7 @@ static void class_release(struct kobject
 			 "be careful\n", class->name);
 }
 
-static struct sysfs_ops class_sysfs_ops = {
+static const struct sysfs_ops class_sysfs_ops = {
 	.show	= class_attr_show,
 	.store	= class_attr_store,
 };
@@ -299,7 +299,7 @@ class_device_attr_store(struct kobject *
 	return ret;
 }
 
-static struct sysfs_ops class_dev_sysfs_ops = {
+static const struct sysfs_ops class_dev_sysfs_ops = {
 	.show	= class_device_attr_show,
 	.store	= class_device_attr_store,
 };
--- 2.6.24-rc7-const.orig/drivers/base/core.c
+++ 2.6.24-rc7-const/drivers/base/core.c
@@ -76,7 +76,7 @@ dev_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops dev_sysfs_ops = {
+static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
 };
--- 2.6.24-rc7-const.orig/drivers/base/sys.c
+++ 2.6.24-rc7-const/drivers/base/sys.c
@@ -55,7 +55,7 @@ sysdev_store(struct kobject * kobj, stru
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= sysdev_show,
 	.store	= sysdev_store,
 };
@@ -105,7 +105,7 @@ static ssize_t sysdev_class_store(struct
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_class_ops = {
+static const struct sysfs_ops sysfs_class_ops = {
 	.show	= sysdev_class_show,
 	.store	= sysdev_class_store,
 };
--- 2.6.24-rc7-const.orig/drivers/cpufreq/cpufreq.c
+++ 2.6.24-rc7-const/drivers/cpufreq/cpufreq.c
@@ -694,7 +694,7 @@ static void cpufreq_sysfs_release(struct
 	complete(&policy->kobj_unregister);
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= show,
 	.store	= store,
 };
--- 2.6.24-rc7-const.orig/drivers/cpuidle/sysfs.c
+++ 2.6.24-rc7-const/drivers/cpuidle/sysfs.c
@@ -186,7 +186,7 @@ static ssize_t cpuidle_store(struct kobj
 	return ret;
 }
 
-static struct sysfs_ops cpuidle_sysfs_ops = {
+static const struct sysfs_ops cpuidle_sysfs_ops = {
 	.show = cpuidle_show,
 	.store = cpuidle_store,
 };
@@ -258,7 +258,7 @@ static ssize_t cpuidle_state_show(struct
 	return ret;
 }
 
-static struct sysfs_ops cpuidle_state_sysfs_ops = {
+static const struct sysfs_ops cpuidle_state_sysfs_ops = {
 	.show = cpuidle_state_show,
 };
 
--- 2.6.24-rc7-const.orig/drivers/pci/pci-driver.c
+++ 2.6.24-rc7-const/drivers/pci/pci-driver.c
@@ -388,7 +388,7 @@ pci_driver_attr_store(struct kobject * k
 	return ret;
 }
 
-static struct sysfs_ops pci_driver_sysfs_ops = {
+static const struct sysfs_ops pci_driver_sysfs_ops = {
 	.show = pci_driver_attr_show,
 	.store = pci_driver_attr_store,
 };
--- 2.6.24-rc7-const.orig/fs/partitions/check.c
+++ 2.6.24-rc7-const/fs/partitions/check.c
@@ -228,7 +228,7 @@ part_attr_store(struct kobject * kobj, s
 	return ret;
 }
 
-static struct sysfs_ops part_sysfs_ops = {
+static const struct sysfs_ops part_sysfs_ops = {
 	.show	=	part_attr_show,
 	.store	=	part_attr_store,
 };
--- 2.6.24-rc7-const.orig/fs/sysfs/file.c
+++ 2.6.24-rc7-const/fs/sysfs/file.c
@@ -52,7 +52,7 @@ subsys_attr_store(struct kobject * kobj,
 	return ret;
 }
 
-static struct sysfs_ops subsys_sysfs_ops = {
+static const struct sysfs_ops subsys_sysfs_ops = {
 	.show	= subsys_attr_show,
 	.store	= subsys_attr_store,
 };
@@ -79,7 +79,7 @@ struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
 	char			* page;
-	struct sysfs_ops	* ops;
+	const struct sysfs_ops	* ops;
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
@@ -101,7 +101,7 @@ static int fill_read_buffer(struct dentr
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -220,7 +220,7 @@ flush_write_buffer(struct dentry * dentr
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -355,7 +355,7 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer * buffer;
-	struct sysfs_ops * ops = NULL;
+	const struct sysfs_ops * ops = NULL;
 	int error;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
--- 2.6.24-rc7-const.orig/include/linux/kobject.h
+++ 2.6.24-rc7-const/include/linux/kobject.h
@@ -101,7 +101,7 @@ extern char * kobject_get_path(struct ko
 
 struct kobj_type {
 	void (*release)(struct kobject *);
-	struct sysfs_ops	* sysfs_ops;
+	const struct sysfs_ops	*sysfs_ops;
 	struct attribute	*const *default_attrs;
 };
 
--- 2.6.24-rc7-const.orig/kernel/params.c
+++ 2.6.24-rc7-const/kernel/params.c
@@ -673,7 +673,7 @@ static ssize_t module_attr_store(struct 
 	return ret;
 }
 
-static struct sysfs_ops module_sysfs_ops = {
+static const struct sysfs_ops module_sysfs_ops = {
 	.show = module_attr_show,
 	.store = module_attr_store,
 };
@@ -730,14 +730,6 @@ static int __init param_sysfs_init(void)
 	return 0;
 }
 subsys_initcall(param_sysfs_init);
-
-#else
-#if 0
-static struct sysfs_ops module_sysfs_ops = {
-	.show = NULL,
-	.store = NULL,
-};
-#endif
 #endif
 
 EXPORT_SYMBOL(param_set_byte);
--- 2.6.24-rc7-const.orig/mm/slub.c
+++ 2.6.24-rc7-const/mm/slub.c
@@ -3940,7 +3940,7 @@ static ssize_t slab_attr_store(struct ko
 	return err;
 }
 
-static struct sysfs_ops slab_sysfs_ops = {
+static const struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
 };


