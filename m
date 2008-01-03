Return-Path: <linux-kernel-owner+w=401wt.eu-S1758352AbYACRg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbYACRg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbYACRgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:36:44 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:33014 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756339AbYACRgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:36:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAFarfEdMROHU/2dsb2JhbACBV6hf
Date: Thu, 3 Jan 2008 12:36:39 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 02/11] Add fastcall to do_IRQ for i386
Message-ID: <20080103173639.GB30582@Krystal>
References: <20080103071609.478486470@goodmis.org> <20080103072226.934978594@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103072226.934978594@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:35:48 up 60 days, 22:41,  5 users,  load average: 1.42, 1.55,
	0.82
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> MCOUNT will disable the regparm parameters of the i386 compile
> options. When doing so, this breaks the prototype of do_IRQ
> where the fastcall must be explicitly called.
> 
> Also fixed some whitespace damage in the call to do_IRQ.
> 

I would propose to try to see how we can #ifdef two different __mcount
assembly functions that would prepare the stack appropriately for each
REGPARM cases.

> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  arch/x86/kernel/irq_32.c |    2 +-
>  include/asm-x86/irq_32.h |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-compile.git/arch/x86/kernel/irq_32.c
> ===================================================================
> --- linux-compile.git.orig/arch/x86/kernel/irq_32.c	2007-12-20 00:20:29.000000000 -0500
> +++ linux-compile.git/arch/x86/kernel/irq_32.c	2007-12-20 00:21:55.000000000 -0500
> @@ -67,7 +67,7 @@ static union irq_ctx *softirq_ctx[NR_CPU
>   * handlers).
>   */
>  fastcall unsigned int do_IRQ(struct pt_regs *regs)
> -{	
> +{
>  	struct pt_regs *old_regs;
>  	/* high bit used in ret_from_ code */
>  	int irq = ~regs->orig_eax;
> Index: linux-compile.git/include/asm-x86/irq_32.h
> ===================================================================
> --- linux-compile.git.orig/include/asm-x86/irq_32.h	2007-12-20 00:20:29.000000000 -0500
> +++ linux-compile.git/include/asm-x86/irq_32.h	2007-12-20 00:21:55.000000000 -0500
> @@ -41,7 +41,7 @@ extern int irqbalance_disable(char *str)
>  extern void fixup_irqs(cpumask_t map);
>  #endif
>  
> -unsigned int do_IRQ(struct pt_regs *regs);
> +fastcall unsigned int do_IRQ(struct pt_regs *regs);
>  void init_IRQ(void);
>  void __init native_init_IRQ(void);
>  
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
