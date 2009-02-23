Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZBWPz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZBWPz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZBWPzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:55:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZBWPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:55:13 -0500
Date: Mon, 23 Feb 2009 10:55:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
 conversions
In-Reply-To: <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0902231053360.18221@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com>
 <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Steven Rostedt wrote:

> 
> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> > > 
> > > As for RO_DATA and bugs, it is a very small window for this to happen, and 
> > > the sys-admin is the one making the change. This is not some periodical 
> > > update. The sys-admin must be the one to initiate the tracer to modify 
> > > text, ie, enabling or disabling the function tracer. Which, by the way, is 
> > > something a sys-admin should only do when the system is off line. The 
> > > overhead of all functions being traced, would not be something to be 
> > > doing on a production system, unless they need to analyze something going 
> > > wrong.
> > > 
> > 
> > The argument "not to be used on production systems" is incompatible with
> > the LTTng view, sorry. If you design your code so it's usable only in
> > debugging scenarios on development machines and not in the field, then I
> > doubt LTTng will be able to rely on it. I'm OK with that, as long as
> > nobody argue that such tracepoint could be replaced by the function
> > tracer, because tracepoints has to be enabled in the field on production
> > machines.
> 
> Please do not confuse ftrace with the function tracer. The stop_machine
> is only about the function tracer and has nothing to do with the rest of
> ftrace. This is one detail. Yes, tracing EVERY function in the kernel
> will add an overhead. There's no way around it. It's OK to do it on a
> production system, but it WILL add overhead. That's what happens when you
> trace EVERY function.
> 
> Note, I leave a lot of the other tracers on by default, and those are all
> within the noise of overhead. I'm only talking about the function tracer
> that is meant to do a lot of tracing. Does LTTng trace EVERY function?

BTW, The above is more about the answer to my statement about running on
a production system. Below, is more an answer to the above. After 
rereading what I wrote, I did not explain it very well.

-- Steve

> 
> Now, yes, if you only select a few functions, there's no noticeable 
> overhead. And yes then you would need to do the stop_machine anyway, and 
> there will be a small window where the kernel text will be writable. 
> Tracing only a small set of functions (say a few 100) is not much of an 
> overhead, and I could see that being done on a production system.
> 
> > 
> > I agree that the racy time window is not that large and is not really a
> > security concern, but it's still just annoying.
> 
> Annoying? how so?
> 
> Again, the stop_machine part has nothing to do with DEBUG_RODATA, it is 
> about the safest and easiest way to modify kernel text.
> 
> -- Steve
> 
> 
