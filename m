Return-Path: <linux-kernel-owner+w=401wt.eu-S937230AbZDJR1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937230AbZDJR1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765648AbZDJR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:27:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51225 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZDJR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:27:22 -0400
Date: Fri, 10 Apr 2009 19:29:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [git-pull -tip] x86: declaration patches
Message-ID: <20090410172925.GA24446@uranus.ravnborg.org>
References: <1239381184.23116.5.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239381184.23116.5.camel@ht.satnam>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaswinder.

> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 7309c0a..2f35e81 100644
> --- a/arch/x86/include/asm/hw_irq.h
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -81,6 +81,11 @@ extern void eisa_set_level_irq(unsigned int irq);
>  /* SMP */
>  extern void smp_apic_timer_interrupt(struct pt_regs *);
>  extern void smp_spurious_interrupt(struct pt_regs *);
> +#ifdef CONFIG_X86_32
> +extern void smp_generic_interrupt(struct pt_regs *);
> +#else
> +extern asmlinkage void smp_generic_interrupt(struct pt_regs *);
> +#endif
>  extern void smp_error_interrupt(struct pt_regs *);
>  #ifdef CONFIG_SMP
>  extern void smp_reschedule_interrupt(struct pt_regs *);
> @@ -93,6 +98,15 @@ extern asmlinkage void smp_invalidate_interrupt(struct pt_regs *);
>  #endif
>  #endif
>  
> +#ifdef CONFIG_X86_IO_APIC
> +#ifdef CONFIG_X86_32
> +extern void smp_irq_move_cleanup_interrupt(void);
> +#else
> +extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
> +#endif
> +#endif

The above is a lot ifdefs just to:
1) use asmlinkage only on 64 bit
2) hide the prototype if do not implement the function

Is there any relevant cost associated with asmlinkage or could we just make it
always asmlinkage?

> +#ifdef CONFIG_X86_64
> +asmlinkage
> +#endif
> +void smp_irq_move_cleanup_interrupt(void)
>  {
>  	unsigned vector, me;
> 


 
>  /*
>   * Handler for GENERIC_INTERRUPT_VECTOR.
>   */
> +#ifdef CONFIG_X86_64
> +asmlinkage
> +#endif
>  void smp_generic_interrupt(struct pt_regs *regs)
>  {

Another one.


	Sam
