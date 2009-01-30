Return-Path: <linux-kernel-owner+w=401wt.eu-S1755194AbZA3Mjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194AbZA3Mjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 07:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZA3Mj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 07:39:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:45609 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZA3Mj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 07:39:27 -0500
Date: Fri, 30 Jan 2009 10:39:16 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: better manage the context info for
	events
Message-ID: <20090130123916.GR627@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4982c159.190c660a.7424.ffffabf9@mx.google.com> <20090130123446.GQ627@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090130123446.GQ627@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 30, 2009 at 10:34:46AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Jan 30, 2009 at 12:59:05AM -0800, Frederic Weisbecker escreveu:
> > Impact: make trace_event more convenient for tracers
> > 
> > All tracers (for the moment) that use the struct trace_event want to have
> > the context info printed before their own output: the pid/cmdline, cpu, and timestamp.
> > 
> > But some other tracers that want to implement their trace_event callbacks will
> > not necessary need these information or they may want to format them as they want.
> > 
> > This patch adds a new default-enabled trace option: TRACE_ITER_CONTEXT_INFO
> > When disabled through:
> > 
> > echo nocontext-info > /debugfs/tracing/trace_options
> > 
> > The pid, cpu and timestamps headers will not be printed.
> > 
> > IE with the sched_switch tracer with context-info (default):
> > 
> >             bash-2935  [001]   100.356561:   2935:120:S ==> [001]     0:140:R <idle>
> >           <idle>-0     [000]   100.412804:      0:140:R   + [000]    11:115:S events/0
> >           <idle>-0     [000]   100.412816:      0:140:R ==> [000]    11:115:R events/0
> >         events/0-11    [000]   100.412829:     11:115:S ==> [000]     0:140:R <idle>
> > 
> > Without context-info:
> > 
> >   2935:120:S ==> [001]     0:140:R <idle>
> >      0:140:R   + [000]    11:115:S events/0
> >      0:140:R ==> [000]    11:115:R events/0
> >     11:115:S ==> [000]     0:140:R <idle>
> > 
> > A tracer can disable it at runtime by clearing the bit TRACE_ITER_CONTEXT_INFO in trace_flags.
> > 
> > Moreover, two callbacks have been added inside trace_event:
> > _ context_info() which let a tracer override the format of the context info
> > _ lat_context_info() which do the same with the latency_trace file
> > 
> > If they are not defined, the usual way of printing the context info will be used.
> 
> Please wait a bit, I'm trying to use it and the first thing I notice was
> that I need the trace_iterator in the context callback, to get the
> timestamp.

Sorry, false alarm, the iterator is there, I was trying to build the
whole binary trace record in the trace_event->bin(), but its not
possible, so I'll do it in two function calls context + trace.

- Arnaldo
