Return-Path: <linux-kernel-owner+w=401wt.eu-S1755814AbZDYCAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814AbZDYCAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 22:00:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZDYCAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 22:00:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:58054 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZDYCAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 22:00:23 -0400
Date: Fri, 24 Apr 2009 22:00:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, zhaolei@cn.fujitsu.com,
       mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com, tzanussi@gmail.com,
       linux-kernel@vger.kernel.org, oleg@redhat.com
Subject: Re: [PATCH 0/4] workqueue_tracepoint: Add worklet tracepoints for
 worklet lifecycle tracing
In-Reply-To: <20090424182821.8263f445.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0904242149150.24293@gandalf.stny.rr.com>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49E8282A.6010004@cn.fujitsu.com> <49E82CA7.2040606@cn.fujitsu.com> <20090417134557.GA23493@elte.hu> <49F1A59B.3080206@cn.fujitsu.com>
 <20090424130616.a3c217cb.akpm@linux-foundation.org> <20090424225909.GA6658@nowhere> <20090424162056.45907fef.akpm@linux-foundation.org> <20090425003702.GC6658@nowhere> <20090424182821.8263f445.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 24 Apr 2009, Andrew Morton wrote:

> On Sat, 25 Apr 2009 02:37:03 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > I discovered it with this tracer. Then it brought me to
> > write this patch:
> > 
> > http://lkml.org/lkml/2009/1/31/184
> > 
> > ...
> > 
> > Still with these same observations, I wrote this another one:
> > 
> > http://lkml.org/lkml/2009/1/26/363
> 
> OK, it's great that you're working to improve the workqueue code.  But
> does this justify permanently adding debug code to the core workqueue
> code?  In fact, because you've discovered these problem, the reasons
> for adding the debug code have lessened!
> 
> What we need are curious developers looking into how well subsystems
> are performing and how well callers are using them.  Adding fairly
> large amounts of permanent debug code into the core subsystems is a
> peculiar way of encouraging such activity.
> 
> If a developer is motivated to improve (say) workqueues then they will
> write a bit of ad-hoc code, or poke at it with systemtap or will
> maintain a private ftrace patch - that's all pretty simple stuff for
> such people.
> 
> So what is the remaining case for adding these patches?  What I see is
> 
> a) that their presence will entice people to run them and maybe find
>    some problems and
> 
> b) the workqueue-maintainer's task is lessened a bit by not having
>    to forward-port his debugging patch.
> 
> I dunno, it all seems a bit thin to me.  Especially when you multiply
> it all by nr_core_subsystems?

I agree that we need to be frugal with the addition of trace points. But 
I don't think the bugs that can be solved with this is always reproducible 
by the developer.

If you have a distribution kernel that is running at a customers location, 
you may not have the privilege of shutting down that kernel, patching the 
code, recompiling and booting up this temporary kernel. It would be nice 
to have strategic locations in the kernel where we can easily enable a 
trace point and monitor what is going on.

If the customer calls and tells you there's some strange performance 
issues when running such and such a load, it would be nice to look at 
things like workqueues to analyze the situation.

Point being, the events are not for me on the box that runs my machines.
Hell, I had Logdev for 10 years doing that for me. But now to have 
something that is running at a customers site with extremely low overhead 
that we can enable when problems arise. That is what makes this worth 
while.

Note, when I was contracting, I even had logdev prints inside the 
production (custom) kernel that I could turn on and off. This was exactly 
for this purpose. To monitor what is happening inside the kernel when in 
the field.

-- Steve

