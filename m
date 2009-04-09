Return-Path: <linux-kernel-owner+w=401wt.eu-S936038AbZDISz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936038AbZDISz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 14:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760361AbZDISzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 14:55:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50522 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbZDISzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 14:55:42 -0400
Date: Thu, 9 Apr 2009 14:55:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: ftrace.c declare prepare_ftrace_return before
 they get used
In-Reply-To: <1239298915.3296.24.camel@ht.satnam>
Message-ID: <alpine.DEB.2.00.0904091452590.21189@gandalf.stny.rr.com>
References: <1239295068.3296.20.camel@ht.satnam>  <20090409172053.GA6033@nowhere> <1239298915.3296.24.camel@ht.satnam>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Apr 2009, Jaswinder Singh Rajput wrote:

> On Thu, 2009-04-09 at 19:20 +0200, Frederic Weisbecker wrote:
> > On Thu, Apr 09, 2009 at 10:07:48PM +0530, Jaswinder Singh Rajput wrote:
> > > Impact: fix sparse warning:
> > >   arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?
> > > 
> > > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > > ---
> > >  arch/x86/include/asm/ftrace.h |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > > index bd2c651..49616d4 100644
> > > --- a/arch/x86/include/asm/ftrace.h
> > > +++ b/arch/x86/include/asm/ftrace.h
> > > @@ -62,4 +62,10 @@ struct dyn_arch_ftrace {
> > >  #endif /* __ASSEMBLY__ */
> > >  #endif /* CONFIG_FUNCTION_TRACER */
> > >  
> > > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > > +#ifndef __ASSEMBLY__
> > > +extern void prepare_ftrace_return(unsigned long *, unsigned long);
> > 
> > 
> > But it is only used from asm code so there is no need to make
> > its prototype public.
> > 
> > I don't think this is necessary but if you really think it is, then I would prefer
> > you use the already existing #ifndef __ASSEMBLY__ block.
> > 

It is not necessary.

> 
> Like this:
> 
> Subject: [PATCH] x86: ftrace.c declare prepare_ftrace_return before they get used
> 
> Impact: fix sparse warning:
>   arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/ftrace.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> index bd2c651..ddc9236 100644
> --- a/arch/x86/include/asm/ftrace.h
> +++ b/arch/x86/include/asm/ftrace.h
> @@ -59,6 +59,11 @@ struct dyn_arch_ftrace {
>  };
>  
>  #endif /*  CONFIG_DYNAMIC_FTRACE */
> +
> +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> +extern void prepare_ftrace_return(unsigned long *, unsigned long);
> +#endif
> +

The only caller is from assembly, so this patch is unnecessary. Unless we 
have some rule that all functions must have a prototype, even when it is 
only called from assembly.

-- Steve


>  #endif /* __ASSEMBLY__ */
>  #endif /* CONFIG_FUNCTION_TRACER */
>  
> -- 
> 1.6.0.6
> 
> 
> 
> 
