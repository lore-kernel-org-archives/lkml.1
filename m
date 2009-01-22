Return-Path: <linux-kernel-owner+w=401wt.eu-S1756979AbZAVJPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979AbZAVJPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:15:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZAVJOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:14:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbZAVJOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:14:49 -0500
Message-ID: <497838FC.6050909@cn.fujitsu.com>
Date: Thu, 22 Jan 2009 17:14:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] workqueue: cleanup workqueue.c to make checkpatch happy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Warnings and errors from checkpatch's output are correct,
this patch fix them.

Only except this incorrect one:
 WARNING: use of in_atomic() is incorrect outside core kernel code
 #295: FILE: kernel/workqueue.c:292:
 +		if (unlikely(in_atomic() || lockdep_depth(current) > 0)) {

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6cf7785..1d2f06f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -120,7 +120,8 @@ static inline void set_wq_data(struct work_struct *work,
 static inline
 struct cpu_workqueue_struct *get_wq_data(struct work_struct *work)
 {
-	return (void *) (atomic_long_read(&work->data) & WORK_STRUCT_WQ_DATA_MASK);
+	return (void *)(atomic_long_read(&work->data)
+			& WORK_STRUCT_WQ_DATA_MASK);
 }
 
 static void insert_work(struct cpu_workqueue_struct *cwq,
@@ -292,7 +293,7 @@ static void run_workqueue(struct cpu_workqueue_struct *cwq)
 			printk(KERN_ERR "BUG: workqueue leaked lock or atomic: "
 					"%s/0x%08x/%d\n",
 					current->comm, preempt_count(),
-				       	task_pid_nr(current));
+					task_pid_nr(current));
 			printk(KERN_ERR "    last function: ");
 			print_symbol("%s\n", (unsigned long)f);
 			debug_show_held_locks(current);
@@ -533,7 +534,7 @@ static void wait_on_work(struct work_struct *work)
 }
 
 static int __cancel_work_timer(struct work_struct *work,
-				struct timer_list* timer)
+				struct timer_list *timer)
 {
 	int ret;
 
@@ -905,7 +906,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 
 	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
- 	cpu_maps_update_done();
+	cpu_maps_update_done();
 
 	free_percpu(wq->cpu_wq);
 	kfree(wq);


