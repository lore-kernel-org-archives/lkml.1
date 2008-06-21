Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYFUQPC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYFUQPC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 12:15:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbYFUQOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 12:14:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56838 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYFUQOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 12:14:52 -0400
Subject: Re: [RFC][Patch 2/2] markers: example of irq regular kernel markers
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>,
       Hideo AOKI <haoki@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com>
References: <20080620174529.GB10943@Krystal> <485C064E.5020705@redhat.com>
	 <20080621190132.E835.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <Pine.LNX.4.58.0806211013300.32694@gandalf.stny.rr.com>
	 <y0mwskiyh36.fsf@ton.toronto.redhat.com>
	 <Pine.LNX.4.58.0806211058510.28481@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 18:13:54 +0200
Message-Id: <1214064834.3223.231.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 11:07 -0400, Steven Rostedt wrote:
> On Sat, 21 Jun 2008, Frank Ch. Eigler wrote:
> > Steven Rostedt <rostedt@goodmis.org> writes:

> > > It also just looks like a debug session instead of a trace marker.
> >
> > Why do you think the difference between those is profound?
> 
> Not that profound but I do find:
> 
>   trace_sched_switch(prev, next);
> 
> much nicer to look at than
> 
>   trace_mark("%p %p", prev, next);
> 
> 
> The trace_sched_switch seems a bit more informative with a simple glance
> than the trace_mark.

I think what Frank refers to here is why not scatter the kernel code
with trace_mark()s on every conceivable location like you do with
printk-style debugging. Those trace marks might help out when
$customer's kernel goes splat and you don't want to provide him with a
custom kernel.

I do think we must make a clear distinction between these cases because:

 1) tracers provide a kernel<->user interface - and whilst we don't have
a stable in-kernel API/ABI we are anal about the kernel/user boundary.
Andrew also greatly worries about this aspect.

 2) it highly uglyfies the code, Frank doesn't need to maintain it, so
its easy for him to say. But IMHO its much harder to read code that is
littered with debug statements that it is to read regular code.

 3) it bloats the kernel,.. while it may not be fast path bloat, all
that marker stuff does go somewhere.


So, while I see the value of 'stable' mark sites for 'stable' events,
I'm dead-set against littering the kernel with markers just because we
can, and hoping they might some day be useful for someone.

