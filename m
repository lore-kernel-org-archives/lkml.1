Return-Path: <linux-kernel-owner+w=401wt.eu-S1755519AbZG2N1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519AbZG2N1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 09:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbZG2N1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 09:27:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbZG2N1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 09:27:32 -0400
Date: Wed, 29 Jul 2009 09:27:29 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jiri Olsa <jolsa@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: stack allocation fix
In-Reply-To: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
Message-ID: <alpine.DEB.2.00.0907290926570.8471@gandalf.stny.rr.com>
References: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 29 Jul 2009, Jiri Olsa wrote:

> Only 24 bytes need to be allocated.
> 
> I believe this was missed in following commit:
> x86, function-graph: only save return values on x86_64
> commit e71e99c294058a61b7a8b9bb6da2f745ac51aa4f

I was just being paranoid again. But it still worked. I'll take this patch 
as a clean up.

Thanks!

-- Steve


> 
> wbr,
> jirka
> 
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> ---
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index c251be7..d59fe32 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
>  END(ftrace_graph_caller)
>  
>  GLOBAL(return_to_handler)
> -	subq  $80, %rsp
> +	subq  $24, %rsp
>  
>  	/* Save the return values */
>  	movq %rax, (%rsp)
> @@ -155,10 +155,10 @@ GLOBAL(return_to_handler)
>  
>  	call ftrace_return_to_handler
>  
> -	movq %rax, 72(%rsp)
> +	movq %rax, 16(%rsp)
>  	movq 8(%rsp), %rdx
>  	movq (%rsp), %rax
> -	addq $72, %rsp
> +	addq $16, %rsp
>  	retq
>  #endif
>  
> 
