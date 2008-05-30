Return-Path: <linux-kernel-owner+w=401wt.eu-S1757316AbYE3L1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316AbYE3L1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbYE3L1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:27:23 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:52494 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbYE3L1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:27:18 -0400
Date: Fri, 30 May 2008 04:27:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, npiggin@suse.de,
       linux-arch@vger.kernel.org, jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] on_each_cpu(): kill unused 'retry' parameter
Message-ID: <20080530112710.GO4943@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1212051661-12733-1-git-send-email-jens.axboe@oracle.com> <1212051661-12733-3-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212051661-12733-3-git-send-email-jens.axboe@oracle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:01:01AM +0200, Jens Axboe wrote:
> It's not even passed on to smp_call_function() anymore, since that
> was removed. So kill it.

>From an RCU viewpoint:

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>  arch/alpha/kernel/process.c            |    2 +-
>  arch/alpha/kernel/smp.c                |    4 ++--
>  arch/arm/kernel/smp.c                  |    6 +++---
>  arch/ia64/kernel/mca.c                 |    4 ++--
>  arch/ia64/kernel/perfmon.c             |    4 ++--
>  arch/ia64/kernel/smp.c                 |    4 ++--
>  arch/mips/kernel/irq-rm9000.c          |    4 ++--
>  arch/mips/kernel/smp.c                 |    4 ++--
>  arch/mips/oprofile/common.c            |    6 +++---
>  arch/parisc/kernel/cache.c             |    6 +++---
>  arch/parisc/kernel/smp.c               |    2 +-
>  arch/parisc/mm/init.c                  |    2 +-
>  arch/powerpc/kernel/rtas.c             |    2 +-
>  arch/powerpc/kernel/tau_6xx.c          |    4 ++--
>  arch/powerpc/kernel/time.c             |    2 +-
>  arch/powerpc/mm/slice.c                |    2 +-
>  arch/powerpc/oprofile/common.c         |    6 +++---
>  arch/s390/kernel/smp.c                 |    6 +++---
>  arch/s390/kernel/time.c                |    2 +-
>  arch/sh/kernel/smp.c                   |    4 ++--
>  arch/sparc64/mm/hugetlbpage.c          |    2 +-
>  arch/x86/kernel/cpu/mcheck/mce_64.c    |    6 +++---
>  arch/x86/kernel/cpu/mcheck/non-fatal.c |    2 +-
>  arch/x86/kernel/cpu/perfctr-watchdog.c |    4 ++--
>  arch/x86/kernel/io_apic_32.c           |    2 +-
>  arch/x86/kernel/io_apic_64.c           |    2 +-
>  arch/x86/kernel/nmi_32.c               |    4 ++--
>  arch/x86/kernel/nmi_64.c               |    4 ++--
>  arch/x86/kernel/tlb_32.c               |    2 +-
>  arch/x86/kernel/tlb_64.c               |    2 +-
>  arch/x86/kernel/vsyscall_64.c          |    2 +-
>  arch/x86/kvm/vmx.c                     |    2 +-
>  arch/x86/mach-voyager/voyager_smp.c    |    2 +-
>  arch/x86/mm/pageattr.c                 |    4 ++--
>  arch/x86/oprofile/nmi_int.c            |   10 +++++-----
>  drivers/char/agp/generic.c             |    2 +-
>  drivers/lguest/x86/core.c              |    4 ++--
>  fs/buffer.c                            |    2 +-
>  include/linux/smp.h                    |    4 ++--
>  kernel/hrtimer.c                       |    2 +-
>  kernel/profile.c                       |    6 +++---
>  kernel/rcupdate.c                      |    2 +-
>  kernel/softirq.c                       |    2 +-
>  mm/page_alloc.c                        |    2 +-
>  mm/slab.c                              |    4 ++--
>  mm/slub.c                              |    2 +-
>  net/iucv/iucv.c                        |    2 +-
>  virt/kvm/kvm_main.c                    |    8 ++++----
>  48 files changed, 84 insertions(+), 84 deletions(-)
> 
> diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> index 96ed82f..351407e 100644
> --- a/arch/alpha/kernel/process.c
> +++ b/arch/alpha/kernel/process.c
> @@ -160,7 +160,7 @@ common_shutdown(int mode, char *restart_cmd)
>  	struct halt_info args;
>  	args.mode = mode;
>  	args.restart_cmd = restart_cmd;
> -	on_each_cpu(common_shutdown_1, &args, 1, 0);
> +	on_each_cpu(common_shutdown_1, &args, 0);
>  }
> 
>  void
> diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
> index 44114c8..83df541 100644
> --- a/arch/alpha/kernel/smp.c
> +++ b/arch/alpha/kernel/smp.c
> @@ -657,7 +657,7 @@ void
>  smp_imb(void)
>  {
>  	/* Must wait other processors to flush their icache before continue. */
> -	if (on_each_cpu(ipi_imb, NULL, 1, 1))
> +	if (on_each_cpu(ipi_imb, NULL, 1))
>  		printk(KERN_CRIT "smp_imb: timed out\n");
>  }
>  EXPORT_SYMBOL(smp_imb);
> @@ -673,7 +673,7 @@ flush_tlb_all(void)
>  {
>  	/* Although we don't have any data to pass, we do want to
>  	   synchronize with the other processors.  */
> -	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1)) {
> +	if (on_each_cpu(ipi_flush_tlb_all, NULL, 1)) {
>  		printk(KERN_CRIT "flush_tlb_all: timed out\n");
>  	}
>  }
> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
> index 6344466..5a7c095 100644
> --- a/arch/arm/kernel/smp.c
> +++ b/arch/arm/kernel/smp.c
> @@ -604,7 +604,7 @@ static inline void ipi_flush_tlb_kernel_range(void *arg)
> 
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(ipi_flush_tlb_all, NULL, 1, 1);
> +	on_each_cpu(ipi_flush_tlb_all, NULL, 1);
>  }
> 
>  void flush_tlb_mm(struct mm_struct *mm)
> @@ -631,7 +631,7 @@ void flush_tlb_kernel_page(unsigned long kaddr)
> 
>  	ta.ta_start = kaddr;
> 
> -	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1, 1);
> +	on_each_cpu(ipi_flush_tlb_kernel_page, &ta, 1);
>  }
> 
>  void flush_tlb_range(struct vm_area_struct *vma,
> @@ -654,5 +654,5 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
>  	ta.ta_start = start;
>  	ta.ta_end = end;
> 
> -	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1, 1);
> +	on_each_cpu(ipi_flush_tlb_kernel_range, &ta, 1);
>  }
> diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
> index 9cd818c..7dd96c1 100644
> --- a/arch/ia64/kernel/mca.c
> +++ b/arch/ia64/kernel/mca.c
> @@ -707,7 +707,7 @@ ia64_mca_cmc_vector_enable (void *dummy)
>  static void
>  ia64_mca_cmc_vector_disable_keventd(struct work_struct *unused)
>  {
> -	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 1, 0);
> +	on_each_cpu(ia64_mca_cmc_vector_disable, NULL, 0);
>  }
> 
>  /*
> @@ -719,7 +719,7 @@ ia64_mca_cmc_vector_disable_keventd(struct work_struct *unused)
>  static void
>  ia64_mca_cmc_vector_enable_keventd(struct work_struct *unused)
>  {
> -	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 1, 0);
> +	on_each_cpu(ia64_mca_cmc_vector_enable, NULL, 0);
>  }
> 
>  /*
> diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
> index 080f41c..f560660 100644
> --- a/arch/ia64/kernel/perfmon.c
> +++ b/arch/ia64/kernel/perfmon.c
> @@ -6508,7 +6508,7 @@ pfm_install_alt_pmu_interrupt(pfm_intr_handler_desc_t *hdl)
>  	}
> 
>  	/* save the current system wide pmu states */
> -	ret = on_each_cpu(pfm_alt_save_pmu_state, NULL, 0, 1);
> +	ret = on_each_cpu(pfm_alt_save_pmu_state, NULL, 1);
>  	if (ret) {
>  		DPRINT(("on_each_cpu() failed: %d\n", ret));
>  		goto cleanup_reserve;
> @@ -6553,7 +6553,7 @@ pfm_remove_alt_pmu_interrupt(pfm_intr_handler_desc_t *hdl)
> 
>  	pfm_alt_intr_handler = NULL;
> 
> -	ret = on_each_cpu(pfm_alt_restore_pmu_state, NULL, 0, 1);
> +	ret = on_each_cpu(pfm_alt_restore_pmu_state, NULL, 1);
>  	if (ret) {
>  		DPRINT(("on_each_cpu() failed: %d\n", ret));
>  	}
> diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
> index 70b7b35..8079d1f 100644
> --- a/arch/ia64/kernel/smp.c
> +++ b/arch/ia64/kernel/smp.c
> @@ -297,7 +297,7 @@ smp_flush_tlb_cpumask(cpumask_t xcpumask)
>  void
>  smp_flush_tlb_all (void)
>  {
> -	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1, 1);
> +	on_each_cpu((void (*)(void *))local_flush_tlb_all, NULL, 1);
>  }
> 
>  void
> @@ -320,7 +320,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
>  	 * anyhow, and once a CPU is interrupted, the cost of local_flush_tlb_all() is
>  	 * rather trivial.
>  	 */
> -	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1, 1);
> +	on_each_cpu((void (*)(void *))local_finish_flush_tlb_mm, mm, 1);
>  }
> 
>  void arch_send_call_function_single_ipi(int cpu)
> diff --git a/arch/mips/kernel/irq-rm9000.c b/arch/mips/kernel/irq-rm9000.c
> index ed9febe..b47e461 100644
> --- a/arch/mips/kernel/irq-rm9000.c
> +++ b/arch/mips/kernel/irq-rm9000.c
> @@ -49,7 +49,7 @@ static void local_rm9k_perfcounter_irq_startup(void *args)
> 
>  static unsigned int rm9k_perfcounter_irq_startup(unsigned int irq)
>  {
> -	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 0, 1);
> +	on_each_cpu(local_rm9k_perfcounter_irq_startup, (void *) irq, 1);
> 
>  	return 0;
>  }
> @@ -66,7 +66,7 @@ static void local_rm9k_perfcounter_irq_shutdown(void *args)
> 
>  static void rm9k_perfcounter_irq_shutdown(unsigned int irq)
>  {
> -	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 0, 1);
> +	on_each_cpu(local_rm9k_perfcounter_irq_shutdown, (void *) irq, 1);
>  }
> 
>  static struct irq_chip rm9k_irq_controller = {
> diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
> index 7a9ae83..4410f17 100644
> --- a/arch/mips/kernel/smp.c
> +++ b/arch/mips/kernel/smp.c
> @@ -246,7 +246,7 @@ static void flush_tlb_all_ipi(void *info)
> 
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(flush_tlb_all_ipi, NULL, 1, 1);
> +	on_each_cpu(flush_tlb_all_ipi, NULL, 1);
>  }
> 
>  static void flush_tlb_mm_ipi(void *mm)
> @@ -366,7 +366,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
>  		.addr2 = end,
>  	};
> 
> -	on_each_cpu(flush_tlb_kernel_range_ipi, &fd, 1, 1);
> +	on_each_cpu(flush_tlb_kernel_range_ipi, &fd, 1);
>  }
> 
>  static void flush_tlb_page_ipi(void *info)
> diff --git a/arch/mips/oprofile/common.c b/arch/mips/oprofile/common.c
> index b5f6f71..dd2fbd6 100644
> --- a/arch/mips/oprofile/common.c
> +++ b/arch/mips/oprofile/common.c
> @@ -27,7 +27,7 @@ static int op_mips_setup(void)
>  	model->reg_setup(ctr);
> 
>  	/* Configure the registers on all cpus.  */
> -	on_each_cpu(model->cpu_setup, NULL, 0, 1);
> +	on_each_cpu(model->cpu_setup, NULL, 1);
> 
>          return 0;
>  }
> @@ -58,7 +58,7 @@ static int op_mips_create_files(struct super_block * sb, struct dentry * root)
> 
>  static int op_mips_start(void)
>  {
> -	on_each_cpu(model->cpu_start, NULL, 0, 1);
> +	on_each_cpu(model->cpu_start, NULL, 1);
> 
>  	return 0;
>  }
> @@ -66,7 +66,7 @@ static int op_mips_start(void)
>  static void op_mips_stop(void)
>  {
>  	/* Disable performance monitoring for all counters.  */
> -	on_each_cpu(model->cpu_stop, NULL, 0, 1);
> +	on_each_cpu(model->cpu_stop, NULL, 1);
>  }
> 
>  int __init oprofile_arch_init(struct oprofile_operations *ops)
> diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
> index e10d25d..5259d8c 100644
> --- a/arch/parisc/kernel/cache.c
> +++ b/arch/parisc/kernel/cache.c
> @@ -51,12 +51,12 @@ static struct pdc_btlb_info btlb_info __read_mostly;
>  void
>  flush_data_cache(void)
>  {
> -	on_each_cpu(flush_data_cache_local, NULL, 1, 1);
> +	on_each_cpu(flush_data_cache_local, NULL, 1);
>  }
>  void 
>  flush_instruction_cache(void)
>  {
> -	on_each_cpu(flush_instruction_cache_local, NULL, 1, 1);
> +	on_each_cpu(flush_instruction_cache_local, NULL, 1);
>  }
>  #endif
> 
> @@ -515,7 +515,7 @@ static void cacheflush_h_tmp_function(void *dummy)
> 
>  void flush_cache_all(void)
>  {
> -	on_each_cpu(cacheflush_h_tmp_function, NULL, 1, 1);
> +	on_each_cpu(cacheflush_h_tmp_function, NULL, 1);
>  }
> 
>  void flush_cache_mm(struct mm_struct *mm)
> diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
> index 126105c..d47f397 100644
> --- a/arch/parisc/kernel/smp.c
> +++ b/arch/parisc/kernel/smp.c
> @@ -292,7 +292,7 @@ void arch_send_call_function_single_ipi(int cpu)
>  void
>  smp_flush_tlb_all(void)
>  {
> -	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
> +	on_each_cpu(flush_tlb_all_local, NULL, 1);
>  }
> 
>  /*
> diff --git a/arch/parisc/mm/init.c b/arch/parisc/mm/init.c
> index 78fe252..7044481 100644
> --- a/arch/parisc/mm/init.c
> +++ b/arch/parisc/mm/init.c
> @@ -1052,7 +1052,7 @@ void flush_tlb_all(void)
>  	    do_recycle++;
>  	}
>  	spin_unlock(&sid_lock);
> -	on_each_cpu(flush_tlb_all_local, NULL, 1, 1);
> +	on_each_cpu(flush_tlb_all_local, NULL, 1);
>  	if (do_recycle) {
>  	    spin_lock(&sid_lock);
>  	    recycle_sids(recycle_ndirty,recycle_dirty_array);
> diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
> index 34843c3..647f3e8 100644
> --- a/arch/powerpc/kernel/rtas.c
> +++ b/arch/powerpc/kernel/rtas.c
> @@ -747,7 +747,7 @@ static int rtas_ibm_suspend_me(struct rtas_args *args)
>  	/* Call function on all CPUs.  One of us will make the
>  	 * rtas call
>  	 */
> -	if (on_each_cpu(rtas_percpu_suspend_me, &data, 1, 0))
> +	if (on_each_cpu(rtas_percpu_suspend_me, &data, 0))
>  		data.error = -EINVAL;
> 
>  	wait_for_completion(&done);
> diff --git a/arch/powerpc/kernel/tau_6xx.c b/arch/powerpc/kernel/tau_6xx.c
> index 368a493..c3a56d6 100644
> --- a/arch/powerpc/kernel/tau_6xx.c
> +++ b/arch/powerpc/kernel/tau_6xx.c
> @@ -192,7 +192,7 @@ static void tau_timeout_smp(unsigned long unused)
> 
>  	/* schedule ourselves to be run again */
>  	mod_timer(&tau_timer, jiffies + shrink_timer) ;
> -	on_each_cpu(tau_timeout, NULL, 1, 0);
> +	on_each_cpu(tau_timeout, NULL, 0);
>  }
> 
>  /*
> @@ -234,7 +234,7 @@ int __init TAU_init(void)
>  	tau_timer.expires = jiffies + shrink_timer;
>  	add_timer(&tau_timer);
> 
> -	on_each_cpu(TAU_init_smp, NULL, 1, 0);
> +	on_each_cpu(TAU_init_smp, NULL, 0);
> 
>  	printk("Thermal assist unit ");
>  #ifdef CONFIG_TAU_INT
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index 73401e8..f1a38a6 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -322,7 +322,7 @@ void snapshot_timebases(void)
>  {
>  	if (!cpu_has_feature(CPU_FTR_PURR))
>  		return;
> -	on_each_cpu(snapshot_tb_and_purr, NULL, 0, 1);
> +	on_each_cpu(snapshot_tb_and_purr, NULL, 1);
>  }
> 
>  /*
> diff --git a/arch/powerpc/mm/slice.c b/arch/powerpc/mm/slice.c
> index ad928ed..2bd12d9 100644
> --- a/arch/powerpc/mm/slice.c
> +++ b/arch/powerpc/mm/slice.c
> @@ -218,7 +218,7 @@ static void slice_convert(struct mm_struct *mm, struct slice_mask mask, int psiz
>  	mb();
> 
>  	/* XXX this is sub-optimal but will do for now */
> -	on_each_cpu(slice_flush_segments, mm, 0, 1);
> +	on_each_cpu(slice_flush_segments, mm, 1);
>  #ifdef CONFIG_SPU_BASE
>  	spu_flush_all_slbs(mm);
>  #endif
> diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
> index 4908dc9..17807ac 100644
> --- a/arch/powerpc/oprofile/common.c
> +++ b/arch/powerpc/oprofile/common.c
> @@ -65,7 +65,7 @@ static int op_powerpc_setup(void)
> 
>  	/* Configure the registers on all cpus.	 If an error occurs on one
>  	 * of the cpus, op_per_cpu_rc will be set to the error */
> -	on_each_cpu(op_powerpc_cpu_setup, NULL, 0, 1);
> +	on_each_cpu(op_powerpc_cpu_setup, NULL, 1);
> 
>  out:	if (op_per_cpu_rc) {
>  		/* error on setup release the performance counter hardware */
> @@ -100,7 +100,7 @@ static int op_powerpc_start(void)
>  	if (model->global_start)
>  		return model->global_start(ctr);
>  	if (model->start) {
> -		on_each_cpu(op_powerpc_cpu_start, NULL, 0, 1);
> +		on_each_cpu(op_powerpc_cpu_start, NULL, 1);
>  		return op_per_cpu_rc;
>  	}
>  	return -EIO; /* No start function is defined for this
> @@ -115,7 +115,7 @@ static inline void op_powerpc_cpu_stop(void *dummy)
>  static void op_powerpc_stop(void)
>  {
>  	if (model->stop)
> -		on_each_cpu(op_powerpc_cpu_stop, NULL, 0, 1);
> +		on_each_cpu(op_powerpc_cpu_stop, NULL, 1);
>          if (model->global_stop)
>                  model->global_stop();
>  }
> diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
> index 60e5195..1c3b6cc 100644
> --- a/arch/s390/kernel/smp.c
> +++ b/arch/s390/kernel/smp.c
> @@ -299,7 +299,7 @@ static void smp_ptlb_callback(void *info)
> 
>  void smp_ptlb_all(void)
>  {
> -	on_each_cpu(smp_ptlb_callback, NULL, 0, 1);
> +	on_each_cpu(smp_ptlb_callback, NULL, 1);
>  }
>  EXPORT_SYMBOL(smp_ptlb_all);
>  #endif /* ! CONFIG_64BIT */
> @@ -347,7 +347,7 @@ void smp_ctl_set_bit(int cr, int bit)
>  	memset(&parms.orvals, 0, sizeof(parms.orvals));
>  	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
>  	parms.orvals[cr] = 1 << bit;
> -	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
> +	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
>  }
>  EXPORT_SYMBOL(smp_ctl_set_bit);
> 
> @@ -361,7 +361,7 @@ void smp_ctl_clear_bit(int cr, int bit)
>  	memset(&parms.orvals, 0, sizeof(parms.orvals));
>  	memset(&parms.andvals, 0xff, sizeof(parms.andvals));
>  	parms.andvals[cr] = ~(1L << bit);
> -	on_each_cpu(smp_ctl_bit_callback, &parms, 0, 1);
> +	on_each_cpu(smp_ctl_bit_callback, &parms, 1);
>  }
>  EXPORT_SYMBOL(smp_ctl_clear_bit);
> 
> diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
> index bf7bf2c..6037ed2 100644
> --- a/arch/s390/kernel/time.c
> +++ b/arch/s390/kernel/time.c
> @@ -909,7 +909,7 @@ static void etr_work_fn(struct work_struct *work)
>  	if (!eacr.ea) {
>  		/* Both ports offline. Reset everything. */
>  		eacr.dp = eacr.es = eacr.sl = 0;
> -		on_each_cpu(etr_disable_sync_clock, NULL, 0, 1);
> +		on_each_cpu(etr_disable_sync_clock, NULL, 1);
>  		del_timer_sync(&etr_timer);
>  		etr_update_eacr(eacr);
>  		set_bit(ETR_FLAG_EACCES, &etr_flags);
> diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
> index 71781ba..60c5084 100644
> --- a/arch/sh/kernel/smp.c
> +++ b/arch/sh/kernel/smp.c
> @@ -197,7 +197,7 @@ static void flush_tlb_all_ipi(void *info)
> 
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(flush_tlb_all_ipi, 0, 1, 1);
> +	on_each_cpu(flush_tlb_all_ipi, 0, 1);
>  }
> 
>  static void flush_tlb_mm_ipi(void *mm)
> @@ -284,7 +284,7 @@ void flush_tlb_kernel_range(unsigned long start, unsigned long end)
> 
>  	fd.addr1 = start;
>  	fd.addr2 = end;
> -	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1, 1);
> +	on_each_cpu(flush_tlb_kernel_range_ipi, (void *)&fd, 1);
>  }
> 
>  static void flush_tlb_page_ipi(void *info)
> diff --git a/arch/sparc64/mm/hugetlbpage.c b/arch/sparc64/mm/hugetlbpage.c
> index 6cfab2e..ebefd2a 100644
> --- a/arch/sparc64/mm/hugetlbpage.c
> +++ b/arch/sparc64/mm/hugetlbpage.c
> @@ -344,7 +344,7 @@ void hugetlb_prefault_arch_hook(struct mm_struct *mm)
>  			 * also executing in this address space.
>  			 */
>  			mm->context.sparc64_ctx_val = ctx;
> -			on_each_cpu(context_reload, mm, 0, 0);
> +			on_each_cpu(context_reload, mm, 0);
>  		}
>  		spin_unlock(&ctx_alloc_lock);
>  	}
> diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
> index e07e8c0..43b7cb5 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce_64.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
> @@ -363,7 +363,7 @@ static void mcheck_check_cpu(void *info)
> 
>  static void mcheck_timer(struct work_struct *work)
>  {
> -	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
> +	on_each_cpu(mcheck_check_cpu, NULL, 1);
> 
>  	/*
>  	 * Alert userspace if needed.  If we logged an MCE, reduce the
> @@ -612,7 +612,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
>  	 * Collect entries that were still getting written before the
>  	 * synchronize.
>  	 */
> -	on_each_cpu(collect_tscs, cpu_tsc, 1, 1);
> +	on_each_cpu(collect_tscs, cpu_tsc, 1);
>  	for (i = next; i < MCE_LOG_LEN; i++) {
>  		if (mcelog.entry[i].finished &&
>  		    mcelog.entry[i].tsc < cpu_tsc[mcelog.entry[i].cpu]) {
> @@ -737,7 +737,7 @@ static void mce_restart(void)
>  	if (next_interval)
>  		cancel_delayed_work(&mcheck_work);
>  	/* Timer race is harmless here */
> -	on_each_cpu(mce_init, NULL, 1, 1);
> +	on_each_cpu(mce_init, NULL, 1);
>  	next_interval = check_interval * HZ;
>  	if (next_interval)
>  		schedule_delayed_work(&mcheck_work,
> diff --git a/arch/x86/kernel/cpu/mcheck/non-fatal.c b/arch/x86/kernel/cpu/mcheck/non-fatal.c
> index 00ccb6c..cc1fccd 100644
> --- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
> +++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
> @@ -59,7 +59,7 @@ static DECLARE_DELAYED_WORK(mce_work, mce_work_fn);
> 
>  static void mce_work_fn(struct work_struct *work)
>  {
> -	on_each_cpu(mce_checkregs, NULL, 1, 1);
> +	on_each_cpu(mce_checkregs, NULL, 1);
>  	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
>  }
> 
> diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
> index f9ae93a..58043f0 100644
> --- a/arch/x86/kernel/cpu/perfctr-watchdog.c
> +++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
> @@ -180,7 +180,7 @@ void disable_lapic_nmi_watchdog(void)
>  	if (atomic_read(&nmi_active) <= 0)
>  		return;
> 
> -	on_each_cpu(stop_apic_nmi_watchdog, NULL, 0, 1);
> +	on_each_cpu(stop_apic_nmi_watchdog, NULL, 1);
>  	wd_ops->unreserve();
> 
>  	BUG_ON(atomic_read(&nmi_active) != 0);
> @@ -202,7 +202,7 @@ void enable_lapic_nmi_watchdog(void)
>  		return;
>  	}
> 
> -	on_each_cpu(setup_apic_nmi_watchdog, NULL, 0, 1);
> +	on_each_cpu(setup_apic_nmi_watchdog, NULL, 1);
>  	touch_nmi_watchdog();
>  }
> 
> diff --git a/arch/x86/kernel/io_apic_32.c b/arch/x86/kernel/io_apic_32.c
> index a40d54f..595f4e0 100644
> --- a/arch/x86/kernel/io_apic_32.c
> +++ b/arch/x86/kernel/io_apic_32.c
> @@ -1565,7 +1565,7 @@ void /*__init*/ print_local_APIC(void * dummy)
> 
>  void print_all_local_APICs (void)
>  {
> -	on_each_cpu(print_local_APIC, NULL, 1, 1);
> +	on_each_cpu(print_local_APIC, NULL, 1);
>  }
> 
>  void /*__init*/ print_PIC(void)
> diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
> index ef1a8df..4504c7f 100644
> --- a/arch/x86/kernel/io_apic_64.c
> +++ b/arch/x86/kernel/io_apic_64.c
> @@ -1146,7 +1146,7 @@ void __apicdebuginit print_local_APIC(void * dummy)
> 
>  void print_all_local_APICs (void)
>  {
> -	on_each_cpu(print_local_APIC, NULL, 1, 1);
> +	on_each_cpu(print_local_APIC, NULL, 1);
>  }
> 
>  void __apicdebuginit print_PIC(void)
> diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
> index a40abc6..3036dc9 100644
> --- a/arch/x86/kernel/nmi_32.c
> +++ b/arch/x86/kernel/nmi_32.c
> @@ -223,7 +223,7 @@ static void __acpi_nmi_enable(void *__unused)
>  void acpi_nmi_enable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
> +		on_each_cpu(__acpi_nmi_enable, NULL, 1);
>  }
> 
>  static void __acpi_nmi_disable(void *__unused)
> @@ -237,7 +237,7 @@ static void __acpi_nmi_disable(void *__unused)
>  void acpi_nmi_disable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
> +		on_each_cpu(__acpi_nmi_disable, NULL, 1);
>  }
> 
>  void setup_apic_nmi_watchdog(void *unused)
> diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
> index 2f1e4f5..bbdcb17 100644
> --- a/arch/x86/kernel/nmi_64.c
> +++ b/arch/x86/kernel/nmi_64.c
> @@ -225,7 +225,7 @@ static void __acpi_nmi_enable(void *__unused)
>  void acpi_nmi_enable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_enable, NULL, 0, 1);
> +		on_each_cpu(__acpi_nmi_enable, NULL, 1);
>  }
> 
>  static void __acpi_nmi_disable(void *__unused)
> @@ -239,7 +239,7 @@ static void __acpi_nmi_disable(void *__unused)
>  void acpi_nmi_disable(void)
>  {
>  	if (atomic_read(&nmi_active) && nmi_watchdog == NMI_IO_APIC)
> -		on_each_cpu(__acpi_nmi_disable, NULL, 0, 1);
> +		on_each_cpu(__acpi_nmi_disable, NULL, 1);
>  }
> 
>  void setup_apic_nmi_watchdog(void *unused)
> diff --git a/arch/x86/kernel/tlb_32.c b/arch/x86/kernel/tlb_32.c
> index 9bb2363..fec1ece 100644
> --- a/arch/x86/kernel/tlb_32.c
> +++ b/arch/x86/kernel/tlb_32.c
> @@ -238,6 +238,6 @@ static void do_flush_tlb_all(void *info)
> 
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
> +	on_each_cpu(do_flush_tlb_all, NULL, 1);
>  }
> 
> diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
> index a1f07d7..184a367 100644
> --- a/arch/x86/kernel/tlb_64.c
> +++ b/arch/x86/kernel/tlb_64.c
> @@ -270,5 +270,5 @@ static void do_flush_tlb_all(void *info)
> 
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(do_flush_tlb_all, NULL, 1, 1);
> +	on_each_cpu(do_flush_tlb_all, NULL, 1);
>  }
> diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
> index 0a03d57..0dcae19 100644
> --- a/arch/x86/kernel/vsyscall_64.c
> +++ b/arch/x86/kernel/vsyscall_64.c
> @@ -301,7 +301,7 @@ static int __init vsyscall_init(void)
>  #ifdef CONFIG_SYSCTL
>  	register_sysctl_table(kernel_root_table2);
>  #endif
> -	on_each_cpu(cpu_vsyscall_init, NULL, 0, 1);
> +	on_each_cpu(cpu_vsyscall_init, NULL, 1);
>  	hotcpu_notifier(cpu_vsyscall_notifier, 0);
>  	return 0;
>  }
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index bb6e010..b2d6ae7 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -2964,7 +2964,7 @@ static void vmx_free_vmcs(struct kvm_vcpu *vcpu)
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> 
>  	if (vmx->vmcs) {
> -		on_each_cpu(__vcpu_clear, vmx, 0, 1);
> +		on_each_cpu(__vcpu_clear, vmx, 1);
>  		free_vmcs(vmx->vmcs);
>  		vmx->vmcs = NULL;
>  	}
> diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
> index 04f596e..abea084 100644
> --- a/arch/x86/mach-voyager/voyager_smp.c
> +++ b/arch/x86/mach-voyager/voyager_smp.c
> @@ -1072,7 +1072,7 @@ static void do_flush_tlb_all(void *info)
>  /* flush the TLB of every active CPU in the system */
>  void flush_tlb_all(void)
>  {
> -	on_each_cpu(do_flush_tlb_all, 0, 1, 1);
> +	on_each_cpu(do_flush_tlb_all, 0, 1);
>  }
> 
>  /* used to set up the trampoline for other CPUs when the memory manager
> diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> index 60bcb5b..9b836ba 100644
> --- a/arch/x86/mm/pageattr.c
> +++ b/arch/x86/mm/pageattr.c
> @@ -106,7 +106,7 @@ static void cpa_flush_all(unsigned long cache)
>  {
>  	BUG_ON(irqs_disabled());
> 
> -	on_each_cpu(__cpa_flush_all, (void *) cache, 1, 1);
> +	on_each_cpu(__cpa_flush_all, (void *) cache, 1);
>  }
> 
>  static void __cpa_flush_range(void *arg)
> @@ -127,7 +127,7 @@ static void cpa_flush_range(unsigned long start, int numpages, int cache)
>  	BUG_ON(irqs_disabled());
>  	WARN_ON(PAGE_ALIGN(start) != start);
> 
> -	on_each_cpu(__cpa_flush_range, NULL, 1, 1);
> +	on_each_cpu(__cpa_flush_range, NULL, 1);
> 
>  	if (!cache)
>  		return;
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index cc48d3f..3238ad3 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -218,8 +218,8 @@ static int nmi_setup(void)
>  		}
> 
>  	}
> -	on_each_cpu(nmi_save_registers, NULL, 0, 1);
> -	on_each_cpu(nmi_cpu_setup, NULL, 0, 1);
> +	on_each_cpu(nmi_save_registers, NULL, 1);
> +	on_each_cpu(nmi_cpu_setup, NULL, 1);
>  	nmi_enabled = 1;
>  	return 0;
>  }
> @@ -271,7 +271,7 @@ static void nmi_shutdown(void)
>  {
>  	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
>  	nmi_enabled = 0;
> -	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
> +	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
>  	unregister_die_notifier(&profile_exceptions_nb);
>  	model->shutdown(msrs);
>  	free_msrs();
> @@ -285,7 +285,7 @@ static void nmi_cpu_start(void *dummy)
> 
>  static int nmi_start(void)
>  {
> -	on_each_cpu(nmi_cpu_start, NULL, 0, 1);
> +	on_each_cpu(nmi_cpu_start, NULL, 1);
>  	return 0;
>  }
> 
> @@ -297,7 +297,7 @@ static void nmi_cpu_stop(void *dummy)
> 
>  static void nmi_stop(void)
>  {
> -	on_each_cpu(nmi_cpu_stop, NULL, 0, 1);
> +	on_each_cpu(nmi_cpu_stop, NULL, 1);
>  }
> 
>  struct op_counter_config counter_config[OP_MAX_COUNTER];
> diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
> index 7fc0c99..270f49a 100644
> --- a/drivers/char/agp/generic.c
> +++ b/drivers/char/agp/generic.c
> @@ -1246,7 +1246,7 @@ static void ipi_handler(void *null)
> 
>  void global_cache_flush(void)
>  {
> -	if (on_each_cpu(ipi_handler, NULL, 1, 1) != 0)
> +	if (on_each_cpu(ipi_handler, NULL, 1) != 0)
>  		panic(PFX "timed out waiting for the other CPUs!\n");
>  }
>  EXPORT_SYMBOL(global_cache_flush);
> diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
> index 5126d5d..44a4d65 100644
> --- a/drivers/lguest/x86/core.c
> +++ b/drivers/lguest/x86/core.c
> @@ -475,7 +475,7 @@ void __init lguest_arch_host_init(void)
>  		cpu_had_pge = 1;
>  		/* adjust_pge is a helper function which sets or unsets the PGE
>  		 * bit on its CPU, depending on the argument (0 == unset). */
> -		on_each_cpu(adjust_pge, (void *)0, 0, 1);
> +		on_each_cpu(adjust_pge, (void *)0, 1);
>  		/* Turn off the feature in the global feature set. */
>  		clear_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
>  	}
> @@ -490,7 +490,7 @@ void __exit lguest_arch_host_fini(void)
>  	if (cpu_had_pge) {
>  		set_bit(X86_FEATURE_PGE, boot_cpu_data.x86_capability);
>  		/* adjust_pge's argument "1" means set PGE. */
> -		on_each_cpu(adjust_pge, (void *)1, 0, 1);
> +		on_each_cpu(adjust_pge, (void *)1, 1);
>  	}
>  	put_online_cpus();
>  }
> diff --git a/fs/buffer.c b/fs/buffer.c
> index a073f3f..5c23ef5 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -1464,7 +1464,7 @@ static void invalidate_bh_lru(void *arg)
>  	
>  void invalidate_bh_lrus(void)
>  {
> -	on_each_cpu(invalidate_bh_lru, NULL, 1, 1);
> +	on_each_cpu(invalidate_bh_lru, NULL, 1);
>  }
>  EXPORT_SYMBOL_GPL(invalidate_bh_lrus);
> 
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 392579e..54a0ed6 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -88,7 +88,7 @@ static inline void init_call_single_data(void)
>  /*
>   * Call a function on all processors
>   */
> -int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait);
> +int on_each_cpu(void (*func) (void *info), void *info, int wait);
> 
>  #define MSG_ALL_BUT_SELF	0x8000	/* Assume <32768 CPU's */
>  #define MSG_ALL			0x8001
> @@ -120,7 +120,7 @@ static inline int up_smp_call_function(void (*func)(void *), void *info)
>  }
>  #define smp_call_function(func, info, wait) \
>  			(up_smp_call_function(func, info))
> -#define on_each_cpu(func,info,retry,wait)	\
> +#define on_each_cpu(func,info,wait)		\
>  	({					\
>  		local_irq_disable();		\
>  		func(info);			\
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 421be5f..50e8616 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -623,7 +623,7 @@ static void retrigger_next_event(void *arg)
>  void clock_was_set(void)
>  {
>  	/* Retrigger the CPU local events everywhere */
> -	on_each_cpu(retrigger_next_event, NULL, 0, 1);
> +	on_each_cpu(retrigger_next_event, NULL, 1);
>  }
> 
>  /*
> diff --git a/kernel/profile.c b/kernel/profile.c
> index ae7ead8..5892641 100644
> --- a/kernel/profile.c
> +++ b/kernel/profile.c
> @@ -252,7 +252,7 @@ static void profile_flip_buffers(void)
>  	mutex_lock(&profile_flip_mutex);
>  	j = per_cpu(cpu_profile_flip, get_cpu());
>  	put_cpu();
> -	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
> +	on_each_cpu(__profile_flip_buffers, NULL, 1);
>  	for_each_online_cpu(cpu) {
>  		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[j];
>  		for (i = 0; i < NR_PROFILE_HIT; ++i) {
> @@ -275,7 +275,7 @@ static void profile_discard_flip_buffers(void)
>  	mutex_lock(&profile_flip_mutex);
>  	i = per_cpu(cpu_profile_flip, get_cpu());
>  	put_cpu();
> -	on_each_cpu(__profile_flip_buffers, NULL, 0, 1);
> +	on_each_cpu(__profile_flip_buffers, NULL, 1);
>  	for_each_online_cpu(cpu) {
>  		struct profile_hit *hits = per_cpu(cpu_profile_hits, cpu)[i];
>  		memset(hits, 0, NR_PROFILE_HIT*sizeof(struct profile_hit));
> @@ -558,7 +558,7 @@ static int __init create_hash_tables(void)
>  out_cleanup:
>  	prof_on = 0;
>  	smp_mb();
> -	on_each_cpu(profile_nop, NULL, 0, 1);
> +	on_each_cpu(profile_nop, NULL, 1);
>  	for_each_online_cpu(cpu) {
>  		struct page *page;
> 
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index c09605f..6addab5 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -127,7 +127,7 @@ void rcu_barrier(void)
>  	 * until all the callbacks are queued.
>  	 */
>  	rcu_read_lock();
> -	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
> +	on_each_cpu(rcu_barrier_func, NULL, 1);
>  	rcu_read_unlock();
>  	wait_for_completion(&rcu_barrier_completion);
>  	mutex_unlock(&rcu_barrier_mutex);
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index d73afb4..c159fd0 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -674,7 +674,7 @@ __init int spawn_ksoftirqd(void)
>  /*
>   * Call a function on all processors
>   */
> -int on_each_cpu(void (*func) (void *info), void *info, int retry, int wait)
> +int on_each_cpu(void (*func) (void *info), void *info, int wait)
>  {
>  	int ret = 0;
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8e83f02..26b7e47 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -946,7 +946,7 @@ void drain_local_pages(void *arg)
>   */
>  void drain_all_pages(void)
>  {
> -	on_each_cpu(drain_local_pages, NULL, 0, 1);
> +	on_each_cpu(drain_local_pages, NULL, 1);
>  }
> 
>  #ifdef CONFIG_HIBERNATION
> diff --git a/mm/slab.c b/mm/slab.c
> index 06236e4..2cdaf56 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -2454,7 +2454,7 @@ static void drain_cpu_caches(struct kmem_cache *cachep)
>  	struct kmem_list3 *l3;
>  	int node;
> 
> -	on_each_cpu(do_drain, cachep, 1, 1);
> +	on_each_cpu(do_drain, cachep, 1);
>  	check_irq_on();
>  	for_each_online_node(node) {
>  		l3 = cachep->nodelists[node];
> @@ -3936,7 +3936,7 @@ static int do_tune_cpucache(struct kmem_cache *cachep, int limit,
>  	}
>  	new->cachep = cachep;
> 
> -	on_each_cpu(do_ccupdate_local, (void *)new, 1, 1);
> +	on_each_cpu(do_ccupdate_local, (void *)new, 1);
> 
>  	check_irq_on();
>  	cachep->batchcount = batchcount;
> diff --git a/mm/slub.c b/mm/slub.c
> index 0987d1c..44715eb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1497,7 +1497,7 @@ static void flush_cpu_slab(void *d)
>  static void flush_all(struct kmem_cache *s)
>  {
>  #ifdef CONFIG_SMP
> -	on_each_cpu(flush_cpu_slab, s, 1, 1);
> +	on_each_cpu(flush_cpu_slab, s, 1);
>  #else
>  	unsigned long flags;
> 
> diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
> index 94d5a45..a178e27 100644
> --- a/net/iucv/iucv.c
> +++ b/net/iucv/iucv.c
> @@ -545,7 +545,7 @@ out:
>   */
>  static void iucv_disable(void)
>  {
> -	on_each_cpu(iucv_retrieve_cpu, NULL, 0, 1);
> +	on_each_cpu(iucv_retrieve_cpu, NULL, 1);
>  	kfree(iucv_path_table);
>  }
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index ea1f595..d4eae6a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1286,7 +1286,7 @@ static int kvm_reboot(struct notifier_block *notifier, unsigned long val,
>  		 * in vmx root mode.
>  		 */
>  		printk(KERN_INFO "kvm: exiting hardware virtualization\n");
> -		on_each_cpu(hardware_disable, NULL, 0, 1);
> +		on_each_cpu(hardware_disable, NULL, 1);
>  	}
>  	return NOTIFY_OK;
>  }
> @@ -1479,7 +1479,7 @@ int kvm_init(void *opaque, unsigned int vcpu_size,
>  			goto out_free_1;
>  	}
> 
> -	on_each_cpu(hardware_enable, NULL, 0, 1);
> +	on_each_cpu(hardware_enable, NULL, 1);
>  	r = register_cpu_notifier(&kvm_cpu_notifier);
>  	if (r)
>  		goto out_free_2;
> @@ -1525,7 +1525,7 @@ out_free_3:
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	unregister_cpu_notifier(&kvm_cpu_notifier);
>  out_free_2:
> -	on_each_cpu(hardware_disable, NULL, 0, 1);
> +	on_each_cpu(hardware_disable, NULL, 1);
>  out_free_1:
>  	kvm_arch_hardware_unsetup();
>  out_free_0:
> @@ -1547,7 +1547,7 @@ void kvm_exit(void)
>  	sysdev_class_unregister(&kvm_sysdev_class);
>  	unregister_reboot_notifier(&kvm_reboot_notifier);
>  	unregister_cpu_notifier(&kvm_cpu_notifier);
> -	on_each_cpu(hardware_disable, NULL, 0, 1);
> +	on_each_cpu(hardware_disable, NULL, 1);
>  	kvm_arch_hardware_unsetup();
>  	kvm_arch_exit();
>  	kvm_exit_debug();
> -- 
> 1.5.6.rc0.40.gd683
> 
