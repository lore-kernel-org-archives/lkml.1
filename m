Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbXFSMjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbXFSMjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbXFSMjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:39:24 -0400
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:33314 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152AbXFSMjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:39:23 -0400
Date: Tue, 19 Jun 2007 05:39:15 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
Message-ID: <20070619123915.GB23051@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070614215818.509851000@localhost> <20070615093330.845322000@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615093330.845322000@localhost>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

I applied this patch to my tree.
Thanks.

On Fri, Jun 15, 2007 at 06:57:30PM +0200, Robert Richter wrote:
> This patch implements Barcelona CPU detection.
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> 
> Index: linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/i386/perfmon/perfmon.c
> +++ linux-2.6.22-rc3/arch/i386/perfmon/perfmon.c
> @@ -1059,6 +1059,7 @@ char *pfm_arch_get_pmu_module_name(void)
>  			goto try_arch;
>  		}
>  	case 15:
> +	case 16:
>  		/* All Opteron processors */
>  		if (cpu_data->x86_vendor == X86_VENDOR_AMD)
>  			return "perfmon_k8";
> Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> @@ -307,7 +307,12 @@ static int pfm_k8_probe_pmu(void)
>  		return -1;
>  	}
>  
> -	if (current_cpu_data.x86 != 15) {
> +	switch (current_cpu_data.x86) {
> +	case 15:
> +	case 16:
> +		PFM_INFO("found family=%d", current_cpu_data.x86);
> +		break;
> +	default:
>  		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
>  		return -1;
>  	}
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
