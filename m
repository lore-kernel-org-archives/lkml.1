Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbYAVUCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbYAVUCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752208AbYAVUB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:01:56 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50532 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYAVUBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:01:54 -0500
Date: Tue, 22 Jan 2008 21:01:52 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: constify data and function pointer tables
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Message-ID: <Pine.LNX.4.64.0801222100490.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


this one also touches like any place that could be found, so I combined 
it.

===Patch begins here===
[PATCH] kernel: constify data and function pointer tables

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/char/apm-emulation.c     |    2 +-
 drivers/char/drm/drmP.h          |    6 +++---
 drivers/char/misc.c              |    2 +-
 drivers/char/tpm/tpm_bios.c      |    4 ++--
 drivers/isdn/capi/kcapi_proc.c   |   10 +++++-----
 drivers/misc/phantom.c           |    2 +-
 drivers/spi/spidev.c             |    2 +-
 fs/afs/proc.c                    |    8 ++++----
 fs/char_dev.c                    |    2 +-
 fs/debugfs/inode.c               |    4 ++--
 fs/hfsplus/inode.c               |    2 +-
 fs/inode.c                       |    2 +-
 fs/locks.c                       |    2 +-
 fs/namespace.c                   |    4 ++--
 include/linux/cgroup.h           |    2 +-
 include/linux/fs.h               |    2 +-
 ipc/util.c                       |    2 +-
 kernel/cgroup.c                  |   12 ++++++------
 kernel/kprobes.c                 |    6 +++---
 kernel/lockdep_proc.c            |    2 +-
 kernel/time/timer_list.c         |    2 +-
 kernel/time/timer_stats.c        |    2 +-
 samples/markers/marker-example.c |    2 +-
 23 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 17d5431..98f140d 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -438,7 +438,7 @@ static int apm_open(struct inode * inode, struct file * filp)
 	return as ? 0 : -ENOMEM;
 }
 
-static struct file_operations apm_bios_fops = {
+static const struct file_operations apm_bios_fops = {
 	.owner		= THIS_MODULE,
 	.read		= apm_read,
 	.poll		= apm_poll,
diff --git a/drivers/char/drm/drmP.h b/drivers/char/drm/drmP.h
index dde02a1..136906b 100644
--- a/drivers/char/drm/drmP.h
+++ b/drivers/char/drm/drmP.h
@@ -612,9 +612,9 @@ struct drm_driver {
 	int major;
 	int minor;
 	int patchlevel;
-	char *name;
-	char *desc;
-	char *date;
+	const char *name;
+	const char *desc;
+	const char *date;
 
 	u32 driver_features;
 	int dev_priv_size;
diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 71c8cd7..035a011 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -90,7 +90,7 @@ static int misc_seq_show(struct seq_file *seq, void *v)
 }
 
 
-static struct seq_operations misc_seq_ops = {
+static const struct seq_operations misc_seq_ops = {
 	.start = misc_seq_start,
 	.next  = misc_seq_next,
 	.stop  = misc_seq_stop,
diff --git a/drivers/char/tpm/tpm_bios.c b/drivers/char/tpm/tpm_bios.c
index 60a2d26..7b6a7fb 100644
--- a/drivers/char/tpm/tpm_bios.c
+++ b/drivers/char/tpm/tpm_bios.c
@@ -344,14 +344,14 @@ static int tpm_ascii_bios_measurements_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations tpm_ascii_b_measurments_seqops = {
+static const struct seq_operations tpm_ascii_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
 	.show = tpm_ascii_bios_measurements_show,
 };
 
-static struct seq_operations tpm_binary_b_measurments_seqops = {
+static const struct seq_operations tpm_binary_b_measurments_seqops = {
 	.start = tpm_bios_measurements_start,
 	.next = tpm_bios_measurements_next,
 	.stop = tpm_bios_measurements_stop,
diff --git a/drivers/isdn/capi/kcapi_proc.c b/drivers/isdn/capi/kcapi_proc.c
index 845a797..ad7865d 100644
--- a/drivers/isdn/capi/kcapi_proc.c
+++ b/drivers/isdn/capi/kcapi_proc.c
@@ -89,14 +89,14 @@ static int contrstats_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations seq_controller_ops = {
+static const struct seq_operations seq_controller_ops = {
 	.start	= controller_start,
 	.next	= controller_next,
 	.stop	= controller_stop,
 	.show	= controller_show,
 };
 
-static struct seq_operations seq_contrstats_ops = {
+static const struct seq_operations seq_contrstats_ops = {
 	.start	= controller_start,
 	.next	= controller_next,
 	.stop	= controller_stop,
@@ -192,14 +192,14 @@ applstats_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations seq_applications_ops = {
+static const struct seq_operations seq_applications_ops = {
 	.start	= applications_start,
 	.next	= applications_next,
 	.stop	= applications_stop,
 	.show	= applications_show,
 };
 
-static struct seq_operations seq_applstats_ops = {
+static const struct seq_operations seq_applstats_ops = {
 	.start	= applications_start,
 	.next	= applications_next,
 	.stop	= applications_stop,
@@ -267,7 +267,7 @@ static int capi_driver_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static struct seq_operations seq_capi_driver_ops = {
+static const struct seq_operations seq_capi_driver_ops = {
 	.start	= capi_driver_start,
 	.next	= capi_driver_next,
 	.stop	= capi_driver_stop,
diff --git a/drivers/misc/phantom.c b/drivers/misc/phantom.c
index cd221fd..8e2736a 100644
--- a/drivers/misc/phantom.c
+++ b/drivers/misc/phantom.c
@@ -249,7 +249,7 @@ static unsigned int phantom_poll(struct file *file, poll_table *wait)
 	return mask;
 }
 
-static struct file_operations phantom_file_ops = {
+static const struct file_operations phantom_file_ops = {
 	.open = phantom_open,
 	.release = phantom_release,
 	.unlocked_ioctl = phantom_ioctl,
diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index b3518ca..be4caed 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -439,7 +439,7 @@ static int spidev_release(struct inode *inode, struct file *filp)
 	return status;
 }
 
-static struct file_operations spidev_fops = {
+static const struct file_operations spidev_fops = {
 	.owner =	THIS_MODULE,
 	/* REVISIT switch to aio primitives, so that userspace
 	 * gets more complete API coverage.  It'll simplify things
diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 846c761..370d656 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -28,7 +28,7 @@ static int afs_proc_cells_show(struct seq_file *m, void *v);
 static ssize_t afs_proc_cells_write(struct file *file, const char __user *buf,
 				    size_t size, loff_t *_pos);
 
-static struct seq_operations afs_proc_cells_ops = {
+static const struct seq_operations afs_proc_cells_ops = {
 	.start	= afs_proc_cells_start,
 	.next	= afs_proc_cells_next,
 	.stop	= afs_proc_cells_stop,
@@ -68,7 +68,7 @@ static void *afs_proc_cell_volumes_next(struct seq_file *p, void *v,
 static void afs_proc_cell_volumes_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_volumes_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_volumes_ops = {
+static const struct seq_operations afs_proc_cell_volumes_ops = {
 	.start	= afs_proc_cell_volumes_start,
 	.next	= afs_proc_cell_volumes_next,
 	.stop	= afs_proc_cell_volumes_stop,
@@ -92,7 +92,7 @@ static void *afs_proc_cell_vlservers_next(struct seq_file *p, void *v,
 static void afs_proc_cell_vlservers_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_vlservers_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_vlservers_ops = {
+static const struct seq_operations afs_proc_cell_vlservers_ops = {
 	.start	= afs_proc_cell_vlservers_start,
 	.next	= afs_proc_cell_vlservers_next,
 	.stop	= afs_proc_cell_vlservers_stop,
@@ -115,7 +115,7 @@ static void *afs_proc_cell_servers_next(struct seq_file *p, void *v,
 static void afs_proc_cell_servers_stop(struct seq_file *p, void *v);
 static int afs_proc_cell_servers_show(struct seq_file *m, void *v);
 
-static struct seq_operations afs_proc_cell_servers_ops = {
+static const struct seq_operations afs_proc_cell_servers_ops = {
 	.start	= afs_proc_cell_servers_start,
 	.next	= afs_proc_cell_servers_next,
 	.stop	= afs_proc_cell_servers_stop,
diff --git a/fs/char_dev.c b/fs/char_dev.c
index c3bfa76..150e38d 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -55,7 +55,7 @@ static struct char_device_struct {
 	unsigned int baseminor;
 	int minorct;
 	char name[64];
-	struct file_operations *fops;
+	const struct file_operations *fops;
 	struct cdev *cdev;		/* will die */
 } *chrdevs[CHRDEV_MAJOR_HASH_SIZE];
 
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 6a713b3..b32b730 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -30,8 +30,8 @@
 #define DEBUGFS_MAGIC	0x64626720
 
 /* declared over in file.c */
-extern struct file_operations debugfs_file_operations;
-extern struct inode_operations debugfs_link_operations;
+extern const struct file_operations debugfs_file_operations;
+extern const struct inode_operations debugfs_link_operations;
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 37744cf..aea1de4 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -279,7 +279,7 @@ static int hfsplus_file_release(struct inode *inode, struct file *file)
 }
 
 extern const struct inode_operations hfsplus_dir_inode_operations;
-extern struct file_operations hfsplus_dir_operations;
+extern const struct file_operations hfsplus_dir_operations;
 
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
diff --git a/fs/inode.c b/fs/inode.c
index ed35383..cca0193 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -111,7 +111,7 @@ static void wake_up_inode(struct inode *inode)
 static struct inode *alloc_inode(struct super_block *sb)
 {
 	static const struct address_space_operations empty_aops;
-	static struct inode_operations empty_iops;
+	static const struct inode_operations empty_iops;
 	static const struct file_operations empty_fops;
 	struct inode *inode;
 
diff --git a/fs/locks.c b/fs/locks.c
index 8b8388e..d389248 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2177,7 +2177,7 @@ static void locks_stop(struct seq_file *f, void *v)
 	unlock_kernel();
 }
 
-struct seq_operations locks_seq_operations = {
+const struct seq_operations locks_seq_operations = {
 	.start	= locks_start,
 	.next	= locks_next,
 	.stop	= locks_stop,
diff --git a/fs/namespace.c b/fs/namespace.c
index 0608388..f967896 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -391,7 +391,7 @@ static int show_vfsmnt(struct seq_file *m, void *v)
 	return err;
 }
 
-struct seq_operations mounts_op = {
+const struct seq_operations mounts_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -429,7 +429,7 @@ static int show_vfsstat(struct seq_file *m, void *v)
 	return err;
 }
 
-struct seq_operations mountstats_op = {
+const struct seq_operations mountstats_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8747932..c843d98 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -33,7 +33,7 @@ extern void cgroup_exit(struct task_struct *p, int run_callbacks);
 extern int cgroupstats_build(struct cgroupstats *stats,
 				struct dentry *dentry);
 
-extern struct file_operations proc_cgroup_operations;
+extern const struct file_operations proc_cgroup_operations;
 
 /* Define the enumeration of all cgroup subsystems */
 #define SUBSYS(_x) _x ## _subsys_id,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..c88626e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -939,7 +939,7 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
 extern int lease_modify(struct file_lock **, int);
 extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
 extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
-extern struct seq_operations locks_seq_operations;
+extern const struct seq_operations locks_seq_operations;
 
 struct fasync_struct {
 	int	magic;
diff --git a/ipc/util.c b/ipc/util.c
index 1aa0ebf..f784a79 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -901,7 +901,7 @@ static int sysvipc_proc_show(struct seq_file *s, void *it)
 	return iface->show(s, it);
 }
 
-static struct seq_operations sysvipc_proc_seqops = {
+static const struct seq_operations sysvipc_proc_seqops = {
 	.start = sysvipc_proc_start,
 	.stop  = sysvipc_proc_stop,
 	.next  = sysvipc_proc_next,
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1a3c239..333f447 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -564,8 +564,8 @@ void cgroup_unlock(void)
 static int cgroup_mkdir(struct inode *dir, struct dentry *dentry, int mode);
 static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry);
 static int cgroup_populate_dir(struct cgroup *cgrp);
-static struct inode_operations cgroup_dir_inode_operations;
-static struct file_operations proc_cgroupstats_operations;
+static const struct inode_operations cgroup_dir_inode_operations;
+static const struct file_operations proc_cgroupstats_operations;
 
 static struct backing_dev_info cgroup_backing_dev_info = {
 	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
@@ -1510,7 +1510,7 @@ static int cgroup_rename(struct inode *old_dir, struct dentry *old_dentry,
 	return simple_rename(old_dir, old_dentry, new_dir, new_dentry);
 }
 
-static struct file_operations cgroup_file_operations = {
+static const struct file_operations cgroup_file_operations = {
 	.read = cgroup_file_read,
 	.write = cgroup_file_write,
 	.llseek = generic_file_llseek,
@@ -1518,7 +1518,7 @@ static struct file_operations cgroup_file_operations = {
 	.release = cgroup_file_release,
 };
 
-static struct inode_operations cgroup_dir_inode_operations = {
+static const struct inode_operations cgroup_dir_inode_operations = {
 	.lookup = simple_lookup,
 	.mkdir = cgroup_mkdir,
 	.rmdir = cgroup_rmdir,
@@ -2390,7 +2390,7 @@ static int cgroup_open(struct inode *inode, struct file *file)
 	return single_open(file, proc_cgroup_show, pid);
 }
 
-struct file_operations proc_cgroup_operations = {
+const struct file_operations proc_cgroup_operations = {
 	.open		= cgroup_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -2419,7 +2419,7 @@ static int cgroupstats_open(struct inode *inode, struct file *file)
 	return single_open(file, proc_cgroupstats_show, 0);
 }
 
-static struct file_operations proc_cgroupstats_operations = {
+static const struct file_operations proc_cgroupstats_operations = {
 	.open = cgroupstats_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index e3a5d81..49e20ec 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -889,7 +889,7 @@ static int __kprobes show_kprobe_addr(struct seq_file *pi, void *v)
 	return 0;
 }
 
-static struct seq_operations kprobes_seq_ops = {
+static const struct seq_operations kprobes_seq_ops = {
 	.start = kprobe_seq_start,
 	.next  = kprobe_seq_next,
 	.stop  = kprobe_seq_stop,
@@ -901,7 +901,7 @@ static int __kprobes kprobes_open(struct inode *inode, struct file *filp)
 	return seq_open(filp, &kprobes_seq_ops);
 }
 
-static struct file_operations debugfs_kprobes_operations = {
+static const struct file_operations debugfs_kprobes_operations = {
 	.open           = kprobes_open,
 	.read           = seq_read,
 	.llseek         = seq_lseek,
@@ -1013,7 +1013,7 @@ static ssize_t write_enabled_file_bool(struct file *file,
 	return count;
 }
 
-static struct file_operations fops_kp = {
+static const struct file_operations fops_kp = {
 	.read =         read_enabled_file_bool,
 	.write =        write_enabled_file_bool,
 };
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 8a135bd..c1e8b3a 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -581,7 +581,7 @@ static int ls_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations lockstat_ops = {
+static const struct seq_operations lockstat_ops = {
 	.start	= ls_start,
 	.next	= ls_next,
 	.stop	= ls_stop,
diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
index 12c5f4c..4eab187 100644
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -265,7 +265,7 @@ static int timer_list_open(struct inode *inode, struct file *filp)
 	return single_open(filp, timer_list_show, NULL);
 }
 
-static struct file_operations timer_list_fops = {
+static const struct file_operations timer_list_fops = {
 	.open		= timer_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index c36bb7e..f120255 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -395,7 +395,7 @@ static int tstats_open(struct inode *inode, struct file *filp)
 	return single_open(filp, tstats_show, NULL);
 }
 
-static struct file_operations tstats_fops = {
+static const struct file_operations tstats_fops = {
 	.open		= tstats_open,
 	.read		= seq_read,
 	.write		= tstats_write,
diff --git a/samples/markers/marker-example.c b/samples/markers/marker-example.c
index 05e438f..27e2668 100644
--- a/samples/markers/marker-example.c
+++ b/samples/markers/marker-example.c
@@ -26,7 +26,7 @@ static int my_open(struct inode *inode, struct file *file)
 	return -EPERM;
 }
 
-static struct file_operations mark_ops = {
+static const struct file_operations mark_ops = {
 	.open = my_open,
 };
 
-- 
1.5.3.4
