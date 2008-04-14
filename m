Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbYDNSWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbYDNSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762607AbYDNSPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:15:55 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:58467 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765400AbYDNSPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:15:54 -0400
Date: Mon, 14 Apr 2008 21:14:48 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] mm/vmstat.c: proper externs
Message-ID: <20080414181448.GX6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper extern declarations for five variables in 
include/linux/vmstat.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 31 Mar 2008
- 25 Feb 2008

 fs/proc/proc_misc.c    |    4 ----
 include/linux/vmstat.h |    6 ++++++
 kernel/sysctl.c        |    2 +-
 mm/vmstat.c            |    1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

b2c1dc15728c7470d3ea5aad9c1227131eb5fc3f diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
index 468805d..622d35b 100644
--- a/fs/proc/proc_misc.c
+++ b/fs/proc/proc_misc.c
@@ -222,7 +222,6 @@ static int meminfo_read_proc(char *page, char **start, off_t off,
 #undef K
 }
 
-extern const struct seq_operations fragmentation_op;
 static int fragmentation_open(struct inode *inode, struct file *file)
 {
 	(void)inode;
@@ -236,7 +235,6 @@ static const struct file_operations fragmentation_file_operations = {
 	.release	= seq_release,
 };
 
-extern const struct seq_operations pagetypeinfo_op;
 static int pagetypeinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &pagetypeinfo_op);
@@ -249,7 +247,6 @@ static const struct file_operations pagetypeinfo_file_ops = {
 	.release	= seq_release,
 };
 
-extern const struct seq_operations zoneinfo_op;
 static int zoneinfo_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &zoneinfo_op);
@@ -346,7 +343,6 @@ static const struct file_operations proc_devinfo_operations = {
 	.release	= seq_release,
 };
 
-extern const struct seq_operations vmstat_op;
 static int vmstat_open(struct inode *inode, struct file *file)
 {
 	return seq_open(file, &vmstat_op);
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 75370ec..0970628 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -40,6 +40,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NR_VM_EVENT_ITEMS
 };
 
+extern const struct seq_operations fragmentation_op;
+extern const struct seq_operations pagetypeinfo_op;
+extern const struct seq_operations zoneinfo_op;
+extern const struct seq_operations vmstat_op;
+extern int sysctl_stat_interval;
+
 #ifdef CONFIG_VM_EVENT_COUNTERS
 /*
  * Light weight per cpu counter implementation.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ffb687c..d78773d 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -42,6 +42,7 @@
 #include <linux/limits.h>
 #include <linux/dcache.h>
 #include <linux/syscalls.h>
+#include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
@@ -76,7 +77,6 @@ extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
 extern int compat_log;
 extern int maps_protect;
-extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 
 /* Constants used for minimum and  maximum */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 422d960..81a6d5f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/cpu.h>
 #include <linux/sched.h>
+#include <linux/vmstat.h>
 
 #ifdef CONFIG_VM_EVENT_COUNTERS
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};

