Return-Path: <linux-kernel-owner+w=401wt.eu-S1761842AbZE0ACq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761842AbZE0ACq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 20:02:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbZEZXzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:55:17 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38636 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbZEZXy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:54:58 -0400
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org
Cc: Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 31/31] x86: MCE: Support action-optional machine checks v2
Date: Wed, 27 May 2009 01:54:33 +0200
Message-Id: <56b13a3c9a5860c8ea97c335956e9bc0036e3186.1243381848.git.ak@linux.intel.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <b8d69f4b36e5bd96c165e59567286081fc49faf0.1243381848.git.ak@linux.intel.com>
References: <1243382073-29338-1-git-send-email-andi@firstfloor.org>
 <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
 <c1d7bf910168f07efb50d98f901f41e289a87f1f.1243381848.git.ak@linux.intel.com>
 <6c6d1f8bbbd2312884dca5a5c75aa5f5a87dae4b.1243381848.git.ak@linux.intel.com>
 <1623cd9a1c77d35fc2044d72c4bfa1246e67a1c0.1243381848.git.ak@linux.intel.com>
 <723b3fe4e35063b123cee9658c24267287eeac07.1243381848.git.ak@linux.intel.com>
 <0301db6d6dabb8bcfaffe76a907a5036646c207d.1243381848.git.ak@linux.intel.com>
 <abf61c300dec40b8e93bb5ae7154a0633c682799.1243381848.git.ak@linux.intel.com>
 <23417423c34ad949f53ebc947af8d18672a79a40.1243381848.git.ak@linux.intel.com>
 <347567c2ace55b336b1a43a67323ff8b86b80243.1243381848.git.ak@linux.intel.com>
 <3e29698799ad2c02429613323897a6e61a0a7d01.1243381848.git.ak@linux.intel.com>
 <34082fc262bae2f910f1a940622173445aea72cd.1243381848.git.ak@linux.intel.com>
 <c3a768c37edad55939c6f9391001fb95e658ffe6.1243381848.git.ak@linux.intel.com>
 <37501061dc5d5581fefcaff92c2606e39cc61913.1243381848.git.ak@linux.intel.com>
 <10e478c24139e29e7e74529edd694858ec2fb7ea.1243381848.git.ak@linux.intel.com>
 <a541b2bc620d04dd777acd27a37f564ec757fe8b.1243381848.git.ak@linux.intel.com>
 <abfc8311c5aff38314860d82db449c6c62e9e34d.1243381848.git.ak@linux.intel.com>
 <b55d8c3d2842ee10f4b06f17cc2658f81b4f7b4e.1243381848.git.ak@linux.intel.com>
 <7efad2e5492abb8f94577a81c2ca397a968064d7.1243381848.git.ak@linux.intel.com>
 <0f7e10122c48b7988b1676be5e7fc75f2c561215.1243381848.git.ak@linux.intel.com>
 <314f7c278aaaa41854bf4f0837a4ca6126160fc8.1243381848.git.ak@linux.intel.com>
 <ecbed09ba385129558d6341f6a48c64edaa164b4.1243381848.git.ak@linux.intel.com>
 <d9664a5ed1cdbfcd7888c7c7114619494114d4ab.1243381848.git.ak@linux.intel.com>
 <172ffa34ba8bc6a493e26f7e97fb7239f906b4e8.1243381848.git.ak@linux.intel.com>
 <e224e71ae8e2b578d4b4a0a079eea963445eaf91.1243381848.git.ak@linux.intel.com>
 <650bd32edc1814f1f792a07de9c5efebefc9c0b3.1243381848.git.ak@linux.intel.com>
 <b464e1eb871500ad8f4f6e5e5f6d394aec97e037.1243381848.git.ak@linux.intel.com>
 <2a7abea3d00cb5a1508d54b45bdb7a94fead46ee.1243381848.git.ak@linux.intel.com>
 <504bce650bbfaa513c9386cfd77edf5f5941654b.1243381848.git.ak@linux.intel.com>
 <7532f66f86301d6d2a192a306d0958f6ac1d0c2e.1243381848.git.ak@linux.intel.com>
 <b8d69f4b36e5bd96c165e59567286081fc49faf0.1243381848.git.ak@linux.intel.com>
In-Reply-To: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
References: <c63915cfa51e24394524ddaa66a6f2cb2fcfe66f.1243381848.git.ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Newer Intel CPUs support a new class of machine checks called recoverable
action optional.

Action Optional means that the CPU detected some form of corruption in
the background and tells the OS about using a machine check
exception. The OS can then take appropiate action, like killing the
process with the corrupted data or logging the event properly to disk.

This is done by the new generic high level memory failure handler added in a
earlier patch. The high level handler takes the address with the failed
memory and does the appropiate action, like killing the process.

In this version of the patch the high level handler is stubbed out
with a weak function to not create a direct dependency on the hwpoison
branch.

The high level handler cannot be directly called from the machine check
exception though, because it has to run in a defined process context to be able
to sleep when taking VM locks (it is not expected to sleep for a long time,
just do so in some exceptional cases like lock contention)

Thus the MCE handler has to queue a work item for process context,
trigger process context and then call the high level handler from there.

This patch adds two path to process context: through a per thread kernel exit
notify_user() callback or through a high priority work item.  The first
runs when the process exits back to user space, the other when it goes
to sleep and there is no higher priority process.

The machine check handler will schedule both, and whoever runs first
will grab the event. This is done because quick reaction to this
event is critical to avoid a potential more fatal machine check
when the corruption is consumed.

There is a simple lock less ring buffer to queue the corrupted
addresses between the exception handler and the process context handler.
Then in process context it just calls the high level VM code with
the corrupted PFNs.

The code adds the required code to extract the failed address from
the CPU's machine check registers. It doesn't try to handle all
possible cases -- the specification has 6 different ways to specify
memory address -- but only the linear address.

Most of the required checking has been already done earlier in the
mce_severity rule checking engine.  Following the Intel
recommendations Action Optional errors are only enabled for known
situations (encoded in MCACODs). The errors are ignored otherwise,
because they are action optional.

v2: Improve comment, disable preemption while processing ring buffer
    (reported by Ying Huang)

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/mce.h       |    1 +
 arch/x86/kernel/cpu/mcheck/mce.c |  133 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/signal.c         |    2 +-
 3 files changed, 135 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 52dbac5..2cd8f6a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -160,6 +160,7 @@ enum mcp_flags {
 extern void machine_check_poll(enum mcp_flags flags, mce_banks_t *b);
 
 extern int mce_notify_irq(void);
+extern void mce_notify_process(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a3470b3..7cdbdf9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -31,6 +31,7 @@
 #include <linux/nmi.h>
 #include <linux/cpu.h>
 #include <linux/fs.h>
+#include <linux/mm.h>
 
 #include <asm/processor.h>
 #include <asm/uaccess.h>
@@ -105,6 +106,8 @@ static inline int skip_bank_init(int i)
 	return i < BITS_PER_LONG && test_bit(i, &dont_init_banks);
 }
 
+static DEFINE_PER_CPU(struct work_struct, mce_work);
+
 /* Do initial initialization of a struct mce */
 void mce_setup(struct mce *m)
 {
@@ -311,6 +314,61 @@ static void mce_wrmsrl(u32 msr, u64 v)
 	wrmsrl(msr, v);
 }
 
+/*
+ * Simple lockless ring to communicate PFNs from the exception handler with the
+ * process context work function. This is vastly simplified because there's
+ * only a single reader and a single writer.
+ */
+#define MCE_RING_SIZE 16	/* we use one entry less */
+
+struct mce_ring {
+	unsigned short start;
+	unsigned short end;
+	unsigned long ring[MCE_RING_SIZE];
+};
+static DEFINE_PER_CPU(struct mce_ring, mce_ring);
+
+/* Runs with CPU affinity in workqueue */
+static int mce_ring_empty(void)
+{
+	struct mce_ring *r = &__get_cpu_var(mce_ring);
+
+	return r->start == r->end;
+}
+
+static int mce_ring_get(unsigned long *pfn)
+{
+	struct mce_ring *r;
+	int ret = 0;
+
+	*pfn = 0;
+	get_cpu();
+	r = &__get_cpu_var(mce_ring);
+	if (r->start == r->end)
+		goto out;
+	*pfn = r->ring[r->start];
+	r->start = (r->start + 1) % MCE_RING_SIZE;
+	ret = 1;
+out:
+	put_cpu();
+	return ret;
+}
+
+/* Always runs in MCE context with preempt off */
+static int mce_ring_add(unsigned long pfn)
+{
+	struct mce_ring *r = &__get_cpu_var(mce_ring);
+	unsigned next;
+
+	next = (r->end + 1) % MCE_RING_SIZE;
+	if (next == r->start)
+		return -1;
+	r->ring[r->end] = pfn;
+	wmb();
+	r->end = next;
+	return 0;
+}
+
 int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mce_disabled)
@@ -336,6 +394,15 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
+static void mce_schedule_work(void)
+{
+	if (!mce_ring_empty()) {
+		struct work_struct *work = &__get_cpu_var(mce_work);
+		if (!work_pending(work))
+			schedule_work(work);
+	}
+}
+
 /*
  * Called after interrupts have been reenabled again
  * when a MCE happened during an interrupts off region
@@ -347,6 +414,7 @@ asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
 	exit_idle();
 	irq_enter();
 	mce_notify_irq();
+	mce_schedule_work();
 	irq_exit();
 }
 
@@ -354,6 +422,13 @@ static void mce_report_event(struct pt_regs *regs)
 {
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
 		mce_notify_irq();
+		/*
+		 * Triggering the work queue here is just an insurance
+		 * policy in case the syscall exit notify handler
+		 * doesn't run soon enough or ends up running on the
+		 * wrong CPU (can happen when audit sleeps)
+		 */
+		mce_schedule_work();
 		return;
 	}
 
@@ -728,6 +803,23 @@ reset:
 	return ret;
 }
 
+/*
+ * Check if the address reported by the CPU is in a format we can parse.
+ * It would be possible to add code for most other cases, but all would
+ * be somewhat complicated (e.g. segment offset would require an instruction
+ * parser). So only support physical addresses upto page granuality for now.
+ */
+static int mce_usable_address(struct mce *m)
+{
+	if (!(m->status & MCI_STATUS_MISCV) || !(m->status & MCI_STATUS_ADDRV))
+		return 0;
+	if ((m->misc & 0x3f) > PAGE_SHIFT)
+		return 0;
+	if (((m->misc >> 6) & 7) != MCM_ADDR_PHYS)
+		return 0;
+	return 1;
+}
+
 static void mce_clear_state(unsigned long *toclear)
 {
 	int i;
@@ -862,6 +954,16 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 		if (m.status & MCI_STATUS_ADDRV)
 			m.addr = mce_rdmsrl(MSR_IA32_MC0_ADDR + i*4);
 
+		/*
+		 * Action optional error. Queue address for later processing.
+		 * When the ring overflows we just ignore the AO error.
+		 * RED-PEN add some logging mechanism when
+		 * usable_address or mce_add_ring fails.
+		 * RED-PEN don't ignore overflow for tolerant == 0
+		 */
+		if (severity == MCE_AO_SEVERITY && mce_usable_address(&m))
+			mce_ring_add(m.addr >> PAGE_SHIFT);
+
 		mce_get_rip(&m, regs);
 		mce_log(&m);
 
@@ -912,6 +1014,36 @@ out:
 }
 EXPORT_SYMBOL_GPL(do_machine_check);
 
+/* dummy to break dependency. actual code is in mm/memory-failure.c */
+void __attribute__((weak)) memory_failure(unsigned long pfn, unsigned vector)
+{
+	printk(KERN_ERR "Action optional memory failure at %lx ignored\n", pfn);
+}
+
+/*
+ * Called after mce notification in process context. This code
+ * is allowed to sleep. Call the high level VM handler to process
+ * any corrupted pages.
+ * Assume that the work queue code only calls this one at a time
+ * per CPU.
+ * Note we don't disable preemption, so this code might run on the wrong
+ * CPU. In this case the event is picked up by the scheduled work queue.
+ * This is merely a fast path to expedite processing in some common
+ * cases.
+ */
+void mce_notify_process(void)
+{
+	unsigned long pfn;
+	mce_notify_irq();
+	while (mce_ring_get(&pfn))
+		memory_failure(pfn, MCE_VECTOR);
+}
+
+static void mce_process_work(struct work_struct *dummy)
+{
+	mce_notify_process();
+}
+
 #ifdef CONFIG_X86_MCE_INTEL
 /***
  * mce_log_therm_throt_event - Logs the thermal throttling event to mcelog
@@ -1202,6 +1334,7 @@ void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
 	mce_init();
 	mce_cpu_features(c);
 	mce_init_timer();
+	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
 }
 
 /*
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index d5dc15b..4976888 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -860,7 +860,7 @@ do_notify_resume(struct pt_regs *regs, void *unused, __u32 thread_info_flags)
 #ifdef CONFIG_X86_NEW_MCE
 	/* notify userspace of pending MCEs */
 	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_irq();
+		mce_notify_process();
 #endif /* CONFIG_X86_64 && CONFIG_X86_MCE */
 
 	/* deal with pending signal delivery */
-- 
1.6.0.2

