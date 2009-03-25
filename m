Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbZCYXFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbZCYXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZCYXEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:04:45 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:54345 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756744AbZCYXEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oLtaJ7uwCBiWHHM7ON2zExKqdxamWcp7Ahir1Hk0+GmJDROnYYV+48mE8yGk362ZGf
         sgJ3UKfS0q7mbjth7w/cHb+OQb7AdB96PwriqvHJPA+pXF3XRhXebsJZHr2As/q+0L0o
         XDvrD13XwcqyfW8vmja7KPe0NpyZSFhKKEOo8=
Date: Thu, 26 Mar 2009 00:04:38 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][GIT PULL] tracing: add handler to trace_stat
Message-ID: <20090325230437.GN5932@nowhere>
References: <alpine.DEB.2.00.0903242329350.22830@gandalf.stny.rr.com> <20090325220149.GK5932@nowhere> <alpine.DEB.2.00.0903251846470.5675@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903251846470.5675@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 06:49:33PM -0400, Steven Rostedt wrote:
> 
> On Wed, 25 Mar 2009, Frederic Weisbecker wrote:
> > >  
> > > diff --git a/kernel/trace/trace_stat.h b/kernel/trace/trace_stat.h
> > > index 202274c..f3546a2 100644
> > > --- a/kernel/trace/trace_stat.h
> > > +++ b/kernel/trace/trace_stat.h
> > > @@ -12,7 +12,7 @@ struct tracer_stat {
> > >  	/* The name of your stat file */
> > >  	const char		*name;
> > >  	/* Iteration over statistic entries */
> > > -	void			*(*stat_start)(void);
> > > +	void			*(*stat_start)(struct tracer_stat *trace);
> > 
> > 
> > 
> > In that case, shoudn't we pass another thing than the struct tracer_stat?
> > Because nothing really private can be stored in it. Moreover, most of the
> > time the handler is dedicated to this tracer_stat so it is able to have
> > an access to it.
> > 
> > May be we could add a void *private inside struct trace_stat and then pass
> > it to stat_start() ?
> > 
> 
> 
> Very few tracers need a private field so adding one would be a waste for 
> them. I just used the old container_of trick.
> 
> 
> struct ftrace_profile_stat {
>         atomic_t                        disabled;
>         struct hlist_head               *hash;
>         struct ftrace_profile_page      *pages;
>         struct ftrace_profile_page      *start;
>         struct tracer_stat              stat;
> };
> 
> static void *function_stat_start(struct tracer_stat *trace)
> {
>         struct ftrace_profile_stat *stat =
>                 container_of(trace, struct ftrace_profile_stat, stat);
> 
> [...]
> 
> And there you have it. I have everything I need unique to the tracer and 
> no need of a private pointer.
> 
> -- Steve
> 


And type safe :-)
Indeed, that's much better.

