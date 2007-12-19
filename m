Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXLSFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXLSFrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXLSFrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:47:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbXLSFrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:47:04 -0500
Message-ID: <4768AF6F.3050603@redhat.com>
Date: Wed, 19 Dec 2007 00:43:11 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: __kprobes annotations
References: <1197930464.23402.112.camel@brick>	 <20071218112936.GE9002@elte.hu> <1197978160.7734.31.camel@brick>	 <4767D02C.6030704@redhat.com> <1198042025.10357.4.camel@brick>
In-Reply-To: <1198042025.10357.4.camel@brick>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> __always_inline on some static functions was to ensure they ended
> up in the .kprobes.text section. Mark this explicitly.

It is good to me.
Thanks!

> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  arch/x86/kernel/kprobes.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index c7a26be..521a469 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -159,7 +159,7 @@ struct kretprobe_blackpoint kretprobe_blacklist[] = {
>  const int kretprobe_blacklist_size = ARRAY_SIZE(kretprobe_blacklist);
>  
>  /* Insert a jump instruction at address 'from', which jumps to address 'to'.*/
> -static void set_jmp_op(void *from, void *to)
> +static void __kprobes set_jmp_op(void *from, void *to)
>  {
>  	struct __arch_jmp_op {
>  		char op;
> @@ -174,7 +174,7 @@ static void set_jmp_op(void *from, void *to)
>   * Returns non-zero if opcode is boostable.
>   * RIP relative instructions are adjusted at copying time in 64 bits mode
>   */
> -static int can_boost(kprobe_opcode_t *opcodes)
> +static int __kprobes can_boost(kprobe_opcode_t *opcodes)
>  {
>  	kprobe_opcode_t opcode;
>  	kprobe_opcode_t *orig_opcodes = opcodes;
> @@ -392,13 +392,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
>  		kcb->kprobe_saved_flags &= ~X86_EFLAGS_IF;
>  }
>  
> -static void clear_btf(void)
> +static void __kprobes clear_btf(void)
>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
>  }
>  
> -static void restore_btf(void)
> +static void __kprobes restore_btf(void)
>  {
>  	if (test_thread_flag(TIF_DEBUGCTLMSR))
>  		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com, masami.hiramatsu.pt@hitachi.com

