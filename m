Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYE2JAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYE2JAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYE2I6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:58:43 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15861 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173AbYE2I6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:58:35 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 1/2] smp_call_function: get rid of the unused nonatomic/retry argument
Date: Thu, 29 May 2008 11:01:00 +0200
Message-Id: <1212051661-12733-2-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.6.rc0.40.gd683
In-Reply-To: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's never used and the comments refer to nonatomic and retry
interchangably. So get rid of it.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/alpha/kernel/core_marvel.c      |    2 +-
 arch/alpha/kernel/smp.c              |    6 +++---
 arch/alpha/oprofile/common.c         |    6 +++---
 arch/arm/oprofile/op_model_mpcore.c  |    2 +-
 arch/arm/vfp/vfpmodule.c             |    2 +-
 arch/cris/arch-v32/kernel/smp.c      |    5 ++---
 arch/ia64/kernel/mca.c               |    2 +-
 arch/ia64/kernel/palinfo.c           |    2 +-
 arch/ia64/kernel/perfmon.c           |    2 +-
 arch/ia64/kernel/process.c           |    2 +-
 arch/ia64/kernel/smpboot.c           |    2 +-
 arch/ia64/kernel/uncached.c          |    5 ++---
 arch/ia64/sn/kernel/sn2/sn_hwperf.c  |    2 +-
 arch/m32r/kernel/smp.c               |    4 ++--
 arch/mips/kernel/smp.c               |    4 ++--
 arch/mips/mm/c-r4k.c                 |   18 +++++++++---------
 arch/mips/pmc-sierra/yosemite/prom.c |    2 +-
 arch/mips/sibyte/cfe/setup.c         |    2 +-
 arch/mips/sibyte/sb1250/prom.c       |    2 +-
 arch/powerpc/kernel/smp.c            |    2 +-
 arch/s390/appldata/appldata_base.c   |    4 ++--
 arch/s390/kernel/smp.c               |   16 ++++++----------
 arch/s390/kernel/time.c              |    4 ++--
 arch/sh/kernel/smp.c                 |   10 +++++-----
 arch/sparc64/kernel/smp.c            |   12 ++++--------
 arch/um/kernel/smp.c                 |    3 +--
 arch/x86/kernel/cpu/mtrr/main.c      |    4 ++--
 arch/x86/kernel/cpuid.c              |    2 +-
 arch/x86/kernel/ldt.c                |    2 +-
 arch/x86/kernel/nmi_32.c             |    2 +-
 arch/x86/kernel/nmi_64.c             |    2 +-
 arch/x86/kernel/smp.c                |    2 +-
 arch/x86/kernel/vsyscall_64.c        |    2 +-
 arch/x86/kvm/vmx.c                   |    2 +-
 arch/x86/kvm/x86.c                   |    2 +-
 arch/x86/lib/msr-on-cpu.c            |    8 ++++----
 arch/x86/mach-voyager/voyager_smp.c  |    2 +-
 arch/x86/xen/smp.c                   |    2 +-
 drivers/acpi/processor_idle.c        |    2 +-
 drivers/cpuidle/cpuidle.c            |    2 +-
 include/asm-alpha/smp.h              |    2 +-
 include/asm-sparc/smp.h              |    2 +-
 include/linux/smp.h                  |    8 ++++----
 kernel/smp.c                         |    6 ++----
 kernel/softirq.c                     |    2 +-
 kernel/time/tick-broadcast.c         |    2 +-
 net/core/flow.c                      |    2 +-
 net/iucv/iucv.c                      |   14 +++++++-------
 virt/kvm/kvm_main.c                  |    6 +++---
 49 files changed, 95 insertions(+), 108 deletions(-)

diff --git a/arch/alpha/kernel/core_marvel.c b/arch/alpha/kernel/core_marvel.c
index ced4aae..04dcc5e 100644
--- a/arch/alpha/kernel/core_marvel.c
+++ b/arch/alpha/kernel/core_marvel.c
@@ -662,7 +662,7 @@ __marvel_rtc_io(u8 b, unsigned long addr, int write)
 		if (smp_processor_id() != boot_cpuid)
 			smp_call_function_single(boot_cpuid,
 						 __marvel_access_rtc,
-						 &rtc_access, 1, 1);
+						 &rtc_access, 1);
 		else
 			__marvel_access_rtc(&rtc_access);
 #else
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 95c905b..44114c8 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -710,7 +710,7 @@ flush_tlb_mm(struct mm_struct *mm)
 		}
 	}
 
-	if (smp_call_function(ipi_flush_tlb_mm, mm, 1, 1)) {
+	if (smp_call_function(ipi_flush_tlb_mm, mm, 1)) {
 		printk(KERN_CRIT "flush_tlb_mm: timed out\n");
 	}
 
@@ -763,7 +763,7 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 	data.mm = mm;
 	data.addr = addr;
 
-	if (smp_call_function(ipi_flush_tlb_page, &data, 1, 1)) {
+	if (smp_call_function(ipi_flush_tlb_page, &data, 1)) {
 		printk(KERN_CRIT "flush_tlb_page: timed out\n");
 	}
 
@@ -815,7 +815,7 @@ flush_icache_user_range(struct vm_area_struct *vma, struct page *page,
 		}
 	}
 
-	if (smp_call_function(ipi_flush_icache_page, mm, 1, 1)) {
+	if (smp_call_function(ipi_flush_icache_page, mm, 1)) {
 		printk(KERN_CRIT "flush_icache_page: timed out\n");
 	}
 
diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index 9fc0eeb..7c3d5ec 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -65,7 +65,7 @@ op_axp_setup(void)
 	model->reg_setup(&reg, ctr, &sys);
 
 	/* Configure the registers on all cpus.  */
-	(void)smp_call_function(model->cpu_setup, &reg, 0, 1);
+	(void)smp_call_function(model->cpu_setup, &reg, 1);
 	model->cpu_setup(&reg);
 	return 0;
 }
@@ -86,7 +86,7 @@ op_axp_cpu_start(void *dummy)
 static int
 op_axp_start(void)
 {
-	(void)smp_call_function(op_axp_cpu_start, NULL, 0, 1);
+	(void)smp_call_function(op_axp_cpu_start, NULL, 1);
 	op_axp_cpu_start(NULL);
 	return 0;
 }
@@ -101,7 +101,7 @@ op_axp_cpu_stop(void *dummy)
 static void
 op_axp_stop(void)
 {
-	(void)smp_call_function(op_axp_cpu_stop, NULL, 0, 1);
+	(void)smp_call_function(op_axp_cpu_stop, NULL, 1);
 	op_axp_cpu_stop(NULL);
 }
 
diff --git a/arch/arm/oprofile/op_model_mpcore.c b/arch/arm/oprofile/op_model_mpcore.c
index 74fae60..4458705 100644
--- a/arch/arm/oprofile/op_model_mpcore.c
+++ b/arch/arm/oprofile/op_model_mpcore.c
@@ -201,7 +201,7 @@ static int em_call_function(int (*fn)(void))
 	data.ret = 0;
 
 	preempt_disable();
-	smp_call_function(em_func, &data, 1, 1);
+	smp_call_function(em_func, &data, 1);
 	em_func(&data);
 	preempt_enable();
 
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 32455c6..c0d2c9b 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -352,7 +352,7 @@ static int __init vfp_init(void)
 	else if (vfpsid & FPSID_NODOUBLE) {
 		printk("no double precision support\n");
 	} else {
-		smp_call_function(vfp_enable, NULL, 1, 1);
+		smp_call_function(vfp_enable, NULL, 1);
 
 		VFP_arch = (vfpsid & FPSID_ARCH_MASK) >> FPSID_ARCH_BIT;  /* Extract the architecture version */
 		printk("implementor %02x architecture %d part %02x variant %x rev %x\n",
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index a9c3334..952a24b 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -194,7 +194,7 @@ void stop_this_cpu(void* dummy)
 /* Other calls */
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 int setup_profiling_timer(unsigned int multiplier)
@@ -316,8 +316,7 @@ int send_ipi(int vector, int wait, cpumask_t cpu_mask)
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function(void (*func)(void *info), void *info,
-		      int nonatomic, int wait)
+int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
 	cpumask_t cpu_mask = CPU_MASK_ALL;
 	struct call_data_struct data;
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 705176b..9cd818c 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1881,7 +1881,7 @@ static int __cpuinit mca_cpu_callback(struct notifier_block *nfb,
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		smp_call_function_single(hotcpu, ia64_mca_cmc_vector_adjust,
-					 NULL, 1, 0);
+					 NULL, 0);
 		break;
 	}
 	return NOTIFY_OK;
diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index 9dc00f7..e5c57f4 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -921,7 +921,7 @@ int palinfo_handle_smp(pal_func_cpu_u_t *f, char *page)
 
 
 	/* will send IPI to other CPU and wait for completion of remote call */
-	if ((ret=smp_call_function_single(f->req_cpu, palinfo_smp_call, &ptr, 0, 1))) {
+	if ((ret=smp_call_function_single(f->req_cpu, palinfo_smp_call, &ptr, 1))) {
 		printk(KERN_ERR "palinfo: remote CPU call from %d to %d on function %d: "
 		       "error %d\n", smp_processor_id(), f->req_cpu, f->func_id, ret);
 		return 0;
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index 71d0513..080f41c 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -1820,7 +1820,7 @@ pfm_syswide_cleanup_other_cpu(pfm_context_t *ctx)
 	int ret;
 
 	DPRINT(("calling CPU%d for cleanup\n", ctx->ctx_cpu));
-	ret = smp_call_function_single(ctx->ctx_cpu, pfm_syswide_force_stop, ctx, 0, 1);
+	ret = smp_call_function_single(ctx->ctx_cpu, pfm_syswide_force_stop, ctx, 1);
 	DPRINT(("called CPU%d for cleanup ret=%d\n", ctx->ctx_cpu, ret));
 }
 #endif /* CONFIG_SMP */
diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
index a3a34b4..fabaf08 100644
--- a/arch/ia64/kernel/process.c
+++ b/arch/ia64/kernel/process.c
@@ -286,7 +286,7 @@ void cpu_idle_wait(void)
 {
 	smp_mb();
 	/* kick all the CPUs so that they exit out of pm_idle */
-	smp_call_function(do_nothing, NULL, 0, 1);
+	smp_call_function(do_nothing, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(cpu_idle_wait);
 
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index d7ad42b..99032f9 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -317,7 +317,7 @@ ia64_sync_itc (unsigned int master)
 
 	go[MASTER] = 1;
 
-	if (smp_call_function_single(master, sync_master, NULL, 1, 0) < 0) {
+	if (smp_call_function_single(master, sync_master, NULL, 0) < 0) {
 		printk(KERN_ERR "sync_itc: failed to get attention of CPU %u!\n", master);
 		return;
 	}
diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index e77995a..8eff8c1 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -123,8 +123,7 @@ static int uncached_add_chunk(struct uncached_pool *uc_pool, int nid)
 	status = ia64_pal_prefetch_visibility(PAL_VISIBILITY_PHYSICAL);
 	if (status == PAL_VISIBILITY_OK_REMOTE_NEEDED) {
 		atomic_set(&uc_pool->status, 0);
-		status = smp_call_function(uncached_ipi_visibility, uc_pool,
-					   0, 1);
+		status = smp_call_function(uncached_ipi_visibility, uc_pool, 1);
 		if (status || atomic_read(&uc_pool->status))
 			goto failed;
 	} else if (status != PAL_VISIBILITY_OK)
@@ -146,7 +145,7 @@ static int uncached_add_chunk(struct uncached_pool *uc_pool, int nid)
 	if (status != PAL_STATUS_SUCCESS)
 		goto failed;
 	atomic_set(&uc_pool->status, 0);
-	status = smp_call_function(uncached_ipi_mc_drain, uc_pool, 0, 1);
+	status = smp_call_function(uncached_ipi_mc_drain, uc_pool, 1);
 	if (status || atomic_read(&uc_pool->status))
 		goto failed;
 
diff --git a/arch/ia64/sn/kernel/sn2/sn_hwperf.c b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
index 8cc0c47..636588e 100644
--- a/arch/ia64/sn/kernel/sn2/sn_hwperf.c
+++ b/arch/ia64/sn/kernel/sn2/sn_hwperf.c
@@ -629,7 +629,7 @@ static int sn_hwperf_op_cpu(struct sn_hwperf_op_info *op_info)
 		if (use_ipi) {
 			/* use an interprocessor interrupt to call SAL */
 			smp_call_function_single(cpu, sn_hwperf_call_sal,
-				op_info, 1, 1);
+				op_info, 1);
 		}
 		else {
 			/* migrate the task before calling SAL */ 
diff --git a/arch/m32r/kernel/smp.c b/arch/m32r/kernel/smp.c
index 74eb7bc..7577f97 100644
--- a/arch/m32r/kernel/smp.c
+++ b/arch/m32r/kernel/smp.c
@@ -212,7 +212,7 @@ void smp_flush_tlb_all(void)
 	local_irq_save(flags);
 	__flush_tlb_all();
 	local_irq_restore(flags);
-	smp_call_function(flush_tlb_all_ipi, NULL, 1, 1);
+	smp_call_function(flush_tlb_all_ipi, NULL, 1);
 	preempt_enable();
 }
 
@@ -505,7 +505,7 @@ void smp_invalidate_interrupt(void)
  *==========================================================================*/
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 /*==========================================================================*
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index c75b26c..7a9ae83 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -167,7 +167,7 @@ static void stop_this_cpu(void *dummy)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 1, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 void __init smp_cpus_done(unsigned int max_cpus)
@@ -266,7 +266,7 @@ static void flush_tlb_mm_ipi(void *mm)
 static inline void smp_on_other_tlbs(void (*func) (void *info), void *info)
 {
 #ifndef CONFIG_MIPS_MT_SMTC
-	smp_call_function(func, info, 1, 1);
+	smp_call_function(func, info, 1);
 #endif
 }
 
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 643c8bc..8d55bd9 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -43,12 +43,12 @@
  *    primary cache.
  */
 static inline void r4k_on_each_cpu(void (*func) (void *info), void *info,
-                                   int retry, int wait)
+                                   int wait)
 {
 	preempt_disable();
 
 #if !defined(CONFIG_MIPS_MT_SMP) && !defined(CONFIG_MIPS_MT_SMTC)
-	smp_call_function(func, info, retry, wait);
+	smp_call_function(func, info, wait);
 #endif
 	func(info);
 	preempt_enable();
@@ -350,7 +350,7 @@ static inline void local_r4k___flush_cache_all(void * args)
 
 static void r4k___flush_cache_all(void)
 {
-	r4k_on_each_cpu(local_r4k___flush_cache_all, NULL, 1, 1);
+	r4k_on_each_cpu(local_r4k___flush_cache_all, NULL, 1);
 }
 
 static inline int has_valid_asid(const struct mm_struct *mm)
@@ -397,7 +397,7 @@ static void r4k_flush_cache_range(struct vm_area_struct *vma,
 	int exec = vma->vm_flags & VM_EXEC;
 
 	if (cpu_has_dc_aliases || (exec && !cpu_has_ic_fills_f_dc))
-		r4k_on_each_cpu(local_r4k_flush_cache_range, vma, 1, 1);
+		r4k_on_each_cpu(local_r4k_flush_cache_range, vma, 1);
 }
 
 static inline void local_r4k_flush_cache_mm(void * args)
@@ -429,7 +429,7 @@ static void r4k_flush_cache_mm(struct mm_struct *mm)
 	if (!cpu_has_dc_aliases)
 		return;
 
-	r4k_on_each_cpu(local_r4k_flush_cache_mm, mm, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_mm, mm, 1);
 }
 
 struct flush_cache_page_args {
@@ -518,7 +518,7 @@ static void r4k_flush_cache_page(struct vm_area_struct *vma,
 	args.addr = addr;
 	args.pfn = pfn;
 
-	r4k_on_each_cpu(local_r4k_flush_cache_page, &args, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_page, &args, 1);
 }
 
 static inline void local_r4k_flush_data_cache_page(void * addr)
@@ -532,7 +532,7 @@ static void r4k_flush_data_cache_page(unsigned long addr)
 		local_r4k_flush_data_cache_page((void *)addr);
 	else
 		r4k_on_each_cpu(local_r4k_flush_data_cache_page, (void *) addr,
-			        1, 1);
+			        1);
 }
 
 struct flush_icache_range_args {
@@ -568,7 +568,7 @@ static void r4k_flush_icache_range(unsigned long start, unsigned long end)
 	args.start = start;
 	args.end = end;
 
-	r4k_on_each_cpu(local_r4k_flush_icache_range, &args, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_icache_range, &args, 1);
 	instruction_hazard();
 }
 
@@ -669,7 +669,7 @@ static void local_r4k_flush_cache_sigtramp(void * arg)
 
 static void r4k_flush_cache_sigtramp(unsigned long addr)
 {
-	r4k_on_each_cpu(local_r4k_flush_cache_sigtramp, (void *) addr, 1, 1);
+	r4k_on_each_cpu(local_r4k_flush_cache_sigtramp, (void *) addr, 1);
 }
 
 static void r4k_flush_icache_all(void)
diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index 35dc435..cf4c868 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -64,7 +64,7 @@ static void prom_exit(void)
 #ifdef CONFIG_SMP
 	if (smp_processor_id())
 		/* CPU 1 */
-		smp_call_function(prom_cpu0_exit, NULL, 1, 1);
+		smp_call_function(prom_cpu0_exit, NULL, 1);
 #endif
 	prom_cpu0_exit(NULL);
 }
diff --git a/arch/mips/sibyte/cfe/setup.c b/arch/mips/sibyte/cfe/setup.c
index 33fce82..fd9604d 100644
--- a/arch/mips/sibyte/cfe/setup.c
+++ b/arch/mips/sibyte/cfe/setup.c
@@ -74,7 +74,7 @@ static void __noreturn cfe_linux_exit(void *arg)
 		if (!reboot_smp) {
 			/* Get CPU 0 to do the cfe_exit */
 			reboot_smp = 1;
-			smp_call_function(cfe_linux_exit, arg, 1, 0);
+			smp_call_function(cfe_linux_exit, arg, 0);
 		}
 	} else {
 		printk("Passing control back to CFE...\n");
diff --git a/arch/mips/sibyte/sb1250/prom.c b/arch/mips/sibyte/sb1250/prom.c
index cf8f6b3..65b1af6 100644
--- a/arch/mips/sibyte/sb1250/prom.c
+++ b/arch/mips/sibyte/sb1250/prom.c
@@ -66,7 +66,7 @@ static void prom_linux_exit(void)
 {
 #ifdef CONFIG_SMP
 	if (smp_processor_id()) {
-		smp_call_function(prom_cpu0_exit, NULL, 1, 1);
+		smp_call_function(prom_cpu0_exit, NULL, 1);
 	}
 #endif
 	while(1);
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index cfdb21e..ff7c60f 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -168,7 +168,7 @@ void arch_send_call_function_ipi(cpumask_t mask)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, NULL, 0, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 }
 
 extern struct gettimeofday_struct do_gtod;
diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index 655d525..f920656 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -207,7 +207,7 @@ __appldata_vtimer_setup(int cmd)
 			per_cpu(appldata_timer, i).expires = per_cpu_interval;
 			smp_call_function_single(i, add_virt_timer_periodic,
 						 &per_cpu(appldata_timer, i),
-						 0, 1);
+						 1);
 		}
 		appldata_timer_active = 1;
 		P_INFO("Monitoring timer started.\n");
@@ -234,7 +234,7 @@ __appldata_vtimer_setup(int cmd)
 			args.timer = &per_cpu(appldata_timer, i);
 			args.expires = per_cpu_interval;
 			smp_call_function_single(i, __appldata_mod_vtimer_wrap,
-						 &args, 0, 1);
+						 &args, 1);
 		}
 	}
 }
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 1f42289..60e5195 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -109,7 +109,7 @@ static void do_call_function(void)
 }
 
 static void __smp_call_function_map(void (*func) (void *info), void *info,
-				    int nonatomic, int wait, cpumask_t map)
+				    int wait, cpumask_t map)
 {
 	struct call_data_struct data;
 	int cpu, local = 0;
@@ -162,7 +162,6 @@ out:
  * smp_call_function:
  * @func: the function to run; this must be fast and non-blocking
  * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
  * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
  * Run a function on all other CPUs.
@@ -170,15 +169,14 @@ out:
  * You must not call this function with disabled interrupts, from a
  * hardware interrupt handler or from a bottom half.
  */
-int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
-		      int wait)
+int smp_call_function(void (*func) (void *info), void *info, int wait)
 {
 	cpumask_t map;
 
 	spin_lock(&call_lock);
 	map = cpu_online_map;
 	cpu_clear(smp_processor_id(), map);
-	__smp_call_function_map(func, info, nonatomic, wait, map);
+	__smp_call_function_map(func, info, wait, map);
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -189,7 +187,6 @@ EXPORT_SYMBOL(smp_call_function);
  * @cpu: the CPU where func should run
  * @func: the function to run; this must be fast and non-blocking
  * @info: an arbitrary pointer to pass to the function
- * @nonatomic: unused
  * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
  * Run a function on one processor.
@@ -198,11 +195,10 @@ EXPORT_SYMBOL(smp_call_function);
  * hardware interrupt handler or from a bottom half.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int nonatomic, int wait)
+			     int wait)
 {
 	spin_lock(&call_lock);
-	__smp_call_function_map(func, info, nonatomic, wait,
-				cpumask_of_cpu(cpu));
+	__smp_call_function_map(func, info, wait, cpumask_of_cpu(cpu));
 	spin_unlock(&call_lock);
 	return 0;
 }
@@ -228,7 +224,7 @@ int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
 {
 	spin_lock(&call_lock);
 	cpu_clear(smp_processor_id(), mask);
-	__smp_call_function_map(func, info, 0, wait, mask);
+	__smp_call_function_map(func, info, wait, mask);
 	spin_unlock(&call_lock);
 	return 0;
 }
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 7aec676..bf7bf2c 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -690,7 +690,7 @@ static int etr_sync_clock(struct etr_aib *aib, int port)
 	 */
 	memset(&etr_sync, 0, sizeof(etr_sync));
 	preempt_disable();
-	smp_call_function(etr_sync_cpu_start, NULL, 0, 0);
+	smp_call_function(etr_sync_cpu_start, NULL, 0);
 	local_irq_disable();
 	etr_enable_sync_clock();
 
@@ -729,7 +729,7 @@ static int etr_sync_clock(struct etr_aib *aib, int port)
 		rc = -EAGAIN;
 	}
 	local_irq_enable();
-	smp_call_function(etr_sync_cpu_end,NULL,0,0);
+	smp_call_function(etr_sync_cpu_end,NULL,0);
 	preempt_enable();
 	return rc;
 }
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 2ed8dce..71781ba 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -168,7 +168,7 @@ static void stop_this_cpu(void *unused)
 
 void smp_send_stop(void)
 {
-	smp_call_function(stop_this_cpu, 0, 1, 0);
+	smp_call_function(stop_this_cpu, 0, 0);
 }
 
 void arch_send_call_function_ipi(cpumask_t mask)
@@ -223,7 +223,7 @@ void flush_tlb_mm(struct mm_struct *mm)
 	preempt_disable();
 
 	if ((atomic_read(&mm->mm_users) != 1) || (current->mm != mm)) {
-		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1, 1);
+		smp_call_function(flush_tlb_mm_ipi, (void *)mm, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -260,7 +260,7 @@ void flush_tlb_range(struct vm_area_struct *vma,
 		fd.vma = vma;
 		fd.addr1 = start;
 		fd.addr2 = end;
-		smp_call_function(flush_tlb_range_ipi, (void *)&fd, 1, 1);
+		smp_call_function(flush_tlb_range_ipi, (void *)&fd, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -303,7 +303,7 @@ void flush_tlb_page(struct vm_area_struct *vma, unsigned long page)
 
 		fd.vma = vma;
 		fd.addr1 = page;
-		smp_call_function(flush_tlb_page_ipi, (void *)&fd, 1, 1);
+		smp_call_function(flush_tlb_page_ipi, (void *)&fd, 1);
 	} else {
 		int i;
 		for (i = 0; i < num_online_cpus(); i++)
@@ -327,6 +327,6 @@ void flush_tlb_one(unsigned long asid, unsigned long vaddr)
 	fd.addr1 = asid;
 	fd.addr2 = vaddr;
 
-	smp_call_function(flush_tlb_one_ipi, (void *)&fd, 1, 1);
+	smp_call_function(flush_tlb_one_ipi, (void *)&fd, 1);
 	local_flush_tlb_one(asid, vaddr);
 }
diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index b82d017..c099d96 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -807,7 +807,6 @@ extern unsigned long xcall_call_function;
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @nonatomic: currently unused.
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code. Does not return until
@@ -817,8 +816,7 @@ extern unsigned long xcall_call_function;
  * hardware interrupt handler or from a bottom half handler.
  */
 static int sparc64_smp_call_function_mask(void (*func)(void *info), void *info,
-					  int nonatomic, int wait,
-					  cpumask_t mask)
+					  int wait, cpumask_t mask)
 {
 	struct call_data_struct data;
 	int cpus;
@@ -853,11 +851,9 @@ out_unlock:
 	return 0;
 }
 
-int smp_call_function(void (*func)(void *info), void *info,
-		      int nonatomic, int wait)
+int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
-	return sparc64_smp_call_function_mask(func, info, nonatomic, wait,
-						cpu_online_map);
+	return sparc64_smp_call_function_mask(func, info, wait, cpu_online_map);
 }
 
 void smp_call_function_client(int irq, struct pt_regs *regs)
@@ -894,7 +890,7 @@ static void tsb_sync(void *info)
 
 void smp_tsb_sync(struct mm_struct *mm)
 {
-	sparc64_smp_call_function_mask(tsb_sync, mm, 0, 1, mm->cpu_vm_mask);
+	sparc64_smp_call_function_mask(tsb_sync, mm, 1, mm->cpu_vm_mask);
 }
 
 extern unsigned long xcall_flush_tlb_mm;
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index e1062ec..be2d50c 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -214,8 +214,7 @@ void smp_call_function_slave(int cpu)
 	atomic_inc(&scf_finished);
 }
 
-int smp_call_function(void (*_func)(void *info), void *_info, int nonatomic,
-		      int wait)
+int smp_call_function(void (*_func)(void *info), void *_info, int wait)
 {
 	int cpus = num_online_cpus() - 1;
 	int i;
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6a1e278..290652c 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -222,7 +222,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	atomic_set(&data.gate,0);
 
 	/*  Start the ball rolling on other CPUs  */
-	if (smp_call_function(ipi_handler, &data, 1, 0) != 0)
+	if (smp_call_function(ipi_handler, &data, 0) != 0)
 		panic("mtrr: timed out waiting for other CPUs\n");
 
 	local_irq_save(flags);
@@ -822,7 +822,7 @@ void mtrr_ap_init(void)
  */
 void mtrr_save_state(void)
 {
-	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1, 1);
+	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
 }
 
 static int __init mtrr_init_finialize(void)
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index daff52a..336dd43 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -95,7 +95,7 @@ static ssize_t cpuid_read(struct file *file, char __user *buf,
 	for (; count; count -= 16) {
 		cmd.eax = pos;
 		cmd.ecx = pos >> 32;
-		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1, 1);
+		smp_call_function_single(cpu, cpuid_smp_cpuid, &cmd, 1);
 		if (copy_to_user(tmp, &cmd, 16))
 			return -EFAULT;
 		tmp += 16;
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0224c36..cb0a639 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -68,7 +68,7 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 		load_LDT(pc);
 		mask = cpumask_of_cpu(smp_processor_id());
 		if (!cpus_equal(current->mm->cpu_vm_mask, mask))
-			smp_call_function(flush_ldt, NULL, 1, 1);
+			smp_call_function(flush_ldt, NULL, 1);
 		preempt_enable();
 #else
 		load_LDT(pc);
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 11b14bb..a40abc6 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -88,7 +88,7 @@ int __init check_nmi_watchdog(void)
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0);
 #endif
 
 	for_each_possible_cpu(cpu)
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index 5a29ded..2f1e4f5 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -96,7 +96,7 @@ int __init check_nmi_watchdog(void)
 
 #ifdef CONFIG_SMP
 	if (nmi_watchdog == NMI_LOCAL_APIC)
-		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0, 0);
+		smp_call_function(nmi_cpu_busy, (void *)&endflag, 0);
 #endif
 
 	for (cpu = 0; cpu < NR_CPUS; cpu++)
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 3e051ae..7f0a10d 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -174,7 +174,7 @@ static void native_smp_send_stop(void)
 	if (reboot_force)
 		return;
 
-	smp_call_function(stop_this_cpu, NULL, 0, 0);
+	smp_call_function(stop_this_cpu, NULL, 0);
 	local_irq_save(flags);
 	disable_local_APIC();
 	local_irq_restore(flags);
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 61efa2f..0a03d57 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -278,7 +278,7 @@ cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN)
-		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 0, 1);
+		smp_call_function_single(cpu, cpu_vsyscall_init, NULL, 1);
 	return NOTIFY_DONE;
 }
 
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index bfe4db1..bb6e010 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -335,7 +335,7 @@ static void vcpu_clear(struct vcpu_vmx *vmx)
 {
 	if (vmx->vcpu.cpu == -1)
 		return;
-	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 0, 1);
+	smp_call_function_single(vmx->vcpu.cpu, __vcpu_clear, vmx, 1);
 	vmx->launched = 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 21338bd..7335231 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4003,6 +4003,6 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
 	 * So need not to call smp_call_function_single() in that case.
 	 */
 	if (vcpu->guest_mode && vcpu->cpu != cpu)
-		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0, 0);
+		smp_call_function_single(ipi_pcpu, vcpu_kick_intr, vcpu, 0);
 	put_cpu();
 }
diff --git a/arch/x86/lib/msr-on-cpu.c b/arch/x86/lib/msr-on-cpu.c
index 57d043f..d5a2b39 100644
--- a/arch/x86/lib/msr-on-cpu.c
+++ b/arch/x86/lib/msr-on-cpu.c
@@ -30,10 +30,10 @@ static int _rdmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 *l, u32 *h, int safe)
 
 	rv.msr_no = msr_no;
 	if (safe) {
-		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __rdmsr_safe_on_cpu, &rv, 1);
 		err = rv.err;
 	} else {
-		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
 	}
 	*l = rv.l;
 	*h = rv.h;
@@ -64,10 +64,10 @@ static int _wrmsr_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h, int safe)
 	rv.l = l;
 	rv.h = h;
 	if (safe) {
-		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __wrmsr_safe_on_cpu, &rv, 1);
 		err = rv.err;
 	} else {
-		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 0, 1);
+		smp_call_function_single(cpu, __wrmsr_on_cpu, &rv, 1);
 	}
 
 	return err;
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index cb34407..04f596e 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -1113,7 +1113,7 @@ int safe_smp_processor_id(void)
 /* broadcast a halt to all other CPUs */
 static void voyager_smp_send_stop(void)
 {
-	smp_call_function(smp_stop_cpu_function, NULL, 1, 1);
+	smp_call_function(smp_stop_cpu_function, NULL, 1);
 }
 
 /* this function is triggered in time.c when a clock tick fires
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index b3786e7..a1651d0 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -331,7 +331,7 @@ static void stop_self(void *v)
 
 void xen_smp_send_stop(void)
 {
-	smp_call_function(stop_self, NULL, 0, 0);
+	smp_call_function(stop_self, NULL, 0);
 }
 
 void xen_smp_send_reschedule(int cpu)
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 2dd2c1f..3831a3b 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1339,7 +1339,7 @@ static void smp_callback(void *v)
 static int acpi_processor_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 0, 1);
+	smp_call_function(smp_callback, NULL, 1);
 	return NOTIFY_OK;
 }
 
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index fc555a9..87b32b5 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -310,7 +310,7 @@ static void smp_callback(void *v)
 static int cpuidle_latency_notify(struct notifier_block *b,
 		unsigned long l, void *v)
 {
-	smp_call_function(smp_callback, NULL, 0, 1);
+	smp_call_function(smp_callback, NULL, 1);
 	return NOTIFY_OK;
 }
 
diff --git a/include/asm-alpha/smp.h b/include/asm-alpha/smp.h
index a9090b6..743403c 100644
--- a/include/asm-alpha/smp.h
+++ b/include/asm-alpha/smp.h
@@ -50,7 +50,7 @@ extern int smp_num_cpus;
 #else /* CONFIG_SMP */
 
 #define hard_smp_processor_id()		0
-#define smp_call_function_on_cpu(func,info,retry,wait,cpu)    ({ 0; })
+#define smp_call_function_on_cpu(func,info,wait,cpu)    ({ 0; })
 
 #endif /* CONFIG_SMP */
 
diff --git a/include/asm-sparc/smp.h b/include/asm-sparc/smp.h
index e6d5615..b61e74b 100644
--- a/include/asm-sparc/smp.h
+++ b/include/asm-sparc/smp.h
@@ -72,7 +72,7 @@ static inline void xc5(smpfunc_t func, unsigned long arg1, unsigned long arg2,
 			   unsigned long arg3, unsigned long arg4, unsigned long arg5)
 { smp_cross_call(func, arg1, arg2, arg3, arg4, arg5); }
 
-static inline int smp_call_function(void (*func)(void *info), void *info, int nonatomic, int wait)
+static inline int smp_call_function(void (*func)(void *info), void *info, int wait)
 {
 	xc1((smpfunc_t)func, (unsigned long)info);
 	return 0;
diff --git a/include/linux/smp.h b/include/linux/smp.h
index 2691bad..392579e 100644
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -62,11 +62,11 @@ extern void smp_cpus_done(unsigned int max_cpus);
 /*
  * Call a function on all other processors
  */
-int smp_call_function(void(*func)(void *info), void *info, int retry, int wait);
+int smp_call_function(void(*func)(void *info), void *info, int wait);
 int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
 				int wait);
 int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int retry, int wait);
+				int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
@@ -118,7 +118,7 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 {
 	return 0;
 }
-#define smp_call_function(func, info, retry, wait) \
+#define smp_call_function(func, info, wait) \
 			(up_smp_call_function(func, info))
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
@@ -130,7 +130,7 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
 static inline void smp_send_reschedule(int cpu) { }
 #define num_booting_cpus()			1
 #define smp_prepare_boot_cpu()			do {} while (0)
-#define smp_call_function_single(cpuid, func, info, retry, wait) \
+#define smp_call_function_single(cpuid, func, info, wait) \
 ({ \
 	WARN_ON(cpuid != 0);	\
 	local_irq_disable();	\
diff --git a/kernel/smp.c b/kernel/smp.c
index ef6de3d..024ca9e 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -195,13 +195,12 @@ void generic_smp_call_function_single_interrupt(void)
  * smp_call_function_single - Run a function on a specific CPU
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @retry: Unused
  * @wait: If true, wait until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code.
  */
 int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
-			     int retry, int wait)
+			     int wait)
 {
 	struct call_single_data d;
 	unsigned long flags;
@@ -339,7 +338,6 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * smp_call_function(): Run a function on all other CPUs.
  * @func: The function to run. This must be fast and non-blocking.
  * @info: An arbitrary pointer to pass to the function.
- * @natomic: Unused
  * @wait: If true, wait (atomically) until function has completed on other CPUs.
  *
  * Returns 0 on success, else a negative status code.
@@ -350,7 +348,7 @@ EXPORT_SYMBOL(smp_call_function_mask);
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int smp_call_function(void (*func)(void *), void *info, int natomic, int wait)
+int smp_call_function(void (*func)(void *), void *info, int wait)
 {
 	int ret;
 
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 36e0617..d73afb4 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -679,7 +679,7 @@ int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
 	int ret = 0;
 
 	preempt_disable();
-	ret = smp_call_function(func, info, retry, wait);
+	ret = smp_call_function(func, info, wait);
 	local_irq_disable();
 	func(info);
 	local_irq_enable();
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 57a1f02..75e7185 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -266,7 +266,7 @@ void tick_broadcast_on_off(unsigned long reason, int *oncpu)
 		       "offline CPU #%d\n", *oncpu);
 	else
 		smp_call_function_single(*oncpu, tick_do_broadcast_on_off,
-					 &reason, 1, 1);
+					 &reason, 1);
 }
 
 /*
diff --git a/net/core/flow.c b/net/core/flow.c
index 1999117..5cf8105 100644
--- a/net/core/flow.c
+++ b/net/core/flow.c
@@ -298,7 +298,7 @@ void flow_cache_flush(void)
 	init_completion(&info.completion);
 
 	local_bh_disable();
-	smp_call_function(flow_cache_flush_per_cpu, &info, 1, 0);
+	smp_call_function(flow_cache_flush_per_cpu, &info, 0);
 	flow_cache_flush_tasklet((unsigned long)&info);
 	local_bh_enable();
 
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9189707..94d5a45 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -480,7 +480,7 @@ static void iucv_setmask_mp(void)
 		if (cpu_isset(cpu, iucv_buffer_cpumask) &&
 		    !cpu_isset(cpu, iucv_irq_cpumask))
 			smp_call_function_single(cpu, iucv_allow_cpu,
-						 NULL, 0, 1);
+						 NULL, 1);
 	preempt_enable();
 }
 
@@ -498,7 +498,7 @@ static void iucv_setmask_up(void)
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
 	for_each_cpu_mask(cpu, cpumask)
-		smp_call_function_single(cpu, iucv_block_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 
 /**
@@ -523,7 +523,7 @@ static int iucv_enable(void)
 	rc = -EIO;
 	preempt_disable();
 	for_each_online_cpu(cpu)
-		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 1);
 	preempt_enable();
 	if (cpus_empty(iucv_buffer_cpumask))
 		/* No cpu could declare an iucv buffer. */
@@ -580,7 +580,7 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE_FROZEN:
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_declare_cpu, NULL, 1);
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
@@ -589,10 +589,10 @@ static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
 			return NOTIFY_BAD;
-		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 0, 1);
+		smp_call_function_single(cpu, iucv_retrieve_cpu, NULL, 1);
 		if (cpus_empty(iucv_irq_cpumask))
 			smp_call_function_single(first_cpu(iucv_buffer_cpumask),
-						 iucv_allow_cpu, NULL, 0, 1);
+						 iucv_allow_cpu, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -652,7 +652,7 @@ static void iucv_cleanup_queue(void)
 	 * pending interrupts force them to the work queue by calling
 	 * an empty function on all cpus.
 	 */
-	smp_call_function(__iucv_cleanup_queue, NULL, 0, 1);
+	smp_call_function(__iucv_cleanup_queue, NULL, 1);
 	spin_lock_irq(&iucv_queue_lock);
 	list_for_each_entry_safe(p, n, &iucv_task_queue, list) {
 		/* Remove stale work items from the task queue. */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2d29e26..ea1f595 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1266,12 +1266,12 @@ static int kvm_cpu_hotplug(struct notifier_block *notifier, unsigned long val,
 	case CPU_UP_CANCELED:
 		printk(KERN_INFO "kvm: disabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_disable, NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_disable, NULL, 1);
 		break;
 	case CPU_ONLINE:
 		printk(KERN_INFO "kvm: enabling virtualization on CPU%d\n",
 		       cpu);
-		smp_call_function_single(cpu, hardware_enable, NULL, 0, 1);
+		smp_call_function_single(cpu, hardware_enable, NULL, 1);
 		break;
 	}
 	return NOTIFY_OK;
@@ -1474,7 +1474,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
 	for_each_online_cpu(cpu) {
 		smp_call_function_single(cpu,
 				kvm_arch_check_processor_compat,
-				&r, 0, 1);
+				&r, 1);
 		if (r < 0)
 			goto out_free_1;
 	}
-- 
1.5.6.rc0.40.gd683

