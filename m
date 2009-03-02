Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZCBUzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZCBUzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 15:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZCBUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 15:54:52 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34655 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZCBUyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:54:51 -0500
Date: Mon, 2 Mar 2009 21:54:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: msr architecture debug code
Message-ID: <20090302205437.GB14471@elte.hu>
References: <1236008575.3332.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236008575.3332.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> The following changes since commit 1d10914bf2c8a1164aef6c341e6c3518a91b8374:
>   Ingo Molnar (1):
>         Merge branch 'core/percpu'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> 
> Jaswinder Singh Rajput (1):
>       x86: msr architecture debug code
> 
>  arch/x86/include/asm/msr_debug.h |   56 ++++++
>  arch/x86/kernel/cpu/Makefile     |    2 +-
>  arch/x86/kernel/cpu/msr_debug.c  |  362 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 419 insertions(+), 1 deletions(-)
>  create mode 100755 arch/x86/include/asm/msr_debug.h
>  create mode 100755 arch/x86/kernel/cpu/msr_debug.c
> 
> Complete diff:
> diff --git a/arch/x86/include/asm/msr_debug.h b/arch/x86/include/asm/msr_debug.h
> new file mode 100755
> index 0000000..ddc4fe5
> --- /dev/null
> +++ b/arch/x86/include/asm/msr_debug.h
> @@ -0,0 +1,56 @@
> +#ifndef _ASM_X86_MSR_DEBUG_H
> +#define _ASM_X86_MSR_DEBUG_H
> +
> +/*
> + * Model Specific Registers (MSR) x86 architecture debug
> + *
> + * Copyright(C) 2009 Jaswinder Singh Rajput
> + */
> +
> +#define MSR_ALL		0
> +#define MSR_PMC		1	/* Performance Monitor counters */
> +
> +struct msr_debug_range {
> +	unsigned min;
> +	unsigned max;
> +	unsigned model;
> +};

Please vertical-align structure field definitions, like you see 
we do it elsewhere in the x86 code.

> +
> +/* Intel MSRs Range */
> +
> +/* DisplayFamily_DisplayModel	Processor Families/Processor Number Series */
> +/* --------------------------	------------------------------------------ */
> +/* 05_01, 05_02, 05_04		Pentium, Pentium with MMX		*/
> +#define	MSR_INTEL_PENTIUM	(1 << 0)
> +
> +/* 06_01			Pentium Pro				*/
> +/* 06_03, 06_05			Pentium II Xeon, Pentium II		*/
> +/* 06_07, 06_08, 06_0A, 06_0B	Pentium III Xeon, Pentum III		*/
> +#define	MSR_INTEL_P6		(1 << 1)
> +
> +/* 06_09, 060D			Pentium M				*/
> +#define	MSR_INTEL_PENTIUM_M	(1 << 4)
> +
> +/* 06_0E			Core Duo, Core Solo			*/
> +#define	MSR_INTEL_CORE		(1 << 5)
> +
> +/* 06_0F			Xeon 3000, 3200, 5100, 5300, 7300 series,
> +				Core 2 Quad, Core 2 Extreme, Core 2 Duo,
> +				Pentium dual-core			*/
> +/* 06_17			Xeon 5200, 5400 series, Core 2 Quad Q9650 */
> +#define	MSR_INTEL_CORE_2	(1 << 6)
> +
> +/* 06_1C			Atom					*/
> +#define	MSR_INTEL_ATOM		(1 << 7)
> +
> +/* 0F_00, 0F_01, 0F_02		Xeon, Xeon MP, Pentium 4		*/
> +/* 0F_03, 0F_04			Xeon, Xeon MP, Pentium 4, Pentium D	*/
> +#define	MSR_INTEL_XEON		(1 << 17)
> +
> +/* 0F_06			Xeon 7100, 5000 Series, Xeon MP,
> +				Pentium 4, Pentium D			*/
> +#define	MSR_INTEL_XEON_MP	(1 << 18)
> +
> +#define	MSR_CPU_ALL		(~0)
> +
> +#endif /* _ASM_X86_MSR_DEBUG_H */
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index c381330..b2452f3 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -8,7 +8,7 @@ CFLAGS_REMOVE_common.o = -pg
>  endif
>  
>  obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
> -obj-y			+= proc.o capflags.o powerflags.o common.o
> +obj-y			+= proc.o capflags.o powerflags.o common.o msr_debug.o
>  obj-y			+= vmware.o hypervisor.o
>  
>  obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
> diff --git a/arch/x86/kernel/cpu/msr_debug.c b/arch/x86/kernel/cpu/msr_debug.c
> new file mode 100755
> index 0000000..505f53f
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/msr_debug.c
> @@ -0,0 +1,362 @@
> +/*
> + * Model Specific Registers (MSR) x86 architecture debug code
> + *
> + * Copyright(C) 2009 Jaswinder Singh Rajput
> + *
> + * For licencing details see kernel-base/COPYING
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/debugfs.h>
> +#include <linux/seq_file.h>
> +#include <asm/msr_debug.h>

Please have a good look at what the standard include files 
section look like - for example in 
arch/x86/kernel/cpu/perf_counter.c or in arch/x86/mm/fault.c. 
Please use that same ordering of the lines here too.

> +static struct msr_debug_range msr_intel_range[] = {
> +	{ 0x00000000, 0x000006d0, MSR_CPU_ALL },
> +	{ 0x000107CC, 0x000107D4, MSR_INTEL_XEON_MP },
> +};
> +
> +static struct msr_debug_range pmc_intel_range[] = {
> +	{ 0x00000010, 0x00000011, MSR_CPU_ALL },	/* TSC */
> +	{ 0x00000011, 0x00000014, MSR_INTEL_PENTIUM },	/* CESR, CTR */
> +	{ 0x0000001B, 0x0000001C, MSR_CPU_ALL },	/* APIC */
> +	{ 0x000000C1, 0x000000C3, MSR_INTEL_P6 },	/* PerfCtr */
> +	{ 0x00000186, 0x00000188, MSR_INTEL_P6 | MSR_INTEL_ATOM |
> +				  MSR_INTEL_CORE_2 },	/* EvtSel */
> +	{ 0x000001A0, 0x000001A1, MSR_CPU_ALL },	/* Misc Feature */
> +	{ 0x00000300, 0x00000312, MSR_INTEL_XEON },	/* Counter */
> +	{ 0x00000309, 0x0000030C, MSR_INTEL_P6 | MSR_INTEL_ATOM |
> +				  MSR_INTEL_CORE_2 },	/* Fixed */
> +	{ 0x00000360, 0x00000372, MSR_INTEL_XEON },	/* CCCR */
> +	{ 0x0000038D, 0x00000391, MSR_INTEL_P6 | MSR_INTEL_ATOM |
> +				  MSR_INTEL_CORE_2 },	/* Fixed & Global */
> +	{ 0x00000390, 0x00000391, MSR_INTEL_P6 | MSR_INTEL_ATOM |
> +				  MSR_INTEL_CORE_2 },	/* OVF */
> +	{ 0x000003A0, 0x000003F3, MSR_INTEL_XEON },	/* ESCR */
> +	{ 0x000003F1, 0x000003F2, MSR_INTEL_P6 | MSR_INTEL_ATOM |
> +				  MSR_INTEL_CORE_2 },	/* PEBS */
> +	{ 0x000107CC, 0x000107D4, MSR_INTEL_XEON_MP },
> +};
> +
> +/* AMD MSRs Range */
> +static struct msr_debug_range msr_amd_range[] = {
> +	{ 0x00000000, 0x00000418, MSR_CPU_ALL},
> +	{ 0xc0000000, 0xc000040b, MSR_CPU_ALL},
> +	{ 0xc0010000, 0xc0010142, MSR_CPU_ALL},
> +	{ 0xc0011000, 0xc001103b, MSR_CPU_ALL},
> +};
> +
> +static struct msr_debug_range pmc_amd_range[] = {
> +	{ 0x00000010, 0x00000011, MSR_CPU_ALL },	/* TSC */
> +	{ 0x0000001B, 0x0000001C, MSR_CPU_ALL },	/* APIC */
> +	{ 0xc0010000, 0xc0010008, MSR_CPU_ALL},
> +};
> +
> +
> +static int get_msr_intel_bit(unsigned model)
> +{
> +	int ret = 0;
> +
> +	switch (model) {
> +	case 0x0501:
> +	case 0x0502:
> +	case 0x0504:
> +		ret = MSR_INTEL_PENTIUM;
> +		break;
> +	case 0x0601:
> +	case 0x0603:
> +	case 0x0605:
> +	case 0x0607:
> +	case 0x0608:
> +	case 0x060A:
> +	case 0x060B:
> +		ret = MSR_INTEL_P6;
> +		break;
> +	case 0x0609:
> +	case 0x060D:
> +		ret = MSR_INTEL_PENTIUM_M;
> +		break;
> +	case 0x060E:
> +		ret = MSR_INTEL_CORE;
> +		break;
> +	case 0x060F:
> +	case 0x0617:
> +		ret = MSR_INTEL_CORE_2;
> +		break;
> +	case 0x061C:
> +		ret = MSR_INTEL_ATOM;
> +		break;
> +	case 0x0F00:
> +	case 0x0F01:
> +	case 0x0F02:
> +	case 0x0F03:
> +	case 0x0F04:
> +		ret = MSR_INTEL_XEON;
> +		break;
> +	case 0x0F06:
> +		ret = MSR_INTEL_XEON_MP;
> +		break;
> +	}

all these magic constants open-coded look a bit ugly. Can it be 
done cleaner?

> +
> +	return ret;
> +}
> +
> +static int get_msr_cpu_bit(unsigned model)
> +{
> +	unsigned vendor;
> +
> +	vendor = model >> 16;
> +	if (vendor == X86_VENDOR_INTEL)
> +		return get_msr_intel_bit(model & 0xffff);
> +	else
> +		return 0;
> +}
> +
> +static int get_msr_range(unsigned *min, unsigned *max, int index,
> +			 unsigned flag, unsigned model)
> +{
> +	unsigned vendor, cpu_bit;
> +	int err = 0;
> +
> +	vendor = model >> 16;
> +	cpu_bit = get_msr_cpu_bit(model);
> +	switch (flag) {
> +	case MSR_ALL:
> +		if (vendor == 0) {
> +			if (msr_intel_range[index].model & cpu_bit) {
> +				*min = msr_intel_range[index].min;
> +				*max = msr_intel_range[index].max;
> +			} else
> +				err = -EINVAL;
> +		} else if (vendor == X86_VENDOR_AMD) {
> +			*min = msr_amd_range[index].min;
> +			*max = msr_amd_range[index].max;
> +		}
> +		break;
> +	case MSR_PMC:
> +		if (vendor == 0) {
> +			if (pmc_intel_range[index].model & cpu_bit) {
> +				*min = pmc_intel_range[index].min;
> +				*max = pmc_intel_range[index].max;
> +			} else
> +				err = -EINVAL;
> +		} else if (vendor == X86_VENDOR_AMD) {
> +			*min = pmc_amd_range[index].min;
> +			*max = pmc_amd_range[index].max;
> +		} else
> +			err = -EINVAL;
> +		break;
> +	default:
> +		err = -ENOSYS;
> +	}
> +
> +	return err;
> +}
> +
> +static int get_msr_range_count(unsigned flag, unsigned model)
> +{
> +	int index = 0;
> +
> +	model >>= 16;
> +	switch (flag) {
> +	case MSR_ALL:
> +		if (model == X86_VENDOR_INTEL)
> +			index = ARRAY_SIZE(msr_intel_range);
> +		else if (model == X86_VENDOR_AMD)
> +			index = ARRAY_SIZE(msr_amd_range);
> +		break;
> +	case MSR_PMC:
> +		if (model == X86_VENDOR_INTEL)
> +			index = ARRAY_SIZE(pmc_intel_range);
> +		else if (model == X86_VENDOR_AMD)
> +			index = ARRAY_SIZE(pmc_amd_range);
> +		break;
> +	}
> +
> +	return index;
> +}
> +
> +static void print_intel_msr(struct seq_file *seq, unsigned int cpu,
> +			    unsigned flag, unsigned model)
> +{
> +	int i, range;
> +	u32 low, high;
> +	unsigned msr, msr_min, msr_max;
> +
> +	range = get_msr_range_count(flag, model);
> +	seq_printf(seq, "processor: %u model 0x%x\n", cpu, model);
> +
> +	for (i = 0; i < range; i++) {
> +		if (get_msr_range(&msr_min, &msr_max, i, flag, model))
> +			continue;
> +		for (msr = msr_min; msr < msr_max; msr++) {
> +			if (rdmsr_safe_on_cpu(cpu, msr, &low, &high))
> +				continue;
> +			if (seq)
> +				seq_printf(seq, " MSR_%08x: %08x_%08x\n",
> +					   msr, high, low);
> +			else
> +				printk(KERN_INFO " MSR_%08x: %08x_%08x\n",
> +				       msr, high, low);
> +		}
> +	}
> +}
> +
> +static void print_amd_msr(struct seq_file *seq, unsigned flag, unsigned model)
> +{
> +	int i, range;
> +	u64 val;
> +	unsigned msr, msr_min, msr_max;
> +
> +	range = get_msr_range_count(flag, model);
> +	seq_printf(seq, "processor: 0 model 0x%x\n", model);
> +
> +	for (i = 0; i < range; i++) {
> +		if (get_msr_range(&msr_min, &msr_max, i, flag, model))
> +			continue;
> +		for (msr = msr_min; msr < msr_max; msr++) {
> +			if (rdmsrl_amd_safe(msr, &val))
> +				continue;
> +			if (seq)
> +				seq_printf(seq, " MSR_%08x: %016llx\n",
> +					   msr, val);
> +			else
> +				printk(KERN_INFO " MSR_%08x: %016llx\n",
> +				       msr, val);
> +		}
> +	}
> +}
> +
> +static int msr_basic_show(struct seq_file *seq, void *v, unsigned flag)
> +{
> +	unsigned model;
> +	struct cpuinfo_x86 *c = v;
> +
> +#ifdef CONFIG_SMP
> +	/* We are only interested for core_id 0 */
> +	if (c->cpu_core_id)
> +		return 0;
> +#endif
> +	model = ((c->x86_vendor << 16) | (c->x86 << 8) | (c->x86_model));
> +	if ((c->x86_max_cores * smp_num_siblings > 1) &&
> +	    (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL))
> +		print_intel_msr(seq, c->phys_proc_id, flag, model);
> +	else
> +		print_amd_msr(seq, flag, model);
> +
> +
> +	seq_printf(seq, "\n");
> +
> +	return 0;
> +}
> +
> +static int msr_seq_show(struct seq_file *seq, void *v)
> +{
> +	return msr_basic_show(seq, v, MSR_ALL);
> +}
> +
> +static int pmc_seq_show(struct seq_file *seq, void *v)
> +{
> +	return msr_basic_show(seq, v, MSR_PMC);
> +}
> +
> +static void *msr_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct cpuinfo_x86 *c = NULL;
> +
> +	if (*pos == 0) /* just in case, cpu 0 is not the first */
> +		*pos = first_cpu(cpu_online_map);
> +	else
> +		*pos = next_cpu_nr(*pos - 1, cpu_online_map);
> +
> +	if ((*pos) < nr_cpu_ids)
> +		c = &cpu_data(*pos);
> +
> +	return c;
> +}
> +
> +static void *msr_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	(*pos)++;
> +
> +	return msr_seq_start(seq, pos);
> +}
> +
> +static void msr_seq_stop(struct seq_file *seq, void *v)
> +{
> +}
> +
> +static const struct seq_operations msr_seq_ops = {
> +	.start = msr_seq_start,
> +	.next  = msr_seq_next,
> +	.stop  = msr_seq_stop,
> +	.show  = msr_seq_show,
> +};
> +
> +static int msr_seq_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &msr_seq_ops);
> +}
> +
> +static const struct file_operations msr_fops = {
> +	.open    = msr_seq_open,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release,
> +};
> +
> +/* Performance monitioring MSRs */
> +static const struct seq_operations pmc_seq_ops = {
> +	.start = msr_seq_start,
> +	.next  = msr_seq_next,
> +	.stop  = msr_seq_stop,
> +	.show  = pmc_seq_show,
> +};
> +
> +static int pmc_seq_open(struct inode *inode, struct file *file)
> +{
> +	return seq_open(file, &pmc_seq_ops);
> +}
> +
> +static const struct file_operations pmc_fops = {
> +	.open    = pmc_seq_open,
> +	.read    = seq_read,
> +	.llseek  = seq_lseek,
> +	.release = seq_release,
> +};

Check how structure initializations are done in other places of 
the x86 tree - for example perf_counters.c. Apply that style 
here too please.

> +
> +static struct dentry *msr_file, *pmc_file, *msr_dir;
> +static int __init msr_debug_init(void)

missing newline after static variables.

> +{
> +	struct cpuinfo_x86 *cpu = &cpu_data(0);
> +
> +	if (!cpu_has(cpu, X86_FEATURE_MSR))
> +		return -ENODEV;
> +
> +	msr_dir = debugfs_create_dir("msr", arch_debugfs_dir);
> +
> +	msr_file = debugfs_create_file("msr", S_IRUGO, msr_dir,
> +					NULL, &msr_fops);
> +	pmc_file = debugfs_create_file("pmc", S_IRUGO, msr_dir,
> +					NULL, &pmc_fops);

I think it would be possible to have a much more intuitive file 
layout under /debug/x86/msr/ than these two /debug/x86/msr/msr 
and /debug/x86/msr/pmc files.

Firstly, it should move one level deeper, to /debug/x86/cpu/msr/ 
- because the MSR is really a property of the CPU, and there are 
other properties of the CPU we might want to expose in the 
future.

Secondly, the picking of debugfs (as opposed to sysfs) is a good 
choice, because we probably want to tweak the layout a number of 
times and want to keep flexibility, without being limited by the 
sysfs ABI.

So i like the idea - but we really want to do even more and add 
more structure to this. If we just want dumb msr enumeration we 
already have /dev/msr.

Regarding the msr directory: one good approach would be to have 
have several "topic" directories under /debug/x86/cpu/msr/.

One such topic would be the 'pmu', with a structure like:

 /debug/x86/cpu/msr/pmu/
 /debug/x86/cpu/msr/pmu/pmc_0/
 /debug/x86/cpu/msr/pmu/pmc_0/counter
 /debug/x86/cpu/msr/pmu/pmc_0/eventsel

There would also be a /debug/x86/cpu/msr/raw/ directory with all 
MSR numbers we know about explicitly, for example:

 /debug/x86/cpu/msr/raw/0x372/value
 /debug/x86/cpu/msr/raw/0x372/width

Maybe a symlink pointing it back to the topic directory would be 
useful as well. For example:

 /debug/x86/cpu/msr/raw/0x372/topic_dir -> /debug/x86/cpu/msr/pmu/pmc_0/

Other "topic directories" are possible too: a 
/debug/x86/cpu/msr/apic/ layout would be very useful and 
informative as well, and so are some of the other MSRs we tweak 
during bootup.

	Ingo
