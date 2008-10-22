Return-Path: <linux-kernel-owner+w=401wt.eu-S1755113AbYJVKf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbYJVKf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 06:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbYJVKfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 06:35:14 -0400
Received: from ns.suse.de ([195.135.220.2]:41422 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJVKfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 06:35:13 -0400
Date: Wed, 22 Oct 2008 12:35:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] x86: enable GBPAGES option by default
Message-ID: <20081022103512.GA1928@wotan.suse.de>
References: <20081022103316.GB27862@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022103316.GB27862@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, messed up Andi's email...

On Wed, Oct 22, 2008 at 12:33:16PM +0200, Nick Piggin wrote:
> DIRECT_GBPAGES was under DEBUG_KERNEL && EXPERIMENTAL and disabled by default.
> Turn it on by default and put it under EMBEDDED.
> 
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -946,6 +946,15 @@ config X86_PAE
>  config ARCH_PHYS_ADDR_T_64BIT
>         def_bool X86_64 || X86_PAE
>  
> +config DIRECT_GBPAGES
> +	bool "Enable 1GB pages for kernel pagetables" if EMBEDDED
> +	default y
> +	depends on X86_64
> +	help
> +	  Allow the kernel linear mapping to use 1GB pages on CPUs that
> +	  support it. This can improve the kernel's performance a tiny bit by
> +	  reducing TLB pressure. If in doubt, say "Y".
> +
>  # Common NUMA Features
>  config NUMA
>  	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
> Index: linux-2.6/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig.debug
> +++ linux-2.6/arch/x86/Kconfig.debug
> @@ -114,18 +114,6 @@ config DEBUG_RODATA
>  	  data. This is recommended so that we can catch kernel bugs sooner.
>  	  If in doubt, say "Y".
>  
> -config DIRECT_GBPAGES
> -	bool "Enable gbpages-mapped kernel pagetables"
> -	depends on DEBUG_KERNEL && EXPERIMENTAL && X86_64
> -	help
> -	  Enable gigabyte pages support (if the CPU supports it). This can
> -	  improve the kernel's performance a tiny bit by reducing TLB
> -	  pressure.
> -
> -	  This is experimental code.
> -
> -	  If in doubt, say "N".
> -
>  config DEBUG_RODATA_TEST
>  	bool "Testcase for the DEBUG_RODATA feature"
>  	depends on DEBUG_RODATA
