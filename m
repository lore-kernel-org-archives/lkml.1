Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZFUKph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZFUKph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 06:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752469AbZFUKpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 06:45:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59747 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZFUKpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 06:45:30 -0400
Date: Sun, 21 Jun 2009 12:45:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/2] function-graph: disable when both x86_32 and
	optimize for size are configured
Message-ID: <20090621104527.GA22961@elte.hu>
References: <20090618224409.916725341@goodmis.org> <20090618225248.476090968@goodmis.org> <20090620162513.GD32377@elte.hu> <alpine.DEB.2.00.0906201822320.20813@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906201822320.20813@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Sat, 20 Jun 2009, Ingo Molnar wrote:
> 
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > > index 4a13e5a..1eac852 100644
> > > --- a/kernel/trace/Kconfig
> > > +++ b/kernel/trace/Kconfig
> > > @@ -121,6 +121,7 @@ config FUNCTION_GRAPH_TRACER
> > >  	bool "Kernel Function Graph Tracer"
> > >  	depends on HAVE_FUNCTION_GRAPH_TRACER
> > >  	depends on FUNCTION_TRACER
> > > +	depends on !X86_32 || !CC_OPTIMIZE_FOR_SIZE
> > >  	default y
> > 
> > Hm, nice fix, but this is a quite nasty constraint - distros like to 
> > enable CC_OPTIMIZE_FOR_SIZE as it neatly trims the kernel's size by 
> > about 30%.
> > 
> > Just in case you have not checked yet: is there no way to turn off 
> > the specific gcc optimization that causes this? Or is it -Os itself 
> > that does this optimization?
> 
> It seems to me that -Os causes it for i386. I did a make V=1 to 
> capture how the files in question were being compiled, and tried 
> various disabling of flags. -Os was the only one to make a 
> difference. :-(

oh well. I think GCC should be fixed/improved to not do this 
particular (rather narrow looking) optimization if -pg is specified 
too.

	Ingo
