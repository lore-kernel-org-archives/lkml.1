Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZFAR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZFAR6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 13:58:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZFAR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 13:58:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:56189 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZFAR6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 13:58:43 -0400
Date: Mon, 1 Jun 2009 17:57:51 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       efault@gmx.de, mtosatti@redhat.com, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Tidy up style details
Message-ID: <tip-22a4f650d686eeaac3629dae1c4294381485efdf@git.kernel.org>
Git-Commit-ID: 22a4f650d686eeaac3629dae1c4294381485efdf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 01 Jun 2009 17:57:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22a4f650d686eeaac3629dae1c4294381485efdf
Gitweb:     http://git.kernel.org/tip/22a4f650d686eeaac3629dae1c4294381485efdf
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 1 Jun 2009 10:13:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 1 Jun 2009 19:55:32 +0200

perf_counter: Tidy up style details

 - whitespace fixlets
 - make local variable definitions more consistent

[ Impact: cleanup ]

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/perf_counter.h |    2 +-
 kernel/perf_counter.c        |   39 +++++++++++++++++++++------------------
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 81ec79c..0e57d8c 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -562,7 +562,7 @@ struct perf_cpu_context {
 	 *
 	 * task, softirq, irq, nmi context
 	 */
-	int			recursion[4];
+	int				recursion[4];
 };
 
 #ifdef CONFIG_PERF_COUNTERS
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index ff8b463..df319c4 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -16,8 +16,9 @@
 #include <linux/file.h>
 #include <linux/poll.h>
 #include <linux/sysfs.h>
-#include <linux/ptrace.h>
+#include <linux/dcache.h>
 #include <linux/percpu.h>
+#include <linux/ptrace.h>
 #include <linux/vmstat.h>
 #include <linux/hardirq.h>
 #include <linux/rculist.h>
@@ -26,7 +27,6 @@
 #include <linux/anon_inodes.h>
 #include <linux/kernel_stat.h>
 #include <linux/perf_counter.h>
-#include <linux/dcache.h>
 
 #include <asm/irq_regs.h>
 
@@ -65,7 +65,9 @@ void __weak hw_perf_disable(void)		{ barrier(); }
 void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak hw_perf_counter_setup(int cpu)	{ barrier(); }
-int __weak hw_perf_group_sched_in(struct perf_counter *group_leader,
+
+int __weak
+hw_perf_group_sched_in(struct perf_counter *group_leader,
 	       struct perf_cpu_context *cpuctx,
 	       struct perf_counter_context *ctx, int cpu)
 {
@@ -127,8 +129,8 @@ static void put_ctx(struct perf_counter_context *ctx)
  * This has to cope with with the fact that until it is locked,
  * the context could get moved to another task.
  */
-static struct perf_counter_context *perf_lock_task_context(
-				struct task_struct *task, unsigned long *flags)
+static struct perf_counter_context *
+perf_lock_task_context(struct task_struct *task, unsigned long *flags)
 {
 	struct perf_counter_context *ctx;
 
@@ -1330,9 +1332,9 @@ __perf_counter_init_context(struct perf_counter_context *ctx,
 
 static struct perf_counter_context *find_get_context(pid_t pid, int cpu)
 {
-	struct perf_cpu_context *cpuctx;
-	struct perf_counter_context *ctx;
 	struct perf_counter_context *parent_ctx;
+	struct perf_counter_context *ctx;
+	struct perf_cpu_context *cpuctx;
 	struct task_struct *task;
 	unsigned long flags;
 	int err;
@@ -1664,8 +1666,8 @@ int perf_counter_task_disable(void)
  */
 void perf_counter_update_userpage(struct perf_counter *counter)
 {
-	struct perf_mmap_data *data;
 	struct perf_counter_mmap_page *userpg;
+	struct perf_mmap_data *data;
 
 	rcu_read_lock();
 	data = rcu_dereference(counter->data);
@@ -1769,10 +1771,11 @@ fail:
 
 static void __perf_mmap_data_free(struct rcu_head *rcu_head)
 {
-	struct perf_mmap_data *data = container_of(rcu_head,
-			struct perf_mmap_data, rcu_head);
+	struct perf_mmap_data *data;
 	int i;
 
+	data = container_of(rcu_head, struct perf_mmap_data, rcu_head);
+
 	free_page((unsigned long)data->user_page);
 	for (i = 0; i < data->nr_pages; i++)
 		free_page((unsigned long)data->data_pages[i]);
@@ -1801,8 +1804,7 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 	struct perf_counter *counter = vma->vm_file->private_data;
 
 	WARN_ON_ONCE(counter->ctx->parent_ctx);
-	if (atomic_dec_and_mutex_lock(&counter->mmap_count,
-				      &counter->mmap_mutex)) {
+	if (atomic_dec_and_mutex_lock(&counter->mmap_count, &counter->mmap_mutex)) {
 		struct user_struct *user = current_user();
 
 		atomic_long_sub(counter->data->nr_pages + 1, &user->locked_vm);
@@ -1821,11 +1823,11 @@ static struct vm_operations_struct perf_mmap_vmops = {
 static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct perf_counter *counter = file->private_data;
+	unsigned long user_locked, user_lock_limit;
 	struct user_struct *user = current_user();
+	unsigned long locked, lock_limit;
 	unsigned long vma_size;
 	unsigned long nr_pages;
-	unsigned long user_locked, user_lock_limit;
-	unsigned long locked, lock_limit;
 	long user_extra, extra;
 	int ret = 0;
 
@@ -1900,8 +1902,8 @@ unlock:
 
 static int perf_fasync(int fd, struct file *filp, int on)
 {
-	struct perf_counter *counter = filp->private_data;
 	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct perf_counter *counter = filp->private_data;
 	int retval;
 
 	mutex_lock(&inode->i_mutex);
@@ -2412,8 +2414,8 @@ static void perf_counter_output(struct perf_counter *counter,
  */
 
 struct perf_comm_event {
-	struct task_struct 	*task;
-	char 			*comm;
+	struct task_struct	*task;
+	char			*comm;
 	int			comm_size;
 
 	struct {
@@ -2932,6 +2934,7 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 			       int nmi, struct pt_regs *regs, u64 addr)
 {
 	int neg = atomic64_add_negative(nr, &counter->hw.count);
+
 	if (counter->hw.irq_period && !neg)
 		perf_swcounter_overflow(counter, nmi, regs, addr);
 }
@@ -3526,7 +3529,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	/*
 	 * Make the child state follow the state of the parent counter,
 	 * not its hw_event.disabled bit.  We hold the parent's mutex,
-	 * so we won't race with perf_counter_{en,dis}able_family.
+	 * so we won't race with perf_counter_{en, dis}able_family.
 	 */
 	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
 		child_counter->state = PERF_COUNTER_STATE_INACTIVE;
