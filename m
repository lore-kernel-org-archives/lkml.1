Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbZBQUxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbZBQUxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 15:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbZBQUwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 15:52:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:57251 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbZBQUwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 15:52:53 -0500
Message-ID: <499B2349.1050006@kernel.org>
Date: Tue, 17 Feb 2009 12:51:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] x86, apic: move APIC drivers to	arch/x86/kernel/apic/*
References: <tip-f62bae5009c1ba596cd475cafbc83e0570a36e26@kernel.org> <499AFDAF.2060705@kernel.org> <20090217181839.GA26541@elte.hu> <20090217184110.GA331@elte.hu>
In-Reply-To: <20090217184110.GA331@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it seems you forgot to push it out.

YH

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> could move probe_32.c es7000_32.c numaq_32.c summit_32.c to 
>>> apic/ too
>> yeah, that's indeed the plan, just didnt get around testing that 
>> yet.
> 
> Below is the commit. Beyond what you listed, i moved bigsmp_32.c 
> too. By renaming apic_64.c to probe_64.c we get the probing code 
> mostly consolidated as well.
> 
> 	Ingo
> 
> ---------------->
>>From 2a05180fe2e5b414f0cb2ccfc80e6c90563e3c67 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Tue, 17 Feb 2009 20:35:16 +0100
> Subject: [PATCH] x86, apic: move remaining APIC drivers to arch/x86/kernel/apic/*
> 
> Move the 32-bit extended-arch APIC drivers to arch/x86/kernel/apic/
> too, and rename apic_64.c to probe_64.c.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/Makefile                       |    6 +-----
>  arch/x86/kernel/apic/Makefile                  |    9 +++++++--
>  arch/x86/kernel/{ => apic}/bigsmp_32.c         |    0
>  arch/x86/kernel/{ => apic}/es7000_32.c         |    0
>  arch/x86/kernel/{ => apic}/numaq_32.c          |    0
>  arch/x86/kernel/{ => apic}/probe_32.c          |    0
>  arch/x86/kernel/apic/{apic_64.c => probe_64.c} |    0
>  arch/x86/kernel/{ => apic}/summit_32.c         |    0
>  8 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
> index 9139ff6..c70537d 100644
> --- a/arch/x86/kernel/Makefile
> +++ b/arch/x86/kernel/Makefile
> @@ -30,7 +30,7 @@ obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
>  obj-y			+= time_$(BITS).o ioport.o ldt.o dumpstack.o
>  obj-y			+= setup.o i8259.o irqinit_$(BITS).o
>  obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
> -obj-$(CONFIG_X86_32)	+= probe_32.o probe_roms_32.o
> +obj-$(CONFIG_X86_32)	+= probe_roms_32.o
>  obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
>  obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
>  obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
> @@ -70,10 +70,6 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= ftrace.o
>  obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>  obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
>  obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
> -obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
> -obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
> -obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
> -obj-$(CONFIG_X86_SUMMIT)	+= summit_32.o
>  obj-y				+= vsmp_64.o
>  obj-$(CONFIG_KPROBES)		+= kprobes.o
>  obj-$(CONFIG_MODULES)		+= module_$(BITS).o
> diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
> index da20b70..97f558d 100644
> --- a/arch/x86/kernel/apic/Makefile
> +++ b/arch/x86/kernel/apic/Makefile
> @@ -2,14 +2,19 @@
>  # Makefile for local APIC drivers and for the IO-APIC code
>  #
>  
> -obj-y				:= apic.o ipi.o nmi.o
> +obj-y				:= apic.o probe_$(BITS).o ipi.o nmi.o
>  obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
>  obj-$(CONFIG_SMP)		+= ipi.o
> +obj-$
>  
>  ifeq ($(CONFIG_X86_64),y)
> -obj-y				+= apic_64.o apic_flat_64.o
> +obj-y				+= apic_flat_64.o
>  obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
>  obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
>  obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
>  endif
>  
> +obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
> +obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
> +obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
> +obj-$(CONFIG_X86_SUMMIT)	+= summit_32.o
> diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
> similarity index 100%
> rename from arch/x86/kernel/bigsmp_32.c
> rename to arch/x86/kernel/apic/bigsmp_32.c
> diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
> similarity index 100%
> rename from arch/x86/kernel/es7000_32.c
> rename to arch/x86/kernel/apic/es7000_32.c
> diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
> similarity index 100%
> rename from arch/x86/kernel/numaq_32.c
> rename to arch/x86/kernel/apic/numaq_32.c
> diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/apic/probe_32.c
> similarity index 100%
> rename from arch/x86/kernel/probe_32.c
> rename to arch/x86/kernel/apic/probe_32.c
> diff --git a/arch/x86/kernel/apic/apic_64.c b/arch/x86/kernel/apic/probe_64.c
> similarity index 100%
> rename from arch/x86/kernel/apic/apic_64.c
> rename to arch/x86/kernel/apic/probe_64.c
> diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/apic/summit_32.c
> similarity index 100%
> rename from arch/x86/kernel/summit_32.c
> rename to arch/x86/kernel/apic/summit_32.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tip-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

