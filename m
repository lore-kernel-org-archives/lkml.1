Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0BVXJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 18:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab0BVXJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 18:09:35 -0500
From: Don Zickus <dzickus@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Don Zickus <dzickus@redhat.com>, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com
Subject: [PATCH] nmi_watchdog: checkpatch.pl cleanups from earlier patches
Date: Mon, 22 Feb 2010 18:09:03 -0500
Message-Id: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly copy/paste whitespace damage with a couple of nitpicks by the script.
Fix the struct definition as requested by Ingo too.

Signed-off-by: Don Zickus <dzickus@redhat.com>
--
Ingo,

I don't know how you want this patch.  Like this to put on top or do you
want me to repost everything with the cleanups inside the appropriate patch?
---
 arch/x86/kernel/apic/hw_nmi.c |   14 +++++-----
 arch/x86/kernel/traps.c       |    6 ++--
 include/linux/nmi.h           |    2 +-
 kernel/nmi_watchdog.c         |   51 ++++++++++++++++++++---------------------
 4 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/apic/hw_nmi.c b/arch/x86/kernel/apic/hw_nmi.c
index 0b4d205..e8b78a0 100644
--- a/arch/x86/kernel/apic/hw_nmi.c
+++ b/arch/x86/kernel/apic/hw_nmi.c
@@ -38,15 +38,15 @@ static inline unsigned int get_timer_irqs(int cpu)
 	irqs += per_cpu(irq_stat, cpu).apic_timer_irqs;
 #endif
 
-        return irqs;
+	return irqs;
 }
 
 static inline int mce_in_progress(void)
 {
 #if defined(CONFIG_X86_MCE)
-        return atomic_read(&mce_entry) > 0;
+	return atomic_read(&mce_entry) > 0;
 #endif
-        return 0;
+	return 0;
 }
 
 int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
@@ -69,9 +69,9 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
 	}
 
 	/* if we are doing an mce, just assume the cpu is not stuck */
-        /* Could check oops_in_progress here too, but it's safer not to */
-        if (mce_in_progress())
-                return 0;
+	/* Could check oops_in_progress here too, but it's safer not to */
+	if (mce_in_progress())
+		return 0;
 
 	/* We determine if the cpu is stuck by checking whether any
 	 * interrupts have happened since we last checked.  Of course
@@ -89,7 +89,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *regs)
 
 u64 hw_nmi_get_sample_period(void)
 {
-        return cpu_khz * 1000;
+	return cpu_khz * 1000;
 }
 
 #ifdef ARCH_HAS_NMI_WATCHDOG
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 973cbc4..bdc7fab 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -402,9 +402,9 @@ static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
 			return;
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	        if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
-	        			                == NOTIFY_STOP)
-	                return;
+		if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT)
+							== NOTIFY_STOP)
+			return;
 
 #ifndef CONFIG_NMI_WATCHDOG
 		/*
diff --git a/include/linux/nmi.h b/include/linux/nmi.h
index 794e735..22cc796 100644
--- a/include/linux/nmi.h
+++ b/include/linux/nmi.h
@@ -57,7 +57,7 @@ u64 hw_nmi_get_sample_period(void);
 extern int nmi_watchdog_enabled;
 struct ctl_table;
 extern int proc_nmi_enabled(struct ctl_table *, int ,
-                        void __user *, size_t *, loff_t *);
+			void __user *, size_t *, loff_t *);
 #endif
 
 #endif
diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
index 3c75cbf..0a6f57f 100644
--- a/kernel/nmi_watchdog.c
+++ b/kernel/nmi_watchdog.c
@@ -50,31 +50,31 @@ void touch_all_nmi_watchdog(void)
 
 static int __init setup_nmi_watchdog(char *str)
 {
-        if (!strncmp(str, "panic", 5)) {
-                panic_on_timeout = 1;
-                str = strchr(str, ',');
-                if (!str)
-                        return 1;
-                ++str;
-        }
-        return 1;
+	if (!strncmp(str, "panic", 5)) {
+		panic_on_timeout = 1;
+		str = strchr(str, ',');
+		if (!str)
+			return 1;
+		++str;
+	}
+	return 1;
 }
 __setup("nmi_watchdog=", setup_nmi_watchdog);
 
 struct perf_event_attr wd_hw_attr = {
-	.type = PERF_TYPE_HARDWARE,
-	.config = PERF_COUNT_HW_CPU_CYCLES,
-	.size = sizeof(struct perf_event_attr),
-	.pinned = 1,
-	.disabled = 1,
+	.type		= PERF_TYPE_HARDWARE,
+	.config		= PERF_COUNT_HW_CPU_CYCLES,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
 };
 
 struct perf_event_attr wd_sw_attr = {
-	.type = PERF_TYPE_SOFTWARE,
-	.config = PERF_COUNT_SW_CPU_CLOCK,
-	.size = sizeof(struct perf_event_attr),
-	.pinned = 1,
-	.disabled = 1,
+	.type		= PERF_TYPE_SOFTWARE,
+	.config		= PERF_COUNT_SW_CPU_CLOCK,
+	.size		= sizeof(struct perf_event_attr),
+	.pinned		= 1,
+	.disabled	= 1,
 };
 
 void wd_overflow(struct perf_event *event, int nmi,
@@ -95,16 +95,15 @@ void wd_overflow(struct perf_event *event, int nmi,
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
 		 */
-		per_cpu(alert_counter,cpu) += 1;
-		if (per_cpu(alert_counter,cpu) == 5) {
-			if (panic_on_timeout) {
+		per_cpu(alert_counter, cpu) += 1;
+		if (per_cpu(alert_counter, cpu) == 5) {
+			if (panic_on_timeout)
 				panic("NMI Watchdog detected LOCKUP on cpu %d", cpu);
-			} else {
+			else
 				WARN(1, "NMI Watchdog detected LOCKUP on cpu %d", cpu);
-			}
 		}
 	} else {
-		per_cpu(alert_counter,cpu) = 0;
+		per_cpu(alert_counter, cpu) = 0;
 	}
 
 	return;
@@ -126,7 +125,7 @@ static int enable_nmi_watchdog(int cpu)
 		event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
 		if (IS_ERR(event)) {
 			/* hardware doesn't exist or not supported, fallback to software events */
-			printk("nmi_watchdog: hardware not available, trying software events\n");
+			printk(KERN_INFO "nmi_watchdog: hardware not available, trying software events\n");
 			wd_attr = &wd_sw_attr;
 			wd_attr->sample_period = NSEC_PER_SEC;
 			event = perf_event_create_kernel_counter(wd_attr, cpu, -1, wd_overflow);
@@ -182,7 +181,7 @@ int proc_nmi_enabled(struct ctl_table *table, int write,
 	if (nmi_watchdog_enabled) {
 		for_each_online_cpu(cpu)
 			if (enable_nmi_watchdog(cpu)) {
-				printk("NMI watchdog failed configuration, "
+				printk(KERN_ERR "NMI watchdog failed configuration, "
 					" can not be enabled\n");
 			}
 	} else {
-- 
1.6.6.83.gc9a2

