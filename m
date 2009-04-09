Return-Path: <linux-kernel-owner+w=401wt.eu-S1764292AbZDIRVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764292AbZDIRVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbZDIRVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:21:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:25863 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbZDIRU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=K+0R/obMO2ktGc5Q0FeqK9eXk3dcxHChy9UlsJ/4okQjntZATiuNniBpMwn/blpvjI
         ebRnvUUEV09TonhvoDEkwsUPmMBYDfLnQ7J2ZfUYV7pYkrI0xI3pf17VirH+cZqUtW9B
         TcU3lf9bXTiraJNonROQfG5gpjK4mfKNZD3g4=
Date: Thu, 9 Apr 2009 19:20:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: ftrace.c declare prepare_ftrace_return
	before they get used
Message-ID: <20090409172053.GA6033@nowhere>
References: <1239295068.3296.20.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239295068.3296.20.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 10:07:48PM +0530, Jaswinder Singh Rajput wrote:
> Impact: fix sparse warning:
>   arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/ftrace.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index bd2c651..49616d4 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -62,4 +62,10 @@ struct dyn_arch_ftrace {
>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +#ifndef __ASSEMBLY__
> +extern void prepare_ftrace_return(unsigned long *, unsigned long);


But it is only used from asm code so there is no need to make
its prototype public.

I don't think this is necessary but if you really think it is, then I would prefer
you use the already existing #ifndef __ASSEMBLY__ block.

Thanks,
Frederic.



> +#endif
> +#endif
> +
>  #endif /* _ASM_X86_FTRACE_H */
> -- 
> 1.6.0.6
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

