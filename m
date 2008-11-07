Return-Path: <linux-kernel-owner+w=401wt.eu-S1753210AbYKGWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbYKGWQj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 17:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbYKGWQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 17:16:30 -0500
Received: from mx2.redhat.com ([66.187.237.31]:36297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbYKGWQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 17:16:28 -0500
Message-ID: <4914BD77.2080005@redhat.com>
Date: Fri, 07 Nov 2008 17:13:11 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] change CONFIG_NUMA description
References: <20081105022553.7CB2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081106085301.GB4890@elte.hu>
In-Reply-To: <20081106085301.GB4890@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
>> CONFIG_NUMA description talk about a bit old thing.
>> So, following changes are better.
>>
>> o CONFIG_NUMA is no longer EXPERIMENTAL o Opteron is not the only 
>> processor of NUMA topology on x86_64 no longer, but also Intel 
>> Core7i has it.
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  arch/x86/Kconfig |    7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> applied to tip/x86/doc, thanks! I've updated a few other details as 
> well, see the final commit below.
> 
> 	Ingo
> 
> ------------->
> From fd51b2d7d5df932767b89e00d0871a38a2c53e74 Mon Sep 17 00:00:00 2001
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Date: Wed, 5 Nov 2008 02:27:19 +0900
> Subject: [PATCH] x86: update CONFIG_NUMA description
> 
> Impact: clarify/update CONFIG_NUMA text
> 
> CONFIG_NUMA description talk about a bit old thing.
> So, following changes are better.
> 
>  o CONFIG_NUMA is no longer EXPERIMENTAL
> 
>  o Opteron is not the only processor of NUMA topology on x86_64 no longer,
>    but also Intel Core7i has it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 350bee1..38ae04b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -951,22 +951,26 @@ config ARCH_PHYS_ADDR_T_64BIT
>  
>  # Common NUMA Features
>  config NUMA
> -	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
> +	bool "Numa Memory Allocation and Scheduler Support"
>  	depends on SMP
>  	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
>  	default n if X86_PC
>  	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
>  	help
>  	  Enable NUMA (Non Uniform Memory Access) support.
> +
>  	  The kernel will try to allocate memory used by a CPU on the
>  	  local memory controller of the CPU and add some more
>  	  NUMA awareness to the kernel.
>  
> -	  For 32-bit this is currently highly experimental and should be only
> -	  used for kernel development. It might also cause boot failures.
> -	  For 64-bit this is recommended on all multiprocessor Opteron systems.
> -	  If the system is EM64T, you should say N unless your system is
> -	  EM64T NUMA.
> +	  For 64-bit this is recommended if the system is Intel Core 7i
> +	  (or later), AMD Opteron, or EM64T NUMA.
> +
> +	  For 32-bit this is only needed on (rare) 32-bit-only platforms
> +	  that support NUMA topologies, such as NUMAQ / Summit, or if you
> +	  boot a 32-bit kernel on a 64-bit NUMA platform.
> +
> +	  Otherwise, you should say N.
>  
>  comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
>  	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)

Core i7, not Core 7i.

-- Chris
