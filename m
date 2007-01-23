Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXAWWBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXAWWBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXAWWBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:01:49 -0500
Received: from www.osadl.org ([213.239.205.134]:35975 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965529AbXAWWB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:01:29 -0500
Message-Id: <20070123211210.058216000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 45/46] Add debugging feature /proc/timer_list
Content-Disposition: inline; filename=debugging-feature-proc-timer_list.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add /proc/timer_list, which prints all currently pending (high-res) timers,
all clock-event sources and their parameters in a human-readable form.

Sample output:

Timer List Version: v0.1
HRTIMER_MAX_CLOCK_BASES: 2
now at 4246046273872 nsecs

cpu: 0
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1273998312645738432 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f5a90ec8>, hrtimer_sched_tick, hrtimer_stop_sched_tick, swapper/0
 # expires at 4246432689566 nsecs [in 386415694 nsecs]
 #1: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, pcscd/2050
 # expires at 4247018194689 nsecs [in 971920817 nsecs]
 #2: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, irqbalance/1909
 # expires at 4247351358392 nsecs [in 1305084520 nsecs]
 #3: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, crond/2157
 # expires at 4249097614968 nsecs [in 3051341096 nsecs]
 #4: <f5a90ec8>, it_real_fn, do_setitimer, syslogd/1888
 # expires at 4251329900926 nsecs [in 5283627054 nsecs]
  .expires_next   : 4246432689566 nsecs
  .hres_active    : 1
  .check_clocks   : 0
  .nr_events      : 31306
  .idle_tick      : 4246020791890 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 986504
  .idle_calls     : 40700
  .idle_sleeps    : 36014
  .idle_entrytime : 4246019418883 nsecs
  .idle_sleeptime : 4178181972709 nsecs

cpu: 1
 clock 0:
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     1273998312645738432 nsecs
active timers:
 clock 1:
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <f5a90ec8>, hrtimer_sched_tick, hrtimer_restart_sched_tick, swapper/0
 # expires at 4246050084568 nsecs [in 3810696 nsecs]
 #1: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, atd/2227
 # expires at 4261010635003 nsecs [in 14964361131 nsecs]
 #2: <f5a90ec8>, hrtimer_wakeup, do_nanosleep, smartd/2332
 # expires at 5469485798970 nsecs [in 1223439525098 nsecs]
  .expires_next   : 4246050084568 nsecs
  .hres_active    : 1
  .check_clocks   : 0
  .nr_events      : 24043
  .idle_tick      : 4246046084568 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 986510
  .idle_calls     : 26360
  .idle_sleeps    : 22551
  .idle_entrytime : 4246043874339 nsecs
  .idle_sleeptime : 4170763761184 nsecs

tick_broadcast_mask: 00000003
event_broadcast_mask: 00000001

CPU#0's local event device:

Clock Event Device: lapic
 capabilities:   0000000e
 max_delta_ns:   807385544
 min_delta_ns:   1443
 mult:           44624025
 shift:          32
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
  .installed:  1
  .expires:    4246432689566 nsecs

CPU#1's local event device:

Clock Event Device: lapic
 capabilities:   0000000e
 max_delta_ns:   807385544
 min_delta_ns:   1443
 mult:           44624025
 shift:          32
 set_next_event: lapic_next_event
 set_mode:       lapic_timer_setup
 event_handler:  hrtimer_interrupt
  .installed:  1
  .expires:    4246050084568 nsecs

Clock Event Device: hpet
 capabilities:   00000007
 max_delta_ns:   2147483647
 min_delta_ns:   3352
 mult:           61496110
 shift:          32
 set_next_event: hpet_next_event
 set_mode:       hpet_set_mode
 event_handler:  handle_nextevt_broadcast

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/tick.h         |   11 +
 kernel/time/Makefile         |    2 
 kernel/time/tick-broadcast.c |   23 +++
 kernel/time/tick-common.c    |    8 +
 kernel/time/timer_list.c     |  287 +++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 329 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/kernel/time/Makefile
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/Makefile
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += ntp.o clocksource.o jiffies.o
+obj-y += ntp.o clocksource.o jiffies.o timer_list.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
Index: linux-2.6.20-rc4-mm1-bo/kernel/time/timer_list.c
===================================================================
--- /dev/null
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/timer_list.c
@@ -0,0 +1,287 @@
+/*
+ * kernel/time/timer_list.c
+ *
+ * List pending timers
+ *
+ * Copyright(C) 2006, Red Hat, Inc., Ingo Molnar
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/proc_fs.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/seq_file.h>
+#include <linux/kallsyms.h>
+#include <linux/tick.h>
+
+#include <asm/uaccess.h>
+
+typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
+
+DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
+
+/*
+ * This allows printing both to /proc/timer_list and
+ * to the console (on SysRq-Q):
+ */
+#define SEQ_printf(m, x...)			\
+ do {						\
+	if (m)					\
+		seq_printf(m, x);		\
+	else					\
+		printk(x);			\
+ } while (0)
+
+static void print_name_offset(struct seq_file *m, void *sym)
+{
+	unsigned long addr = (unsigned long)sym;
+	char namebuf[KSYM_NAME_LEN+1];
+	unsigned long size, offset;
+	const char *sym_name;
+	char *modname;
+
+	sym_name = kallsyms_lookup(addr, &size, &offset, &modname, namebuf);
+	if (sym_name)
+		SEQ_printf(m, "%s", sym_name);
+	else
+		SEQ_printf(m, "<%p>", sym);
+}
+
+static void
+print_timer(struct seq_file *m, struct hrtimer *timer, int idx, u64 now)
+{
+#ifdef CONFIG_TIMER_STATS
+	char tmp[TASK_COMM_LEN + 1];
+#endif
+	SEQ_printf(m, " #%d: ", idx);
+	print_name_offset(m, timer);
+	SEQ_printf(m, ", ");
+	print_name_offset(m, timer->function);
+	SEQ_printf(m, ", S:%02lx", timer->state);
+#ifdef CONFIG_TIMER_STATS
+	SEQ_printf(m, ", ");
+	print_name_offset(m, timer->start_site);
+	memcpy(tmp, timer->start_comm, TASK_COMM_LEN);
+	tmp[TASK_COMM_LEN] = 0;
+	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
+#endif
+	SEQ_printf(m, "\n");
+	SEQ_printf(m, " # expires at %Ld nsecs [in %Ld nsecs]\n",
+		(unsigned long long)ktime_to_ns(timer->expires),
+		(unsigned long long)(ktime_to_ns(timer->expires) - now));
+}
+
+static void
+print_active_timers(struct seq_file *m, struct hrtimer_clock_base *base,
+		    u64 now)
+{
+	struct hrtimer *timer, tmp;
+	unsigned long next = 0, i;
+	struct rb_node *curr;
+	unsigned long flags;
+
+next_one:
+	i = 0;
+	spin_lock_irqsave(&base->cpu_base->lock, flags);
+
+	curr = base->first;
+	/*
+	 * Crude but we have to do this O(N*N) thing, because
+	 * we have to unlock the base when printing:
+	 */
+	while (curr && i < next) {
+		curr = rb_next(curr);
+		i++;
+	}
+
+	if (curr) {
+
+		timer = rb_entry(curr, struct hrtimer, node);
+		tmp = *timer;
+		spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+
+		print_timer(m, &tmp, i, now);
+		next++;
+		goto next_one;
+	}
+	spin_unlock_irqrestore(&base->cpu_base->lock, flags);
+}
+
+static void
+print_base(struct seq_file *m, struct hrtimer_clock_base *base, u64 now)
+{
+	SEQ_printf(m, "  .index:      %d\n",
+			base->index);
+	SEQ_printf(m, "  .resolution: %Ld nsecs\n",
+			(unsigned long long)ktime_to_ns(base->resolution));
+	SEQ_printf(m,   "  .get_time:   ");
+	print_name_offset(m, base->get_time);
+	SEQ_printf(m,   "\n");
+#ifdef CONFIG_HIGH_RES_TIMERS
+	SEQ_printf(m, "  .offset:     %Ld nsecs\n",
+			ktime_to_ns(base->offset));
+#endif
+	SEQ_printf(m,   "active timers:\n");
+	print_active_timers(m, base, now);
+}
+
+static void print_cpu(struct seq_file *m, int cpu, u64 now)
+{
+	struct hrtimer_cpu_base *cpu_base = &per_cpu(hrtimer_bases, cpu);
+	int i;
+
+	SEQ_printf(m, "\ncpu: %d\n", cpu);
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+		SEQ_printf(m, " clock %d:\n", i);
+		print_base(m, cpu_base->clock_base + i, now);
+	}
+#define P(x) \
+	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(cpu_base->x))
+#define P_ns(x) \
+	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
+		(u64)(ktime_to_ns(cpu_base->x)))
+
+#ifdef CONFIG_HIGH_RES_TIMERS
+	P_ns(expires_next);
+	P(hres_active);
+	P(nr_events);
+#endif
+#undef P
+#undef P_ns
+
+#ifdef CONFIG_TICK_ONESHOT
+# define P(x) \
+	SEQ_printf(m, "  .%-15s: %Ld\n", #x, (u64)(ts->x))
+# define P_ns(x) \
+	SEQ_printf(m, "  .%-15s: %Ld nsecs\n", #x, \
+		(u64)(ktime_to_ns(ts->x)))
+	{
+		struct tick_sched *ts = tick_get_tick_sched(cpu);
+		P(nohz_mode);
+		P_ns(idle_tick);
+		P(tick_stopped);
+		P(idle_jiffies);
+		P(idle_calls);
+		P(idle_sleeps);
+		P_ns(idle_entrytime);
+		P_ns(idle_sleeptime);
+		P(last_jiffies);
+		P(next_jiffies);
+		P_ns(idle_expires);
+		SEQ_printf(m, "jiffies: %Ld\n", (u64)jiffies);
+	}
+#endif
+
+#undef P
+#undef P_ns
+}
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+static void
+print_tickdevice(struct seq_file *m, struct tick_device *td)
+{
+	struct clock_event_device *dev = td->evtdev;
+
+	SEQ_printf(m, "\nTick Device: mode:     %d\n", td->mode);
+
+	SEQ_printf(m, "Clock Event Device: ");
+	if (!dev) {
+		SEQ_printf(m, "<NULL>\n");
+		return;
+	}
+	SEQ_printf(m, "%s\n", dev->name);
+	SEQ_printf(m, " max_delta_ns:   %ld\n", dev->max_delta_ns);
+	SEQ_printf(m, " min_delta_ns:   %ld\n", dev->min_delta_ns);
+	SEQ_printf(m, " mult:           %ld\n", dev->mult);
+	SEQ_printf(m, " shift:          %d\n", dev->shift);
+	SEQ_printf(m, " mode:           %d\n", dev->mode);
+	SEQ_printf(m, " next_event:     %Ld nsecs\n",
+		   (unsigned long long) ktime_to_ns(dev->next_event));
+
+	SEQ_printf(m, " set_next_event: ");
+	print_name_offset(m, dev->set_next_event);
+	SEQ_printf(m, "\n");
+
+	SEQ_printf(m, " set_mode:       ");
+	print_name_offset(m, dev->set_mode);
+	SEQ_printf(m, "\n");
+
+	SEQ_printf(m, " event_handler:  ");
+	print_name_offset(m, dev->event_handler);
+	SEQ_printf(m, "\n");
+}
+
+static void timer_list_show_tickdevices(struct seq_file *m)
+{
+	int cpu;
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+	print_tickdevice(m, tick_get_broadcast_device());
+	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
+		   tick_get_broadcast_mask()->bits[0]);
+#ifdef CONFIG_TICK_ONESHOT
+	SEQ_printf(m, "tick_broadcast_oneshot_mask: %08lx\n",
+		   tick_get_broadcast_oneshot_mask()->bits[0]);
+#endif
+	SEQ_printf(m, "\n");
+#endif
+	for_each_online_cpu(cpu)
+		   print_tickdevice(m, tick_get_device(cpu));
+	SEQ_printf(m, "\n");
+}
+#else
+static void timer_list_show_tickdevices(struct seq_file *m) { }
+#endif
+
+static int timer_list_show(struct seq_file *m, void *v)
+{
+	u64 now = ktime_to_ns(ktime_get());
+	int cpu;
+
+	SEQ_printf(m, "Timer List Version: v0.3\n");
+	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
+	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
+
+	for_each_online_cpu(cpu)
+		print_cpu(m, cpu, now);
+
+	SEQ_printf(m, "\n");
+	timer_list_show_tickdevices(m);
+
+	return 0;
+}
+
+void sysrq_timer_list_show(void)
+{
+	timer_list_show(NULL, NULL);
+}
+
+static int timer_list_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, timer_list_show, NULL);
+}
+
+static struct file_operations timer_list_fops = {
+	.open		= timer_list_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static int __init init_timer_list_procfs(void)
+{
+	struct proc_dir_entry *pe;
+
+	pe = create_proc_entry("timer_list", 0644, NULL);
+	if (!pe)
+		return -ENOMEM;
+
+	pe->proc_fops = &timer_list_fops;
+
+	return 0;
+}
+__initcall(init_timer_list_procfs);
Index: linux-2.6.20-rc4-mm1-bo/include/linux/tick.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/tick.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/tick.h
@@ -59,6 +59,7 @@ struct tick_sched {
 
 extern void __init tick_init(void);
 extern int tick_is_oneshot_available(void);
+extern struct tick_device *tick_get_device(int cpu);
 
 # ifdef CONFIG_HIGH_RES_TIMERS
 extern int tick_init_highres(void);
@@ -69,6 +70,16 @@ extern void tick_cancel_sched_timer(int 
 static inline void tick_cancel_sched_timer(int cpu) { }
 # endif /* HIGHRES */
 
+# ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+extern struct tick_device *tick_get_broadcast_device(void);
+extern cpumask_t *tick_get_broadcast_mask(void);
+
+#  ifdef CONFIG_TICK_ONESHOT
+extern cpumask_t *tick_get_broadcast_oneshot_mask(void);
+#  endif
+
+# endif /* BROADCAST */
+
 # ifdef CONFIG_TICK_ONESHOT
 extern void tick_clock_notify(void);
 extern int tick_check_oneshot_change(int allow_nohz);
Index: linux-2.6.20-rc4-mm1-bo/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/tick-broadcast.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/tick-broadcast.c
@@ -27,11 +27,24 @@
  * timer stops in C3 state.
  */
 
-static struct tick_device tick_broadcast_device;
+struct tick_device tick_broadcast_device;
 static cpumask_t tick_broadcast_mask;
 static DEFINE_SPINLOCK(tick_broadcast_lock);
 
 /*
+ * Debugging: see timer_list.c
+ */
+struct tick_device *tick_get_broadcast_device(void)
+{
+	return &tick_broadcast_device;
+}
+
+cpumask_t *tick_get_broadcast_mask(void)
+{
+	return &tick_broadcast_mask;
+}
+
+/*
  * Start the device in periodic mode
  */
 static void tick_broadcast_start_periodic(struct clock_event_device *bc)
@@ -266,6 +279,14 @@ void tick_do_resume(int cpu)
 static cpumask_t tick_broadcast_oneshot_mask;
 
 /*
+ * Debugging: see timer_list.c
+ */
+cpumask_t *tick_get_broadcast_oneshot_mask(void)
+{
+	return &tick_broadcast_oneshot_mask;
+}
+
+/*
  * Reprogram the broadcast device:
  *
  * Called with tick_broadcast_lock held and interrupts disabled.
Index: linux-2.6.20-rc4-mm1-bo/kernel/time/tick-common.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/tick-common.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/tick-common.c
@@ -34,6 +34,14 @@ ktime_t tick_period;
 static int tick_do_timer_cpu = -1;
 DEFINE_SPINLOCK(tick_device_lock);
 
+/*
+ * Debugging: see timer_list.c
+ */
+struct tick_device *tick_get_device(int cpu)
+{
+	return &per_cpu(tick_cpu_device, cpu);
+}
+
 /**
  * tick_is_oneshot_available - check for a oneshot capable event device
  */

--

