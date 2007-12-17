Return-Path: <linux-kernel-owner+w=401wt.eu-S1764416AbXLQPRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764416AbXLQPRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763675AbXLQPQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:16:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754087AbXLQPQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:16:56 -0500
Message-ID: <476692C0.7020802@redhat.com>
Date: Mon, 17 Dec 2007 10:16:16 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: Unify cosmetic kprobes{32|64}.c
References: <1197674207.898.72.camel@brick>
In-Reply-To: <1197674207.898.72.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harvey,

Harvey Harrison wrote:
> diff --git a/arch/x86/kernel/kprobes_32.c b/arch/x86/kernel/kprobes_32.c
> index f4ba584..2a8acd6 100644
> --- a/arch/x86/kernel/kprobes_32.c
> +++ b/arch/x86/kernel/kprobes_32.c
> @@ -234,7 +234,7 @@ static int __kprobes is_IF_modifier(kprobe_opcode_t opcode)
>  
>  int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  {
> -	/* insn: must be on special executable page on i386. */
> +	/* insn: must be on special executable page on x86_32|64. */
>  	p->ainsn.insn = get_insn_slot();
>  	if (!p->ainsn.insn)
>  		return -ENOMEM;
> @@ -373,13 +373,21 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
>  static __always_inline void clear_btf(void)
>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
> +#ifdef CONFIG_X86_32
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
> +#else
> +		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
> +#endif
>  }
>  
>  static __always_inline void restore_btf(void)
>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
> +#ifdef CONFIG_X86_32
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
> +#else
> +		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
> +#endif
>  }

I think you can use wrmsr() on X86_64 too.
So, we can merge it to wrmsr().


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

