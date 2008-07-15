Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYGOOLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYGOOLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbYGOOK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:10:58 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33400 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752559AbYGOOK4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:10:56 -0400
X-Greylist: delayed 1141 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 10:10:56 EDT
Message-Id: <1216129914.20462.1263591561@webmail.messagingengine.com>
X-Sasl-Enc: U+7HxGNX1IahlookcQZrbDNAaG0E6Fpv0ccVGf1zWYVq 1216129914
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jaswinder Singh" <jaswinder@infradead.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "kernelnewbies" <kernelnewbies@nl.linux.org>,
       "kernel-janitors" <kernel-janitors@vger.kernel.org>,
       "David Woodhouse" <dwmw2@infradead.org>, "Ingo Molnar" <mingo@elte.hu>
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <1216119158.21749.5.camel@jaswinder.satnam>
Subject: Re: [PATCH] x86: traps and do_traps under one hood
In-Reply-To: <1216119158.21749.5.camel@jaswinder.satnam>
Date: Tue, 15 Jul 2008 15:51:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 16:22:38 +0530, "Jaswinder Singh"
<jaswinder@infradead.org> said:
> 
> Declaring x86 traps under one hood.
> Declaring x86 do_traps before defining them.
> 
> Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
> ---
>  arch/x86/kernel/traps_32.c                |   20 ---------
>  arch/x86/kernel/traps_64.c                |   21 ----------
>  include/asm-x86/mach-default/mach_traps.h |   62 +++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 41 deletions(-)

Hi Jaswinder,

I think moving the declarations to a header file is a good thing,
but I don't think mach_traps.h is a suitable place. The definitions
of the functions are in entry_32.S and entry_64.S, so I would suggest
making a new header include/asm-x86/entry.h. Some other ENTRY's
(like system_call and some xen-specific ones) would then also fit
in this header.

What do you think?

Greetings,
    Alexander

> diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
> index 8a76897..9107ef7 100644
> --- a/arch/x86/kernel/traps_32.c
> +++ b/arch/x86/kernel/traps_32.c
> @@ -77,26 +77,6 @@ char ignore_fpu_irq;
>  gate_desc idt_table[256]
>  	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
>  
> -asmlinkage void divide_error(void);
> -asmlinkage void debug(void);
> -asmlinkage void nmi(void);
> -asmlinkage void int3(void);
> -asmlinkage void overflow(void);
> -asmlinkage void bounds(void);
> -asmlinkage void invalid_op(void);
> -asmlinkage void device_not_available(void);
> -asmlinkage void coprocessor_segment_overrun(void);
> -asmlinkage void invalid_TSS(void);
> -asmlinkage void segment_not_present(void);
> -asmlinkage void stack_segment(void);
> -asmlinkage void general_protection(void);
> -asmlinkage void page_fault(void);
> -asmlinkage void coprocessor_error(void);
> -asmlinkage void simd_coprocessor_error(void);
> -asmlinkage void alignment_check(void);
> -asmlinkage void spurious_interrupt_bug(void);
> -asmlinkage void machine_check(void);
> -
>  int panic_on_unrecovered_nmi;
>  int kstack_depth_to_print = 24;
>  static unsigned int code_bytes = 64;
> diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
> index 2696a68..56c413c 100644
> --- a/arch/x86/kernel/traps_64.c
> +++ b/arch/x86/kernel/traps_64.c
> @@ -54,27 +54,6 @@
>  
>  #include <mach_traps.h>
>  
> -asmlinkage void divide_error(void);
> -asmlinkage void debug(void);
> -asmlinkage void nmi(void);
> -asmlinkage void int3(void);
> -asmlinkage void overflow(void);
> -asmlinkage void bounds(void);
> -asmlinkage void invalid_op(void);
> -asmlinkage void device_not_available(void);
> -asmlinkage void double_fault(void);
> -asmlinkage void coprocessor_segment_overrun(void);
> -asmlinkage void invalid_TSS(void);
> -asmlinkage void segment_not_present(void);
> -asmlinkage void stack_segment(void);
> -asmlinkage void general_protection(void);
> -asmlinkage void page_fault(void);
> -asmlinkage void coprocessor_error(void);
> -asmlinkage void simd_coprocessor_error(void);
> -asmlinkage void alignment_check(void);
> -asmlinkage void spurious_interrupt_bug(void);
> -asmlinkage void machine_check(void);
> -
>  int panic_on_unrecovered_nmi;
>  int kstack_depth_to_print = 12;
>  static unsigned int code_bytes = 64;
> diff --git a/include/asm-x86/mach-default/mach_traps.h
> b/include/asm-x86/mach-default/mach_traps.h
> index 2fe7705..e803b1d 100644
> --- a/include/asm-x86/mach-default/mach_traps.h
> +++ b/include/asm-x86/mach-default/mach_traps.h
> @@ -36,4 +36,66 @@ static inline void reassert_nmi(void)
>  		unlock_cmos();
>  }
>  
> +/* traps */
> +
> +/* Common in X86_32 and X86_64 */
> +asmlinkage void divide_error(void);
> +asmlinkage void debug(void);
> +asmlinkage void nmi(void);
> +asmlinkage void int3(void);
> +asmlinkage void overflow(void);
> +asmlinkage void bounds(void);
> +asmlinkage void invalid_op(void);
> +asmlinkage void device_not_available(void);
> +asmlinkage void coprocessor_segment_overrun(void);
> +asmlinkage void invalid_TSS(void);
> +asmlinkage void segment_not_present(void);
> +asmlinkage void stack_segment(void);
> +asmlinkage void general_protection(void);
> +asmlinkage void page_fault(void);
> +asmlinkage void coprocessor_error(void);
> +asmlinkage void simd_coprocessor_error(void);
> +asmlinkage void alignment_check(void);
> +asmlinkage void spurious_interrupt_bug(void);
> +asmlinkage void machine_check(void);
> +
> +void do_divide_error(struct pt_regs *, long);
> +void do_overflow(struct pt_regs *, long);
> +void do_bounds(struct pt_regs *, long);
> +void do_coprocessor_segment_overrun(struct pt_regs *, long);
> +void do_invalid_TSS(struct pt_regs *, long);
> +void do_segment_not_present(struct pt_regs *, long);
> +void do_stack_segment(struct pt_regs *, long);
> +void do_alignment_check(struct pt_regs *, long);
> +void do_invalid_op(struct pt_regs *, long);
> +void do_general_protection(struct pt_regs *, long);
> +void do_nmi(struct pt_regs *, long);
> +
> +extern int panic_on_unrecovered_nmi;
> +extern int kstack_depth_to_print;
> +
> +#ifdef CONFIG_X86_32
> +
> +void do_iret_error(struct pt_regs *, long);
> +void do_int3(struct pt_regs *, long);
> +void do_debug(struct pt_regs *, long);
> +void math_error(void __user *);
> +void do_coprocessor_error(struct pt_regs *, long);
> +void do_simd_coprocessor_error(struct pt_regs *, long);
> +void do_spurious_interrupt_bug(struct pt_regs *, long);
> +unsigned long patch_espfix_desc(unsigned long, unsigned long);
> +asmlinkage void math_emulate(long);
> +
> +#else /* CONFIG_X86_32 */
> +
> +asmlinkage void double_fault(void);
> +
> +asmlinkage void do_int3(struct pt_regs *, long);
> +asmlinkage void do_stack_segment(struct pt_regs *, long);
> +asmlinkage void do_debug(struct pt_regs *, unsigned long);
> +asmlinkage void do_coprocessor_error(struct pt_regs *);
> +asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
> +asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
> +
> +#endif /* CONFIG_X86_32 */
>  #endif /* !_MACH_TRAPS_H */
> -- 
> 1.5.5.1
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Same, same, but different…

