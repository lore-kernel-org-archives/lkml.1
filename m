Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYANRRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYANRRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 12:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbYANRRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 12:17:23 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45951 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750894AbYANRRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 12:17:22 -0500
Message-ID: <478B991F.8060809@sgi.com>
Date: Mon, 14 Jan 2008 09:17:19 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] x86: Change NR_CPUS arrays in numa_64
References: <20080113183453.973425000@sgi.com> <20080113183455.077460000@sgi.com> <20080114111428.GA24237@elte.hu>
In-Reply-To: <20080114111428.GA24237@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * travis@sgi.com <travis@sgi.com> wrote:
> 
>> Change the following static arrays sized by NR_CPUS to
>> per_cpu data variables:
>>
>> 	char cpu_to_node_map[NR_CPUS];
> 
> x86.git randconfig testing found the !NUMA build bugs below.
> 
> 	Ingo

Thanks!  I'll add this in.

Mike

> 
> --------------->
> ---
>  arch/x86/kernel/setup_64.c   |    2 ++
>  arch/x86/kernel/smpboot_64.c |    4 ++++
>  2 files changed, 6 insertions(+)
> 
> Index: linux/arch/x86/kernel/setup_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/setup_64.c
> +++ linux/arch/x86/kernel/setup_64.c
> @@ -379,7 +379,9 @@ void __init setup_arch(char **cmdline_p)
>  #ifdef CONFIG_SMP
>  	/* setup to use the early static init tables during kernel startup */
>  	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
> +#ifdef CONFIG_NUMA
>  	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
> +#endif
>  	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
>  #endif
>  
> Index: linux/arch/x86/kernel/smpboot_64.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/smpboot_64.c
> +++ linux/arch/x86/kernel/smpboot_64.c
> @@ -864,8 +864,10 @@ void __init smp_set_apicids(void)
>  		if (per_cpu_offset(cpu)) {
>  			per_cpu(x86_cpu_to_apicid, cpu) =
>  						x86_cpu_to_apicid_init[cpu];
> +#ifdef CONFIG_NUMA
>  			per_cpu(x86_cpu_to_node_map, cpu) =
>  						x86_cpu_to_node_map_init[cpu];
> +#endif
>  			per_cpu(x86_bios_cpu_apicid, cpu) =
>  						x86_bios_cpu_apicid_init[cpu];
>  		}
> @@ -876,7 +878,9 @@ void __init smp_set_apicids(void)
>  
>  	/* indicate the early static arrays are gone */
>  	x86_cpu_to_apicid_early_ptr = NULL;
> +#ifdef CONFIG_NUMA
>  	x86_cpu_to_node_map_early_ptr = NULL;
> +#endif
>  	x86_bios_cpu_apicid_early_ptr = NULL;
>  }
>  

