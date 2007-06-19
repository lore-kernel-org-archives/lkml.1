Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXFSMko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXFSMko (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758420AbXFSMk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:40:27 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:60527 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbXFSMkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:40:24 -0400
Date: Tue, 19 Jun 2007 05:40:17 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070619124017.GD23051@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070614215818.509851000@localhost> <20070615093331.040831000@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615093331.040831000@localhost>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

Patch applied.
Thanks.

On Fri, Jun 15, 2007 at 06:58:49PM +0200, Robert Richter wrote:
> Minor changes (whitespace, comments, ...)
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> @@ -32,23 +32,29 @@ static int force_nmi;
>  MODULE_PARM_DESC(force_nmi, "bool: force use of NMI for PMU interrupt");
>  module_param(force_nmi, bool, 0600);
>  
> -static struct pfm_arch_pmu_info pfm_k8_pmu_info={
> +static struct pfm_arch_pmu_info pfm_k8_pmu_info = {
>  	.pmc_addrs = {
> -		{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
> -		{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
> -		{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
> -		{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
> +/* pmc0  */	{{MSR_K7_EVNTSEL0, 0}, 0, PFM_REGT_EN},
> +/* pmc1  */	{{MSR_K7_EVNTSEL1, 0}, 1, PFM_REGT_EN},
> +/* pmc2  */	{{MSR_K7_EVNTSEL2, 0}, 2, PFM_REGT_EN},
> +/* pmc3  */	{{MSR_K7_EVNTSEL3, 0}, 3, PFM_REGT_EN},
>  	},
>  	.pmd_addrs = {
> -		{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
> -		{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
> -		{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
> -		{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
> +/* pmd0  */	{{MSR_K7_PERFCTR0, 0}, 0, PFM_REGT_CTR},
> +/* pmd1  */	{{MSR_K7_PERFCTR1, 0}, 0, PFM_REGT_CTR},
> +/* pmd2  */	{{MSR_K7_PERFCTR2, 0}, 0, PFM_REGT_CTR},
> +/* pmd3  */	{{MSR_K7_PERFCTR3, 0}, 0, PFM_REGT_CTR},
>  	},
>  	.pmu_style = PFM_X86_PMU_P6
>  };
>  
>  /*
> + * force Local APIC interrupt on overflow
> + */
> +#define PFM_K8_VAL	(1ULL<<20)
> +#define PFM_K8_NO64	(1ULL<<20)
> +
> +/*
>   * reserved bits must be zero
>   *
>   * - upper 32 bits are reserved
> @@ -59,12 +65,6 @@ static struct pfm_arch_pmu_info pfm_k8_p
>  			| (1ULL<<20)	\
>  			| (1ULL<<21))
>  
> -/*
> - * force Local APIC interrupt on overflow
> - */
> -#define PFM_K8_VAL	(1ULL<<20)
> -#define PFM_K8_NO64	(1ULL<<20)
> -
>  static struct pfm_reg_desc pfm_k8_pmc_desc[]={
>  /* pmc0  */ PMC_D(PFM_REG_I64, "PERFSEL0", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL0),
>  /* pmc1  */ PMC_D(PFM_REG_I64, "PERFSEL1", PFM_K8_VAL, PFM_K8_RSVD, PFM_K8_NO64, MSR_K7_EVNTSEL1),
> @@ -73,11 +73,11 @@ static struct pfm_reg_desc pfm_k8_pmc_de
>  };
>  #define PFM_AMD_NUM_PMCS ARRAY_SIZE(pfm_k8_pmc_desc)
>  
> -static struct pfm_reg_desc pfm_k8_pmd_desc[]={
> -/* pmd0  */ PMD_D(PFM_REG_C, "PERFCTR0", MSR_K7_PERFCTR0),
> -/* pmd1  */ PMD_D(PFM_REG_C, "PERFCTR1", MSR_K7_PERFCTR1),
> -/* pmd2  */ PMD_D(PFM_REG_C, "PERFCTR2", MSR_K7_PERFCTR2),
> -/* pmd3  */ PMD_D(PFM_REG_C, "PERFCTR3", MSR_K7_PERFCTR3),
> +static struct pfm_reg_desc pfm_k8_pmd_desc[] = {
> +/* pmd0  */ PMD_D(PFM_REG_C,   "PERFCTR0",	MSR_K7_PERFCTR0),
> +/* pmd1  */ PMD_D(PFM_REG_C,   "PERFCTR1",	MSR_K7_PERFCTR1),
> +/* pmd2  */ PMD_D(PFM_REG_C,   "PERFCTR2",	MSR_K7_PERFCTR2),
> +/* pmd3  */ PMD_D(PFM_REG_C,   "PERFCTR3",	MSR_K7_PERFCTR3),
>  };
>  #define PFM_AMD_NUM_PMDS ARRAY_SIZE(pfm_k8_pmd_desc)
>  
> Index: linux-2.6.22-rc3/include/asm-i386/perfmon.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/asm-i386/perfmon.h
> +++ linux-2.6.22-rc3/include/asm-i386/perfmon.h
> @@ -50,14 +50,14 @@
>  /*
>   * bitmask for reg_type
>   */
> -#define PFM_REGT_NA	 0x00 /* not available */
> -#define PFM_REGT_EN 	 0x01 /* has enable bit (cleared on ctxsw) */
> -#define PFM_REGT_ESCR    0x02 /* P4: ESCR */
> -#define PFM_REGT_CCCR    0x04 /* P4: CCCR */
> -#define PFM_REGT_OTH 	 0x80 /* other type of register */
> -#define PFM_REGT_PEBS	 0x10 /* PEBS related */
> -#define PFM_REGT_NOHT    0x20 /* unavailable with HT */
> -#define PFM_REGT_CTR     0x40 /* counter */
> +#define PFM_REGT_NA		0x0000	/* not available */
> +#define PFM_REGT_EN		0x0001	/* has enable bit (cleared on ctxsw) */
> +#define PFM_REGT_ESCR		0x0002	/* P4: ESCR */
> +#define PFM_REGT_CCCR		0x0004	/* P4: CCCR */
> +#define PFM_REGT_PEBS		0x0010	/* PEBS related */
> +#define PFM_REGT_NOHT		0x0020	/* unavailable with HT */
> +#define PFM_REGT_CTR		0x0040	/* counter */
> +#define PFM_REGT_OTH		0x0080	/* other type of register */
>  
>  /*
>   * This design and the partitioning of resources for SMT (hyper threads)
> Index: linux-2.6.22-rc3/include/linux/perfmon_pmu.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/linux/perfmon_pmu.h
> +++ linux-2.6.22-rc3/include/linux/perfmon_pmu.h
> @@ -69,7 +69,7 @@ struct pfm_reg_desc {
>  #define PFM_REG_C64	0x04  /* PMD: 64-bit virtualization */
>  #define PFM_REG_RO	0x08  /* PMD: read-only (writes ignored) */
>  #define PFM_REG_V	0x10  /* PMD: virtual reg (provided by PMU description) */
> -#define PFM_REG_NO64	0x100 /* PMC: supports REGFL_NOEMUL64 */
> +#define PFM_REG_NO64	0x100 /* PMC: supports PFM_REGFL_NO_EMUL64 */
>  
>  /*
>   * define some shortcuts for common types
> 
> --
> AMD Saxony, Dresden, Germany
> Operating System Research Center
> email: robert.richter@amd.com
> 
> 
> 

-- 

-Stephane
