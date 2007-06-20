Return-Path: <linux-kernel-owner+w=401wt.eu-S1753901AbXFTUnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbXFTUnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 16:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbXFTUnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 16:43:32 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:47822 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbXFTUnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 16:43:31 -0400
Date: Wed, 20 Jun 2007 13:43:24 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Robert Richter <robert.richter@amd.com>
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 6/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070620204324.GC26200@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070620182126.248753000@amd.com> <20070620184148.GG5874@erda.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620184148.GG5874@erda.amd.com>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

I am not sure why you need to define virtual PMD registers?
Any PMD can be included in samples asa long as they are specified
in pfarg_pmd_t.smpl_pmds[].


On Wed, Jun 20, 2007 at 08:41:49PM +0200, Robert Richter wrote:
> Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
>  static struct pfm_reg_desc pfm_k8_pmc_desc[]={
>  /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
>  /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
>  /* pmc2  */ PMC_D(PFM_REG_I64, "PERFSEL2", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL2),
>  /* pmc3  */ PMC_D(PFM_REG_I64, "PERFSEL3", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL3),
> +/* pmc4  */ PMC_D(PFM_REG_I, "IBSFETCHCTL", PFM_AMD64_IBSFETCHCTL_VAL, PFM_AMD64_IBSFETCHCTL_RSVD, PFM_AMD64_IBSFETCHCTL_NO64, MSR_AMD64_IBSFETCHCTL),
> +/* pmc5  */ PMC_D(PFM_REG_I, "IBSOPCTL", PFM_AMD64_IBSOPCTL_VAL, PFM_AMD64_IBSOPCTL_RSVD, PFM_AMD64_IBSOPCTL_NO64, MSR_AMD64_IBSOPCTL),
>  };
>  #define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
>  
> @@ -78,6 +111,18 @@ static struct pfm_reg_desc pfm_k8_pmd_de
>  /* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
>  /* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
>  /* pmd3  */ PMD_D(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3),
> +/* pmd4  */ PMD_D(PFM_REG_ICV, "IBSFETCHCTR",	PFM_VPMD_AMD64_IBSFETCHCTR),
> +/* pmd5  */ PMD_D(PFM_REG_IRO, "IBSFETCHCTL",	MSR_AMD64_IBSFETCHCTL),
> +/* pmd6  */ PMD_D(PFM_REG_IRO, "IBSFETCHLINAD",	MSR_AMD64_IBSFETCHLINAD),
> +/* pmd7  */ PMD_D(PFM_REG_IRO, "IBSFETCHPHYSAD", MSR_AMD64_IBSFETCHPHYSAD),
> +/* pmd8  */ PMD_D(PFM_REG_ICV, "IBSOPCTR",	PFM_VPMD_AMD64_IBSOPCTR),
> +/* pmd9  */ PMD_D(PFM_REG_IRO, "IBSOPCTL",	MSR_AMD64_IBSOPCTL),
> +/* pmd10 */ PMD_D(PFM_REG_IRO, "IBSOPRIP",	MSR_AMD64_IBSOPRIP),
> +/* pmd11 */ PMD_D(PFM_REG_IRO, "IBSOPDATA",	MSR_AMD64_IBSOPDATA),
> +/* pmd12 */ PMD_D(PFM_REG_IRO, "IBSOPDATA2",	MSR_AMD64_IBSOPDATA2),
> +/* pmd13 */ PMD_D(PFM_REG_IRO, "IBSOPDATA3",	MSR_AMD64_IBSOPDATA3),
> +/* pmd14 */ PMD_D(PFM_REG_IRO, "IBSDCLINAD",	MSR_AMD64_IBSDCLINAD),
> +/* pmd15 */ PMD_D(PFM_REG_IRO, "IBSDCPHYSAD",	MSR_AMD64_IBSDCPHYSAD),
>  };
>  #define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
>  
> @@ -284,6 +329,9 @@ static int pfm_k8_detect_nmi(void)
>  	 * auto-detect which perfctr/eventsel is used by NMI watchdog
>  	 */
>  	for (i=0; i < PFM_AMD_NUM_PMDS; i++) {
> +		/* skip IBS registers */
> +		if (pfm_k8_pmu_info.pmc_addrs[i].reg_type & PFM_REGT_IBS)
> +			continue;
>  		if (avail_to_resrv_perfctr_nmi(pfm_k8_pmd_desc[i].hw_addr))
>  			continue;
>  
> @@ -332,10 +380,75 @@ static int pfm_k8_probe_pmu(void)
>  		pfm_k8_setup_nb_event_control();
>  
>  	PFM_INFO("Using AMD64 PMU");
> +	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS)
> +		PFM_INFO("IBS is supported by processor");
> +	if (pfm_k8_pmu_info.flags & PFM_X86_FL_IBS_EXT)
> +		PFM_INFO("IBS extended registers are supported by processor");
>  
>  	return 0;
>  }
>  
> +static inline void
> +pfm_amd64_check_register(struct pfm_pmu_config *cfg,
> +			 struct pfm_reg_desc *reg,
> +			 struct pfm_arch_ext_reg *ext_reg)
> +{
> +	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
> +
> +	if (!(ext_reg->reg_type & PFM_REGT_AMD64))
> +		/* No special AMD64 PMU register */
> +		return;
> +
> +	/* Disable register */
> +	reg->type &= ~PFM_REG_I;
> +
> +	switch (ext_reg->reg_type & PFM_REGT_AMD64) {
> +	case (PFM_REGT_IBS):
> +		/* IBS register */
> +		if (!(arch_info->flags & PFM_X86_FL_IBS))
> +			return;
> +		break;
> +	case (PFM_REGT_IBS|PFM_REGT_IBS_EXT):
> +		/* IBS extended register */
> +		if (!(arch_info->flags & PFM_X86_FL_IBS_EXT))
> +			return;
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	/* Enable register */
> +	reg->type |= PFM_REG_I;
> +}
> +
> +static void pfm_amd64_setup_pmu(struct pfm_pmu_config *cfg)
> +{
> +	u16 i;
> +	struct pfm_arch_pmu_info *arch_info = cfg->arch_info;
> +
> +	/* set PMU features depending on CPUID */
> +	arch_info->flags &= ~(PFM_X86_FL_IBS|PFM_X86_FL_IBS_EXT);
> +	switch (current_cpu_data.x86) {
> +	case 15:
> +		break;
> +	case 16:
> +		arch_info->flags |= PFM_X86_FL_IBS;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	/* Disable unsupported PMC/PMD registers */
> +	for (i = 0; i < cfg->num_pmc_entries;  i++) {
> +		pfm_amd64_check_register(cfg, &cfg->pmc_desc[i],
> +					 &arch_info->pmc_addrs[i]);
> +	}
> +	for (i = 0; i < cfg->num_pmd_entries;  i++) {
> +		pfm_amd64_check_register(cfg, &cfg->pmd_desc[i],
> +					 &arch_info->pmd_addrs[i]);
> +	}
> +}
> +
>  static struct pfm_pmu_config pfm_k8_pmu_conf = {
>  	.pmu_name = "AMD64",
>  	.counter_width = 47,
> @@ -344,14 +457,17 @@ static struct pfm_pmu_config pfm_k8_pmu_
>  	.num_pmc_entries = PFM_AMD_NUM_PMCS,
>  	.num_pmd_entries = PFM_AMD_NUM_PMDS,
>  	.probe_pmu = pfm_k8_probe_pmu,
> -	.version = "1.1",
> +	.version = "1.2",
>  	.arch_info = &pfm_k8_pmu_info,
>  	.flags = PFM_PMU_BUILTIN_FLAG,
> -	.owner = THIS_MODULE
> +	.owner = THIS_MODULE,
> +	.pmd_sread = pfm_pmd_sread,
> +	.pmd_swrite = pfm_pmd_swrite,
>  };
>  	
>  static int __init pfm_k8_pmu_init_module(void)
>  {
> +	pfm_amd64_setup_pmu(&pfm_k8_pmu_conf);
>  	return pfm_pmu_register(&pfm_k8_pmu_conf);
>  }
>  
> Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
> +++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
> @@ -76,6 +76,18 @@
>  /* AMD64 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
>  
> +#define MSR_AMD64_IBSFETCHCTL		0xc0011030
> +#define MSR_AMD64_IBSFETCHLINAD		0xc0011031
> +#define MSR_AMD64_IBSFETCHPHYSAD	0xc0011032
> +#define MSR_AMD64_IBSOPCTL		0xc0011033
> +#define MSR_AMD64_IBSOPRIP		0xc0011034
> +#define MSR_AMD64_IBSOPDATA		0xc0011035
> +#define MSR_AMD64_IBSOPDATA2		0xc0011036
> +#define MSR_AMD64_IBSOPDATA3		0xc0011037
> +#define MSR_AMD64_IBSDCLINAD		0xc0011038
> +#define MSR_AMD64_IBSDCPHYSAD		0xc0011039
> +#define MSR_AMD64_IBSCTL		0xc001103a
> +
>  /* K8 MSRs */
>  #define MSR_K8_TOP_MEM1			0xc001001a
>  #define MSR_K8_TOP_MEM2			0xc001001d
> Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
> +++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
> @@ -2,6 +2,9 @@
>   * Copyright (c) 2005-2006 Hewlett-Packard Development Company, L.P.
>   * Contributed by Stephane Eranian <eranian@hpl.hp.com>
>   *
> + * Copyright (c) 2007 Advanced Micro Devices, Inc.
> + * Contributed by Robert Richter <robert.richter@amd.com>
> + *
>   * This file contains X86 Processor Family specific definitions
>   * for the perfmon interface. This covers P6, Pentium M, P4/Xeon
>   * (32-bit and 64-bit, i.e., EM64T) and AMD X86-64.
> @@ -29,6 +32,7 @@
>  
>  #include <asm/desc.h>
>  #include <asm/apic.h>
> +#include <linux/threads.h> /* NR_CPUS */
>  
>  #ifdef CONFIG_4KSTACKS
>  #define PFM_ARCH_PMD_STK_ARG	2
> @@ -48,6 +52,15 @@
>  #define PFM_ESCR_RSVD  ~0x000000007ffffffcULL
>  
>  /*
> + * For AMD64
> + */
> +/* Familiy 10h */
> +#define PFM_AMD64_IBSFETCHEN	(1ULL<<48)
> +#define PFM_AMD64_IBSFETCHVAL	(1ULL<<49)
> +#define PFM_AMD64_IBSOPEN	(1ULL<<17)
> +#define PFM_AMD64_IBSOPVAL	(1ULL<<18)
> +
> +/*
>   * bitmask for reg_type
>   */
>  #define PFM_REGT_NA		0x0000	/* not available */
> @@ -58,6 +71,17 @@
>  #define PFM_REGT_NOHT		0x0020	/* unavailable with HT */
>  #define PFM_REGT_CTR		0x0040	/* counter */
>  #define PFM_REGT_OTH		0x0080	/* other type of register */
> +#define PFM_REGT_IBS		0x0100	/* IBS register set */
> +#define PFM_REGT_IBS_EXT	0x0200	/* IBS extended register set */
> +
> +/* AMD64 PMU features */
> +#define PFM_REGT_AMD64		(PFM_REGT_IBS|PFM_REGT_IBS_EXT)
> +
> +/* We count IBS events in virtual PMDs to use implemented sampling
> + * features */
> +#define PFM_VPMD_AMD64_IBSFETCHCTR	0
> +#define PFM_VPMD_AMD64_IBSOPCTR		1
> +#define PFM_NUM_VPMDS			2
>  
>  /*
>   * This design and the partitioning of resources for SMT (hyper threads)
> @@ -93,6 +117,11 @@ struct pfm_arch_pmu_info {
>  	u16 pebs_ctr_idx;  /* index of PEBS IQ_CTR4 counter  (for overflow) */
>  	u16 reserved;	   /* for future use */
>  	u8  pmu_style;	   /* type of PMU interface (P4, P6) */
> +	u64 vpmds[NR_CPUS][PFM_NUM_VPMDS];	/* virt. sw PMDs per cpu */
> +	u16 ibsfetchctl_idx;    /* IBS: index of IBS fetch control register */
> +	u16 ibsfetchctr_idx;    /* IBS: index of IBS fetch counter (virtual) */
> +	u16 ibsopctl_idx;       /* IBS: index of IBS execution control register */
> +	u16 ibsopctr_idx;       /* IBS: index of IBS execution counter (virtual) */
>  };
>  
>  /*
> @@ -109,6 +138,12 @@ struct pfm_arch_pmu_info {
>  #define PFM_X86_FL_PMU_DS	0x01	/* Intel: support for Data Save Area (DS) */
>  #define PFM_X86_FL_PMU_PEBS	0x02	/* Intel: support PEBS (implies DS) */
>  #define PFM_X86_FL_USE_NMI	0x04	/* must use NMI interrupt */
> +#define PFM_X86_FL_IBS		0x08	/* AMD64: support for IBS */
> +#define PFM_X86_FL_IBS_EXT	0x10	/* AMD64: support for IBS extended registers */
> +
> +/* Virtual PMDs access functions */
> +u64 pfm_pmd_sread(struct pfm_context *ctx, unsigned int cnum);
> +void pfm_pmd_swrite(struct pfm_context *ctx, unsigned int cnum, u64 val);
>  
>  void __pfm_read_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 *val);
>  void __pfm_write_reg_p4(const struct pfm_arch_ext_reg *xreg, u64 val);
> @@ -340,6 +375,9 @@ static inline int pfm_arch_context_initi
>  static inline void pfm_arch_ovfl_reset_pmd(struct pfm_context *ctx, unsigned int cnum)
>  {
>  	u64 val;
> +	if (unlikely(pfm_pmu_conf->pmd_desc[cnum].type & PFM_REG_V))
> +		/* skip virtual counters */
> +		return;
>  	val = pfm_arch_read_pmd(ctx, cnum);
>  	pfm_arch_write_pmd(ctx, cnum, val);
>  }
> Index: linux-2.6.22-rc3/include/linux/perfmon_pmu.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/linux/perfmon_pmu.h
> +++ linux-2.6.22-rc3/include/linux/perfmon_pmu.h
> @@ -2,6 +2,9 @@
>   * Copyright (c) 2006 Hewlett-Packard Development Company, L.P.
>   * Contributed by Stephane Eranian <eranian@hpl.hp.com>
>   *
> + * Copyright (c) 2007 Advanced Micro Devices, Inc.
> + * Contributed by Robert Richter <robert.richter@amd.com>
> + *
>   * Interface for PMU description modules
>   *
>   * This program is free software; you can redistribute it and/or
> @@ -78,6 +81,8 @@ struct pfm_reg_desc {
>  #define PFM_REG_W64	(PFM_REG_WC|PFM_REG_NO64|PFM_REG_I)
>  #define PFM_REG_C	(PFM_REG_C64|PFM_REG_I)
>  #define PFM_REG_I64	(PFM_REG_NO64|PFM_REG_I)
> +#define PFM_REG_IRO	(PFM_REG_RO|PFM_REG_I)
> +#define PFM_REG_ICV	(PFM_REG_C64|PFM_REG_I|PFM_REG_V) /* virtual (sw) counter */
>  
>  typedef int (*pfm_pmc_check_t)(struct pfm_context *ctx,
>  			       struct pfm_event_set *set,
> Index: linux-2.6.22-rc3/perfmon/perfmon_intr.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/perfmon/perfmon_intr.c
> +++ linux-2.6.22-rc3/perfmon/perfmon_intr.c
> @@ -18,6 +18,9 @@
>   * Contributed by Stephane Eranian <eranian@hpl.hp.com>
>   *                David Mosberger-Tang <davidm@hpl.hp.com>
>   *
> + * Copyright (c) 2007 Advanced Micro Devices, Inc.
> + * Contributed by Robert Richter <robert.richter@amd.com>
> + *
>   * More information about perfmon available at:
>   * 	http://perfmon2.sf.net
>   *
> @@ -163,7 +166,19 @@ static void pfm_overflow_handler(struct 
>  		 */
>  		old_val = new_val = pmds[i];
>  		ovfl_thres = set->pmds[i].ovflsw_thres;
> -		new_val += 1 + ovfl_mask;
> +		if (likely(!(pfm_pmu_conf->pmd_desc[i].type & PFM_REG_V)))
> +			new_val += 1 + ovfl_mask;
> +		else {
> +			/* No hardware counter */
> +			/*
> +			 * Since the previous value is unknown, 64 bit
> +			 * overflows can only detected for zero
> +			 * values. Thus, increments of more than 1
> +			 * will not be detected.
> +			 */
> +			if (! new_val)
> +				old_val = ~0;
> +		}
>  		pmds[i] = new_val;
>  
>  		/*
> 
> -- 
> AMD Saxony, Dresden, Germany
> Operating System Research Center
> email: robert.richter@amd.com
> 
> 

-- 

-Stephane
