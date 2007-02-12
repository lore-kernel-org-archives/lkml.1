Return-Path: <linux-kernel-owner+w=401wt.eu-S1030205AbXBLWKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbXBLWKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030206AbXBLWKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:10:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030205AbXBLWKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:10:51 -0500
Message-ID: <45D0E60F.2090506@redhat.com>
Date: Mon, 12 Feb 2007 17:11:27 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH x86 for review III] [17/29] x86: Add new CPUID bits for
 AMD Family 10 CPUs in /proc/cpuinfo
References: <20070212551.664370000@suse.de> <20070212165137.AD85913E1B@wotan.suse.de>
In-Reply-To: <20070212165137.AD85913E1B@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Just various new acronyms. The new popcnt bit is in the middle
> of Intel space. This looks a little weird, but I've been assured
> it's ok.
> 
> Also I fixed RDTSCP for i386 which was at the wrong place.
> 
> For i386 and x86-64.
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> ---
>  arch/i386/kernel/cpu/proc.c |   14 +++++++++-----
>  arch/x86_64/kernel/setup.c  |   14 ++++++++++----
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 
> Index: linux/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/setup.c
> +++ linux/arch/x86_64/kernel/setup.c
> @@ -942,7 +942,8 @@ static int show_cpuinfo(struct seq_file 
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, "nx", NULL, "mmxext", NULL,
> -		NULL, "fxsr_opt", NULL, "rdtscp", NULL, "lm", "3dnowext", "3dnow",
> +		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm",
> +		"3dnowext", "3dnow",
>  
>  		/* Transmeta-defined */
>  		"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
> @@ -960,7 +961,7 @@ static int show_cpuinfo(struct seq_file 
>  		/* Intel-defined (#2) */
>  		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
>  		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
> -		NULL, NULL, "dca", NULL, NULL, NULL, NULL, NULL,
> +		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* VIA/Cyrix/Centaur-defined */
> @@ -970,8 +971,10 @@ static int show_cpuinfo(struct seq_file 
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* AMD-defined (#2) */
> -		"lahf_lm", "cmp_legacy", "svm", NULL, "cr8_legacy", NULL, NULL, NULL,
> -		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> +		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8_legacy",
> +		"altmovcr8", "abm", "sse4a",
> +		"misalignsse", "3dnowprefetch",
> +		"osvw", "ibs", NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  	};
> @@ -982,6 +985,9 @@ static int show_cpuinfo(struct seq_file 
>  		"ttp",  /* thermal trip */
>  		"tm",
>  		"stc",
> +		"100mhzsteps",
> +		"hwpstate",
> +		NULL,	/* tsc invariant mapped to constant_tsc */
>  		NULL,
>  		/* nothing */	/* constant_tsc - moved to flags */
>  	};
> Index: linux/arch/i386/kernel/cpu/proc.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/cpu/proc.c
> +++ linux/arch/i386/kernel/cpu/proc.c
> @@ -29,7 +29,7 @@ static int show_cpuinfo(struct seq_file 
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, "syscall", NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, "mp", "nx", NULL, "mmxext", NULL,
> -		NULL, "fxsr_opt", "rdtscp", NULL, NULL, "lm", "3dnowext", "3dnow",
> +		NULL, "fxsr_opt", "pdpe1gb", "rdtscp", NULL, "lm", "3dnowext", "3dnow",
>  
>  		/* Transmeta-defined */
>  		"recovery", "longrun", NULL, "lrti", NULL, NULL, NULL, NULL,
> @@ -47,7 +47,7 @@ static int show_cpuinfo(struct seq_file 
>  		/* Intel-defined (#2) */
>  		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
>  		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
> -		NULL, NULL, "dca", NULL, NULL, NULL, NULL, NULL,
> +		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* VIA/Cyrix/Centaur-defined */
> @@ -57,8 +57,9 @@ static int show_cpuinfo(struct seq_file 
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* AMD-defined (#2) */
> -		"lahf_lm", "cmp_legacy", "svm", NULL, "cr8legacy", NULL, NULL, NULL,
> -		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> +		"lahf_lm", "cmp_legacy", "svm", "extapic", "cr8legacy", "abm",
> +		"sse4a", "misalignsse",
> +		"3dnowprefetch", "osvw", "ibs", NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  	};
> @@ -69,8 +70,11 @@ static int show_cpuinfo(struct seq_file 
>  		"ttp",  /* thermal trip */
>  		"tm",
>  		"stc",
> +		"100mhzsteps",
> +		"hwpstate",
>  		NULL,
> -		/* nothing */	/* constant_tsc - moved to flags */
> +		NULL,	/* constant_tsc - moved to flags */
> +		/* nothing */
>  	};
>  	struct cpuinfo_x86 *c = v;
>  	int i, n = c - cpu_data;
> -

Since we seem to have become the place where all these are collected,
shouldn't we document what they mean? I've got some this machine that
I'd like to know more about:

dts ss ds_cpl est tm2 ssse3 xtpr


