Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYLPUYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYLPUYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:24:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYLPUUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:20:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56965 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758997AbYLPUUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:20:08 -0500
Date: Tue, 16 Dec 2008 21:19:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] x86: traps.c declare functions before they get used
Message-ID: <20081216201956.GA14505@elte.hu>
References: <1229360145.15326.5.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229360145.15326.5.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> 
> In asm/traps.h :-
> do_double_fault : added under X86_64
> sync_regs : added under X86_64
> math_error : moved out from X86_32 as it is common for both 32 and 64 bit
> smp_thermal_interrupt : added under X86_64
> mce_threshold_interrupt : added under X86_64
> math_emulate : moved from X86_32 to MATH_EMULATION
> ---
>  arch/x86/include/asm/traps.h |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
> index 45dee28..d8a201b 100644
> --- a/arch/x86/include/asm/traps.h
> +++ b/arch/x86/include/asm/traps.h
> @@ -46,6 +46,10 @@ dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
>  dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
>  dotraplinkage void do_segment_not_present(struct pt_regs *, long);
>  dotraplinkage void do_stack_segment(struct pt_regs *, long);
> +#ifdef CONFIG_X86_64
> +dotraplinkage void do_double_fault(struct pt_regs *, long);
> +asmlinkage __kprobes struct pt_regs *sync_regs(struct pt_regs *);
> +#endif
>  dotraplinkage void do_general_protection(struct pt_regs *, long);
>  dotraplinkage void do_page_fault(struct pt_regs *, unsigned long);
>  dotraplinkage void do_spurious_interrupt_bug(struct pt_regs *, long);
> @@ -72,9 +76,14 @@ static inline int get_si_code(unsigned long condition)
>  extern int panic_on_unrecovered_nmi;
>  extern int kstack_depth_to_print;
>  
> -#ifdef CONFIG_X86_32
>  void math_error(void __user *);
> +#ifdef CONFIG_X86_32
>  unsigned long patch_espfix_desc(unsigned long, unsigned long);
> +#else
> +asmlinkage void smp_thermal_interrupt(void);
> +asmlinkage void mce_threshold_interrupt(void);
> +#endif
> +#ifndef CONFIG_MATH_EMULATION
>  asmlinkage void math_emulate(long);
>  #endif

uhm, shouldnt that #ifndef CONFIG_MATH_EMULATION be #ifdef 
CONFIG_MATH_EMULATION?

	Ingo
