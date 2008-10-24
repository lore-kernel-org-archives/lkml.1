Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYJXLxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYJXLxu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 07:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYJXLxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 07:53:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40537 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXLxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 07:53:42 -0400
Date: Fri, 24 Oct 2008 07:53:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>, Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH] trace: add the MMIO-tracer to the tracer menu
In-Reply-To: <1224845357.4075.0.camel@twins>
Message-ID: <alpine.DEB.1.10.0810240752410.25677@gandalf.stny.rr.com>
References: <1224845357.4075.0.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Oct 2008, Peter Zijlstra wrote:

> Subject: trace: add the MMIO-tracer to the tracer menu
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Fri Oct 24 12:46:04 CEST 2008
> 
> Add the MMIO-tracer to the tracer menu.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: Pekka Paalanen <pq@iki.fi>
> ---
>  arch/x86/Kconfig.debug |   28 ++--------------------------
>  kernel/trace/Kconfig   |   28 ++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+), 26 deletions(-)
> 
> Index: linux-2.6/arch/x86/Kconfig.debug
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig.debug
> +++ linux-2.6/arch/x86/Kconfig.debug
> @@ -175,32 +175,8 @@ config IOMMU_LEAK
>  	  Add a simple leak tracer to the IOMMU code. This is useful when you
>  	  are debugging a buggy device driver that leaks IOMMU mappings.
>  
> -config MMIOTRACE_HOOKS
> -	bool
> -
> -config MMIOTRACE
> -	bool "Memory mapped IO tracing"
> -	depends on DEBUG_KERNEL && PCI
> -	select TRACING
> -	select MMIOTRACE_HOOKS
> -	help
> -	  Mmiotrace traces Memory Mapped I/O access and is meant for
> -	  debugging and reverse engineering. It is called from the ioremap
> -	  implementation and works via page faults. Tracing is disabled by
> -	  default and can be enabled at run-time.
> -
> -	  See Documentation/tracers/mmiotrace.txt.
> -	  If you are not helping to develop drivers, say N.
> -
> -config MMIOTRACE_TEST
> -	tristate "Test module for mmiotrace"
> -	depends on MMIOTRACE && m
> -	help
> -	  This is a dumb module for testing mmiotrace. It is very dangerous
> -	  as it will write garbage to IO memory starting at a given address.
> -	  However, it should be safe to use on e.g. unused portion of VRAM.
> -
> -	  Say N, unless you absolutely know what you are doing.
> +config HAVE_MMIOTRACE_SUPPORT
> +	def_bool y
>  
>  #
>  # IO delay types:
> Index: linux-2.6/kernel/trace/Kconfig
> ===================================================================
> --- linux-2.6.orig/kernel/trace/Kconfig
> +++ linux-2.6/kernel/trace/Kconfig
> @@ -194,4 +194,32 @@ config FTRACE_STARTUP_TEST
>  	  functioning properly. It will do tests on all the configured
>  	  tracers of ftrace.
>  
> +config MMIOTRACE_HOOKS
> +	bool
> +
> +config MMIOTRACE
> +	bool "Memory mapped IO tracing"
> +	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
> +	select TRACING

Since this was taken from the x86 Kconfig, do we need to add a
"depends X86" ?

-- Steve

> +	select MMIOTRACE_HOOKS
> +	help
> +	  Mmiotrace traces Memory Mapped I/O access and is meant for
> +	  debugging and reverse engineering. It is called from the ioremap
> +	  implementation and works via page faults. Tracing is disabled by
> +	  default and can be enabled at run-time.
> +
> +	  See Documentation/tracers/mmiotrace.txt.
> +	  If you are not helping to develop drivers, say N.
> +
> +config MMIOTRACE_TEST
> +	tristate "Test module for mmiotrace"
> +	depends on MMIOTRACE && m
> +	help
> +	  This is a dumb module for testing mmiotrace. It is very dangerous
> +	  as it will write garbage to IO memory starting at a given address.
> +	  However, it should be safe to use on e.g. unused portion of VRAM.
> +
> +	  Say N, unless you absolutely know what you are doing.
> +
> +
>  endmenu
> 
> 
> 
