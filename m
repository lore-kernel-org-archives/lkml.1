Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbXFSNfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbXFSNfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 09:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXFSNe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 09:34:57 -0400
Received: from ccerelbas02.cce.hp.com ([161.114.21.105]:58436 "EHLO
	ccerelbas02.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbXFSNe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 09:34:56 -0400
Date: Tue, 19 Jun 2007 06:34:47 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070619133447.GE23051@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070614215818.509851000@localhost> <20070615093331.168842000@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615093331.168842000@localhost>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

This patch is not specific to perfmon. It modifies the general
infrastructure. As such it could be submitted indepdently.

I will include it in my "infrastructure" patch file for now.

On Fri, Jun 15, 2007 at 06:59:28PM +0200, Robert Richter wrote:
> This patch rearranges AMD64 MSR definitions.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
> +++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
> @@ -75,6 +75,18 @@
>  
>  /* K7/K8 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
> +
> +/* K8 MSRs */
> +#define MSR_K8_TOP_MEM1			0xC001001A
> +#define MSR_K8_TOP_MEM2			0xC001001D
> +#define MSR_K8_SYSCFG			0xC0010010
> +#define MSR_K8_HWCR			0xC0010015
> +#define MSR_K8_ENABLE_C1E		0xc0010055
> +#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
> +#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
> +#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
> +
> +/* K7 MSRs */
>  #define MSR_K7_EVNTSEL0			0xc0010000
>  #define MSR_K7_PERFCTR0			0xc0010004
>  #define MSR_K7_EVNTSEL1			0xc0010001
> @@ -83,20 +95,10 @@
>  #define MSR_K7_PERFCTR2			0xc0010006
>  #define MSR_K7_EVNTSEL3			0xc0010003
>  #define MSR_K7_PERFCTR3			0xc0010007
> -#define MSR_K8_TOP_MEM1			0xc001001a
>  #define MSR_K7_CLK_CTL			0xc001001b
> -#define MSR_K8_TOP_MEM2			0xc001001d
> -#define MSR_K8_SYSCFG			0xc0010010
> -
> -#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
> -#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
> -#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */
> -
>  #define MSR_K7_HWCR			0xc0010015
> -#define MSR_K8_HWCR			0xc0010015
>  #define MSR_K7_FID_VID_CTL		0xc0010041
>  #define MSR_K7_FID_VID_STATUS		0xc0010042
> -#define MSR_K8_ENABLE_C1E		0xc0010055
>  
>  /* K6 MSRs */
>  #define MSR_K6_EFER			0xc0000080
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
