Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbYGPOax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbYGPOax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 10:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYGPOap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 10:30:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39582 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYGPOao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 10:30:44 -0400
Date: Wed, 16 Jul 2008 17:30:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] Add module.h include to stacktrace.c.
Message-ID: <20080716143033.GD25557@cs181140183.pp.htv.fi>
References: <20080711103925.GA20589@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080711103925.GA20589@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Why was this patch ignored?

The build failures now made it into Linus' tree.

Stephen already fixed the powerpc one.
s390 is still broken.
And I just ran into this compile error on sh...

cu
Adrian


On Fri, Jul 11, 2008 at 12:39:25PM +0200, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Fixes this:
> 
>   CC      arch/s390/kernel/stacktrace.o
> arch/s390/kernel/stacktrace.c:84: warning: data definition has no type or storage class
> arch/s390/kernel/stacktrace.c:84: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> arch/s390/kernel/stacktrace.c:84: warning: parameter names (without types) in function declaration
> arch/s390/kernel/stacktrace.c:97: warning: data definition has no type or storage class
> arch/s390/kernel/stacktrace.c:97: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
> arch/s390/kernel/stacktrace.c:97: warning: parameter names (without types) in function declaration
> 
> caused by "stacktrace: export save_stack_trace[_tsk]"
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
> Ingo, the patch which causes this came in via one of your trees.
> Please merge/apply. Thanks.
> 
>  arch/avr32/kernel/stacktrace.c   |    1 +
>  arch/mips/kernel/stacktrace.c    |    1 +
>  arch/powerpc/kernel/stacktrace.c |    1 +
>  arch/s390/kernel/stacktrace.c    |    1 +
>  arch/sh/kernel/stacktrace.c      |    1 +
>  5 files changed, 5 insertions(+)
> 
> Index: linux-next/arch/s390/kernel/stacktrace.c
> ===================================================================
> --- linux-next.orig/arch/s390/kernel/stacktrace.c
> +++ linux-next/arch/s390/kernel/stacktrace.c
> @@ -10,6 +10,7 @@
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
>  #include <linux/kallsyms.h>
> +#include <linux/module.h>
>  
>  static unsigned long save_context_stack(struct stack_trace *trace,
>  					unsigned long sp,
> Index: linux-next/arch/avr32/kernel/stacktrace.c
> ===================================================================
> --- linux-next.orig/arch/avr32/kernel/stacktrace.c
> +++ linux-next/arch/avr32/kernel/stacktrace.c
> @@ -10,6 +10,7 @@
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
>  #include <linux/thread_info.h>
> +#include <linux/module.h>
>  
>  register unsigned long current_frame_pointer asm("r7");
>  
> Index: linux-next/arch/mips/kernel/stacktrace.c
> ===================================================================
> --- linux-next.orig/arch/mips/kernel/stacktrace.c
> +++ linux-next/arch/mips/kernel/stacktrace.c
> @@ -7,6 +7,7 @@
>   */
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
> +#include <linux/module.h
>  #include <asm/stacktrace.h>
>  
>  /*
> Index: linux-next/arch/powerpc/kernel/stacktrace.c
> ===================================================================
> --- linux-next.orig/arch/powerpc/kernel/stacktrace.c
> +++ linux-next/arch/powerpc/kernel/stacktrace.c
> @@ -12,6 +12,7 @@
>  
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
> +#include <linux/module.h>
>  #include <asm/ptrace.h>
>  
>  /*
> Index: linux-next/arch/sh/kernel/stacktrace.c
> ===================================================================
> --- linux-next.orig/arch/sh/kernel/stacktrace.c
> +++ linux-next/arch/sh/kernel/stacktrace.c
> @@ -12,6 +12,7 @@
>  #include <linux/sched.h>
>  #include <linux/stacktrace.h>
>  #include <linux/thread_info.h>
> +#include <linux/module.h>
>  #include <asm/ptrace.h>
>  
>  /*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

