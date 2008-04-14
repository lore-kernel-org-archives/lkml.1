Return-Path: <linux-kernel-owner+w=401wt.eu-S1756947AbYDNMGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947AbYDNMGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbYDNMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:06:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59242 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYDNMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:06:14 -0400
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
From: Peter Zijlstra <peterz@infradead.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Gautham Shenoy <ego@in.ibm.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1208156045.7427.16.camel@twins>
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com>
	 <1208156045.7427.16.camel@twins>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 14:06:07 +0200
Message-Id: <1208174767.7427.60.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-14 at 08:54 +0200, Peter Zijlstra wrote:
> Fun,
> 
> I will need to sort out this code before I can say anything about that,
> perhaps Gautham and or Rafael have ideas before I can come up with
> something.. ?
> 
> On Sun, 2008-04-13 at 23:04 -0400, Miles Lane wrote:
> > [ 3217.586003] [ INFO: possible circular locking dependency detected ]
> > [ 3217.586006] 2.6.25-rc9 #1
> > [ 3217.586008] -------------------------------------------------------
> > [ 3217.586011] pm-suspend/7421 is trying to acquire lock:
> > [ 3217.586013]  (&per_cpu(cpu_policy_rwsem, cpu)){----}, at:
> > [<c0277fe1>] lock_policy_rwsem_write+0x33/0x5a
> > [ 3217.586023]
> > [ 3217.586024] but task is already holding lock:
> > [ 3217.586026]  (&cpu_hotplug.lock){--..}, at: [<c0142cec>]
> > cpu_hotplug_begin+0x2f/0x89
> > [ 3217.586033]
> > [ 3217.586033] which lock already depends on the new lock.
> > [ 3217.586035]
> > [ 3217.586036]
> > [ 3217.586037] the existing dependency chain (in reverse order) is:
> > [ 3217.586039]
> > [ 3217.586040] -> #3 (&cpu_hotplug.lock){--..}:
> > [ 3217.586044]        [<c013f39f>] __lock_acquire+0xa02/0xbaf
> > [ 3217.586052]        [<c013f5c2>] lock_acquire+0x76/0x9d
> > [ 3217.586058]        [<c0309c17>] mutex_lock_nested+0xd5/0x274
> > [ 3217.586066]        [<c0143038>] get_online_cpus+0x2c/0x3e
> > [ 3217.586072]        [<c011eb03>] sched_getaffinity+0xe/0x4d
> > [ 3217.586079]        [<c0159784>] __synchronize_sched+0x11/0x5f
> > [ 3217.586087]        [<c0137380>] synchronize_srcu+0x22/0x5b
> > [ 3217.586093]        [<c01376a3>] srcu_notifier_chain_unregister+0x45/0x4c
> > [ 3217.586100]        [<c0277204>] cpufreq_unregister_notifier+0x1f/0x2f
> > [ 3217.586107]        [<f8cfd68c>] cpufreq_governor_dbs+0x1e9/0x242
> > [cpufreq_conservative]
> > [ 3217.586117]        [<c027758d>] __cpufreq_governor+0xb2/0xe9
> > [ 3217.586124]        [<c0277703>] __cpufreq_set_policy+0x13f/0x1c3
> > [ 3217.586130]        [<c0277bf3>] store_scaling_governor+0x150/0x17f
> > [ 3217.586137]        [<c0278708>] store+0x42/0x5b
> > [ 3217.586143]        [<c01b1ac9>] sysfs_write_file+0xb8/0xe3
> > [ 3217.586151]        [<c017dbc7>] vfs_write+0x8c/0x108
> > [ 3217.586158]        [<c017e122>] sys_write+0x3b/0x60
> > [ 3217.586165]        [<c0104470>] sysenter_past_esp+0x6d/0xc5
> > [ 3217.586172]        [<ffffffff>] 0xffffffff
> > [ 3217.586184]
> > [ 3217.586185] -> #2 (&sp->mutex){--..}:
> > [ 3217.586188]        [<c013f39f>] __lock_acquire+0xa02/0xbaf
> > [ 3217.586195]        [<c013f5c2>] lock_acquire+0x76/0x9d
> > [ 3217.586201]        [<c0309c17>] mutex_lock_nested+0xd5/0x274
> > [ 3217.586208]        [<c0137374>] synchronize_srcu+0x16/0x5b
> > [ 3217.586214]        [<c01376a3>] srcu_notifier_chain_unregister+0x45/0x4c
> > [ 3217.586220]        [<c0277204>] cpufreq_unregister_notifier+0x1f/0x2f
> > [ 3217.586227]        [<f8cfd68c>] cpufreq_governor_dbs+0x1e9/0x242
> > [cpufreq_conservative]
> > [ 3217.586235]        [<c027758d>] __cpufreq_governor+0xb2/0xe9
> > [ 3217.586242]        [<c0277703>] __cpufreq_set_policy+0x13f/0x1c3
> > [ 3217.586248]        [<c0277bf3>] store_scaling_governor+0x150/0x17f
> > [ 3217.586255]        [<c0278708>] store+0x42/0x5b
> > [ 3217.586261]        [<c01b1ac9>] sysfs_write_file+0xb8/0xe3
> > [ 3217.586268]        [<c017dbc7>] vfs_write+0x8c/0x108
> > [ 3217.586274]        [<c017e122>] sys_write+0x3b/0x60
> > [ 3217.586280]        [<c0104470>] sysenter_past_esp+0x6d/0xc5
> > [ 3217.586287]        [<ffffffff>] 0xffffffff
> > [ 3217.586297]
> > [ 3217.586298] -> #1 (dbs_mutex#2){--..}:
> > [ 3217.586302]        [<c013f39f>] __lock_acquire+0xa02/0xbaf
> > [ 3217.586309]        [<c013f5c2>] lock_acquire+0x76/0x9d
> > [ 3217.586315]        [<c0309c17>] mutex_lock_nested+0xd5/0x274
> > [ 3217.586322]        [<f8cfd511>] cpufreq_governor_dbs+0x6e/0x242
> > [cpufreq_conservative]
> > [ 3217.586330]        [<c027758d>] __cpufreq_governor+0xb2/0xe9
> > [ 3217.586336]        [<c0277719>] __cpufreq_set_policy+0x155/0x1c3
> > [ 3217.586343]        [<c0277bf3>] store_scaling_governor+0x150/0x17f
> > [ 3217.586349]        [<c0278708>] store+0x42/0x5b
> > [ 3217.586355]        [<c01b1ac9>] sysfs_write_file+0xb8/0xe3
> > [ 3217.586362]        [<c017dbc7>] vfs_write+0x8c/0x108
> > [ 3217.586369]        [<c017e122>] sys_write+0x3b/0x60
> > [ 3217.586375]        [<c0104470>] sysenter_past_esp+0x6d/0xc5
> > [ 3217.586381]        [<ffffffff>] 0xffffffff
> > [ 3217.586451]
> > [ 3217.586452] -> #0 (&per_cpu(cpu_policy_rwsem, cpu)){----}:
> > [ 3217.586456]        [<c013f2c6>] __lock_acquire+0x929/0xbaf
> > [ 3217.586463]        [<c013f5c2>] lock_acquire+0x76/0x9d
> > [ 3217.586469]        [<c030a219>] down_write+0x28/0x44
> > [ 3217.586475]        [<c0277fe1>] lock_policy_rwsem_write+0x33/0x5a
> > [ 3217.586482]        [<c0308abd>] cpufreq_cpu_callback+0x43/0x66
> > [ 3217.586489]        [<c013753e>] notifier_call_chain+0x2b/0x4a
> > [ 3217.586495]        [<c013757f>] __raw_notifier_call_chain+0xe/0x10
> > [ 3217.586501]        [<c0142dde>] _cpu_down+0x71/0x1f8
> > [ 3217.586507]        [<c0143094>] disable_nonboot_cpus+0x4a/0xc6
> > [ 3217.586513]        [<c0146ce5>] suspend_devices_and_enter+0x6c/0x101
> > [ 3217.586521]        [<c0146e8b>] enter_state+0xc4/0x119
> > [ 3217.586527]        [<c0146f76>] state_store+0x96/0xac
> > [ 3217.586533]        [<c01e7479>] kobj_attr_store+0x1a/0x22
> > [ 3217.586541]        [<c01b1ac9>] sysfs_write_file+0xb8/0xe3
> > [ 3217.586547]        [<c017dbc7>] vfs_write+0x8c/0x108
> > [ 3217.586554]        [<c017e122>] sys_write+0x3b/0x60
> > [ 3217.586560]        [<c0104470>] sysenter_past_esp+0x6d/0xc5
> > [ 3217.586567]        [<ffffffff>] 0xffffffff
> > [ 3217.586578]
> > [ 3217.586578] other info that might help us debug this:
> > [ 3217.586580]
> > [ 3217.586582] 5 locks held by pm-suspend/7421:
> > [ 3217.586584]  #0:  (&buffer->mutex){--..}, at: [<c01b1a36>]
> > sysfs_write_file+0x25/0xe3
> > [ 3217.586590]  #1:  (pm_mutex){--..}, at: [<c0146eca>] enter_state+0x103/0x119
> > [ 3217.586596]  #2:  (pm_sleep_rwsem){--..}, at: [<c0261789>]
> > device_suspend+0x25/0x1ad
> > [ 3217.586604]  #3:  (cpu_add_remove_lock){--..}, at: [<c0142c93>]
> > cpu_maps_update_begin+0xf/0x11
> > [ 3217.586610]  #4:  (&cpu_hotplug.lock){--..}, at: [<c0142cec>]
> > cpu_hotplug_begin+0x2f/0x89
> > [ 3217.586616]
> > [ 3217.586617] stack backtrace:
> > [ 3217.586620] Pid: 7421, comm: pm-suspend Not tainted 2.6.25-rc9 #1
> > [ 3217.586627]  [<c013d914>] print_circular_bug_tail+0x5b/0x66
> > [ 3217.586634]  [<c013d25e>] ? print_circular_bug_entry+0x39/0x43
> > [ 3217.586643]  [<c013f2c6>] __lock_acquire+0x929/0xbaf
> > [ 3217.586656]  [<c013f5c2>] lock_acquire+0x76/0x9d
> > [ 3217.586661]  [<c0277fe1>] ? lock_policy_rwsem_write+0x33/0x5a
> > [ 3217.586668]  [<c030a219>] down_write+0x28/0x44
> > [ 3217.586673]  [<c0277fe1>] ? lock_policy_rwsem_write+0x33/0x5a
> > [ 3217.586678]  [<c0277fe1>] lock_policy_rwsem_write+0x33/0x5a
> > [ 3217.586684]  [<c0308abd>] cpufreq_cpu_callback+0x43/0x66
> > [ 3217.586689]  [<c013753e>] notifier_call_chain+0x2b/0x4a
> > [ 3217.586696]  [<c013757f>] __raw_notifier_call_chain+0xe/0x10
> > [ 3217.586701]  [<c0142dde>] _cpu_down+0x71/0x1f8
> > [ 3217.586710]  [<c0143094>] disable_nonboot_cpus+0x4a/0xc6
> > [ 3217.586716]  [<c0146ce5>] suspend_devices_and_enter+0x6c/0x101
> > [ 3217.586721]  [<c0146e8b>] enter_state+0xc4/0x119
> > [ 3217.586726]  [<c0146f76>] state_store+0x96/0xac
> > [ 3217.586731]  [<c0146ee0>] ? state_store+0x0/0xac
> > [ 3217.586736]  [<c01e7479>] kobj_attr_store+0x1a/0x22
> > [ 3217.586742]  [<c01b1ac9>] sysfs_write_file+0xb8/0xe3
> > [ 3217.586750]  [<c01b1a11>] ? sysfs_write_file+0x0/0xe3
> > [ 3217.586755]  [<c017dbc7>] vfs_write+0x8c/0x108
> > [ 3217.586762]  [<c017e122>] sys_write+0x3b/0x60
> > [ 3217.586769]  [<c0104470>] sysenter_past_esp+0x6d/0xc5
> > [ 3217.586780]  =======================
> > [ 3217.588064] Breaking affinity for irq 16


Ok, so cpu_hotplug has a few issues imho:

 - access to active_writer isn't serialized and thus racey
 - holding the lock over the 'write' section generates the stuff above

So basically we want a reader/writer lock, where get/put_online_cpu is
the read side and cpu_hotplug_begin/done the write side.

We want:
 - readers to recurse in readers (code excluding cpu-hotplug can
   call code needing the same).

 - readers to recurse in the writer (the code changing the state can
   call code needing a stable state)

rwlock_t isn't quite suitable because it doesn't allow reader in writer
recursion and doesn't allow sleeping.

No lockdep annotation _yet_, because current lockdep recursive reader
support is:
 - broken (have a patch for that)
 - doesn't support reader in writer recursion (will have to do something
   about that)

Ok, so aside from the obviuos disclaimers, I've only compiled this and
might have made things way too complicated - but a slightly feverish
brain does that at times. What do people think?

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 2011ad8..119d837 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -27,12 +27,13 @@ static int cpu_hotplug_disabled;
 
 static struct {
 	struct task_struct *active_writer;
-	struct mutex lock; /* Synchronizes accesses to refcount, */
+	spinlock_t lock; /* Synchronizes accesses to refcount, */
 	/*
 	 * Also blocks the new readers during
 	 * an ongoing cpu hotplug operation.
 	 */
 	int refcount;
+	wait_queue_head_t reader_queue;
 	wait_queue_head_t writer_queue;
 } cpu_hotplug;
 
@@ -41,8 +42,9 @@ static struct {
 void __init cpu_hotplug_init(void)
 {
 	cpu_hotplug.active_writer = NULL;
-	mutex_init(&cpu_hotplug.lock);
+	spin_lock_init(&cpu_hotplug.lock);
 	cpu_hotplug.refcount = 0;
+	init_waitqueue_head(&cpu_hotplug.reader_queue);
 	init_waitqueue_head(&cpu_hotplug.writer_queue);
 }
 
@@ -51,27 +53,42 @@ void __init cpu_hotplug_init(void)
 void get_online_cpus(void)
 {
 	might_sleep();
+
+	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
-		return;
-	mutex_lock(&cpu_hotplug.lock);
+		goto unlock;
+
+	if (cpu_hotplug.active_writer) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&cpu_hotplug.reader_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!cpu_hotplug.active_writer)
+				break;
+			spin_unlock(&cpu_hotplug.lock);
+			schedule();
+			spin_lock(&cpu_hotplug.lock);
+		}
+		finish_wait(&cpu_hotplug.reader_queue, &wait);
+	}
 	cpu_hotplug.refcount++;
-	mutex_unlock(&cpu_hotplug.lock);
-
+ unlock:
+	spin_unlock(&cpu_hotplug.lock);
 }
 EXPORT_SYMBOL_GPL(get_online_cpus);
 
 void put_online_cpus(void)
 {
+	spin_lock(&cpu_hotplug.lock);
 	if (cpu_hotplug.active_writer == current)
-		return;
-	mutex_lock(&cpu_hotplug.lock);
-	cpu_hotplug.refcount--;
+		goto unlock;
 
-	if (unlikely(writer_exists()) && !cpu_hotplug.refcount)
+	cpu_hotplug.refcount--;
+	if (!cpu_hotplug.refcount)
 		wake_up(&cpu_hotplug.writer_queue);
-
-	mutex_unlock(&cpu_hotplug.lock);
-
+ unlock:
+	spin_unlock(&cpu_hotplug.lock);
 }
 EXPORT_SYMBOL_GPL(put_online_cpus);
 
@@ -95,45 +112,41 @@ void cpu_maps_update_done(void)
  * This ensures that the hotplug operation can begin only when the
  * refcount goes to zero.
  *
- * Note that during a cpu-hotplug operation, the new readers, if any,
- * will be blocked by the cpu_hotplug.lock
- *
- * Since cpu_maps_update_begin is always called after invoking
- * cpu_maps_update_begin, we can be sure that only one writer is active.
- *
- * Note that theoretically, there is a possibility of a livelock:
- * - Refcount goes to zero, last reader wakes up the sleeping
- *   writer.
- * - Last reader unlocks the cpu_hotplug.lock.
- * - A new reader arrives at this moment, bumps up the refcount.
- * - The writer acquires the cpu_hotplug.lock finds the refcount
- *   non zero and goes to sleep again.
- *
- * However, this is very difficult to achieve in practice since
- * get_online_cpus() not an api which is called all that often.
- *
+ * cpu_hotplug is basically an unfair recursive reader/writer lock that
+ * allows reader in writer recursion.
  */
 static void cpu_hotplug_begin(void)
 {
-	DECLARE_WAITQUEUE(wait, current);
-
-	mutex_lock(&cpu_hotplug.lock);
+	might_sleep();
 
-	cpu_hotplug.active_writer = current;
-	add_wait_queue_exclusive(&cpu_hotplug.writer_queue, &wait);
-	while (cpu_hotplug.refcount) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		mutex_unlock(&cpu_hotplug.lock);
-		schedule();
-		mutex_lock(&cpu_hotplug.lock);
+	spin_lock(&cpu_hotplug.lock);
+	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
+		DEFINE_WAIT(wait);
+
+		for (;;) {
+			prepare_to_wait(&cpu_hotplug.writer_queue, &wait,
+					TASK_UNINTERRUPTIBLE);
+			if (!cpu_hotplug.refcount && !cpu_hotplug.active_writer)
+				break;
+			spin_unlock(&cpu_hotplug.lock);
+			schedule();
+			spin_lock(&cpu_hotplug.lock);
+		}
+		finish_wait(&cpu_hotplug.writer_queue, &wait);
 	}
-	remove_wait_queue_locked(&cpu_hotplug.writer_queue, &wait);
+	cpu_hotplug.active_writer = current;
+	spin_unlock(&cpu_hotplug.lock);
 }
 
 static void cpu_hotplug_done(void)
 {
+	spin_lock(&cpu_hotplug.lock);
 	cpu_hotplug.active_writer = NULL;
-	mutex_unlock(&cpu_hotplug.lock);
+	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
+		wake_up(&cpu_hotplug.writer_queue);
+	else
+		wake_up_all(&cpu_hotplug.reader_queue);
+	spin_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
 int __cpuinit register_cpu_notifier(struct notifier_block *nb)


