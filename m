Return-Path: <linux-kernel-owner+w=401wt.eu-S1755297AbYLIWMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbYLIWMQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 17:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYLIWL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 17:11:59 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:41363 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYLIWL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 17:11:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=lzN17rohkI3Qp3QsT/oMVOhDH47OdFHI37sN/LMqneMk12FyPQ8rey5SSUkeIW6kL0
         TJOENs50ZZl+zMNL4FTMoloRoMbmhDHS+TzDM5u39JTc16/J+f4NypNkahRZhhZN1Wek
         I63qJRS5Sd4qPivrb1vXq1QsCRTdNqH7ucKX4=
Message-ID: <493EED2B.4030102@gmail.com>
Date: Tue, 09 Dec 2008 23:11:55 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 26/31] kernel: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 kernel/irq/manage.c          |    2 +-
 kernel/kexec.c               |    2 +-
 kernel/kprobes.c             |    2 +-
 kernel/lockdep.c             |    4 ++--
 kernel/smp.c                 |    2 +-
 kernel/time/tick-broadcast.c |    2 +-
 kernel/time/tick-sched.c     |    2 +-
 kernel/trace/ftrace.c        |    4 ++--
 kernel/trace/ring_buffer.c   |    6 ++++--
 kernel/trace/trace.c         |   10 +++++-----
 kernel/trace/trace_boot.c    |    2 +-
 11 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 801addd..6e3d9f8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -110,7 +110,7 @@ int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
 /*
  * Generic version of the affinity autoselector.
  */
-int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
+static int do_irq_select_affinity(unsigned int irq, struct irq_desc *desc)
 {
 	cpumask_t mask;
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index ac0fde7..07b1078 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -42,7 +42,7 @@
 note_buf_t* crash_notes;
 
 /* vmcoreinfo stuff */
-unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
+static unsigned char vmcoreinfo_data[VMCOREINFO_BYTES];
 u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9f8a3f2..75cd3dc 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -419,7 +419,7 @@ void kretprobe_hash_unlock(struct task_struct *tsk, unsigned long *flags)
 	spin_unlock_irqrestore(hlist_lock, *flags);
 }
 
-void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
+static void kretprobe_table_unlock(unsigned long hash, unsigned long *flags)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_unlock_irqrestore(hlist_lock, *flags);
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 46a4041..eb8d81c 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -984,7 +984,7 @@ static int noinline print_infinite_recursion_bug(void)
 	return 0;
 }
 
-unsigned long __lockdep_count_forward_deps(struct lock_class *class,
+static unsigned long __lockdep_count_forward_deps(struct lock_class *class,
 					   unsigned int depth)
 {
 	struct lock_list *entry;
@@ -1015,7 +1015,7 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 	return ret;
 }
 
-unsigned long __lockdep_count_backward_deps(struct lock_class *class,
+static unsigned long __lockdep_count_backward_deps(struct lock_class *class,
 					    unsigned int depth)
 {
 	struct lock_list *entry;
diff --git a/kernel/smp.c b/kernel/smp.c
index 75c8dde..269e6e6 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,7 +13,7 @@
 
 static DEFINE_PER_CPU(struct call_single_queue, call_single_queue);
 static LIST_HEAD(call_function_queue);
-__cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(call_function_lock);
 
 enum {
 	CSD_FLAG_WAIT		= 0x01,
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f98a1b7..8b244df 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -27,7 +27,7 @@
  * timer stops in C3 state.
  */
 
-struct tick_device tick_broadcast_device;
+static struct tick_device tick_broadcast_device;
 static cpumask_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 static int tick_broadcast_force;
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 342fc9c..446620f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -134,7 +134,7 @@ __setup("nohz=", setup_tick_nohz);
  * value. We do this unconditionally on any cpu, as we don't know whether the
  * cpu, which has the update task assigned is in a long sleep.
  */
-void tick_nohz_update_jiffies(void)
+static void tick_nohz_update_jiffies(void)
 {
 	int cpu = smp_processor_id();
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 78db083..d9519ab 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -817,7 +817,7 @@ ftrace_avail_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-int ftrace_avail_release(struct inode *inode, struct file *file)
+static int ftrace_avail_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct ftrace_iterator *iter = m->private;
@@ -1154,7 +1154,7 @@ void ftrace_set_filter(unsigned char *buf, int len, int reset)
  * is enabled. If @buf is NULL and reset is set, all functions will be enabled
  * for tracing.
  */
-void ftrace_set_notrace(unsigned char *buf, int len, int reset)
+static void ftrace_set_notrace(unsigned char *buf, int len, int reset)
 {
 	ftrace_set_regex(buf, len, reset, 0);
 }
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 668bbb5..44a934c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1418,7 +1418,8 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the entries from.
  */
-unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
+static unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer,
+		int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
@@ -1434,7 +1435,8 @@ unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
  * @buffer: The ring buffer
  * @cpu: The per CPU buffer to get the number of overruns from
  */
-unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer, int cpu)
+static unsigned long ring_buffer_overrun_cpu(struct ring_buffer *buffer,
+		int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d86e325..1ae6df8 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -113,7 +113,7 @@ static DEFINE_PER_CPU(struct trace_array_cpu, max_data);
 static int			tracer_enabled = 1;
 
 /* function tracing enabled */
-int				ftrace_function_enabled;
+static int			ftrace_function_enabled;
 
 /*
  * trace_buf_size is the size in bytes that is allocated
@@ -572,7 +572,7 @@ static int cmdline_idx;
 static DEFINE_SPINLOCK(trace_cmdline_lock);
 
 /* temporary disable recording */
-atomic_t trace_record_cmdline_disabled __read_mostly;
+static atomic_t trace_record_cmdline_disabled __read_mostly;
 
 static void trace_init_cmdlines(void)
 {
@@ -734,7 +734,7 @@ static void ftrace_trace_stack(struct trace_array *tr,
 #endif
 }
 
-void __trace_stack(struct trace_array *tr,
+static void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
 		   int skip)
@@ -1284,7 +1284,7 @@ lat_print_generic(struct trace_seq *s, struct trace_entry *entry, int cpu)
 		trace_seq_puts(s, ".");
 }
 
-unsigned long preempt_mark_thresh = 100;
+static unsigned long preempt_mark_thresh = 100;
 
 static void
 lat_print_timestamp(struct trace_seq *s, u64 abs_usecs,
@@ -1950,7 +1950,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-int tracing_release(struct inode *inode, struct file *file)
+static int tracing_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
 	struct trace_iterator *iter = m->private;
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index d0a5e50..1649989 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -27,7 +27,7 @@ void stop_boot_trace(void)
 	trace_boot_enabled = 0;
 }
 
-void reset_boot_trace(struct trace_array *tr)
+static void reset_boot_trace(struct trace_array *tr)
 {
 	stop_boot_trace();
 }

