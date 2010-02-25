Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab0BYMIV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 07:08:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:45274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830Ab0BYMIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:08:19 -0500
Date: Thu, 25 Feb 2010 12:07:11 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu, dzickus@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
References: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/nmi] nmi_watchdog: Clean up various small details
Message-ID: <tip-47195d57636604ff6048b0d7aa3e4ed9643f6073@git.kernel.org>
Git-Commit-ID: 47195d57636604ff6048b0d7aa3e4ed9643f6073
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 12:07:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  47195d57636604ff6048b0d7aa3e4ed9643f6073
Gitweb:     http://git.kernel.org/tip/47195d57636604ff6048b0d7aa3e4ed9643f6073
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 22 Feb 2010 18:09:03 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 12:40:50 +0100

nmi_watchdog: Clean up various small details

Mostly copy/paste whitespace damage with a couple of nitpicks by
the checkpatch script. Fix the struct definition as requested by Ingo too.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: peterz@infradead.org
Cc: gorcunov@gmail.com
Cc: aris@redhat.com
LKML-Reference: <1266880143-24943-1-git-send-email-dzickus@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
--
 arch/x86/kernel/apic/hw_nmi.c |   14 +++++------
 arch/x86/kernel/traps.c       |    6 ++--
 include/linux/nmi.h           |    2 -
 kernel/nmi_watchdog.c         |   51 ++++++++++++++++++++----------------------
 4 files changed, 36 insertions(+), 37 deletions(-)
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
