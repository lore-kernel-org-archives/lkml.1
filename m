Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbZBHANY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbZBHANY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZBHANP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 19:13:15 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49022 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZBHANP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 19:13:15 -0500
Date: Sat, 7 Feb 2009 16:13:15 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090208001315.GG7120@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <f73f7ab80902071456j6b2f7ea2q7400e777209998e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73f7ab80902071456j6b2f7ea2q7400e777209998e0@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 05:56:31PM -0500, Kyle Moffett wrote:
> On Thu, Feb 5, 2009 at 11:58 PM, Mathieu Desnoyers
> <compudj@krystal.dyndns.org> wrote:
> > I figured out I needed some userspace RCU for the userspace tracing part
> > of LTTng (for quick read access to the control variables) to trace
> > userspace pthread applications. So I've done a quick-and-dirty userspace
> > RCU implementation.
> >
> > It works so far, but I have not gone through any formal verification
> > phase. It seems to work on paper, and the tests are also OK (so far),
> > but I offer no guarantee for this 300-lines-ish 1-day hack. :-) If you
> > want to comment on it, it would be welcome. It's a userland-only
> > library. It's also currently x86-only, but only a few basic definitions
> > must be adapted in urcu.h to port it.
> 
> I have actually been fiddling with an RCU-esque design for a
> multithreaded event-driven userspace server process.  Essentially all
> threads using RCU-protected data run through a central event loop
> which drives my entirely-userspace RCU state machine.  I actually have
> a cooperative scheduler for groups of events to allow me to
> load-balance a large number of clients without the full overhead of a
> kernel thread per client.  This does rely on
> clock_gettime(CLOCK_THREAD_CPUTIME_ID) returning a useful monotonic
> value, however.
> 
> By building the whole internal system as an
> event-driven-state-machine, I don't need to keep a stack for blocked
> events.  The events which do large amounts of work call a
> "need_resched()"-ish function every so often, and if it returns true
> they return up the stack.  Relatively few threads (1 per physical CPU,
> plus a few for blocking event polling) are needed to completely
> saturate the system.
> 
> For RCU I simply treat event-handler threads the way the kernel treats
> CPUs, I report a Quiescent State every so often in-between processing
> events.
> 
> The event-handling mechanism is entirely agnostic to the way that
> events are generated.  It has built-in mechanisms for FD, signal, and
> AIO-based events, and it's trivial to add another event-polling thread
> for GTK/Qt/etc.
> 
> I'm still only halfway through laying out the framework for this
> library, but once it's done I'll make sure to post it somewhere for
> those who are interested.

I look forward to seeing it!  Perhaps user-level RCU is an idea whose
time has come?  ;-)

							Thanx, Paul
