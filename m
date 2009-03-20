Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZCTFnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZCTFnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 01:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZCTFnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 01:43:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:49897 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbZCTFnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 01:43:35 -0400
Subject: Re: [RFC][PATCH -tip 4/9] power: add kernel_trap_sp()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       systemtap-ml <systemtap@sources.redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <49C2B4BF.4080904@redhat.com>
References: <49C2B4BF.4080904@redhat.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 16:42:40 +1100
Message-Id: <1237527760.25062.567.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 17:10 -0400, Masami Hiramatsu wrote:
> Add kernel_trap_sp() on powerpc, based on systemtap's runtime/regs.h.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>

I haven't looked at the usage of it, but it's weird to have something
call "kernel_trap_sp" that returns the -user- stack pointer... is
this really what's expected here ?

> ---
>  arch/powerpc/include/asm/ptrace.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
> index c9c678f..0ac366c 100644
> --- a/arch/powerpc/include/asm/ptrace.h
> +++ b/arch/powerpc/include/asm/ptrace.h
> @@ -83,6 +83,7 @@ struct pt_regs {
> 
>  #define instruction_pointer(regs) ((regs)->nip)
>  #define user_stack_pointer(regs) ((regs)->gpr[1])
> +#define kernel_trap_sp(regs) (user_stack_pointer(regs))
>  #define regs_return_value(regs) ((regs)->gpr[3])
> 
>  #ifdef CONFIG_SMP

