Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab0BKCTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:19:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0BKCTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:19:31 -0500
Message-ID: <4B73691A.8080100@redhat.com>
Date: Wed, 10 Feb 2010 21:19:06 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] s390: add pt_regs register and stack access API
References: <20100210162610.GC6933@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100210162610.GC6933@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> This API is needed for the kprobe-based event tracer.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/Kconfig              |    1 
>  arch/s390/include/asm/ptrace.h |   14 +++++++
>  arch/s390/kernel/ptrace.c      |   76 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 90 insertions(+), 1 deletion(-)
> 
> --- a/arch/s390/include/asm/ptrace.h
> +++ b/arch/s390/include/asm/ptrace.h
> @@ -492,13 +492,25 @@ struct user_regs_struct
>  struct task_struct;
>  extern void user_enable_single_step(struct task_struct *);
>  extern void user_disable_single_step(struct task_struct *);
> +extern void show_regs(struct pt_regs * regs);
>  
>  #define user_mode(regs) (((regs)->psw.mask & PSW_MASK_PSTATE) != 0)
>  #define instruction_pointer(regs) ((regs)->psw.addr & PSW_ADDR_INSN)
>  #define user_stack_pointer(regs)((regs)->gprs[15])
>  #define regs_return_value(regs)((regs)->gprs[2])
>  #define profile_pc(regs) instruction_pointer(regs)
> -extern void show_regs(struct pt_regs * regs);
> +
> +int regs_query_register_offset(const char *name);
> +const char *regs_query_register_name(unsigned int offset);
> +unsigned long regs_get_argument_nth(struct pt_regs *regs, unsigned int n);

Hmm, the latest kprobe-tracer on -tip/master doesn't support
regs_get_argument_nth() anymore, because the function ABI
strongly depends on each function interface, compile option
etc. So I removed it (14640106f243a3b29944d7198569090fa6546f2d
and aa5add93e92019018e905146f8c3d3f8e3c08300).

Yeah, those patches are still on -tip tree. Since I'm working on
-tip/master for kprobe-tracer etc., please work on -tip tree.

Thank you!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

