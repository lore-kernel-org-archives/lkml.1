Return-Path: <linux-kernel-owner+w=401wt.eu-S1756437AbYFMOTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756437AbYFMOTG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481AbYFMOSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:18:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYFMOSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:18:54 -0400
Date: Fri, 13 Jun 2008 10:17:04 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Hideo AOKI <haoki@redhat.com>, mingo@elte.hu,
       Masami Hiramatsu <mhiramat@redhat.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Kernel marker has no performance impact on ia64.
Message-ID: <20080613141704.GA25372@redhat.com>
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <1213289621.31518.128.camel@twins> <20080612173858.GA22454@redhat.com> <1213354872.31518.193.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213354872.31518.193.camel@twins>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jun 13, 2008 at 01:01:12PM +0200, Peter Zijlstra wrote:
> [...]
> > > The trace point need not be concerned with which data, nor into what
> > > buffer.
> > 
> > The "which data" is definitely a trace point concern.  It communicates
> > from the developer to users as to what values are likely to be of
> > interest.
> 
> But that is tracer specific - I might write a scheduler tracer that
> looks at the quality of scheduling decisions and thus wants to look at
> the virtual timeline variables and the scheduling class of the tasks
> involved.

> That's a whole different context, but the trace points are the same. Are
> you saying trace points are not to allow me to do that?

Of course markers can allow you to do that.  You can add two markers
in one spot if you really want to, one with far more details than the
other.  You can still write your own "tracer" kernel-side code to
attach to that if you wish.  But you might find that you don't have
to, if a more general tool can get you the same data (and more).

(A separate issue, brought up some number of times here, has been
whether even detailed debugging-oriented markers would be worth
keeping in the code.  I've argued that, yes, it's worthwhile, since
they cost nearly nothing, and in exchange would allow your
users/customers to gather the same debugging data for bug reports, in
situ on a live system.)



> > > > (a) rely on debugging information?  Even assuming we could get proper
> > > >     anchors (PC addresses or unambiguous type names) to start
> > > >     searching dwarf data, we lose a key attractions of markers: that
> > > >     it can robustly transfer data *without* dwarf data kept around.
> > > 
> > > Perhaps you can ship a reduced set of dwarf info [...]
> > 
> > "I" don't ship or generate dwarf data.  Distributors do.
> 
> That's ignoring the point - 'someone' could generate reduced debug info
> to allow you to easily get what you want.

But is there clear benefit to blocking potential incremental progress,
waiting for newer technology?  What if one can transition smoothly
once godot does show up?


> [...]
> > > Get your own tracer in kernel - that provides exactly what stap needs?
> > 
> > You are missing that (a) this is the point of markers - to allow the
> > the gajillion tracers a single place per event to hook through, and
> > (b) we would like to leave to subsystem developers and/or end-users as
> > to what data should be available.  We don't want to get into the
> > middle of it.
> 
> I think a) and b) contradict each other, you cannot cater for all
> tracers and limit the data they can use.

We are not talking about "limiting".  Markers are about identifying
the large intersection of interest (events + data) amongst multiple
tracing-type tools, and letting them share an single efficient hooking
mechanism for getting at that.  No one said it must to be the solitary
tracing-hook mechanism.

My (b) point was that systemtap per se does not want to specify what
subset of data should be available to an end user -- so we don't want
systemtap-specific markers or hooks or whatever.  We want to expose
whatever the developer deemed appropriate.  I merely lobby that this
set should include some values that tools can use without heroic
measures.


- FChE
