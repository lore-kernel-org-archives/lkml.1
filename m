Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbZDEHwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbZDEHwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 03:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZDEHwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 03:52:23 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:3998 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbZDEHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 03:52:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FbKnG9nGb2yQNfXMDw0hLS0nPZhScegIel/x/P7SKCur2gUwlkoiv9iUc7kYOsp3a8
         FiWQhxumL5+m6vjVU72F4jBivZWeAc9vqY5x3iGvoFSsn/etxicfsUd1AEN1FpDeF6h4
         myYt+NPTGlxe84iiYfgBZ9e9ZYmD9wO9MtxuE=
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0904041140490.32083@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org>
	 <20090403121434.GJ31399@elte.hu>
	 <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com>
	 <1238827803.22495.16.camel@bookworm>
	 <alpine.DEB.2.00.0904041140490.32083@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 02:52:17 -0500
Message-Id: <1238917937.7989.231.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 11:42 -0400, Steven Rostedt wrote:
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
> 
> >  
> >  #
> >  # Minimum requirements an architecture has to meet for us to
> > @@ -177,7 +178,7 @@ config CONTEXT_SWITCH_TRACER
> >  
> >  config EVENT_TRACER
> >  	bool "Trace various events in the kernel"
> > -	select TRACING
> > +	depends on TRACING
> 
> This means we can only select EVENT_TRACER if something else has been 
> selected. Can't we keep the "select TRACING" here.
> 

Keeping 'select TRACING' here gives this error:

kernel/trace/Kconfig:53:error: found recursive dependency: TRACING ->
EVENT_TRACER -> TRACING

I'll have to play around with it some more...

Tom

> That way, we could just select EVENT_TRACER, but if anything other 
> tracer is selected, we automatically get EVENT_TRACER.
> 
> The logic would be, if you pick any tracer you get the EVENT_TRACER.
> But you can still just ask for the EVENT_TRACER with no other tracer.

> -- Steve
> 
> 
> 
> >  	help
> >  	  This tracer hooks to various trace points in the kernel
> >  	  allowing the user to pick and choose which trace point they
> > -- 
> > 1.5.6.3
> > 
> > 
> > 
> > 

