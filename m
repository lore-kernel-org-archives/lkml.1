Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbYGVT2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbYGVT2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:28:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754818AbYGVTYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:08 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:40544 "EHLO
	SG2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552AbYGVTX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:23:59 -0400
X-BigFish: VPS26(z37d4jzzz10d3izzz32i87il43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9VC-01-8PK-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 07/24] drivers/oprofile: Coding style fixes in buffer_sync.c
Date: Tue, 22 Jul 2008 21:08:51 +0200
Message-ID: <1216753748-11261-8-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:39.0355 (UTC) FILETIME=[71E61AB0:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/buffer_sync.c |  111 ++++++++++++++++++++-------------------
 1 files changed, 57 insertions(+), 54 deletions(-)

diff --git a/drivers/oprofile/buffer_sync.c b/drivers/oprofile/buffer_sync.c
index 9304c45..69a7327 100644
--- a/drivers/oprofile/buffer_sync.c
+++ b/drivers/oprofile/buffer_sync.c
@@ -33,7 +33,7 @@
 #include "event_buffer.h"
 #include "cpu_buffer.h"
 #include "buffer_sync.h"
- 
+
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
 static cpumask_t marked_cpus = CPU_MASK_NONE;
@@ -48,10 +48,11 @@ static void process_task_mortuary(void);
  * Can be invoked from softirq via RCU callback due to
  * call_rcu() of the task struct, hence the _irqsave.
  */
-static int task_free_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_free_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long flags;
-	struct task_struct * task = data;
+	struct task_struct *task = data;
 	spin_lock_irqsave(&task_mortuary, flags);
 	list_add(&task->tasks, &dying_tasks);
 	spin_unlock_irqrestore(&task_mortuary, flags);
@@ -62,13 +63,14 @@ static int task_free_notify(struct notifier_block * self, unsigned long val, voi
 /* The task is on its way out. A sync of the buffer means we can catch
  * any remaining samples for this task.
  */
-static int task_exit_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+task_exit_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	/* To avoid latency problems, we only process the current CPU,
 	 * hoping that most samples for the task are on this CPU
 	 */
 	sync_buffer(raw_smp_processor_id());
-  	return 0;
+	return 0;
 }
 
 
@@ -77,11 +79,12 @@ static int task_exit_notify(struct notifier_block * self, unsigned long val, voi
  * we don't lose any. This does not have to be exact, it's a QoI issue
  * only.
  */
-static int munmap_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+munmap_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 	unsigned long addr = (unsigned long)data;
-	struct mm_struct * mm = current->mm;
-	struct vm_area_struct * mpnt;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *mpnt;
 
 	down_read(&mm->mmap_sem);
 
@@ -99,11 +102,12 @@ static int munmap_notify(struct notifier_block * self, unsigned long val, void *
 	return 0;
 }
 
- 
+
 /* We need to be told about new modules so we don't attribute to a previously
  * loaded module, or drop the samples on the floor.
  */
-static int module_load_notify(struct notifier_block * self, unsigned long val, void * data)
+static int
+module_load_notify(struct notifier_block *self, unsigned long val, void *data)
 {
 #ifdef CONFIG_MODULES
 	if (val != MODULE_STATE_COMING)
@@ -118,7 +122,7 @@ static int module_load_notify(struct notifier_block * self, unsigned long val, v
 	return 0;
 }
 
- 
+
 static struct notifier_block task_free_nb = {
 	.notifier_call	= task_free_notify,
 };
@@ -135,7 +139,7 @@ static struct notifier_block module_load_nb = {
 	.notifier_call = module_load_notify,
 };
 
- 
+
 static void end_sync(void)
 {
 	end_cpu_work();
@@ -208,14 +212,14 @@ static inline unsigned long fast_get_dcookie(struct path *path)
  * not strictly necessary but allows oprofile to associate
  * shared-library samples with particular applications
  */
-static unsigned long get_exec_dcookie(struct mm_struct * mm)
+static unsigned long get_exec_dcookie(struct mm_struct *mm)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
- 
+	struct vm_area_struct *vma;
+
 	if (!mm)
 		goto out;
- 
+
 	for (vma = mm->mmap; vma; vma = vma->vm_next) {
 		if (!vma->vm_file)
 			continue;
@@ -235,13 +239,14 @@ out:
  * sure to do this lookup before a mm->mmap modification happens so
  * we don't lose track.
  */
-static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, off_t * offset)
+static unsigned long
+lookup_dcookie(struct mm_struct *mm, unsigned long addr, off_t *offset)
 {
 	unsigned long cookie = NO_COOKIE;
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 
 	for (vma = find_vma(mm, addr); vma; vma = vma->vm_next) {
- 
+
 		if (addr < vma->vm_start || addr >= vma->vm_end)
 			continue;
 
@@ -265,7 +270,7 @@ static unsigned long lookup_dcookie(struct mm_struct * mm, unsigned long addr, o
 
 
 static unsigned long last_cookie = INVALID_COOKIE;
- 
+
 static void add_cpu_switch(int i)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -278,16 +283,16 @@ static void add_kernel_ctx_switch(unsigned int in_kernel)
 {
 	add_event_entry(ESCAPE_CODE);
 	if (in_kernel)
-		add_event_entry(KERNEL_ENTER_SWITCH_CODE); 
+		add_event_entry(KERNEL_ENTER_SWITCH_CODE);
 	else
-		add_event_entry(KERNEL_EXIT_SWITCH_CODE); 
+		add_event_entry(KERNEL_EXIT_SWITCH_CODE);
 }
- 
+
 static void
-add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
+add_user_ctx_switch(struct task_struct const *task, unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
-	add_event_entry(CTX_SWITCH_CODE); 
+	add_event_entry(CTX_SWITCH_CODE);
 	add_event_entry(task->pid);
 	add_event_entry(cookie);
 	/* Another code for daemon back-compat */
@@ -296,7 +301,7 @@ add_user_ctx_switch(struct task_struct const * task, unsigned long cookie)
 	add_event_entry(task->tgid);
 }
 
- 
+
 static void add_cookie_switch(unsigned long cookie)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -304,7 +309,7 @@ static void add_cookie_switch(unsigned long cookie)
 	add_event_entry(cookie);
 }
 
- 
+
 static void add_trace_begin(void)
 {
 	add_event_entry(ESCAPE_CODE);
@@ -319,13 +324,13 @@ static void add_sample_entry(unsigned long offset, unsigned long event)
 }
 
 
-static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
+static int add_us_sample(struct mm_struct *mm, struct op_sample *s)
 {
 	unsigned long cookie;
 	off_t offset;
- 
- 	cookie = lookup_dcookie(mm, s->eip, &offset);
- 
+
+	cookie = lookup_dcookie(mm, s->eip, &offset);
+
 	if (cookie == INVALID_COOKIE) {
 		atomic_inc(&oprofile_stats.sample_lost_no_mapping);
 		return 0;
@@ -341,13 +346,13 @@ static int add_us_sample(struct mm_struct * mm, struct op_sample * s)
 	return 1;
 }
 
- 
+
 /* Add a sample to the global event buffer. If possible the
  * sample is converted into a persistent dentry/offset pair
  * for later lookup from userspace.
  */
 static int
-add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
+add_sample(struct mm_struct *mm, struct op_sample *s, int in_kernel)
 {
 	if (in_kernel) {
 		add_sample_entry(s->eip, s->event);
@@ -359,9 +364,9 @@ add_sample(struct mm_struct * mm, struct op_sample * s, int in_kernel)
 	}
 	return 0;
 }
- 
 
-static void release_mm(struct mm_struct * mm)
+
+static void release_mm(struct mm_struct *mm)
 {
 	if (!mm)
 		return;
@@ -370,9 +375,9 @@ static void release_mm(struct mm_struct * mm)
 }
 
 
-static struct mm_struct * take_tasks_mm(struct task_struct * task)
+static struct mm_struct *take_tasks_mm(struct task_struct *task)
 {
-	struct mm_struct * mm = get_task_mm(task);
+	struct mm_struct *mm = get_task_mm(task);
 	if (mm)
 		down_read(&mm->mmap_sem);
 	return mm;
@@ -383,10 +388,10 @@ static inline int is_code(unsigned long val)
 {
 	return val == ESCAPE_CODE;
 }
- 
+
 
 /* "acquire" as many cpu buffer slots as we can */
-static unsigned long get_slots(struct oprofile_cpu_buffer * b)
+static unsigned long get_slots(struct oprofile_cpu_buffer *b)
 {
 	unsigned long head = b->head_pos;
 	unsigned long tail = b->tail_pos;
@@ -412,7 +417,7 @@ static unsigned long get_slots(struct oprofile_cpu_buffer * b)
 }
 
 
-static void increment_tail(struct oprofile_cpu_buffer * b)
+static void increment_tail(struct oprofile_cpu_buffer *b)
 {
 	unsigned long new_tail = b->tail_pos + 1;
 
@@ -435,8 +440,8 @@ static void process_task_mortuary(void)
 {
 	unsigned long flags;
 	LIST_HEAD(local_dead_tasks);
-	struct task_struct * task;
-	struct task_struct * ttask;
+	struct task_struct *task;
+	struct task_struct *ttask;
 
 	spin_lock_irqsave(&task_mortuary, flags);
 
@@ -493,7 +498,7 @@ void sync_buffer(int cpu)
 {
 	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);
 	struct mm_struct *mm = NULL;
-	struct task_struct * new;
+	struct task_struct *new;
 	unsigned long cookie = 0;
 	int in_kernel = 1;
 	unsigned int i;
@@ -501,7 +506,7 @@ void sync_buffer(int cpu)
 	unsigned long available;
 
 	mutex_lock(&buffer_mutex);
- 
+
 	add_cpu_switch(cpu);
 
 	/* Remember, only we can modify tail_pos */
@@ -509,8 +514,8 @@ void sync_buffer(int cpu)
 	available = get_slots(cpu_buf);
 
 	for (i = 0; i < available; ++i) {
-		struct op_sample * s = &cpu_buf->buffer[cpu_buf->tail_pos];
- 
+		struct op_sample *s = &cpu_buf->buffer[cpu_buf->tail_pos];
+
 		if (is_code(s->eip)) {
 			if (s->event <= CPU_IS_KERNEL) {
 				/* kernel/userspace switch */
@@ -522,7 +527,7 @@ void sync_buffer(int cpu)
 				state = sb_bt_start;
 				add_trace_begin();
 			} else {
-				struct mm_struct * oldmm = mm;
+				struct mm_struct *oldmm = mm;
 
 				/* userspace context switch */
 				new = (struct task_struct *)s->event;
@@ -533,13 +538,11 @@ void sync_buffer(int cpu)
 					cookie = get_exec_dcookie(mm);
 				add_user_ctx_switch(new, cookie);
 			}
-		} else {
-			if (state >= sb_bt_start &&
-			    !add_sample(mm, s, in_kernel)) {
-				if (state == sb_bt_start) {
-					state = sb_bt_ignore;
-					atomic_inc(&oprofile_stats.bt_lost_no_mapping);
-				}
+		} else if (state >= sb_bt_start &&
+			   !add_sample(mm, s, in_kernel)) {
+			if (state == sb_bt_start) {
+				state = sb_bt_ignore;
+				atomic_inc(&oprofile_stats.bt_lost_no_mapping);
 			}
 		}
 
-- 
1.5.5.4


