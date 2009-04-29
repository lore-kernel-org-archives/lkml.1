Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZD2FVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZD2FVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZD2FVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:21:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49480 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbZD2FV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:21:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for worklet lifecycle tracing
Cc: kosaki.motohiro@jp.fujitsu.com, fche@redhat.com (Frank Ch. Eigler),
       zhaolei@cn.fujitsu.com, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
In-Reply-To: <20090428212919.c1f6f4b4.akpm@linux-foundation.org>
References: <20090429120953.4B0E.A69D9226@jp.fujitsu.com> <20090428212919.c1f6f4b4.akpm@linux-foundation.org>
Message-Id: <20090429133813.4B14.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 14:21:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 29 Apr 2009 13:03:51 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > > But in this case the approach is different - the problem statement is
> > > "I need to add tracepoints to subsystem X".  It's not driven by any
> > > particular development problem.  So there's no guarantee at all that the
> > > end result will be _useful_ for anything!
> > 
> > May I explain my opinion? I am original patch author of latency enhancement of
> > workqueue tracer.
> > 
> > In real world, desktop and server user use various the out of tree driver and kernel
> > module (e.g. some graphics driver, DRBD, proprietery security software et.al).
> > and poor quality driver often make bug in asynchronous processing place
> > (e.g. timer, workqueue, irq).
> > 
> > the bug may not be easy fixable and analyzable. if kernel oops happend,
> > it's easy. oops log point out suspector clearly in almost case.
> > but if the poor driver makes large latency, the evidence often vanished
> > before latency occured.
> > 
> > When trouble happend, An administrator get large bafflement. "Oh, which software
> > is wrong? how do I divide good and wrong software?".
> > In past days, We always say "hehe, you use proprietery module. can you 
> > reproduce this bug on upstream kernel only?". this answer don't help
> > nor solve end-user. it is one of escape of accountability.
> > 
> > The good well defined static tracepoint help its situation largely.
> > 
> > 
> > In addition, As far as I know, typical DTrace user don't use dynamic 
> > tracing feature at all.
> > They think they don't know how choice proper probe point for dynamic tracing.
> > They repeatedly strongly hope to increase well defined static probe point. they
> > think dynamic trace feature is too hard to use.
> > 
> > I also strongly dislike random place tracepoint. but I don't think this patch
> > series is random.
> > and I think other asynchronous processing subsystem need static tracepoint.
> 
> OK.
> 
> It's quite unclear to me how we get from here to a situation where we
> have something which your administrator can use.  Hopefully someone
> some day will pull all this together into an overall integrated
> toolset.  The fact that the kernel work is being done (afaict)
> waaaaaaaay in advance of that development means that we'll probably
> have to revist the kernel work.  So be it.
> 
> But your administrator wouldn't even know to go looking at workqueues! 
> Unless the userspace support tools are very very good.  He might
> instead spend hours poking at the sleep-tracer or the rwsem-tracer or
> the slow-work-tracer or blah blah.

Agreed. then I add latency list displaying feature to worktracer stastics.
It display suspect workqueue (or no need doubt workqueue).

My expected use-case is:
good sorted-out stastics narrow down suspector. and most detailed information
can be get by event tracer.

IOW, generally I agree with you. good userspace tools is very very important.
but workqueue tracer latency view, I think current stastics is enough.


> I expect that a generic function-entry tracer (which we already have)
> would be the starting tool for diagnosing such a problem.  Probably it
> would be the ending tool too.

I think function tracer is control flow oriented tracer. event tracer is data flow
oriented tracer.
they see another aspect to one thing.

example, if big latency is caused complex funny locking dependency, control
flow analysis don't solve issue, we need data flow analysis.




> What's the terminal state here?  The end result?  I see lots of random
> somewhat-useless-looking tracers being added, but what are we actually
> working towards?
> 
> Until we know that, how do we know that we're not adding stuff
> which we won't need (as I suspect we are doing)?

Oh well. I can't say the goal of ftrace framework itself.

I only say:
many issue and trouble in real world isn't kernel itself
problem. but we aren't always white hands. There are various half gray
issue.
In past days, we always say "it isn't kernel bug, it's userland mis-use".
but I don't think it's real solution. it makes game of cat and mouse.

strong analysis helping feature seems right way of improve linux quality
of end-user view (not kernel developer view).

Fortunately, I'm working for big server vendor now and I can see
past trouble log and I also have some userland development experience. 
then, I think I know some frequently troubled place
than pure kernel developer and I can help to discuss "which is proper 
place of well known tracepoint".

but it's only "I think". I need good discussion.



