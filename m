Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYAVNbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYAVNbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 08:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760926AbYAVNb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 08:31:28 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:26903
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760234AbYAVNb1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 08:31:27 -0500
Message-Id: <4795FE5D.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 22 Jan 2008 13:31:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, <tony.luck@intel.com>, <axboe@kernel.dk>
Subject: [PATCH 3/3] constify struct sysfs_ops (against -mm)
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
 block/ll_rw_blk.c                       |    2 +-
 drivers/base/bus.c                      |    4 ++--
 drivers/base/class.c                    |    4 ++--
 drivers/base/core.c                     |    2 +-
 drivers/base/sys.c                      |    4 ++--
 drivers/cpufreq/cpufreq.c               |    2 +-
 drivers/cpuidle/sysfs.c                 |    4 ++--
 fs/sysfs/file.c                         |    8 ++++----
 include/linux/kobject.h                 |    2 +-
 kernel/params.c                         |    2 +-
 mm/slub.c                               |    2 +-
 16 files changed, 23 insertions(+), 23 deletions(-)

--- 2.6.24-rc8-mm1-const.orig/Documentation/kobject.txt
+++ 2.6.24-rc8-mm1-const/Documentation/kobject.txt
@@ -262,7 +262,7 @@ kobj_type:
 
     struct kobj_type {
 	    void (*release)(struct kobject *);
-	    struct sysfs_ops	*sysfs_ops;
+	    const struct sysfs_ops *sysfs_ops;
 	    struct attribute	*const *default_attrs;
     };
 
--- 2.6.24-rc8-mm1-const.orig/arch/ia64/kernel/topology.c
+++ 2.6.24-rc8-mm1-const/arch/ia64/kernel/topology.c
@@ -267,7 +267,7 @@ static ssize_t cache_show(struct kobject
 	return ret;
 }
 
-static struct sysfs_ops cache_sysfs_ops = {
+static const struct sysfs_ops cache_sysfs_ops = {
 	.show   = cache_show
 };
 
--- 2.6.24-rc8-mm1-const.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 2.6.24-rc8-mm1-const/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -668,7 +668,7 @@ static ssize_t store(struct kobject * ko
 	return 0;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show   = show,
 	.store  = store,
 };
--- 2.6.24-rc8-mm1-const.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ 2.6.24-rc8-mm1-const/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -377,7 +377,7 @@ static ssize_t store(struct kobject *kob
 	return ret;
 }
 
-static struct sysfs_ops threshold_ops = {
+static const struct sysfs_ops threshold_ops = {
 	.show = show,
 	.store = store,
 };
--- 2.6.24-rc8-mm1-const.orig/block/elevator.c
+++ 2.6.24-rc8-mm1-const/block/elevator.c
@@ -914,7 +914,7 @@ elv_attr_store(struct kobject *kobj, str
 	return error;
 }
 
-static struct sysfs_ops elv_sysfs_ops = {
+static const struct sysfs_ops elv_sysfs_ops = {
 	.show	= elv_attr_show,
 	.store	= elv_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/block/ll_rw_blk.c
+++ 2.6.24-rc8-mm1-const/block/ll_rw_blk.c
@@ -4184,7 +4184,7 @@ queue_attr_store(struct kobject *kobj, s
 	return res;
 }
 
-static struct sysfs_ops queue_sysfs_ops = {
+static const struct sysfs_ops queue_sysfs_ops = {
 	.show	= queue_attr_show,
 	.store	= queue_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/base/bus.c
+++ 2.6.24-rc8-mm1-const/drivers/base/bus.c
@@ -71,7 +71,7 @@ drv_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops driver_sysfs_ops = {
+static const struct sysfs_ops driver_sysfs_ops = {
 	.show	= drv_attr_show,
 	.store	= drv_attr_store,
 };
@@ -120,7 +120,7 @@ bus_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops bus_sysfs_ops = {
+static const struct sysfs_ops bus_sysfs_ops = {
 	.show	= bus_attr_show,
 	.store	= bus_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/base/class.c
+++ 2.6.24-rc8-mm1-const/drivers/base/class.c
@@ -61,7 +61,7 @@ static void class_release(struct kobject
 			 "be careful\n", class->name);
 }
 
-static struct sysfs_ops class_sysfs_ops = {
+static const struct sysfs_ops class_sysfs_ops = {
 	.show	= class_attr_show,
 	.store	= class_attr_store,
 };
@@ -307,7 +307,7 @@ class_device_attr_store(struct kobject *
 	return ret;
 }
 
-static struct sysfs_ops class_dev_sysfs_ops = {
+static const struct sysfs_ops class_dev_sysfs_ops = {
 	.show	= class_device_attr_show,
 	.store	= class_device_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/base/core.c
+++ 2.6.24-rc8-mm1-const/drivers/base/core.c
@@ -76,7 +76,7 @@ dev_attr_store(struct kobject * kobj, st
 	return ret;
 }
 
-static struct sysfs_ops dev_sysfs_ops = {
+static const struct sysfs_ops dev_sysfs_ops = {
 	.show	= dev_attr_show,
 	.store	= dev_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/base/sys.c
+++ 2.6.24-rc8-mm1-const/drivers/base/sys.c
@@ -53,7 +53,7 @@ sysdev_store(struct kobject * kobj, stru
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= sysdev_show,
 	.store	= sysdev_store,
 };
@@ -103,7 +103,7 @@ static ssize_t sysdev_class_store(struct
 	return -EIO;
 }
 
-static struct sysfs_ops sysfs_class_ops = {
+static const struct sysfs_ops sysfs_class_ops = {
 	.show	= sysdev_class_show,
 	.store	= sysdev_class_store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/cpufreq/cpufreq.c
+++ 2.6.24-rc8-mm1-const/drivers/cpufreq/cpufreq.c
@@ -725,7 +725,7 @@ static void cpufreq_sysfs_release(struct
 	complete(&policy->kobj_unregister);
 }
 
-static struct sysfs_ops sysfs_ops = {
+static const struct sysfs_ops sysfs_ops = {
 	.show	= show,
 	.store	= store,
 };
--- 2.6.24-rc8-mm1-const.orig/drivers/cpuidle/sysfs.c
+++ 2.6.24-rc8-mm1-const/drivers/cpuidle/sysfs.c
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
 
--- 2.6.24-rc8-mm1-const.orig/fs/sysfs/file.c
+++ 2.6.24-rc8-mm1-const/fs/sysfs/file.c
@@ -50,7 +50,7 @@ struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
 	char			* page;
-	struct sysfs_ops	* ops;
+	const struct sysfs_ops	* ops;
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
@@ -72,7 +72,7 @@ static int fill_read_buffer(struct dentr
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
 
@@ -191,7 +191,7 @@ flush_write_buffer(struct dentry * dentr
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
@@ -326,7 +326,7 @@ static int sysfs_open_file(struct inode 
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct kobject *kobj = attr_sd->s_parent->s_dir.kobj;
 	struct sysfs_buffer *buffer;
-	struct sysfs_ops *ops;
+	const struct sysfs_ops *ops;
 	int error = -EACCES;
 	char *p;
 
--- 2.6.24-rc8-mm1-const.orig/include/linux/kobject.h
+++ 2.6.24-rc8-mm1-const/include/linux/kobject.h
@@ -107,7 +107,7 @@ extern char * kobject_get_path(struct ko
 
 struct kobj_type {
 	void (*release)(struct kobject *);
-	struct sysfs_ops	* sysfs_ops;
+	const struct sysfs_ops	*sysfs_ops;
 	struct attribute	*const *default_attrs;
 };
 
--- 2.6.24-rc8-mm1-const.orig/kernel/params.c
+++ 2.6.24-rc8-mm1-const/kernel/params.c
@@ -672,7 +672,7 @@ static ssize_t module_attr_store(struct 
 	return ret;
 }
 
-static struct sysfs_ops module_sysfs_ops = {
+static const struct sysfs_ops module_sysfs_ops = {
 	.show = module_attr_show,
 	.store = module_attr_store,
 };
--- 2.6.24-rc8-mm1-const.orig/mm/slub.c
+++ 2.6.24-rc8-mm1-const/mm/slub.c
@@ -4114,7 +4114,7 @@ static ssize_t slab_attr_store(struct ko
 	return err;
 }
 
-static struct sysfs_ops slab_sysfs_ops = {
+static const struct sysfs_ops slab_sysfs_ops = {
 	.show = slab_attr_show,
 	.store = slab_attr_store,
 };


