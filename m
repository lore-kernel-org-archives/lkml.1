Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYAVUBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYAVUBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 15:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYAVUAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 15:00:49 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:49480 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbYAVUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 15:00:47 -0500
Date: Tue, 22 Jan 2008 21:00:46 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: [PATCH] procfs: constify function pointer tables
In-Reply-To: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
Message-ID: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This touches so many different places that I did not feel like creating 
a miniscule patch for each architecture. I hope that is ok.

===Patch begins===
[PATCH] procfs: constify function pointer tables

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 arch/alpha/kernel/setup.c     |    2 +-
 arch/blackfin/kernel/setup.c  |    2 +-
 arch/cris/kernel/setup.c      |    2 +-
 arch/frv/kernel/setup.c       |    2 +-
 arch/h8300/kernel/setup.c     |    2 +-
 arch/m32r/kernel/setup.c      |    2 +-
 arch/m68k/kernel/setup.c      |    2 +-
 arch/m68knommu/kernel/setup.c |    2 +-
 arch/parisc/kernel/setup.c    |    2 +-
 arch/ppc/kernel/setup.c       |    2 +-
 arch/v850/kernel/procfs.c     |    2 +-
 arch/xtensa/kernel/setup.c    |    2 +-
 fs/proc/base.c                |    6 +++---
 fs/proc/nommu.c               |    2 +-
 fs/proc/proc_misc.c           |   22 +++++++++++-----------
 fs/proc/proc_sysctl.c         |    4 ++--
 fs/proc/proc_tty.c            |    2 +-
 fs/proc/task_mmu.c            |    8 ++++----
 fs/proc/task_nommu.c          |    2 +-
 19 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index bd5e68c..823f18e 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -1472,7 +1472,7 @@ c_stop(struct seq_file *f, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index d282201..d67cf54 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -691,7 +691,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next = c_next,
 	.stop = c_stop,
diff --git a/arch/cris/kernel/setup.c b/arch/cris/kernel/setup.c
index 65466c4..e42aedd 100644
--- a/arch/cris/kernel/setup.c
+++ b/arch/cris/kernel/setup.c
@@ -180,7 +180,7 @@ static void c_stop(struct seq_file *m, void *v)
 
 extern int show_cpuinfo(struct seq_file *m, void *v);
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next  = c_next,
 	.stop  = c_stop,
diff --git a/arch/frv/kernel/setup.c b/arch/frv/kernel/setup.c
index a74c087..582e832 100644
--- a/arch/frv/kernel/setup.c
+++ b/arch/frv/kernel/setup.c
@@ -1109,7 +1109,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/h8300/kernel/setup.c b/arch/h8300/kernel/setup.c
index b2e86d0..fb0f809 100644
--- a/arch/h8300/kernel/setup.c
+++ b/arch/h8300/kernel/setup.c
@@ -236,7 +236,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/m32r/kernel/setup.c b/arch/m32r/kernel/setup.c
index d648143..c815fbe 100644
--- a/arch/m32r/kernel/setup.c
+++ b/arch/m32r/kernel/setup.c
@@ -366,7 +366,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start = c_start,
 	.next = c_next,
 	.stop = c_stop,
diff --git a/arch/m68k/kernel/setup.c b/arch/m68k/kernel/setup.c
index ed3a4ca..6a8afa9 100644
--- a/arch/m68k/kernel/setup.c
+++ b/arch/m68k/kernel/setup.c
@@ -449,7 +449,7 @@ static void *c_next(struct seq_file *m, void *v, loff_t *pos)
 static void c_stop(struct seq_file *m, void *v)
 {
 }
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/m68knommu/kernel/setup.c b/arch/m68knommu/kernel/setup.c
index 332345d..001181a 100644
--- a/arch/m68knommu/kernel/setup.c
+++ b/arch/m68knommu/kernel/setup.c
@@ -263,7 +263,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index c44b8c5..39e7c5a 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -190,7 +190,7 @@ c_stop (struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= c_start,
 	.next	= c_next,
 	.stop	= c_stop,
diff --git a/arch/ppc/kernel/setup.c b/arch/ppc/kernel/setup.c
index 5255bd8..9b38b0b 100644
--- a/arch/ppc/kernel/setup.c
+++ b/arch/ppc/kernel/setup.c
@@ -277,7 +277,7 @@ static void c_stop(struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start =c_start,
 	.next =	c_next,
 	.stop =	c_stop,
diff --git a/arch/v850/kernel/procfs.c b/arch/v850/kernel/procfs.c
index e6f9d06..e433cde 100644
--- a/arch/v850/kernel/procfs.c
+++ b/arch/v850/kernel/procfs.c
@@ -59,7 +59,7 @@ static void cpuinfo_stop (struct seq_file *m, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op = {
+const struct seq_operations cpuinfo_op = {
 	.start	= cpuinfo_start,
 	.next	= cpuinfo_next,
 	.stop	= cpuinfo_stop,
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 2e8d398..b80f2cb 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -469,7 +469,7 @@ c_stop(struct seq_file *f, void *v)
 {
 }
 
-struct seq_operations cpuinfo_op =
+const struct seq_operations cpuinfo_op =
 {
 	start:  c_start,
 	next:   c_next,
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 7411bfb..1784c97 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -435,7 +435,7 @@ static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
 };
 
-extern struct seq_operations mounts_op;
+extern const struct seq_operations mounts_op;
 struct proc_mounts {
 	struct seq_file m;
 	int event;
@@ -514,7 +514,7 @@ static const struct file_operations proc_mounts_operations = {
 	.poll		= mounts_poll,
 };
 
-extern struct seq_operations mountstats_op;
+extern const struct seq_operations mountstats_op;
 static int mountstats_open(struct inode *inode, struct file *file)
 {
 	int ret = seq_open(file, &mountstats_op);
@@ -895,7 +895,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	return end - buffer;
 }
 
-static struct file_operations proc_clear_refs_operations = {
+static const struct file_operations proc_clear_refs_operations = {
 	.write		= clear_refs_write,
 };
 #endif
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index 22f789d..5d9147b 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -116,7 +116,7 @@ static void *nommu_vma_list_next(struct seq_file *m, void *v, loff_t *pos)
 	return rb_next((struct rb_node *) v);
 }
 
-static struct seq_operations proc_nommu_vma_list_seqop = {
+static const struct seq_operations proc_nommu_vma_list_seqop = {
 	.start	= nommu_vma_list_start,
 	.next	= nommu_vma_list_next,
 	.stop	= nommu_vma_list_stop,
diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 3462bfd..7315786 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -216,7 +216,7 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 #undef K
 }
 
-extern struct seq_operations fragmentation_op;
+extern const struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -230,7 +230,7 @@ static const struct file_operations fragmentation_file_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations pagetypeinfo_op;
+extern const struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -243,7 +243,7 @@ static const struct file_operations pagetypeinfo_file_ops = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations zoneinfo_op;
+extern const struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -268,7 +268,7 @@ static int version_read_proc(char *page, char **start, off_t off,
 	return proc_calc_metrics(page, start, off, count, eof, len);
 }
 
-extern struct seq_operations cpuinfo_op;
+extern const struct seq_operations cpuinfo_op;
 static int cpuinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &cpuinfo_op);
@@ -321,7 +321,7 @@ static void devinfo_stop(struct seq_file *f, void *v)
 	/* Nothing to do */
 }
 
-static struct seq_operations devinfo_ops = {
+static const struct seq_operations devinfo_ops = {
 	.start = devinfo_start,
 	.next  = devinfo_next,
 	.stop  = devinfo_stop,
@@ -340,7 +340,7 @@ static const struct file_operations proc_devinfo_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations vmstat_op;
+extern const struct seq_operations vmstat_op;
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
@@ -371,7 +371,7 @@ static int stram_read_proc(char *page, char **start, off_t off,
 #endif
 
 #ifdef CONFIG_BLOCK
-extern struct seq_operations partitions_op;
+extern const struct seq_operations partitions_op;
 static int partitions_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &partitions_op);
@@ -383,7 +383,7 @@ static const struct file_operations proc_partitions_operations = {
 	.release	= seq_release,
 };
 
-extern struct seq_operations diskstats_op;
+extern const struct seq_operations diskstats_op;
 static int diskstats_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &diskstats_op);
@@ -397,7 +397,7 @@ static const struct file_operations proc_diskstats_operations = {
 #endif
 
 #ifdef CONFIG_MODULES
-extern struct seq_operations modules_op;
+extern const struct seq_operations modules_op;
 static int modules_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &modules_op);
@@ -424,7 +424,7 @@ static const struct file_operations proc_slabinfo_operations = {
 };
 
 #ifdef CONFIG_DEBUG_SLAB_LEAK
-extern struct seq_operations slabstats_op;
+extern const struct seq_operations slabstats_op;
 static int slabstats_open(struct inode *inode, struct file *file)
 {
 	unsigned long *n = kzalloc(PAGE_SIZE, GFP_KERNEL);
@@ -599,7 +599,7 @@ static void int_seq_stop(struct seq_file *f, void *v)
 
 
 extern int show_interrupts(struct seq_file *f, void *v); /* In arch code */
-static struct seq_operations int_seq_ops = {
+static const struct seq_operations int_seq_ops = {
 	.start = int_seq_start,
 	.next  = int_seq_next,
 	.stop  = int_seq_stop,
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 4e57fcf..b9cb23c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -9,7 +9,7 @@
 
 static struct dentry_operations proc_sys_dentry_operations;
 static const struct file_operations proc_sys_file_operations;
-static struct inode_operations proc_sys_inode_operations;
+static const struct inode_operations proc_sys_inode_operations;
 
 static void proc_sys_refresh_inode(struct inode *inode, struct ctl_table *table)
 {
@@ -446,7 +446,7 @@ static const struct file_operations proc_sys_file_operations = {
 	.readdir	= proc_sys_readdir,
 };
 
-static struct inode_operations proc_sys_inode_operations = {
+static const struct inode_operations proc_sys_inode_operations = {
 	.lookup		= proc_sys_lookup,
 	.permission	= proc_sys_permission,
 	.setattr	= proc_sys_setattr,
diff --git a/fs/proc/proc_tty.c b/fs/proc/proc_tty.c
index 2284622..6d3da93 100644
--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -120,7 +120,7 @@ static void t_stop(struct seq_file *m, void *v)
 	mutex_unlock(&tty_mutex);
 }
 
-static struct seq_operations tty_drivers_op = {
+static const struct seq_operations tty_drivers_op = {
 	.start	= t_start,
 	.next	= t_next,
 	.stop	= t_stop,
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8043a3e..2c2755d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -467,14 +467,14 @@ static void m_stop(struct seq_file *m, void *v)
 		put_task_struct(priv->task);
 }
 
-static struct seq_operations proc_pid_maps_op = {
+static const struct seq_operations proc_pid_maps_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
 	.show	= show_map
 };
 
-static struct seq_operations proc_pid_smaps_op = {
+static const struct seq_operations proc_pid_smaps_op = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
@@ -482,7 +482,7 @@ static struct seq_operations proc_pid_smaps_op = {
 };
 
 static int do_maps_open(struct inode *inode, struct file *file,
-			struct seq_operations *ops)
+			const struct seq_operations *ops)
 {
 	struct proc_maps_private *priv;
 	int ret = -ENOMEM;
@@ -526,7 +526,7 @@ static int show_numa_map_checked(struct seq_file *m, void *v)
 	return show_numa_map(m, v);
 }
 
-static struct seq_operations proc_pid_numa_maps_op = {
+static const struct seq_operations proc_pid_numa_maps_op = {
         .start  = m_start,
         .next   = m_next,
         .stop   = m_stop,
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 1932c2c..e5a3d8b 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -199,7 +199,7 @@ static void *m_next(struct seq_file *m, void *_vml, loff_t *pos)
 	return vml ? vml->next : NULL;
 }
 
-static struct seq_operations proc_pid_maps_ops = {
+static const struct seq_operations proc_pid_maps_ops = {
 	.start	= m_start,
 	.next	= m_next,
 	.stop	= m_stop,
-- 
1.5.3.4

