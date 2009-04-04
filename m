Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbZDDPnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbZDDPnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 11:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZDDPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 11:42:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbZDDPmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 11:42:47 -0400
Date: Sat, 4 Apr 2009 11:42:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Tom Zanussi <tzanussi@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/4] [GIT PULL] for tip/tracing/filters
In-Reply-To: <1238827803.22495.16.camel@bookworm>
Message-ID: <alpine.DEB.2.00.0904041140490.32083@gandalf.stny.rr.com>
References: <20090402052721.013878388@goodmis.org>  <20090403121434.GJ31399@elte.hu>  <alpine.DEB.2.00.0904031035060.965@gandalf.stny.rr.com> <1238827803.22495.16.camel@bookworm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 4 Apr 2009, Tom Zanussi wrote:
> On Fri, 2009-04-03 at 10:36 -0400, Steven Rostedt wrote:
> 
> I'm guessing the problem is that CONFIG_EVENT_TRACER wasn't selected but
> should have been, because those tracers all now export events
> (trace_event_types.h, included by trace_export.c).  I'm not sure this is
> the right way to do it, but the patch below selects EVENT_TRACER if
> TRACING is selected (a couple of the exported events belong to bprint
> and print, which don't have a config option other than TRACING, so it
> seems to belong there).
> 
> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> 
> ---
>  kernel/trace/Kconfig |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 8a41360..a061746 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -56,6 +56,7 @@ config TRACING
>  	select TRACEPOINTS
>  	select NOP_TRACER
>  	select BINARY_PRINTF
> +	select EVENT_TRACER

Yeah, we can do this.

>  
>  #
>  # Minimum requirements an architecture has to meet for us to
> @@ -177,7 +178,7 @@ config CONTEXT_SWITCH_TRACER
>  
>  config EVENT_TRACER
>  	bool "Trace various events in the kernel"
> -	select TRACING
> +	depends on TRACING

This means we can only select EVENT_TRACER if something else has been 
selected. Can't we keep the "select TRACING" here.

That way, we could just select EVENT_TRACER, but if anything other 
tracer is selected, we automatically get EVENT_TRACER.

The logic would be, if you pick any tracer you get the EVENT_TRACER.
But you can still just ask for the EVENT_TRACER with no other tracer.

-- Steve



>  	help
>  	  This tracer hooks to various trace points in the kernel
>  	  allowing the user to pick and choose which trace point they
> -- 
> 1.5.6.3
> 
> 
> 
> 
