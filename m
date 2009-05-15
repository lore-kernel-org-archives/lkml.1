Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbZEOW2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbZEOW2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 18:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753232AbZEOW2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 18:28:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:47993 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956AbZEOW2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 18:28:14 -0400
Subject: Re: [PATCH] powerpc/ftrace: fix constraint to be early clobber
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0905141236420.30591@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0905141236420.30591@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 16 May 2009 08:27:18 +1000
Message-Id: <1242426438.9691.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 10:33 -0400, Steven Rostedt wrote:
> After upgrading my distcc boxes from gcc 4.2.2 to 4.4.0, the function 
> graph tracer broke. This was discovered on my x86 boxes.
> 
> The issue is that gcc used the same register for an output as it did for 
> an input in an asm statement. I first thought this was a bug in gcc and 
> reported it. I was notified that gcc was correct and that the output had 
> to be flagged as an "early clobber".
> 
> I noticed that powerpc had the same issue and this patch fixes it.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Ack. You merge this or I do ?

Cheers,
Ben.

> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index 70e2a73..68fd74e 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -594,7 +594,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
>  			PPC_LONG "2b,4b\n"
>  		".previous"
>  
> -		: [old] "=r" (old), [faulted] "=r" (faulted)
> +		: [old] "=&r" (old), [faulted] "=r" (faulted)
>  		: [parent] "r" (parent), [return_hooker] "r" (return_hooker)
>  		: "memory"
>  	);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

