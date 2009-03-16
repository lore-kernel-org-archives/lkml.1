Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbZCPSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbZCPSvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754131AbZCPSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:51:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZCPSvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:51:14 -0400
Date: Mon, 16 Mar 2009 14:51:12 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
       fweisbec@gmail.com, fche@redhat.com, peterz@infradead.org
Subject: Re: [Patch 2/2] tracepoints for softirq entry/exit - tracepoints
In-Reply-To: <alpine.DEB.2.00.0903161441210.27978@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0903161446510.27978@gandalf.stny.rr.com>
References: <20090312183603.GC3352@redhat.com> <20090314025701.GC22526@Krystal> <alpine.DEB.2.00.0903160934010.26431@gandalf.stny.rr.com> <20090316183739.GA10292@Krystal> <alpine.DEB.2.00.0903161441210.27978@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 16 Mar 2009, Steven Rostedt wrote:

> 
> On Mon, 16 Mar 2009, Mathieu Desnoyers wrote:
> > > > 
> > > > The softirq tracepoints are a good idea indeed (I have similar ones in
> > > > the LTTng tree). My main concern is about the fact that you output the
> > > > softirq name in plain text to the trace buffers. I would rather prefer
> > > > to save only the softirq (h-vec) into the trace and dump the mapping
> > > > (h-vec) to name only once, so we can save precious trace bytes.
> > > 
> > > The TP_FMT is only used by those tracers that want to use it. Any tracer 
> > > can still hook directly to the trace point and do what every they want.
> > > 
> > > -- Steve
> > > 
> > 
> > By doing so, you are removing the ability to use the TP_FMT information
> > to perform high-speed system-wide tracing. I thought the goal was to
> > create a unified buffering, but sadly I don't see the high-speed
> > requirements being part of that plan.
> 
> TP_FMT has nothing to do with the unified buffering. The unified buffer 
> does not even know about it. But if you want high-speed event tracing, 
> that is what the TRACE_EVENT was created for.

Here's an example:

The "event tracing" uses the format field to show those events for the 
hook in the sched switching, and wake ups.

The wake up tracer on the other hand, does not care about the format, it 
only cares about having a hook where a a task is woken up, and where it 
gets scheduled in, and perhaps events in between. But it uses its own 
formatting to do the output.

-- Steve

