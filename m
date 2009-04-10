Return-Path: <linux-kernel-owner+w=401wt.eu-S1752582AbZDJEa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbZDJEa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 00:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZDJEaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 00:30:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:54777 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZDJEaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 00:30:13 -0400
Subject: Re: [PATCH -tip] x86: ftrace.c declare prepare_ftrace_return
 before they get used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       josh@freedesktop.org
In-Reply-To: <alpine.DEB.2.00.0904091452590.21189@gandalf.stny.rr.com>
References: <1239295068.3296.20.camel@ht.satnam>
	 <20090409172053.GA6033@nowhere> <1239298915.3296.24.camel@ht.satnam>
	 <alpine.DEB.2.00.0904091452590.21189@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 09:59:55 +0530
Message-Id: <1239337795.3036.25.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 14:55 -0400, Steven Rostedt wrote:
> 
> On Thu, 9 Apr 2009, Jaswinder Singh Rajput wrote:
> 
> > 
> > Subject: [PATCH] x86: ftrace.c declare prepare_ftrace_return before they get used
> > 
> > Impact: fix sparse warning:
> >   arch/x86/kernel/ftrace.c:411:6: warning: symbol 'prepare_ftrace_return' was not declared. Should it be static?
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/include/asm/ftrace.h |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/ftrace.h b/arch/x86/include/asm/ftrace.h
> > index bd2c651..ddc9236 100644
> > --- a/arch/x86/include/asm/ftrace.h
> > +++ b/arch/x86/include/asm/ftrace.h
> > @@ -59,6 +59,11 @@ struct dyn_arch_ftrace {
> >  };
> >  
> >  #endif /*  CONFIG_DYNAMIC_FTRACE */
> > +
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> > +extern void prepare_ftrace_return(unsigned long *, unsigned long);
> > +#endif
> > +
> 
> The only caller is from assembly, so this patch is unnecessary. Unless we 
> have some rule that all functions must have a prototype, even when it is 
> only called from assembly.
> 

Then:

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18dfa30..75c0682 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -408,6 +408,7 @@ int ftrace_disable_ftrace_graph_caller(void)
  * Hook the return address and push it in the stack of return addrs
  * in current thread info.
  */
+asmlinkage
 void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 {
        unsigned long old;


Josh: Do you think sparse should not warn like for this case.
What will be the best solution for this case.

--
JSR


