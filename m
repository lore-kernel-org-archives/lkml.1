Return-Path: <linux-kernel-owner+w=401wt.eu-S1764984AbYDYXng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764984AbYDYXng (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYDYXn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:43:28 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:1129 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYDYXn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xiuCsrybRniG5wsHO+LvYbJmGWixlgJpG/newWWsgQTTWKl589EjBpN4P7L5/ET46Uy40lsTys4QbIR+Q/MqdTVkrXf5J1oawN5akIFmXF2aVcmsZFqseXl1To6z8uLLsVWR6nDjAN+rUUw+Z+NzeX0NAoTMnOfU5pC3FsOCmv0=
Message-ID: <dd18b0c30804251643t418d6ebci39e9cac6f673e354@mail.gmail.com>
Date: Fri, 25 Apr 2008 23:43:25 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: ebuddington@wesleyan.edu
Subject: Re: 2.6.25 BUG: soft lockup
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080425223920.GG8519@sparrow.23.warren.st>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080425223920.GG8519@sparrow.23.warren.st>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 10:39 PM, Eric Buddington
<ebuddington@verizon.net> wrote:
> On a Sempron laptop with kernel 2.6.24.4, I am getting this reliably
>  after a few minutes of uptime. I am also seeing all accesses to
>  /dev/hda stuck permanently in D state after that, though I don't know
>  if that's related. Both are repeatable, though.
>
>  clipped from dmesg:
>  ----------------------------------------------------
>  BUG: soft lockup - CPU#0 stuck for 61s! [swapper:0]
>
>  Pid: 0, comm: swapper Not tainted (2.6.25 #1)
>  EIP: 0060:[<c0132a9f>] EFLAGS: 00000293 CPU: 0
>  EIP is at tick_broadcast_oneshot_control+0xb8/0xc4
>  EAX: 00000293 EBX: c07020d0 ECX: 00000f6c EDX: c213edcf
>  ESI: 00000293 EDI: c0631460 EBP: 00000000 ESP: c0686f5c
>   DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
>  CR0: 8005003b CR2: 084b5e90 CR3: 0acd2000 CR4: 000006d0
>  DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
>  DR6: ffff0ff0 DR7: 00000400
>   [<c0132572>] tick_notify+0x185/0x294
>   [<c0496e75>] notifier_call_chain+0x2a/0x47
>   [<c012ebe4>] raw_notifier_call_chain+0x9/0xc
>   [<c0132116>] clockevents_notify+0x11/0x45
>   [<c02ab0dd>] acpi_idle_enter_simple+0x1b6/0x20d
>   [<c039b66e>] cpuidle_idle_call+0x56/0x85
>   [<c039b618>] cpuidle_idle_call+0x0/0x85
>   [<c0105974>] default_idle+0x0/0x74
>   [<c010595b>] cpu_idle+0x49/0x62
>
>
>
>
>  and from Alt-SysRq-t:
>  ------------------------------------------
>  cp            D c063b34c     0  5813   1087
>        c062c320 00000082 00120050 c063b34c c5721c74 c074c980 00000282 003faf08
>        003faf08 c5721cb4 00000000 c049457e c074c9c8 c074c9c8 003faf08 c012413e
>        c9ee4590 c074c980 c070bd98 c063b480 c0493ff9 00000005 c014ea6c 00000000
>  Call Trace:
>   [<c049457e>] schedule_timeout+0x72/0x8d
>   [<c012413e>] process_timeout+0x0/0x5
>   [<c0493ff9>] __sched_text_start+0x11/0x19
>   [<c014ea6c>] congestion_wait+0x4c/0x60
>   [<c012bcbe>] autoremove_wake_function+0x0/0x2d
>   [<c0149f0b>] __alloc_pages+0x282/0x2cd
>   [<c0145e9d>] find_or_create_page+0x6d/0xa0
>   [<c017d190>] __getblk+0x135/0x2a7
>   [<c01bc24b>] ext3_mark_inode_dirty+0x29/0x30
>   [<c01b93a3>] read_block_bitmap+0x37/0x11f
>   [<c01b9e3e>] ext3_new_blocks+0x176/0x4b8
>   [<c01bd401>] ext3_get_blocks_handle+0x32f/0x777
>   [<c01c8e63>] do_get_write_access+0x2d2/0x30d
>   [<c01c83e8>] __journal_file_buffer+0x7d/0xfe
>   [<c01c84ea>] journal_dirty_metadata+0x7c/0x82
>   [<c01c5d3f>] __ext3_journal_dirty_metadata+0x13/0x32
>   [<c01bbb45>] ext3_mark_iloc_dirty+0x268/0x2c0
>   [<c01c0a59>] ext3_mkdir+0x0/0x23f
>   [<c01bd950>] ext3_getblk+0x4a/0x15c
>   [<c01c92aa>] start_this_handle+0x213/0x26e
>   [<c016965f>] permission+0x85/0xc1
>   [<c01c0a59>] ext3_mkdir+0x0/0x23f
>   [<c01bda75>] ext3_bread+0x13/0x63
>   [<c01c0a59>] ext3_mkdir+0x0/0x23f
>   [<c01c0b16>] ext3_mkdir+0xbd/0x23f
>   [<c01c8191>] ext3_permission+0x0/0xa
>   [<c01c0a59>] ext3_mkdir+0x0/0x23f
>   [<c016a1b3>] vfs_mkdir+0x54/0x91
>   [<c016bc67>] sys_mkdirat+0x84/0xb9
>   [<c016bcab>] sys_mkdir+0xf/0x13
>   [<c010681a>] syscall_call+0x7/0xb
>   =======================
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>

Hello; This looks similar to what I was expireincing putting nohz=off
keeps the system from freezing,
Peter Zijlstra gave me this patch to use, which worked for me. The
only problem I had is patch -p1 < xxx.patch seemed to not work for me.
but worked for Peter.


 arch/x86/kernel/apm_32.c      |    3 +
 arch/x86/kernel/process.c     |  117 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c  |  118 +---------------------------------------
 arch/x86/kernel/process_64.c  |  123 +-----------------------------------------
 drivers/acpi/processor_idle.c |   19 +++---
 include/asm-x86/processor.h   |    1
 6 files changed, 137 insertions(+), 244 deletions(-)

Index: linux-2.6-2/arch/x86/kernel/process_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_32.c
+++ linux-2.6-2/arch/x86/kernel/process_32.c
@@ -111,12 +111,10 @@ void default_idle(void)
                */
               smp_mb();

-               local_irq_disable();
-               if (!need_resched()) {
+               if (!need_resched())
                       safe_halt();    /* enables interrupts racelessly */
-                       local_irq_disable();
-               }
-               local_irq_enable();
+               else
+                       local_irq_enable();
               current_thread_info()->status |= TS_POLLING;
       } else {
               local_irq_enable();
@@ -128,17 +126,6 @@ void default_idle(void)
 EXPORT_SYMBOL(default_idle);
 #endif

-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->work.need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-       local_irq_enable();
-       cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
 /* We don't actually take CPU down, just spin without interrupts. */
@@ -196,6 +183,7 @@ void cpu_idle(void)
                       if (cpu_is_offline(cpu))
                               play_dead();

+                       local_irq_disable();
                       __get_cpu_var(irq_stat).idle_timestamp = jiffies;
                       idle();
               }
@@ -206,104 +194,6 @@ void cpu_idle(void)
       }
 }

-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-       smp_mb();
-       /* kick all the CPUs so that they exit out of pm_idle */
-       smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __sti_mwait(ax, cx);
-               else
-                       local_irq_enable();
-       } else
-               local_irq_enable();
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-       local_irq_enable();
-       mwait_idle_with_hints(0, 0);
-}
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-       if (force_mwait)
-               return 1;
-       /* Any C1 states supported? */
-       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-       static int selected;
-
-       if (selected)
-               return;
-#ifdef CONFIG_X86_SMP
-       if (pm_idle == poll_idle && smp_num_siblings > 1) {
-               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-                       " performance may degrade.\n");
-       }
-#endif
-       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-               /*
-                * Skip, if setup has overridden idle.
-                * One CPU supports mwait => All CPUs supports mwait
-                */
-               if (!pm_idle) {
-                       printk(KERN_INFO "using mwait in idle threads.\n");
-                       pm_idle = mwait_idle;
-               }
-       }
-       selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-       if (!strcmp(str, "poll")) {
-               printk("using polling idle threads.\n");
-               pm_idle = poll_idle;
-       } else if (!strcmp(str, "mwait"))
-               force_mwait = 1;
-       else
-               return -1;
-
-       boot_option_idle_override = 1;
-       return 0;
-}
-early_param("idle", idle_setup);
-
 void __show_registers(struct pt_regs *regs, int all)
 {
       unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
Index: linux-2.6-2/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process_64.c
+++ linux-2.6-2/arch/x86/kernel/process_64.c
@@ -106,26 +106,13 @@ void default_idle(void)
        * test NEED_RESCHED:
        */
       smp_mb();
-       local_irq_disable();
-       if (!need_resched()) {
+       if (!need_resched())
               safe_halt();    /* enables interrupts racelessly */
-               local_irq_disable();
-       }
-       local_irq_enable();
+       else
+               local_irq_enable();
       current_thread_info()->status |= TS_POLLING;
 }

-/*
- * On SMP it's slightly faster (but much more power-consuming!)
- * to poll the ->need_resched flag instead of waiting for the
- * cross-CPU IPI to arrive. Use this option with caution.
- */
-static void poll_idle(void)
-{
-       local_irq_enable();
-       cpu_relax();
-}
-
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);

@@ -192,110 +179,6 @@ void cpu_idle(void)
       }
 }

-static void do_nothing(void *unused)
-{
-}
-
-/*
- * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
- * pm_idle and update to new pm_idle value. Required while changing pm_idle
- * handler on SMP systems.
- *
- * Caller must have changed pm_idle to the new value before the call. Old
- * pm_idle value will not be used by any CPU after the return of this function.
- */
-void cpu_idle_wait(void)
-{
-       smp_mb();
-       /* kick all the CPUs so that they exit out of pm_idle */
-       smp_call_function(do_nothing, NULL, 0, 1);
-}
-EXPORT_SYMBOL_GPL(cpu_idle_wait);
-
-/*
- * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
- * which can obviate IPI to trigger checking of need_resched.
- * We execute MONITOR against need_resched and enter optimized wait state
- * through MWAIT. Whenever someone changes need_resched, we would be woken
- * up from MWAIT (without an IPI).
- *
- * New with Core Duo processors, MWAIT can take some hints based on CPU
- * capability.
- */
-void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __mwait(ax, cx);
-       }
-}
-
-/* Default MONITOR/MWAIT with no hints, used for default C1 state */
-static void mwait_idle(void)
-{
-       if (!need_resched()) {
-               __monitor((void *)&current_thread_info()->flags, 0, 0);
-               smp_mb();
-               if (!need_resched())
-                       __sti_mwait(0, 0);
-               else
-                       local_irq_enable();
-       } else {
-               local_irq_enable();
-       }
-}
-
-
-static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
-{
-       if (force_mwait)
-               return 1;
-       /* Any C1 states supported? */
-       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
-}
-
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
-{
-       static int selected;
-
-       if (selected)
-               return;
-#ifdef CONFIG_X86_SMP
-       if (pm_idle == poll_idle && smp_num_siblings > 1) {
-               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
-                       " performance may degrade.\n");
-       }
-#endif
-       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
-               /*
-                * Skip, if setup has overridden idle.
-                * One CPU supports mwait => All CPUs supports mwait
-                */
-               if (!pm_idle) {
-                       printk(KERN_INFO "using mwait in idle threads.\n");
-                       pm_idle = mwait_idle;
-               }
-       }
-       selected = 1;
-}
-
-static int __init idle_setup(char *str)
-{
-       if (!strcmp(str, "poll")) {
-               printk("using polling idle threads.\n");
-               pm_idle = poll_idle;
-       } else if (!strcmp(str, "mwait"))
-               force_mwait = 1;
-       else
-               return -1;
-
-       boot_option_idle_override = 1;
-       return 0;
-}
-early_param("idle", idle_setup);
-
 /* Prints also some state that isn't saved in the pt_regs */
 void __show_regs(struct pt_regs * regs)
 {
Index: linux-2.6-2/drivers/acpi/processor_idle.c
===================================================================
--- linux-2.6-2.orig/drivers/acpi/processor_idle.c
+++ linux-2.6-2/drivers/acpi/processor_idle.c
@@ -418,13 +418,12 @@ static void acpi_processor_idle(void)

       cx = pr->power.state;
       if (!cx || acpi_idle_suspend) {
-               if (pm_idle_save)
-                       pm_idle_save();
-               else
+               if (pm_idle_save) {
+                       pm_idle_save(); /* enables IRQs */
+               } else {
                       acpi_safe_halt();
-
-               if (irqs_disabled())
                       local_irq_enable();
+               }

               return;
       }
@@ -520,10 +519,12 @@ static void acpi_processor_idle(void)
                * Use the appropriate idle routine, the one that would
                * be used without acpi C-states.
                */
-               if (pm_idle_save)
-                       pm_idle_save();
-               else
+               if (pm_idle_save) {
+                       pm_idle_save(); /* enables IRQs */
+               } else {
                       acpi_safe_halt();
+                       local_irq_enable();
+               }

               /*
                * TBD: Can't get time duration while in C1, as resumes
@@ -534,8 +535,6 @@ static void acpi_processor_idle(void)
                *       skew otherwise.
                */
               sleep_ticks = 0xFFFFFFFF;
-               if (irqs_disabled())
-                       local_irq_enable();

               break;

Index: linux-2.6-2/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6-2/arch/x86/kernel/apm_32.c
@@ -904,6 +904,7 @@ recalc:
                       original_pm_idle();
               else
                       default_idle();
+               local_irq_disable();
               jiffies_since_last_check = jiffies - last_jiffies;
               if (jiffies_since_last_check > idle_period)
                       goto recalc;
@@ -911,6 +912,8 @@ recalc:

       if (apm_idle_done)
               apm_do_busy();
+
+       local_irq_enable();
 }

 /**
Index: linux-2.6-2/include/asm-x86/processor.h
===================================================================
--- linux-2.6-2.orig/include/asm-x86/processor.h
+++ linux-2.6-2/include/asm-x86/processor.h
@@ -723,6 +723,7 @@ static inline void __mwait(unsigned long

 static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 {
+       trace_hardirqs_on();
       /* "mwait %eax, %ecx;" */
       asm volatile("sti; .byte 0x0f, 0x01, 0xc9;"
                    :: "a" (eax), "c" (ecx));
Index: linux-2.6-2/arch/x86/kernel/process.c
===================================================================
--- linux-2.6-2.orig/arch/x86/kernel/process.c
+++ linux-2.6-2/arch/x86/kernel/process.c
@@ -4,6 +4,8 @@
 #include <linux/smp.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/pm.h>

 struct kmem_cache *task_xstate_cachep;

@@ -42,3 +44,118 @@ void arch_task_cache_init(void)
                                 __alignof__(union thread_xstate),
                                 SLAB_PANIC, NULL);
 }
+
+static void do_nothing(void *unused)
+{
+}
+
+/*
+ * cpu_idle_wait - Used to ensure that all the CPUs discard old value of
+ * pm_idle and update to new pm_idle value. Required while changing pm_idle
+ * handler on SMP systems.
+ *
+ * Caller must have changed pm_idle to the new value before the call. Old
+ * pm_idle value will not be used by any CPU after the return of this function.
+ */
+void cpu_idle_wait(void)
+{
+       smp_mb();
+       /* kick all the CPUs so that they exit out of pm_idle */
+       smp_call_function(do_nothing, NULL, 0, 1);
+}
+EXPORT_SYMBOL_GPL(cpu_idle_wait);
+
+/*
+ * This uses new MONITOR/MWAIT instructions on P4 processors with PNI,
+ * which can obviate IPI to trigger checking of need_resched.
+ * We execute MONITOR against need_resched and enter optimized wait state
+ * through MWAIT. Whenever someone changes need_resched, we would be woken
+ * up from MWAIT (without an IPI).
+ *
+ * New with Core Duo processors, MWAIT can take some hints based on CPU
+ * capability.
+ */
+void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
+{
+       if (!need_resched()) {
+               __monitor((void *)&current_thread_info()->flags, 0, 0);
+               smp_mb();
+               if (!need_resched())
+                       __mwait(ax, cx);
+       }
+}
+
+/* Default MONITOR/MWAIT with no hints, used for default C1 state */
+static void mwait_idle(void)
+{
+       if (!need_resched()) {
+               __monitor((void *)&current_thread_info()->flags, 0, 0);
+               smp_mb();
+               if (!need_resched())
+                       __sti_mwait(0, 0);
+               else
+                       local_irq_enable();
+       } else
+               local_irq_enable();
+}
+
+
+static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
+{
+       if (force_mwait)
+               return 1;
+       /* Any C1 states supported? */
+       return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
+}
+
+/*
+ * On SMP it's slightly faster (but much more power-consuming!)
+ * to poll the ->work.need_resched flag instead of waiting for the
+ * cross-CPU IPI to arrive. Use this option with caution.
+ */
+static void poll_idle(void)
+{
+       local_irq_enable();
+       cpu_relax();
+}
+
+void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+{
+       static int selected;
+
+       if (selected)
+               return;
+#ifdef CONFIG_X86_SMP
+       if (pm_idle == poll_idle && smp_num_siblings > 1) {
+               printk(KERN_WARNING "WARNING: polling idle and HT enabled,"
+                       " performance may degrade.\n");
+       }
+#endif
+       if (cpu_has(c, X86_FEATURE_MWAIT) && mwait_usable(c)) {
+               /*
+                * Skip, if setup has overridden idle.
+                * One CPU supports mwait => All CPUs supports mwait
+                */
+               if (!pm_idle) {
+                       printk(KERN_INFO "using mwait in idle threads.\n");
+                       pm_idle = mwait_idle;
+               }
+       }
+       selected = 1;
+}
+
+static int __init idle_setup(char *str)
+{
+       if (!strcmp(str, "poll")) {
+               printk("using polling idle threads.\n");
+               pm_idle = poll_idle;
+       } else if (!strcmp(str, "mwait"))
+               force_mwait = 1;
+       else
+               return -1;
+
+       boot_option_idle_override = 1;
+       return 0;
+}
+early_param("idle", idle_setup);
+

Hope this helps unfreeze you're computer
regards;
-- 
Justin P. Mattock
