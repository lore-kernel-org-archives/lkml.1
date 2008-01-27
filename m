Return-Path: <linux-kernel-owner+w=401wt.eu-S1756731AbYA0JXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbYA0JXu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 04:23:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbYA0JXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 04:23:36 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39179 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbYA0JXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 04:23:34 -0500
Date: Sun, 27 Jan 2008 10:23:44 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/3] x86: Macrofy resuable code
Message-ID: <20080127092344.GB18116@uranus.ravnborg.org>
References: <479C4A42.1020602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479C4A42.1020602@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 02:39:22PM +0530, Abhishek Sagar wrote:
> Encapsulate reusable code .
> 
> Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
> ---
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index a99e764..45f2949 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -74,6 +74,13 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  #define stack_addr(regs) ((unsigned long *)&regs->sp)
>  #endif
>  
> +#define kprobe_bkpt_addr(regs) \
> +	((unsigned long)(regs->ip - sizeof(kprobe_opcode_t)))
> +
> +#define is_jprobe_bkpt(ptr) \
> +	((ptr > (u8 *)jprobe_return) && (ptr < (u8 *)jprobe_return_end))
> +
> +
Small static functions are preferred over macros.
Any particular reason to use a macro here?

	Sam
