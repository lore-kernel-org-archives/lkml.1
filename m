Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0CERqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:46:17 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:3812 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0CERqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:46:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tMvBf1KiPbKZmtBYvBlr+gWarm2wlTJh3q7Im2sY2EnGq9IuDykGeEnrwQJIaBUEKY
         TPGULgkR6MP3ACffUwm7xE1h5MCdE1WPxfeiuE2eqpNB/QYIFdM5mEBgHObPBPkBmHsC
         G2JTdIKQTmC1GH6do4MlLpjl1fWhRbNFArVEk=
Date: Fri, 5 Mar 2010 18:46:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 2/2] perf: Walk through the relevant events only
Message-ID: <20100305174614.GF5244@nowhere>
References: <1267772426-5944-1-git-send-regression-fweisbec@gmail.com> <1267772426-5944-2-git-send-regression-fweisbec@gmail.com> <1267781969.16716.55.camel@laptop> <20100305170331.GB5244@nowhere> <1267809629.4942.0.camel@laptop> <20100305173342.GE5244@nowhere> <1267810752.4942.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267810752.4942.5.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 06:39:12PM +0100, Peter Zijlstra wrote:
> On Fri, 2010-03-05 at 18:33 +0100, Frederic Weisbecker wrote:
> > On Fri, Mar 05, 2010 at 06:20:29PM +0100, Peter Zijlstra wrote:
> > > On Fri, 2010-03-05 at 18:03 +0100, Frederic Weisbecker wrote:
> > > > 
> > > > Now isn't the problem more in the fact that most of the swevents
> > > > should be tracepoints? 
> > > 
> > > No, different interface, and I don't want to require TRACE=y, I already
> > > utterly hate that x86 requires PERF=y.
> > > 
> > 
> > This could be reduced to the strict minimum, say CONFIG_TRACEPOINT
> > and some code around just to support the event ids.
> 
> Can't, software events already are an ABI so we'll have to support that
> forever, but sure you can make something that reduces to the current
> software event callback on TRACE=n and maps to the right software event
> id when TRACE=y.


That looks feasible. I may try something like that.


> 
> > Software events could be made optionals too.
> 
> Sure, but they're nowhere near as much code as tracepoints.


Yeah but they have the overhead of an off case to handle, something
that can be turned off if we have only perf for breakpoints.


> 
> > > I already
> > > utterly hate that x86 requires PERF=y.
> > 
> > 
> > Me too, and it's my bad, so me double too. Sometimes I think
> > we should make BREAKPOINTs optional, default y. I just don't know
> > if something like this that has always been builtin can be made
> > optional.
> 
> Simply for build testing that would be useful, we could make it an
> embedded switch.


Agreed.

Ok, I'll work toward an hlist version for the initial topic.
Thanks.

