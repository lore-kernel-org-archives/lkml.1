Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296Ab0BYPLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:11:00 -0500
Received: from tomts43.bellnexxia.net ([209.226.175.110]:34936 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759103Ab0BYPK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:10:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJchhktGGOM5/2dsb2JhbACbFnS8a4R1BIMX
Date: Thu, 25 Feb 2010 10:10:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip v3&10 01/18] kprobes/x86: Cleanup
	RELATIVEJUMP_INSTRUCTION to RELATIVEJUMP_OPCODE
Message-ID: <20100225151055.GA12635@Krystal>
References: <20100225133342.6725.26971.stgit@localhost6.localdomain6> <20100225133349.6725.99302.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20100225133349.6725.99302.stgit@localhost6.localdomain6>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 10:10:29 up 70 days, 23:28,  4 users,  load average: 0.10, 0.08,
	0.03
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Change RELATIVEJUMP_INSTRUCTION macro to RELATIVEJUMP_OPCODE since it
> represents just the opcode byte.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Anders Kaseorg <andersk@ksplice.com>
> Cc: Tim Abbott <tabbott@ksplice.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
> ---
> 
>  arch/x86/include/asm/kprobes.h |    2 +-
>  arch/x86/kernel/kprobes.c      |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kprobes.h b/arch/x86/include/asm/kprobes.h
> index 4fe681d..eaec8ea 100644
> --- a/arch/x86/include/asm/kprobes.h
> +++ b/arch/x86/include/asm/kprobes.h
> @@ -32,7 +32,7 @@ struct kprobe;
>  
>  typedef u8 kprobe_opcode_t;
>  #define BREAKPOINT_INSTRUCTION	0xcc
> -#define RELATIVEJUMP_INSTRUCTION 0xe9
> +#define RELATIVEJUMP_OPCODE 0xe9
>  #define MAX_INSN_SIZE 16
>  #define MAX_STACK_SIZE 64
>  #define MIN_STACK_SIZE(ADDR)					       \
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 5de9f4a..15177cd 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -115,7 +115,7 @@ static void __kprobes set_jmp_op(void *from, void *to)
>  	} __attribute__((packed)) * jop;
>  	jop = (struct __arch_jmp_op *)from;
>  	jop->raddr = (s32)((long)(to) - ((long)(from) + 5));
> -	jop->op = RELATIVEJUMP_INSTRUCTION;
> +	jop->op = RELATIVEJUMP_OPCODE;
>  }
>  
>  /*
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

-- 
Mathieu Desnoyers
Operating System Efficiency Consultant
EfficiOS Inc.
http://www.efficios.com
