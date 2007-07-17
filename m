Return-Path: <linux-kernel-owner+w=401wt.eu-S933954AbXGQQvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954AbXGQQvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbXGQQu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:50:57 -0400
Received: from il.qumranet.com ([82.166.9.18]:42596 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbXGQQu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:50:56 -0400
From: Avi Kivity <avi@qumranet.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [GIT PULL][RESEND #2] KVM Updates for 2.6.23-rc1
Date: Tue, 17 Jul 2007 19:51:04 +0300
Message-Id: <11846910642166-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.2.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

I fixed the issue with the previous patchset.  Please provide further feedback,
or pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git for-linus

This contains kvm updates for the 2.6.23 merge window, including

 - performance improvements
 - suspend/resume fixes
 - guest smp
 - random fixes and cleanups

Anthony Liguori (1):
      KVM: SVM: Allow direct guest access to PC debug port

Avi Kivity (57):
      KVM: Assume that writes smaller than 4 bytes are to non-pagetable pages
      KVM: Avoid saving and restoring some host CPU state on lightweight vmexit
      KVM: Unindent some code
      KVM: Reduce misfirings of the fork detector
      KVM: Be more careful restoring fs on lightweight vmexit
      KVM: Unify kvm_mmu_pre_write() and kvm_mmu_post_write()
      KVM: MMU: Respect nonpae pagetable quadrant when zapping ptes
      KVM: Update shadow pte on write to guest pte
      KVM: Increase mmu shadow cache to 1024 pages
      KVM: Fix potential guest state leak into host
      KVM: Move some more msr mangling into vmx_save_host_state()
      KVM: Rationalize exception bitmap usage
      KVM: Consolidate guest fpu activation and deactivation
      KVM: Set cr0.mp for guests
      KVM: MMU: Simplify kvm_mmu_free_page() a tiny bit
      KVM: MMU: Store shadow page tables as kernel virtual addresses, not physical
      KVM: VMX: Only reload guest msrs if they are already loaded
      KVM: Avoid corrupting tr in real mode
      KVM: Fix vmx I/O bitmap initialization on highmem systems
      KVM: VMX: Use local labels in inline assembly
      KVM: x86 emulator: implement wbinvd
      KVM: MMU: Use slab caches for shadow pages and their headers
      KVM: MMU: Simplify fetch() a little bit
      KVM: MMU: Move set_pte_common() to pte width dependent code
      KVM: MMU: Pass the guest pde to set_pte_common
      KVM: MMU: Fold fix_read_pf() into set_pte_common()
      KVM: MMU: Fold fix_write_pf() into set_pte_common()
      KVM: Move shadow pte modifications from set_pte/set_pde to set_pde_common()
      KVM: Make shadow pte updates atomic
      KVM: MMU: Make setting shadow ptes atomic on i386
      KVM: MMU: Remove cr0.wp tricks
      KVM: MMU: Simpify accessed/dirty/present/nx bit handling
      KVM: MMU: Don't cache guest access bits in the shadow page table
      KVM: MMU: Remove unused large page marker
      KVM: Lazy guest cr3 switching
      KVM: Fix vcpu freeing for guest smp
      KVM: Fix adding an smp virtual machine to the vm list
      KVM: Enable guest smp
      KVM: Move duplicate halt handling code into kvm_main.c
      KVM: Emulate hlt on real mode for Intel
      KVM: Keep an upper bound of initialized vcpus
      KVM: Flush remote tlbs when reducing shadow pte permissions
      KVM: Initialize the BSP bit in the APIC_BASE msr correctly
      KVM: VMX: Ensure vcpu time stamp counter is monotonous
      KVM: VMX: Reinitialize the real-mode tss when entering real mode
      KVM: VMX: Remove unnecessary code in vmx_tlb_flush()
      KVM: Remove kvmfs in favor of the anonymous inodes source
      KVM: Clean up #includes
      HOTPLUG: Add CPU_DYING notifier
      HOTPLUG: Adapt cpuset hotplug callback to CPU_DYING
      HOTPLUG: Adapt thermal throttle to CPU_DYING
      x86_64: Allow smp_call_function_single() to current cpu
      i386: Allow smp_call_function_single() to current cpu
      SMP: Allow smp_call_function_single() to current cpu
      KVM: Keep track of which cpus have virtualization enabled
      KVM: Tune hotplug/suspend IPIs
      KVM: Use CPU_DYING for disabling virtualization

Eddie Dong (5):
      KVM: VMX: Avoid saving and restoring msrs on lightweight vmexit
      KVM: VMX: Cleanup redundant code in MSR set
      KVM: VMX: Avoid saving and restoring msr_efer on lightweight vmexit
      KVM: Use symbolic constants instead of magic numbers
      KVM: Add support for in-kernel pio handlers

Gregory Haskins (2):
      KVM: Adds support for in-kernel mmio handlers
      KVM: VMX: Fix interrupt checking on lightweight exit

He, Qing (1):
      KVM: VMX: Enable io bitmaps to avoid IO port 0x80 VMEXITs

Jan Engelhardt (1):
      Use menuconfig objects II - KVM/Virt

Joerg Roedel (1):
      KVM: SVM: Reliably detect if SVM was disabled by BIOS

Luca Tettamanti (2):
      KVM: Fix x86 emulator writeback
      KVM: Avoid useless memory write when possible

Markus Rechberger (1):
      KVM: Fix includes

Matthew Gregan (1):
      KVM: Implement IA32_EBL_CR_POWERON msr

Nguyen Anh Quynh (1):
      KVM: Remove unnecessary initialization and checks in mark_page_dirty()

Nitin A Kamble (3):
      KVM: VMX: Handle #SS faults from real mode
      KVM: Implement emulation of "pop reg" instruction (opcode 0x58-0x5f)
      KVM: Implement emulation of instruction "ret" (opcode 0xc3)

Robert P. J. Day (1):
      KVM: Replace C code with call to ARRAY_SIZE() macro.

Shani Moideen (2):
      KVM: SVM: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)
      KVM: VMX: Replace memset(<addr>, 0, PAGESIZE) with clear_page(<addr>)

Shaohua Li (1):
      KVM: MMU: Fix Wrong tlb flush order

 arch/i386/kernel/cpu/mcheck/therm_throt.c |    6 +-
 arch/i386/kernel/smpcommon.c              |    8 +-
 arch/x86_64/kernel/smp.c                  |   12 +-
 drivers/kvm/Kconfig                       |    9 +-
 drivers/kvm/kvm.h                         |  116 +++++-
 drivers/kvm/kvm_main.c                    |  456 ++++++++++++--------
 drivers/kvm/mmu.c                         |  292 ++++++-------
 drivers/kvm/paging_tmpl.h                 |  273 +++++++------
 drivers/kvm/svm.c                         |   59 ++-
 drivers/kvm/svm.h                         |    3 +
 drivers/kvm/vmx.c                         |  652 ++++++++++++++++++-----------
 drivers/kvm/x86_emulate.c                 |   44 ++-
 fs/anon_inodes.c                          |    1 +
 include/linux/magic.h                     |    1 -
 include/linux/notifier.h                  |    3 +
 include/linux/smp.h                       |    7 +-
 kernel/cpu.c                              |   16 +-
 kernel/cpuset.c                           |    3 +
 18 files changed, 1198 insertions(+), 763 deletions(-)

Here is the diff outside drivers/kvm/:

diff --git a/arch/i386/kernel/cpu/mcheck/therm_throt.c b/arch/i386/kernel/cpu/mcheck/therm_throt.c
index 7ba7c3a..1203dc5 100644
--- a/arch/i386/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/i386/kernel/cpu/mcheck/therm_throt.c
@@ -134,19 +134,21 @@ static __cpuinit int thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	int err;
 
 	sys_dev = get_cpu_sysdev(cpu);
-	mutex_lock(&therm_cpu_lock);
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		err = thermal_throttle_add_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
+		mutex_lock(&therm_cpu_lock);
 		thermal_throttle_remove_dev(sys_dev);
+		mutex_unlock(&therm_cpu_lock);
 		break;
 	}
-	mutex_unlock(&therm_cpu_lock);
 	return NOTIFY_OK;
 }
 
diff --git a/arch/i386/kernel/smpcommon.c b/arch/i386/kernel/smpcommon.c
index 1868ae1..bbfe85a 100644
--- a/arch/i386/kernel/smpcommon.c
+++ b/arch/i386/kernel/smpcommon.c
@@ -47,7 +47,7 @@ int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 EXPORT_SYMBOL(smp_call_function);
 
 /**
- * smp_call_function_single - Run a function on another CPU
+ * smp_call_function_single - Run a function on a specific CPU
  * @cpu: The target CPU.  Cannot be the calling CPU.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
@@ -66,9 +66,11 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	int ret;
 	int me = get_cpu();
 	if (cpu == me) {
-		WARN_ON(1);
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
-		return -EBUSY;
+		return 0;
 	}
 
 	ret = smp_call_function_mask(cpumask_of_cpu(cpu), func, info, wait);
diff --git a/arch/x86_64/kernel/smp.c b/arch/x86_64/kernel/smp.c
index 2ff4685..0694940 100644
--- a/arch/x86_64/kernel/smp.c
+++ b/arch/x86_64/kernel/smp.c
@@ -357,7 +357,7 @@ __smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 }
 
 /*
- * smp_call_function_single - Run a function on another CPU
+ * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
  * @nonatomic: Currently unused.
@@ -374,14 +374,18 @@ int smp_call_function_single (int cpu, void (*func) (void *info), void *info,
 {
 	/* prevent preemption and reschedule on another processor */
 	int me = get_cpu();
+
+	/* Can deadlock when called with interrupts disabled */
+	WARN_ON(irqs_disabled());
+
 	if (cpu == me) {
+		local_irq_disable();
+		func(info);
+		local_irq_enable();
 		put_cpu();
 		return 0;
 	}
 
-	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
-
 	spin_lock_bh(&call_lock);
 	__smp_call_function_single(cpu, func, info, nonatomic, wait);
 	spin_unlock_bh(&call_lock);
diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 40fe3a3..edc6748 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -139,6 +139,7 @@ err_put_filp:
 	put_filp(file);
 	return error;
 }
+EXPORT_SYMBOL_GPL(anon_inode_getfd);
 
 /*
  * A single inode exist for all anon_inode files. Contrary to pipes,
diff --git a/include/linux/magic.h b/include/linux/magic.h
index 9d713c0..36cc20d 100644
--- a/include/linux/magic.h
+++ b/include/linux/magic.h
@@ -13,7 +13,6 @@
 #define HPFS_SUPER_MAGIC	0xf995e849
 #define ISOFS_SUPER_MAGIC	0x9660
 #define JFFS2_SUPER_MAGIC	0x72b6
-#define KVMFS_SUPER_MAGIC	0x19700426
 #define ANON_INODE_FS_MAGIC	0x09041934
 
 #define MINIX_SUPER_MAGIC	0x137F		/* original minix fs */
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index 9431101..576f2bb 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -196,6 +196,8 @@ extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_LOCK_ACQUIRE	0x0008 /* Acquire all hotcpu locks */
 #define CPU_LOCK_RELEASE	0x0009 /* Release all hotcpu locks */
+#define CPU_DYING		0x000A /* CPU (unsigned)v not running any task,
+				        * not handling interrupts, soon dead */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
@@ -208,6 +210,7 @@ extern int __srcu_notifier_call_chain(struct srcu_notifier_head *nh,
 #define CPU_DOWN_PREPARE_FROZEN	(CPU_DOWN_PREPARE | CPU_TASKS_FROZEN)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
+#define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_NOTIFIER_H */
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 96ac21f..8039dac 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -7,6 +7,7 @@
  */
 
 #include <linux/errno.h>
+#include <asm/system.h>
 
 extern void cpu_idle(void);
 
@@ -102,7 +103,11 @@ static inline void smp_send_reschedule(int cpu) { }
 static inline int smp_call_function_single(int cpuid, void (*func) (void *info),
 					   void *info, int retry, int wait)
 {
-	return -EBUSY;
+	WARN_ON(cpuid != 0);
+	local_irq_disable();
+	func(info);
+	local_irq_enable();
+	return 0;
 }
 
 #endif /* !SMP */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 208cf34..181ae70 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -103,11 +103,19 @@ static inline void check_for_tasks(int cpu)
 	write_unlock_irq(&tasklist_lock);
 }
 
+struct take_cpu_down_param {
+	unsigned long mod;
+	void *hcpu;
+};
+
 /* Take this CPU down. */
-static int take_cpu_down(void *unused)
+static int take_cpu_down(void *_param)
 {
+	struct take_cpu_down_param *param = _param;
 	int err;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
@@ -127,6 +135,10 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	cpumask_t old_allowed, tmp;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	struct take_cpu_down_param tcd_param = {
+		.mod = mod,
+		.hcpu = hcpu,
+	};
 
 	if (num_online_cpus() == 1)
 		return -EBUSY;
@@ -153,7 +165,7 @@ static int _cpu_down(unsigned int cpu, int tasks_frozen)
 	set_cpus_allowed(current, tmp);
 
 	mutex_lock(&cpu_bitmask_lock);
-	p = __stop_machine_run(take_cpu_down, NULL, cpu);
+	p = __stop_machine_run(take_cpu_down, &tcd_param, cpu);
 	mutex_unlock(&cpu_bitmask_lock);
 
 	if (IS_ERR(p) || cpu_online(cpu)) {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4c49188..c4d123f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2138,6 +2138,9 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *nb,
 				unsigned long phase, void *cpu)
 {
+	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+		return NOTIFY_DONE;
+
 	common_cpu_mem_hotplug_unplug();
 	return 0;
 }
