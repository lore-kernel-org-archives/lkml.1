Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbZD2Efw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbZD2Efw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbZD2Efn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:35:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbZD2Efm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:35:42 -0400
Date: Tue, 28 Apr 2009 21:29:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: fche@redhat.com (Frank Ch. Eigler), zhaolei@cn.fujitsu.com, mingo@elte.hu,
       fweisbec@gmail.com, rostedt@goodmis.org, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
Message-Id: <20090428212919.c1f6f4b4.akpm@linux-foundation.org>
In-Reply-To: <20090429120953.4B0E.A69D9226@jp.fujitsu.com>
References: <y0mr5zclmhi.fsf@ton.toronto.redhat.com>
	<20090428114827.afb8bbe6.akpm@linux-foundation.org>
	<20090429120953.4B0E.A69D9226@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 13:03:51 +0900 (JST) KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> > But in this case the approach is different - the problem statement is
> > "I need to add tracepoints to subsystem X".  It's not driven by any
> > particular development problem.  So there's no guarantee at all that the
> > end result will be _useful_ for anything!
> 
> May I explain my opinion? I am original patch author of latency enhancement of
> workqueue tracer.
> 
> In real world, desktop and server user use various the out of tree driver and kernel
> module (e.g. some graphics driver, DRBD, proprietery security software et.al).
> and poor quality driver often make bug in asynchronous processing place
> (e.g. timer, workqueue, irq).
> 
> the bug may not be easy fixable and analyzable. if kernel oops happend,
> it's easy. oops log point out suspector clearly in almost case.
> but if the poor driver makes large latency, the evidence often vanished
> before latency occured.
> 
> When trouble happend, An administrator get large bafflement. "Oh, which software
> is wrong? how do I divide good and wrong software?".
> In past days, We always say "hehe, you use proprietery module. can you 
> reproduce this bug on upstream kernel only?". this answer don't help
> nor solve end-user. it is one of escape of accountability.
> 
> The good well defined static tracepoint help its situation largely.
> 
> 
> In addition, As far as I know, typical DTrace user don't use dynamic 
> tracing feature at all.
> They think they don't know how choice proper probe point for dynamic tracing.
> They repeatedly strongly hope to increase well defined static probe point. they
> think dynamic trace feature is too hard to use.
> 
> I also strongly dislike random place tracepoint. but I don't think this patch
> series is random.
> and I think other asynchronous processing subsystem need static tracepoint.

OK.

It's quite unclear to me how we get from here to a situation where we
have something which your administrator can use.  Hopefully someone
some day will pull all this together into an overall integrated
toolset.  The fact that the kernel work is being done (afaict)
waaaaaaaay in advance of that development means that we'll probably
have to revist the kernel work.  So be it.

But your administrator wouldn't even know to go looking at workqueues! 
Unless the userspace support tools are very very good.  He might
instead spend hours poking at the sleep-tracer or the rwsem-tracer or
the slow-work-tracer or blah blah.

I expect that a generic function-entry tracer (which we already have)
would be the starting tool for diagnosing such a problem.  Probably it
would be the ending tool too.

What's the terminal state here?  The end result?  I see lots of random
somewhat-useless-looking tracers being added, but what are we actually
working towards?

Until we know that, how do we know that we're not adding stuff
which we won't need (as I suspect we are doing)?
