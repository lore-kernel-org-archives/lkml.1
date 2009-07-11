Return-Path: <linux-kernel-owner+w=401wt.eu-S1752441AbZGKLBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbZGKLBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZGKLB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:01:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:38469 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbZGKLB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:01:26 -0400
Subject: Re: [tip:x86/cleanups] x86/cpu: Clean up various files a bit
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-8bdbd962ecfcbdd96f9dbb02d780b4553afd2543@git.kernel.org>
References: <new-submission>
	 <tip-8bdbd962ecfcbdd96f9dbb02d780b4553afd2543@git.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 16:30:26 +0530
Message-Id: <1247310026.3032.17.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-07-11 at 09:57 +0000, tip-bot for Alan Cox wrote:
> Commit-ID:  8bdbd962ecfcbdd96f9dbb02d780b4553afd2543
> Gitweb:     http://git.kernel.org/tip/8bdbd962ecfcbdd96f9dbb02d780b4553afd2543
> Author:     Alan Cox <alan@linux.intel.com>
> AuthorDate: Sat, 4 Jul 2009 00:35:45 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sat, 11 Jul 2009 11:24:09 +0200
> 
> x86/cpu: Clean up various files a bit
> 
> No code changes except printk levels (although some of the K6
> mtrr code might be clearer if there were a few as would
> splitting out some of the intel cache code).
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/amd.c              |   37 ++++++-----
>  arch/x86/kernel/cpu/bugs.c             |   10 ++--
>  arch/x86/kernel/cpu/bugs_64.c          |    2 +-
>  arch/x86/kernel/cpu/common.c           |    8 +-
>  arch/x86/kernel/cpu/cyrix.c            |   19 +++--
>  arch/x86/kernel/cpu/hypervisor.c       |    5 +-
>  arch/x86/kernel/cpu/intel.c            |   11 ++--
>  arch/x86/kernel/cpu/intel_cacheinfo.c  |  116 ++++++++++++++++---------------
>  arch/x86/kernel/cpu/perfctr-watchdog.c |   45 ++++++------
>  arch/x86/kernel/cpu/proc.c             |    2 +-
>  arch/x86/kernel/cpu/vmware.c           |   18 +++---
>  11 files changed, 144 insertions(+), 129 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index 28e5f59..c6eb02e 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -2,7 +2,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mm.h>
>  
> -#include <asm/io.h>
> +#include <linux/io.h>

linux/io.h should move to linux/XXX.h block

>  
>  static void __init check_hlt(void)
> @@ -98,7 +98,7 @@ static void __init check_hlt(void)
>  	halt();
>  	halt();
>  	halt();
> -	printk("OK.\n");
> +	printk(KERN_CONT "OK.\n");
>  }
>  
>  /*
> @@ -122,9 +122,9 @@ static void __init check_popad(void)
>  	 * CPU hard. Too bad.
>  	 */
>  	if (res != 12345678)
> -		printk("Buggy.\n");
> +		printk(KERN_CONT "Buggy.\n");
>  	else
> -		printk("OK.\n");
> +		printk(KERN_CONT "OK.\n");
>  #endif
>  }
>  
> @@ -156,7 +156,7 @@ void __init check_bugs(void)
>  {
>  	identify_boot_cpu();
>  #ifndef CONFIG_SMP
> -	printk("CPU: ");
> +	printk(KERN_INFO "CPU: ");
>  	print_cpu_info(&boot_cpu_data);
>  #endif
>  	check_config();
> diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
> index 9a3ed06..04f0fe5 100644
> --- a/arch/x86/kernel/cpu/bugs_64.c
> +++ b/arch/x86/kernel/cpu/bugs_64.c
> @@ -15,7 +15,7 @@ void __init check_bugs(void)
>  {
>  	identify_boot_cpu();
>  #if !defined(CONFIG_SMP)
> -	printk("CPU: ");
> +	printk(KERN_INFO "CPU: ");
>  	print_cpu_info(&boot_cpu_data);
>  #endif
>  	alternative_instructions();

I think, these was left intentionally otherwise dmesg output looks
weird.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index d6f27c9..c96ea44 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -18,8 +18,8 @@
>  #include <asm/hypervisor.h>
>  #include <asm/processor.h>
>  #include <asm/sections.h>
> -#include <asm/topology.h>
> -#include <asm/cpumask.h>
> +#include <linux/topology.h>
> +#include <linux/cpumask.h>

ditto

>  #include <asm/pgtable.h>
>  #include <asm/atomic.h>
>  #include <asm/proto.h>
> @@ -28,13 +28,13 @@
>  #include <asm/desc.h>
>  #include <asm/i387.h>
>  #include <asm/mtrr.h>
> -#include <asm/numa.h>
> +#include <linux/numa.h>

ditto.

>  #include <asm/asm.h>
>  #include <asm/cpu.h>
>  #include <asm/mce.h>
>  #include <asm/msr.h>
>  #include <asm/pat.h>
> -#include <asm/smp.h>
> +#include <linux/smp.h>

ditto + have you checking different config files, in some cases we get
error due to this.

>  
>  #ifdef CONFIG_X86_LOCAL_APIC
>  #include <asm/uv/uv.h>
> diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
> index 593171e..19807b8 100644
> --- a/arch/x86/kernel/cpu/cyrix.c
> +++ b/arch/x86/kernel/cpu/cyrix.c
> @@ -3,10 +3,10 @@
>  #include <linux/delay.h>
>  #include <linux/pci.h>
>  #include <asm/dma.h>
> -#include <asm/io.h>
> +#include <linux/io.h>
>  #include <asm/processor-cyrix.h>
>  #include <asm/processor-flags.h>
> -#include <asm/timer.h>
> +#include <linux/timer.h>
>  #include <asm/pci-direct.h>
>  #include <asm/tsc.h>
>  

ditto

> @@ -282,7 +282,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
>  		 *  The 5510/5520 companion chips have a funky PIT.
>  		 */
>  		if (vendor == PCI_VENDOR_ID_CYRIX &&
> -	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
> +			(device == PCI_DEVICE_ID_CYRIX_5510 ||
> +					device == PCI_DEVICE_ID_CYRIX_5520))
>  			mark_tsc_unstable("cyrix 5510/5520 detected");

This even looks ugly.

>  	}
>  #endif
> @@ -299,7 +300,8 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
>  			 *  ?  : 0x7x
>  			 * GX1 : 0x8x          GX1  datasheet 56
>  			 */
> -			if ((0x30 <= dir1 && dir1 <= 0x6f) || (0x80 <= dir1 && dir1 <= 0x8f))
> +			if ((0x30 <= dir1 && dir1 <= 0x6f) ||
> +					(0x80 <= dir1 && dir1 <= 0x8f))
>  				geode_configure();

ditto

>  			return;
>  		} else { /* MediaGX */
> @@ -427,9 +429,12 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
>  			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
>  			local_irq_save(flags);
>  			ccr3 = getCx86(CX86_CCR3);
> -			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);       /* enable MAPEN  */
> -			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);  /* enable cpuid  */
> -			setCx86(CX86_CCR3, ccr3);                       /* disable MAPEN */
> +			/* enable MAPEN  */
> +			setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10);
> +			/* enable cpuid  */
> +			setCx86_old(CX86_CCR4, getCx86_old(CX86_CCR4) | 0x80);
> +			/* disable MAPEN */
> +			setCx86(CX86_CCR3, ccr3);
>  			local_irq_restore(flags);
>  		}
>  	}
>  
> @@ -174,7 +174,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  #ifdef CONFIG_X86_F00F_BUG
>  	/*
>  	 * All current models of Pentium and Pentium with MMX technology CPUs
> -	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
> +	 * have the F0 0F bug, which lets nonprivileged users lock up the
> +	 * system.

It should be non-privileged


I think this is enough.

Even though I have send some of these fixes many times to you and you
keep on rejecting my patch by saying there are more clean-ups.

Do not you feel it this time.

Thanks,
--
JSR

>  	 * Note that the workaround only should be initialized once...
>  	 */
>  	c->f00f_bug = 0;
> @@ -207,7 +208,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
>  			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
>  			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
>  			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
> -			wrmsr (MSR_IA32_MISC_ENABLE, lo, hi);
> +			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
>  		}
>  	}
>  
> @@ -283,7 +284,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
>  	/* Intel has a non-standard dependency on %ecx for this CPUID level. */
>  	cpuid_count(4, 0, &eax, &ebx, &ecx, &edx);
>  	if (eax & 0x1f)
> -		return ((eax >> 26) + 1);
> +		return (eax >> 26) + 1;
>  	else
>  		return 1;
>  }
> diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> index 789efe2..306bf0d 100644
> --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> @@ -3,7 +3,7 @@
>   *
>   *	Changes:
>   *	Venkatesh Pallipadi	: Adding cache identification through cpuid(4)
> - *		Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
> + *	Ashok Raj <ashok.raj@intel.com>: Work with CPU hotplug infrastructure.
>   *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
>   */
>  
> @@ -16,7 +16,7 @@
>  #include <linux/pci.h>
>  
>  #include <asm/processor.h>
> -#include <asm/smp.h>
> +#include <linux/smp.h>
>  #include <asm/k8.h>
>  
>  #define LVL_1_INST	1
> @@ -25,14 +25,15 @@
>  #define LVL_3		4
>  #define LVL_TRACE	5
>  
> -struct _cache_table
> -{
> +struct _cache_table {
>  	unsigned char descriptor;
>  	char cache_type;
>  	short size;
>  };
>  
> -/* all the cache descriptor types we care about (no TLB or trace cache entries) */
> +/* All the cache descriptor types we care about (no TLB or
> +   trace cache entries) */
> +
>  static const struct _cache_table __cpuinitconst cache_table[] =
>  {
>  	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
> @@ -105,8 +106,7 @@ static const struct _cache_table __cpuinitconst cache_table[] =
>  };
>  
> 
> -enum _cache_type
> -{
> +enum _cache_type {
>  	CACHE_TYPE_NULL	= 0,
>  	CACHE_TYPE_DATA = 1,
>  	CACHE_TYPE_INST = 2,
> @@ -170,31 +170,31 @@ unsigned short			num_cache_leaves;
>     Maybe later */
>  union l1_cache {
>  	struct {
> -		unsigned line_size : 8;
> -		unsigned lines_per_tag : 8;
> -		unsigned assoc : 8;
> -		unsigned size_in_kb : 8;
> +		unsigned line_size:8;
> +		unsigned lines_per_tag:8;
> +		unsigned assoc:8;
> +		unsigned size_in_kb:8;
>  	};
>  	unsigned val;
>  };
>  
>  union l2_cache {
>  	struct {
> -		unsigned line_size : 8;
> -		unsigned lines_per_tag : 4;
> -		unsigned assoc : 4;
> -		unsigned size_in_kb : 16;
> +		unsigned line_size:8;
> +		unsigned lines_per_tag:4;
> +		unsigned assoc:4;
> +		unsigned size_in_kb:16;
>  	};
>  	unsigned val;
>  };
>  
>  union l3_cache {
>  	struct {
> -		unsigned line_size : 8;
> -		unsigned lines_per_tag : 4;
> -		unsigned assoc : 4;
> -		unsigned res : 2;
> -		unsigned size_encoded : 14;
> +		unsigned line_size:8;
> +		unsigned lines_per_tag:4;
> +		unsigned assoc:4;
> +		unsigned res:2;
> +		unsigned size_encoded:14;
>  	};
>  	unsigned val;
>  };
> @@ -350,7 +350,8 @@ static int __cpuinit find_num_cache_leaves(void)
>  
>  unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  {
> -	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0; /* Cache sizes */
> +	/* Cache sizes */
> +	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0;
>  	unsigned int new_l1d = 0, new_l1i = 0; /* Cache sizes from cpuid(4) */
>  	unsigned int new_l2 = 0, new_l3 = 0, i; /* Cache sizes from cpuid(4) */
>  	unsigned int l2_id = 0, l3_id = 0, num_threads_sharing, index_msb;
> @@ -377,8 +378,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  
>  			retval = cpuid4_cache_lookup_regs(i, &this_leaf);
>  			if (retval >= 0) {
> -				switch(this_leaf.eax.split.level) {
> -				    case 1:
> +				switch (this_leaf.eax.split.level) {
> +				case 1:
>  					if (this_leaf.eax.split.type ==
>  							CACHE_TYPE_DATA)
>  						new_l1d = this_leaf.size/1024;
> @@ -386,19 +387,20 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  							CACHE_TYPE_INST)
>  						new_l1i = this_leaf.size/1024;
>  					break;
> -				    case 2:
> +				case 2:
>  					new_l2 = this_leaf.size/1024;
>  					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
>  					index_msb = get_count_order(num_threads_sharing);
>  					l2_id = c->apicid >> index_msb;
>  					break;
> -				    case 3:
> +				case 3:
>  					new_l3 = this_leaf.size/1024;
>  					num_threads_sharing = 1 + this_leaf.eax.split.num_threads_sharing;
> -					index_msb = get_count_order(num_threads_sharing);
> +					index_msb = get_count_order(
> +							num_threads_sharing);
>  					l3_id = c->apicid >> index_msb;
>  					break;
> -				    default:
> +				default:
>  					break;
>  				}
>  			}
> @@ -421,22 +423,21 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  		/* Number of times to iterate */
>  		n = cpuid_eax(2) & 0xFF;
>  
> -		for ( i = 0 ; i < n ; i++ ) {
> +		for (i = 0 ; i < n ; i++) {
>  			cpuid(2, &regs[0], &regs[1], &regs[2], &regs[3]);
>  
>  			/* If bit 31 is set, this is an unknown format */
> -			for ( j = 0 ; j < 3 ; j++ ) {
> -				if (regs[j] & (1 << 31)) regs[j] = 0;
> -			}
> +			for (j = 0 ; j < 3 ; j++)
> +				if (regs[j] & (1 << 31))
> +					regs[j] = 0;
>  
>  			/* Byte 0 is level count, not a descriptor */
> -			for ( j = 1 ; j < 16 ; j++ ) {
> +			for (j = 1 ; j < 16 ; j++) {
>  				unsigned char des = dp[j];
>  				unsigned char k = 0;
>  
>  				/* look up this descriptor in the table */
> -				while (cache_table[k].descriptor != 0)
> -				{
> +				while (cache_table[k].descriptor != 0) {
>  					if (cache_table[k].descriptor == des) {
>  						if (only_trace && cache_table[k].cache_type != LVL_TRACE)
>  							break;
> @@ -488,14 +489,14 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
>  	}
>  
>  	if (trace)
> -		printk (KERN_INFO "CPU: Trace cache: %dK uops", trace);
> -	else if ( l1i )
> -		printk (KERN_INFO "CPU: L1 I cache: %dK", l1i);
> +		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
> +	else if (l1i)
> +		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
>  
>  	if (l1d)
> -		printk(", L1 D cache: %dK\n", l1d);
> +		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
>  	else
> -		printk("\n");
> +		printk(KERN_CONT "\n");
>  
>  	if (l2)
>  		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
> @@ -558,8 +559,13 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
>  	}
>  }
>  #else
> -static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
> -static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
> +static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
> +{
> +}
> +
> +static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
> +{
> +}
>  #endif
>  
>  static void __cpuinit free_cache_attributes(unsigned int cpu)
> @@ -645,7 +651,7 @@ static DEFINE_PER_CPU(struct _index_kobject *, index_kobject);
>  static ssize_t show_##file_name						\
>  			(struct _cpuid4_info *this_leaf, char *buf)	\
>  {									\
> -	return sprintf (buf, "%lu\n", (unsigned long)this_leaf->object + val); \
> +	return sprintf(buf, "%lu\n", (unsigned long)this_leaf->object + val); \
>  }
>  
>  show_one_plus(level, eax.split.level, 0);
> @@ -656,7 +662,7 @@ show_one_plus(number_of_sets, ecx.split.number_of_sets, 1);
>  
>  static ssize_t show_size(struct _cpuid4_info *this_leaf, char *buf)
>  {
> -	return sprintf (buf, "%luK\n", this_leaf->size / 1024);
> +	return sprintf(buf, "%luK\n", this_leaf->size / 1024);
>  }
>  
>  static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
> @@ -669,7 +675,7 @@ static ssize_t show_shared_cpu_map_func(struct _cpuid4_info *this_leaf,
>  		const struct cpumask *mask;
>  
>  		mask = to_cpumask(this_leaf->shared_cpu_map);
> -		n = type?
> +		n = type ?
>  			cpulist_scnprintf(buf, len-2, mask) :
>  			cpumask_scnprintf(buf, len-2, mask);
>  		buf[n++] = '\n';
> @@ -800,7 +806,7 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
>  static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
>  		show_cache_disable_1, store_cache_disable_1);
>  
> -static struct attribute * default_attrs[] = {
> +static struct attribute *default_attrs[] = {
>  	&type.attr,
>  	&level.attr,
>  	&coherency_line_size.attr,
> @@ -815,7 +821,7 @@ static struct attribute * default_attrs[] = {
>  	NULL
>  };
>  
> -static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
> +static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
>  {
>  	struct _cache_attr *fattr = to_attr(attr);
>  	struct _index_kobject *this_leaf = to_object(kobj);
> @@ -828,8 +834,8 @@ static ssize_t show(struct kobject * kobj, struct attribute * attr, char * buf)
>  	return ret;
>  }
>  
> -static ssize_t store(struct kobject * kobj, struct attribute * attr,
> -		     const char * buf, size_t count)
> +static ssize_t store(struct kobject *kobj, struct attribute *attr,
> +		     const char *buf, size_t count)
>  {
>  	struct _cache_attr *fattr = to_attr(attr);
>  	struct _index_kobject *this_leaf = to_object(kobj);
> @@ -883,7 +889,7 @@ static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
>  		goto err_out;
>  
>  	per_cpu(index_kobject, cpu) = kzalloc(
> -	    sizeof(struct _index_kobject ) * num_cache_leaves, GFP_KERNEL);
> +	    sizeof(struct _index_kobject) * num_cache_leaves, GFP_KERNEL);
>  	if (unlikely(per_cpu(index_kobject, cpu) == NULL))
>  		goto err_out;
>  
> @@ -917,7 +923,7 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
>  	}
>  
>  	for (i = 0; i < num_cache_leaves; i++) {
> -		this_object = INDEX_KOBJECT_PTR(cpu,i);
> +		this_object = INDEX_KOBJECT_PTR(cpu, i);
>  		this_object->cpu = cpu;
>  		this_object->index = i;
>  		retval = kobject_init_and_add(&(this_object->kobj),
> @@ -925,9 +931,8 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
>  					      per_cpu(cache_kobject, cpu),
>  					      "index%1lu", i);
>  		if (unlikely(retval)) {
> -			for (j = 0; j < i; j++) {
> -				kobject_put(&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
> -			}
> +			for (j = 0; j < i; j++)
> +				kobject_put(&(INDEX_KOBJECT_PTR(cpu, j)->kobj));
>  			kobject_put(per_cpu(cache_kobject, cpu));
>  			cpuid4_cache_sysfs_exit(cpu);
>  			return retval;
> @@ -952,7 +957,7 @@ static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
>  	cpumask_clear_cpu(cpu, to_cpumask(cache_dev_map));
>  
>  	for (i = 0; i < num_cache_leaves; i++)
> -		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
> +		kobject_put(&(INDEX_KOBJECT_PTR(cpu, i)->kobj));
>  	kobject_put(per_cpu(cache_kobject, cpu));
>  	cpuid4_cache_sysfs_exit(cpu);
>  }
> @@ -977,8 +982,7 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
>  	return NOTIFY_OK;
>  }
>  
> -static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier =
> -{
> +static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
>  	.notifier_call = cacheinfo_cpu_callback,
>  };
>  
> diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
> index 5c481f6..8100a29 100644
> --- a/arch/x86/kernel/cpu/perfctr-watchdog.c
> +++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
> @@ -68,16 +68,16 @@ static inline unsigned int nmi_perfctr_msr_to_bit(unsigned int msr)
>  	/* returns the bit offset of the performance counter register */
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_AMD:
> -		return (msr - MSR_K7_PERFCTR0);
> +		return msr - MSR_K7_PERFCTR0;
>  	case X86_VENDOR_INTEL:
>  		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
> -			return (msr - MSR_ARCH_PERFMON_PERFCTR0);
> +			return msr - MSR_ARCH_PERFMON_PERFCTR0;
>  
>  		switch (boot_cpu_data.x86) {
>  		case 6:
> -			return (msr - MSR_P6_PERFCTR0);
> +			return msr - MSR_P6_PERFCTR0;
>  		case 15:
> -			return (msr - MSR_P4_BPU_PERFCTR0);
> +			return msr - MSR_P4_BPU_PERFCTR0;
>  		}
>  	}
>  	return 0;
> @@ -92,16 +92,16 @@ static inline unsigned int nmi_evntsel_msr_to_bit(unsigned int msr)
>  	/* returns the bit offset of the event selection register */
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_AMD:
> -		return (msr - MSR_K7_EVNTSEL0);
> +		return msr - MSR_K7_EVNTSEL0;
>  	case X86_VENDOR_INTEL:
>  		if (cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
> -			return (msr - MSR_ARCH_PERFMON_EVENTSEL0);
> +			return msr - MSR_ARCH_PERFMON_EVENTSEL0;
>  
>  		switch (boot_cpu_data.x86) {
>  		case 6:
> -			return (msr - MSR_P6_EVNTSEL0);
> +			return msr - MSR_P6_EVNTSEL0;
>  		case 15:
> -			return (msr - MSR_P4_BSU_ESCR0);
> +			return msr - MSR_P4_BSU_ESCR0;
>  		}
>  	}
>  	return 0;
> @@ -113,7 +113,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
>  {
>  	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
>  
> -	return (!test_bit(counter, perfctr_nmi_owner));
> +	return !test_bit(counter, perfctr_nmi_owner);
>  }
>  
>  /* checks the an msr for availability */
> @@ -124,7 +124,7 @@ int avail_to_resrv_perfctr_nmi(unsigned int msr)
>  	counter = nmi_perfctr_msr_to_bit(msr);
>  	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
>  
> -	return (!test_bit(counter, perfctr_nmi_owner));
> +	return !test_bit(counter, perfctr_nmi_owner);
>  }
>  EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
>  
> @@ -237,7 +237,7 @@ static unsigned int adjust_for_32bit_ctr(unsigned int hz)
>  	 */
>  	counter_val = (u64)cpu_khz * 1000;
>  	do_div(counter_val, retval);
> - 	if (counter_val > 0x7fffffffULL) {
> +	if (counter_val > 0x7fffffffULL) {
>  		u64 count = (u64)cpu_khz * 1000;
>  		do_div(count, 0x7fffffffUL);
>  		retval = count + 1;
> @@ -251,7 +251,7 @@ static void write_watchdog_counter(unsigned int perfctr_msr,
>  	u64 count = (u64)cpu_khz * 1000;
>  
>  	do_div(count, nmi_hz);
> -	if(descr)
> +	if (descr)
>  		pr_debug("setting %s to -0x%08Lx\n", descr, count);
>  	wrmsrl(perfctr_msr, 0 - count);
>  }
> @@ -262,7 +262,7 @@ static void write_watchdog_counter32(unsigned int perfctr_msr,
>  	u64 count = (u64)cpu_khz * 1000;
>  
>  	do_div(count, nmi_hz);
> -	if(descr)
> +	if (descr)
>  		pr_debug("setting %s to -0x%08Lx\n", descr, count);
>  	wrmsr(perfctr_msr, (u32)(-count), 0);
>  }
> @@ -296,7 +296,7 @@ static int setup_k7_watchdog(unsigned nmi_hz)
>  
>  	/* setup the timer */
>  	wrmsr(evntsel_msr, evntsel, 0);
> -	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0",nmi_hz);
> +	write_watchdog_counter(perfctr_msr, "K7_PERFCTR0", nmi_hz);
>  
>  	/* initialize the wd struct before enabling */
>  	wd->perfctr_msr = perfctr_msr;
> @@ -387,7 +387,7 @@ static int setup_p6_watchdog(unsigned nmi_hz)
>  	/* setup the timer */
>  	wrmsr(evntsel_msr, evntsel, 0);
>  	nmi_hz = adjust_for_32bit_ctr(nmi_hz);
> -	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0",nmi_hz);
> +	write_watchdog_counter32(perfctr_msr, "P6_PERFCTR0", nmi_hz);
>  
>  	/* initialize the wd struct before enabling */
>  	wd->perfctr_msr = perfctr_msr;
> @@ -415,7 +415,7 @@ static void __kprobes p6_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
>  	apic_write(APIC_LVTPC, APIC_DM_NMI);
>  
>  	/* P6/ARCH_PERFMON has 32 bit counter write */
> -	write_watchdog_counter32(wd->perfctr_msr, NULL,nmi_hz);
> +	write_watchdog_counter32(wd->perfctr_msr, NULL, nmi_hz);
>  }
>  
>  static const struct wd_ops p6_wd_ops = {
> @@ -490,9 +490,9 @@ static int setup_p4_watchdog(unsigned nmi_hz)
>  	if (smp_num_siblings == 2) {
>  		unsigned int ebx, apicid;
>  
> -        	ebx = cpuid_ebx(1);
> -	        apicid = (ebx >> 24) & 0xff;
> -        	ht_num = apicid & 1;
> +		ebx = cpuid_ebx(1);
> +		apicid = (ebx >> 24) & 0xff;
> +		ht_num = apicid & 1;
>  	} else
>  #endif
>  		ht_num = 0;
> @@ -544,7 +544,7 @@ static int setup_p4_watchdog(unsigned nmi_hz)
>  	}
>  
>  	evntsel = P4_ESCR_EVENT_SELECT(0x3F)
> -	 	| P4_ESCR_OS
> +		| P4_ESCR_OS
>  		| P4_ESCR_USR;
>  
>  	cccr_val |= P4_CCCR_THRESHOLD(15)
> @@ -612,7 +612,7 @@ static void __kprobes p4_rearm(struct nmi_watchdog_ctlblk *wd, unsigned nmi_hz)
>  {
>  	unsigned dummy;
>  	/*
> - 	 * P4 quirks:
> +	 * P4 quirks:
>  	 * - An overflown perfctr will assert its interrupt
>  	 *   until the OVF flag in its CCCR is cleared.
>  	 * - LVTPC is masked on interrupt and must be
> @@ -662,7 +662,8 @@ static int setup_intel_arch_watchdog(unsigned nmi_hz)
>  	 * NOTE: Corresponding bit = 0 in ebx indicates event present.
>  	 */
>  	cpuid(10, &(eax.full), &ebx, &unused, &unused);
> -	if ((eax.split.mask_length < (ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
> +	if ((eax.split.mask_length <
> +			(ARCH_PERFMON_UNHALTED_CORE_CYCLES_INDEX+1)) ||
>  	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
>  		return 0;
>  
> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> index d5e3039..1e90434 100644
> --- a/arch/x86/kernel/cpu/proc.c
> +++ b/arch/x86/kernel/cpu/proc.c
> @@ -128,7 +128,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>  			if (i < ARRAY_SIZE(x86_power_flags) &&
>  			    x86_power_flags[i])
>  				seq_printf(m, "%s%s",
> -					   x86_power_flags[i][0]?" ":"",
> +					   x86_power_flags[i][0] ? " " : "",
>  					   x86_power_flags[i]);
>  			else
>  				seq_printf(m, " [%d]", i);
> diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
> index 284c399..bc24f51 100644
> --- a/arch/x86/kernel/cpu/vmware.c
> +++ b/arch/x86/kernel/cpu/vmware.c
> @@ -49,17 +49,17 @@ static inline int __vmware_platform(void)
>  
>  static unsigned long __vmware_get_tsc_khz(void)
>  {
> -        uint64_t tsc_hz;
> -        uint32_t eax, ebx, ecx, edx;
> +	uint64_t tsc_hz;
> +	uint32_t eax, ebx, ecx, edx;
>  
> -        VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
> +	VMWARE_PORT(GETHZ, eax, ebx, ecx, edx);
>  
> -        if (ebx == UINT_MAX)
> -                return 0;
> -        tsc_hz = eax | (((uint64_t)ebx) << 32);
> -        do_div(tsc_hz, 1000);
> -        BUG_ON(tsc_hz >> 32);
> -        return tsc_hz;
> +	if (ebx == UINT_MAX)
> +		return 0;
> +	tsc_hz = eax | (((uint64_t)ebx) << 32);
> +	do_div(tsc_hz, 1000);
> +	BUG_ON(tsc_hz >> 32);
> +	return tsc_hz;
>  }
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

