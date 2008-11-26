Return-Path: <linux-kernel-owner+w=401wt.eu-S1753288AbYKZWnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288AbYKZWnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbYKZWmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:42:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52428 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbYKZWln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:41:43 -0500
Date: Wed, 26 Nov 2008 17:41:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 5/5] powerpc/ppc32: static ftrace fixes for PPC32
In-Reply-To: <20081126220423.701125085@goodmis.org>
Message-ID: <alpine.DEB.1.10.0811261740360.1501@gandalf.stny.rr.com>
References: <20081126215821.263324391@goodmis.org> <20081126220423.701125085@goodmis.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Steven Rostedt wrote:

> From: Steven Rostedt <rostedt@gollum.(none)>

Ah, I need to add GIT_AUTHOR on my PowerBook. And yes, it's name
is gollum ;-)

I'll fix this and push it again.

-- Steve

> 
> Impact: fix for PowerPC 32 code
> 
> There were some early init code that was not safe for static
> ftrace to boot on my PowerBook. This code must only use relative
> addressing, and static mcount performs a compare of the
> ftrace_trace_function pointer, and gets that with an absolute address.
> In the early init boot up code, this will cause a fault.
> 
> This patch removes tracing from the files containing the offending
> functions.
> 
> Signed-off-by: Steven Rostedt <rostedt@gollum.(none)>
> ---
>  arch/powerpc/kernel/Makefile |    1 +
>  arch/powerpc/lib/Makefile    |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 92673b4..d17edb4 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -17,6 +17,7 @@ ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_cputable.o = -pg -mno-sched-epilog
>  CFLAGS_REMOVE_prom_init.o = -pg -mno-sched-epilog
>  CFLAGS_REMOVE_btext.o = -pg -mno-sched-epilog
> +CFLAGS_REMOVE_prom.o = -pg -mno-sched-epilog
>  
>  ifdef CONFIG_DYNAMIC_FTRACE
>  # dynamic ftrace setup.
> diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
> index d69912c..8db3527 100644
> --- a/arch/powerpc/lib/Makefile
> +++ b/arch/powerpc/lib/Makefile
> @@ -6,6 +6,9 @@ ifeq ($(CONFIG_PPC64),y)
>  EXTRA_CFLAGS		+= -mno-minimal-toc
>  endif
>  
> +CFLAGS_REMOVE_code-patching.o = -pg
> +CFLAGS_REMOVE_feature-fixups.o = -pg
> +
>  obj-y			:= string.o alloc.o \
>  			   checksum_$(CONFIG_WORD_SIZE).o
>  obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o
> -- 
> 1.5.6.5
> 
> -- 
> 
> 
