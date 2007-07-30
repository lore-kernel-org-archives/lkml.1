Return-Path: <linux-kernel-owner+w=401wt.eu-S938568AbXG3Rdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938568AbXG3Rdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761737AbXG3Rdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:33:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:38451 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463AbXG3Rdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:33:31 -0400
Subject: Re: [PATCH] create /proc/all-interrupts
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org
Cc: Joe Korty <joe.korty@ccur.com>, mingo@elte.hu, tglx@linutronix.de,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       jason.baietto@ccur.com
In-Reply-To: <46A8EE78.4040702@zytor.com>
References: <20070726180522.GA1486@tsunami.ccur.com>
	 <46A8EE78.4040702@zytor.com>
Content-Type: multipart/mixed; boundary="=-EsU/qJxaCSrl+o2Misva"
Date: Mon, 30 Jul 2007 10:33:17 -0700
Message-Id: <1185816797.3170.1.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EsU/qJxaCSrl+o2Misva
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2007-07-26 at 11:56 -0700, H. Peter Anvin wrote: 
> Joe Korty wrote:
> > Create /proc/all-interrupts for some architectures.
> > 
> > Create a version of /proc/interrupts that displays _every_
> > IRQ vector, not just those that someone thought might be
> > interesting, and add an entry in the commentary column
> > for those vectors which lacked such a comment.
> > 
> > Rationale: /proc/interrupts is not truly useful unless it
> > displays every IRQ vector, not just those somebody thought
> > would be interesting.  For example, since /proc/interrupts
> > does not display the rescheduling interrupt, the occurance
> > of rescheduling interrupt floods ends up affecting
> > latencies, yet without an entry in /proc/interrupts, it
> > is difficult to discern why latencies are being affected.
> > 
> > Rather than modify /proc/interrupts, this patch creates
> > a new version of /proc/interrupts, on the off-chance
> > that adding new lines to /proc/interrupts, and appending
> > new fields to the end of old lines, might break some
> > longstanding script.  However, these kinds of changes
> > traditionally do not affect scripts, so it might be
> > reasonable to fold /proc/all-interrupts back into
> > /proc/interrupts.
> 
> I think that would be the right thing to do.  We have added things to
> /proc/interrupts in the past.
> 
Hi Andrew,

Would it make sense to drop this patch into -mm for feedback?

Thanks,

Sven

--=-EsU/qJxaCSrl+o2Misva
Content-Disposition: inline
Content-Description: Attached message - [PATCH 2/3]
	proc-interrupts-missing-vectors
Content-Type: message/rfc822

Return-path: <joe.korty@ccur.com>
Received: from AMPHION.novell.com ([130.57.1.22]) by
	lucius.provo.novell.com with ESMTP; Wed, 25 Jul 2007 14:58:56 -0600
Received: from gamx.iccur.com (flvpn.ccur.com [66.10.65.2]) by
	AMPHION.novell.com (TMA SMTPRS 4.4.568.54) with ESMTP id
	<D0109455533@AMPHION.novell.com> for <sdietrich@novell.com>; Wed, 25 Jul
	2007 14:59:02 -0600
Received-SPF: none (AMPHION.novell.com: domain of joe.korty@ccur.com does
	not designate any permitted senders)
X-IADB2: None
X-Bonded-Senders: None
X-Habeas: None
X-Cloudmark-Rating: 0 <127.0.50.0>
X-IDDB: None
X-Modus-ReverseDNS: OK
X-Modus-BlackList: 66.10.65.2=OK;joe.korty@ccur.com=OK
X-Modus-RBL: 66.10.65.2=OK
X-Modus-Trusted: 66.10.65.2=NO
X-Modus-Audit: FALSE;0;0;0
Received: from gamx.iccur.com (localhost.localdomain [127.0.0.1]) by
	tsunami.ccur.com (8.13.8/8.13.5) with ESMTP id l6PKwHj4009038; Wed, 25 Jul
	2007 16:58:18 -0400
Received: (from jak@localhost) by gamx.iccur.com (8.13.8/8.13.5/Submit) id
	l6PKwHno009037; Wed, 25 Jul 2007 16:58:17 -0400
Date: Wed, 25 Jul 2007 16:58:16 -0400
From: Joe Korty <joe.korty@ccur.com>
To: mingo@elte.hu
Cc: tglx@linutronix.de, sdietrich@novell.com, linux-rt-users@vger.kernel.org
Subject: [PATCH 2/3] proc-interrupts-missing-vectors
Message-ID: <20070725205816.GA9032@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
X-Evolution-Source: imap://sdietrich@imap.novell.com/
Content-Transfer-Encoding: 7bit

Add missing IRQs to /proc/interrupts.

/proc/interrupts is not truly useful unless it displays
every IRQ vector, not just those somebody thought
would be interesting.  For example, since the default
/proc/interrupts setup did not display the rescheduling
interrupt, the occurance of rescheduling interrupt floods
ends up affecting latencies, yet without an entry in
/proc/interrupts, it is difficult to discern why latencies
are being affected.

Also does a silly little expansion of the 'ERR:' display
to be per cpu.  This makes its layout identical to all
the other display lines in /proc/interrupts.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.22.1-rt8/arch/i386/kernel/apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/apic.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/apic.c	2007-07-25 16:07:43.000000000 -0400
@@ -1268,6 +1268,8 @@
 {
 	unsigned long v;
 
+	atomic_inc(&__get_cpu_var(irq_spur_counts));
+
 	irq_enter();
 	/*
 	 * Check if this really is a spurious interrupt and ACK it
@@ -1297,7 +1299,7 @@
 	apic_write(APIC_ESR, 0);
 	v1 = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc(&__get_cpu_var(irq_err_counts));
 
 	/* Here is what the APIC error bits mean:
 	   0: Send CS error
Index: 2.6.22.1-rt8/arch/i386/kernel/cpu/mcheck/p4.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/cpu/mcheck/p4.c	2007-07-25 16:07:43.000000000 -0400
@@ -60,6 +60,7 @@
 fastcall void smp_thermal_interrupt(struct pt_regs *regs)
 {
 	irq_enter();
+	atomic_inc(&__get_cpu_var(irq_thermal_counts));
 	vendor_thermal_interrupt(regs);
 	irq_exit();
 }
Index: 2.6.22.1-rt8/arch/i386/kernel/i8259.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/i8259.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/i8259.c	2007-07-25 16:07:43.000000000 -0400
@@ -209,7 +209,7 @@
 			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc(&__get_cpu_var(irq_err_counts));
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
Index: 2.6.22.1-rt8/arch/i386/kernel/io_apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/io_apic.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/io_apic.c	2007-07-25 16:07:43.000000000 -0400
@@ -51,7 +51,6 @@
 #include "io_ports.h"
 
 int (*ioapic_renumber_irq)(int ioapic, int irq);
-atomic_t irq_mis_count;
 
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
@@ -2031,7 +2030,7 @@
 	ack_APIC_irq();
 
 	if (!(v & (1 << (i & 0x1f)))) {
-		atomic_inc(&irq_mis_count);
+		atomic_inc(&__get_cpu_var(irq_mis_counts));
 		spin_lock(&ioapic_lock);
 		/* mask = 1, trigger = 0 */
 		__modify_IO_APIC_irq(irq, 0x00010000, 0x00008000);
Index: 2.6.22.1-rt8/arch/i386/kernel/irq.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/irq.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/irq.c	2007-07-25 16:23:12.000000000 -0400
@@ -252,7 +252,13 @@
  * Interrupt statistics:
  */
 
-atomic_t irq_err_count;
+DEFINE_PER_CPU(atomic_t, irq_resched_counts);
+DEFINE_PER_CPU(atomic_t, irq_call_counts);
+DEFINE_PER_CPU(atomic_t, irq_spur_counts);
+DEFINE_PER_CPU(atomic_t, irq_tlb_counts);
+DEFINE_PER_CPU(atomic_t, irq_thermal_counts);
+DEFINE_PER_CPU(atomic_t, irq_err_counts);
+DEFINE_PER_CPU(atomic_t, irq_mis_counts);
 
 /*
  * /proc/interrupts printing:
@@ -305,9 +311,60 @@
 				per_cpu(irq_stat,j).apic_timer_irqs);
 		seq_putc(p, '\n');
 #endif
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
-#if defined(CONFIG_X86_IO_APIC)
-		seq_printf(p, "MIS: %10u\n", atomic_read(&irq_mis_count));
+#ifdef CONFIG_SMP
+#ifdef RESCHEDULE_VECTOR
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_resched_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef CALL_FUNCTION_VECTOR
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_call_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef INVALIDATE_TLB_VECTOR
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_tlb_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef THERMAL_APIC_VECTOR
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_thermal_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef SPURIOUS_APIC_VECTOR
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_spur_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef ERROR_APIC_VECTOR
+		seq_printf(p, "ERR: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_err_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#if defined(CONFIG_X86_IO_APIC) && defined(APIC_MISMATCH_DEBUG)
+		seq_printf(p, "MIS: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ",
+				atomic_read(&per_cpu(irq_mis_counts, j)));
+		seq_putc(p, '\n');
 #endif
 	}
 	return 0;
Index: 2.6.22.1-rt8/arch/i386/kernel/smp.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/i386/kernel/smp.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/i386/kernel/smp.c	2007-07-25 16:07:43.000000000 -0400
@@ -315,6 +315,7 @@
 	unsigned long cpu;
 
 	cpu = get_cpu();
+	atomic_inc(&__get_cpu_var(irq_tlb_counts));
 
 	if (!cpu_isset(cpu, flush_cpumask))
 		goto out;
@@ -658,6 +659,7 @@
 {
 	trace_special(regs->eip, 0, 0);
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_resched_counts));
 	set_tsk_need_resched(current);
 }
 
@@ -668,6 +670,7 @@
 	int wait = call_data->wait;
 
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_call_counts));
 	/*
 	 * Notify initiating CPU that I've grabbed the data and am
 	 * about to execute the function
Index: 2.6.22.1-rt8/arch/x86_64/kernel/apic.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/apic.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/apic.c	2007-07-25 16:07:43.000000000 -0400
@@ -1099,6 +1099,9 @@
 asmlinkage void smp_spurious_interrupt(void)
 {
 	unsigned int v;
+
+	atomic_inc(&__get_cpu_var(irq_spur_counts));
+
 	exit_idle();
 	irq_enter();
 	/*
@@ -1127,7 +1130,7 @@
 	apic_write(APIC_ESR, 0);
 	v1 = apic_read(APIC_ESR);
 	ack_APIC_irq();
-	atomic_inc(&irq_err_count);
+	atomic_inc(&__get_cpu_var(irq_err_counts));
 
 	/* Here is what the APIC error bits mean:
 	   0: Send CS error
Index: 2.6.22.1-rt8/arch/x86_64/kernel/i8259.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/i8259.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/i8259.c	2007-07-25 16:07:43.000000000 -0400
@@ -273,7 +273,7 @@
 			printk(KERN_DEBUG "spurious 8259A interrupt: IRQ%d.\n", irq);
 			spurious_irq_mask |= irqmask;
 		}
-		atomic_inc(&irq_err_count);
+		atomic_inc(&__get_cpu_var(irq_err_counts));
 		/*
 		 * Theoretically we do not have to handle this IRQ,
 		 * but in Linux this does not cause problems and is
Index: 2.6.22.1-rt8/arch/x86_64/kernel/irq.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/irq.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/irq.c	2007-07-25 16:23:12.000000000 -0400
@@ -20,7 +20,18 @@
 #include <asm/idle.h>
 #include <asm/smp.h>
 
-atomic_t irq_err_count;
+DEFINE_PER_CPU(atomic_t, irq_resched_counts);
+DEFINE_PER_CPU(atomic_t, irq_call_counts);
+DEFINE_PER_CPU(atomic_t, irq_spur_counts);
+DEFINE_PER_CPU(atomic_t, irq_tlb_counts);
+DEFINE_PER_CPU(atomic_t, irq_threshold_counts);
+DEFINE_PER_CPU(atomic_t, irq_thermal_counts);
+DEFINE_PER_CPU(atomic_t, irq_err_counts);
+#ifdef CONFIG_X86_IO_APIC
+#ifdef APIC_MISMATCH_DEBUG
+DEFINE_PER_CPU(atomic_t, irq_mis_counts);
+#endif
+#endif
 
 #ifdef CONFIG_DEBUG_STACKOVERFLOW
 /*
@@ -93,7 +104,62 @@
 		for_each_online_cpu(j)
 			seq_printf(p, "%10u ", cpu_pda(j)->apic_timer_irqs);
 		seq_putc(p, '\n');
-		seq_printf(p, "ERR: %10u\n", atomic_read(&irq_err_count));
+#ifdef CONFIG_SMP
+#ifdef RESCHEDULE_VECTOR
+		seq_printf(p, "RES: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_resched_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef CALL_FUNCTION_VECTOR
+		seq_printf(p, "CAL: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_call_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef CONFIG_SMP
+#ifdef INVALIDATE_TLB_VECTOR_START
+		seq_printf(p, "TLB: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_tlb_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
+#ifdef THERMAL_APIC_VECTOR
+		seq_printf(p, "TRM: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_thermal_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef THRESHOLD_APIC_VECTOR
+		seq_printf(p, "THR: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_threshold_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef SPURIOUS_APIC_VECTOR
+		seq_printf(p, "SPU: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_spur_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef ERROR_APIC_VECTOR
+		seq_printf(p, "ERR: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_err_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#ifdef CONFIG_X86_IO_APIC
+#ifdef APIC_MISMATCH_DEBUG
+		seq_printf(p, "MIS: ");
+		for_each_online_cpu(j)
+			seq_printf(p, "%10u ", atomic_read(&per_cpu(irq_mis_counts, j)));
+		seq_putc(p, '\n');
+#endif
+#endif
 	}
 	return 0;
 }
Index: 2.6.22.1-rt8/arch/x86_64/kernel/mce_amd.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/mce_amd.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/mce_amd.c	2007-07-25 16:07:43.000000000 -0400
@@ -186,6 +186,8 @@
 	exit_idle();
 	irq_enter();
 
+	atomic_inc(&__get_cpu_var(irq_threshold_counts));
+
 	memset(&m, 0, sizeof(m));
 	rdtscll(m.tsc);
 	m.cpu = smp_processor_id();
Index: 2.6.22.1-rt8/arch/x86_64/kernel/mce_intel.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/mce_intel.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/mce_intel.c	2007-07-25 16:07:43.000000000 -0400
@@ -21,6 +21,7 @@
 
 	exit_idle();
 	irq_enter();
+	atomic_inc(&__get_cpu_var(irq_thermal_counts));
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
Index: 2.6.22.1-rt8/include/asm-i386/apic.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-i386/apic.h	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-i386/apic.h	2007-07-25 16:07:43.000000000 -0400
@@ -7,6 +7,7 @@
 #include <asm/apicdef.h>
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/atomic.h>
 
 #define Dprintk(x...)
 
@@ -118,6 +119,9 @@
 
 extern void smp_send_nmi_allbutself(void);
 
+DECLARE_PER_CPU(atomic_t, irq_spur_counts);
+DECLARE_PER_CPU(atomic_t, irq_thermal_counts);
+
 #else /* !CONFIG_X86_LOCAL_APIC */
 static inline void lapic_shutdown(void) { }
 
Index: 2.6.22.1-rt8/include/asm-i386/hw_irq.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-i386/hw_irq.h	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-i386/hw_irq.h	2007-07-25 16:07:43.000000000 -0400
@@ -13,6 +13,7 @@
  */
 
 #include <linux/profile.h>
+#include <linux/percpu.h>
 #include <asm/atomic.h>
 #include <asm/irq.h>
 #include <asm/sections.h>
@@ -58,8 +59,11 @@
 
 extern unsigned long io_apic_irqs;
 
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+DECLARE_PER_CPU(atomic_t, irq_resched_counts);
+DECLARE_PER_CPU(atomic_t, irq_call_counts);
+DECLARE_PER_CPU(atomic_t, irq_tlb_counts);
+DECLARE_PER_CPU(atomic_t, irq_err_counts);
+DECLARE_PER_CPU(atomic_t, irq_mis_counts);
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
Index: 2.6.22.1-rt8/include/asm-x86_64/apic.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-x86_64/apic.h	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-x86_64/apic.h	2007-07-25 16:07:43.000000000 -0400
@@ -6,6 +6,7 @@
 #include <asm/fixmap.h>
 #include <asm/apicdef.h>
 #include <asm/system.h>
+#include <asm/atomic.h>
 
 #define Dprintk(x...)
 
@@ -101,4 +102,7 @@
 extern unsigned boot_cpu_id;
 extern int local_apic_timer_c2_ok;
 
+DECLARE_PER_CPU(atomic_t, irq_spur_counts);
+DECLARE_PER_CPU(atomic_t, irq_thermal_counts);
+
 #endif /* __ASM_APIC_H */
Index: 2.6.22.1-rt8/include/asm-x86_64/hw_irq.h
===================================================================
--- 2.6.22.1-rt8.orig/include/asm-x86_64/hw_irq.h	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/include/asm-x86_64/hw_irq.h	2007-07-25 16:07:43.000000000 -0400
@@ -123,8 +123,12 @@
 
 extern unsigned long io_apic_irqs;
 
-extern atomic_t irq_err_count;
-extern atomic_t irq_mis_count;
+DECLARE_PER_CPU(atomic_t, irq_resched_counts);
+DECLARE_PER_CPU(atomic_t, irq_call_counts);
+DECLARE_PER_CPU(atomic_t, irq_tlb_counts);
+DECLARE_PER_CPU(atomic_t, irq_threshold_counts);
+DECLARE_PER_CPU(atomic_t, irq_err_counts);
+DECLARE_PER_CPU(atomic_t, irq_mis_counts);
 
 #define IO_APIC_IRQ(x) (((x) >= 16) || ((1<<(x)) & io_apic_irqs))
 
Index: 2.6.22.1-rt8/arch/x86_64/kernel/smp.c
===================================================================
--- 2.6.22.1-rt8.orig/arch/x86_64/kernel/smp.c	2007-07-25 16:07:23.000000000 -0400
+++ 2.6.22.1-rt8/arch/x86_64/kernel/smp.c	2007-07-25 16:07:43.000000000 -0400
@@ -133,6 +133,8 @@
 	int sender;
 	union smp_flush_state *f;
 
+	atomic_inc(&__get_cpu_var(irq_tlb_counts));
+
 	cpu = smp_processor_id();
 	/*
 	 * orig_rax contains the negated interrupt vector.
@@ -508,6 +510,7 @@
 asmlinkage void smp_reschedule_interrupt(void)
 {
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_resched_counts));
 }
 
 asmlinkage void smp_call_function_interrupt(void)
@@ -517,6 +520,7 @@
 	int wait = call_data->wait;
 
 	ack_APIC_irq();
+	atomic_inc(&__get_cpu_var(irq_call_counts));
 	/*
 	 * Notify initiating CPU that I've grabbed the data and am
 	 * about to execute the function

--=-EsU/qJxaCSrl+o2Misva--

