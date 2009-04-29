Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbZD2EEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbZD2EEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750863AbZD2EDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:03:54 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48256 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbZD2EDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:03:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for worklet lifecycle tracing
Cc: kosaki.motohiro@jp.fujitsu.com, fche@redhat.com (Frank Ch. Eigler),
       zhaolei@cn.fujitsu.com, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       oleg@redhat.com
In-Reply-To: <20090428114827.afb8bbe6.akpm@linux-foundation.org>
References: <y0mr5zclmhi.fsf@ton.toronto.redhat.com> <20090428114827.afb8bbe6.akpm@linux-foundation.org>
Message-Id: <20090429120953.4B0E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 29 Apr 2009 13:03:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 28 Apr 2009 13:24:57 -0400
> fche@redhat.com (Frank Ch. Eigler) wrote:
> 
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > 
> > > [...]  The patches introduce a moderate amount of tracing-specific
> > > hooks into the core workqueue code, which inevitably increases the
> > > maintenance load for that code.  It is important that it be
> > > demonstrated that the benefts of the code are worth that cost.
> > > Hence it is important that these benefits be demonstrated to us, by
> > > yourself.  Please.  [...]
> > 
> > To be fair, if you ask for someone to specify and quantify the
> > "benefits" side of this, shouldn't someone specify and quantify the
> > "cost" side of this too?
> 
> Not if benefit==0 ;)
> 
> (Which I suspect will be close to the truth)
>
> 
> >  That way we would have something to compare.
> 
> Well, there are two aspects to this.  There's the immediate up-front
> cost - a little added complexity, more code, etc.
> 
> But there's also the where-the-hell-is-this-all-going question.  Are we
> going to end up with hundreds or thousands of tracepoints sprinkled all
> over core kernel?  If so, what use are they?  What userspace tools will
> be used to pull them into something useful?  Who will be developing
> those tools and are they involved in the development of the
> tracepoints?  Will this proliferation of static tracepoints actively
> kill off the development and maturation of dynamic tracepoints?  If so,
> is that good?
> 
> 
> From where I sit it looks like a mad scramble to sprinkle fairly random
> tracepoints all over the place under the assumption that
> this-may-be-useful-to-someone-one-day.  But of course, that means that
> they many never be useful to anyone ever.
> 
> Part of this derives from the development approach.  With the various
> tracers which we've developed in the past, the problem has been "I'm
> working on subsystem X and I need help".  So the tracer is driven by a
> particular development problem (original blktrace, ext3-debug, etc). 
> This will axiomatically result in a tracer which is _useful_.
> 
> But in this case the approach is different - the problem statement is
> "I need to add tracepoints to subsystem X".  It's not driven by any
> particular development problem.  So there's no guarantee at all that the
> end result will be _useful_ for anything!

May I explain my opinion? I am original patch author of latency enhancement of
workqueue tracer.

In real world, desktop and server user use various the out of tree driver and kernel
module (e.g. some graphics driver, DRBD, proprietery security software et.al).
and poor quality driver often make bug in asynchronous processing place
(e.g. timer, workqueue, irq).

the bug may not be easy fixable and analyzable. if kernel oops happend,
it's easy. oops log point out suspector clearly in almost case.
but if the poor driver makes large latency, the evidence often vanished
before latency occured.

When trouble happend, An administrator get large bafflement. "Oh, which software
is wrong? how do I divide good and wrong software?".
In past days, We always say "hehe, you use proprietery module. can you 
reproduce this bug on upstream kernel only?". this answer don't help
nor solve end-user. it is one of escape of accountability.

The good well defined static tracepoint help its situation largely.


In addition, As far as I know, typical DTrace user don't use dynamic 
tracing feature at all.
They think they don't know how choice proper probe point for dynamic tracing.
They repeatedly strongly hope to increase well defined static probe point. they
think dynamic trace feature is too hard to use.

I also strongly dislike random place tracepoint. but I don't think this patch
series is random.
and I think other asynchronous processing subsystem need static tracepoint.



