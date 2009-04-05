Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbZDEOrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbZDEOrc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 10:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753008AbZDEOrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 10:47:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51134 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZDEOrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 10:47:21 -0400
Date: Sun, 5 Apr 2009 16:47:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
Message-ID: <20090405144705.GD25250@elte.hu>
References: <20090402052721.013878388@goodmis.org> <20090403121434.GJ31399@elte.hu> <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com> <1238827803.22495.16.camel@bookworm> <alpine.DEB.2.00.0904041140490.32083@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904041140490.32083@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> On Sat, 4 Apr 2009, Tom Zanussi wrote:
> > On Fri, 2009-04-03 at 10:36 -0400, Steven Rostedt wrote:
> > 
> > I'm guessing the problem is that CONFIG_EVENT_TRACER wasn't selected but
> > should have been, because those tracers all now export events
> > (trace_event_types.h, included by trace_export.c).  I'm not sure this is
> > the right way to do it, but the patch below selects EVENT_TRACER if
> > TRACING is selected (a couple of the exported events belong to bprint
> > and print, which don't have a config option other than TRACING, so it
> > seems to belong there).
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> > ---
> >  kernel/trace/Kconfig |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> > index 8a41360..a061746 100644
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -56,6 +56,7 @@ config TRACING
> >  	select TRACEPOINTS
> >  	select NOP_TRACER
> >  	select BINARY_PRINTF
> > +	select EVENT_TRACER
> 
> Yeah, we can do this.

Yeah - it has become more of a core facility thing, not a separate 
plugin.

That's the long-term healthy life-cycle for certain tracing 
functionality anyway: if it becomes so useful that all tracers want 
to make use of it, it becomes part of the standard infrastructure.

	Ingo
