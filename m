Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCUDvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCUDvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 23:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbZCUDvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 23:51:07 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33980 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZCUDvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 23:51:05 -0400
Subject: Re: [PATCH 2/3] powerpc: Remove -fno-omit-frame-pointer workarounds
From: Steven Rostedt <srostedt@redhat.com>
To: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090320164431.GB28037@oksana.dev.rtsoft.ru>
References: <20090320164404.GA19933@oksana.dev.rtsoft.ru>
	 <20090320164431.GB28037@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 20 Mar 2009 23:50:06 -0400
Message-Id: <1237607406.17367.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ben,

Can you ACK or take this patch too.

Thanks,

-- Steve


On Fri, 2009-03-20 at 19:44 +0300, Anton Vorontsov wrote:
> The workarounds aren't needed any longer since the top level Makefile
> doesn't pass -fno-omit-frame-pointer cflag for PowerPC.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  arch/powerpc/Makefile                    |    5 -----
>  arch/powerpc/kernel/Makefile             |   12 ++++++------
>  arch/powerpc/platforms/powermac/Makefile |    2 +-
>  lib/Kconfig.debug                        |    6 +++---
>  4 files changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
> index 551fc58..1dd7748 100644
> --- a/arch/powerpc/Makefile
> +++ b/arch/powerpc/Makefile
> @@ -120,11 +120,6 @@ ifeq ($(CONFIG_6xx),y)
>  KBUILD_CFLAGS		+= -mcpu=powerpc
>  endif
>  
> -# Work around a gcc code-gen bug with -fno-omit-frame-pointer.
> -ifeq ($(CONFIG_FUNCTION_TRACER),y)
> -KBUILD_CFLAGS		+= -mno-sched-epilog
> -endif
> -
>  cpu-as-$(CONFIG_4xx)		+= -Wa,-m405
>  cpu-as-$(CONFIG_6xx)		+= -Wa,-maltivec
>  cpu-as-$(CONFIG_POWER4)		+= -Wa,-maltivec
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index dfec3d2..f86caeb 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -14,14 +14,14 @@ endif
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace early boot code
> -CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
> -CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_cputable.o = -pg
> +CFLAGS_REMOVE_prom_init.o = -pg
> +CFLAGS_REMOVE_btext.o = -pg
> +CFLAGS_REMOVE_prom.o = -pg
>  # do not trace tracer code
> -CFLAGS_REMOVE_ftrace.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_ftrace.o = -pg
>  # timers used by tracing
> -CFLAGS_REMOVE_time.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_time.o = -pg
>  endif
>  
>  obj-y				:= cputable.o ptrace.o syscalls.o \
> diff --git a/arch/powerpc/platforms/powermac/Makefile b/arch/powerpc/platforms/powermac/Makefile
> index 50f1693..0eb8781 100644
> --- a/arch/powerpc/platforms/powermac/Makefile
> +++ b/arch/powerpc/platforms/powermac/Makefile
> @@ -2,7 +2,7 @@ CFLAGS_bootx_init.o  		+= -fPIC
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  # Do not trace early boot code
> -CFLAGS_REMOVE_bootx_init.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_bootx_init.o = -pg
>  endif
>  
>  obj-y				+= pic.o setup.o time.o feature.o pci.o \
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index fc8cd1f..713620d 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -493,7 +493,7 @@ config LOCKDEP
>  	bool
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select STACKTRACE
> -	select FRAME_POINTER if !MIPS && !PPC && !ARM_UNWIND
> +	select FRAME_POINTER if !MIPS && !ARM_UNWIND
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  
> @@ -866,13 +866,13 @@ config FAULT_INJECTION_STACKTRACE_FILTER
>  	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
>  	depends on !X86_64
>  	select STACKTRACE
> -	select FRAME_POINTER if !PPC
> +	select FRAME_POINTER
>  	help
>  	  Provide stacktrace filter for fault-injection capabilities
>  
>  config LATENCYTOP
>  	bool "Latency measuring infrastructure"
> -	select FRAME_POINTER if !MIPS && !PPC
> +	select FRAME_POINTER if !MIPS
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  	select STACKTRACE

