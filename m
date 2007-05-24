Return-Path: <linux-kernel-owner+w=401wt.eu-S1754517AbXEXWDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbXEXWDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXEXWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:03:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbXEXWDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:03:08 -0400
Date: Thu, 24 May 2007 15:02:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, Len Brown <len.brown@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Display Intel Dynamic Acceleration feature in
 /proc/cpuinfo
Message-Id: <20070524150223.41063046.akpm@linux-foundation.org>
In-Reply-To: <20070523224637.GB15887@linux-os.sc.intel.com>
References: <20070523224637.GB15887@linux-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 15:46:37 -0700
Venki Pallipadi <venkatesh.pallipadi@intel.com> wrote:

> Display Intel Dynamic Acceleration feature in /proc/cpuinfo. This feature
> will be enabled automatically by current acpi-cpufreq driver and cpufreq.
> 
> Refer to Intel Software Developer's Manual for more details about the feature.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> Index: linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
> ===================================================================
> --- linux-2.6.22-rc-mm.orig/arch/i386/kernel/cpu/proc.c
> +++ linux-2.6.22-rc-mm/arch/i386/kernel/cpu/proc.c
> @@ -41,7 +41,7 @@ static int show_cpuinfo(struct seq_file 
>  		"cxmmx", "k6_mtrr", "cyrix_arr", "centaur_mcr",
>  		NULL, NULL, NULL, NULL,
>  		"constant_tsc", "up", NULL, NULL, NULL, NULL, NULL, NULL,
> -		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> +		"ida", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  
>  		/* Intel-defined (#2) */
> Index: linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
> ===================================================================
> --- linux-2.6.22-rc-mm.orig/arch/x86_64/kernel/setup.c
> +++ linux-2.6.22-rc-mm/arch/x86_64/kernel/setup.c
> @@ -949,7 +949,7 @@ static int show_cpuinfo(struct seq_file 
>  		/* Other (Linux-defined) */
>  		"cxmmx", NULL, "cyrix_arr", "centaur_mcr", NULL,
>  		"constant_tsc", NULL, NULL,
> -		"up", NULL, NULL, NULL, NULL, NULL, NULL, NULL,
> +		"up", NULL, NULL, NULL, "ida", NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
>  		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,

Ho hum.  This clashes with hpa's git-newsetup tree, which goes for a great
tromp through the cpuinfo implementation.

Hunk #1 FAILED at 41.
1 out of 1 hunk FAILED -- saving rejects to file arch/i386/kernel/cpu/proc.c.rej
patching file arch/x86_64/kernel/setup.c
Hunk #1 FAILED at 951.
1 out of 1 hunk FAILED -- saving rejects to file arch/x86_64/kernel/setup.c.rej
patching file include/asm-i386/cpufeature.h
Hunk #1 FAILED at 81.
1 out of 1 hunk FAILED -- saving rejects to file include/asm-i386/cpufeature.h.rej
patching file include/asm-x86_64/cpufeature.h
Hunk #1 FAILED at 70.
1 out of 1 hunk FAILED -- saving rejects to file include/asm-x86_64/cpufeature.h.rej

I'm not sure I can be bothered repairing all that at present.  I think I'll
go and hide until it becomes somebody else's problem.

<looks at hpa's tree>

@@ -23,13 +23,14 @@ static int show_cpuinfo(struct seq_file 
                "fpu", "vme", "de", "pse", "tsc", "msr", "pae", "mce",
                "cx8", "apic", NULL, "sep", "mtrr", "pge", "mca", "cmov",
                "pat", "pse36", "pn", "clflush", NULL, "dts", "acpi", "mmx",
-               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", "pbe",
+               "fxsr", "sse", "sse2", "ss", "ht", "tm", "ia64", NULL,

<wonders where pbe went to>


