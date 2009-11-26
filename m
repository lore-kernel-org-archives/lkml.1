Return-Path: <linux-kernel-owner+w=401wt.eu-S1760548AbZKZOpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760548AbZKZOpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbZKZOpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:45:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61628 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbZKZOp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:45:26 -0500
Subject: Re: [tip:perf/core] events: Rename TRACE_EVENT_TEMPLATE() to
 DECLARE_EVENT_CLASS()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, penberg@cs.helsinki.fi, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091126084039.GA15919@elte.hu>
References: <4B0E286A.2000405@cn.fujitsu.com>
	 <tip-091ad3658e3c76c5fb05f65bfb64a0246f8f31b5@git.kernel.org>
	 <1259224390.21397.87.camel@gandalf.stny.rr.com>
	 <20091126084039.GA15919@elte.hu>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 26 Nov 2009 09:45:30 -0500
Message-Id: <1259246730.21397.97.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 09:40 +0100, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 

> > I would like to hear what others think about this change before we go 
> > ahead and implement it.
> 
> You mean TRACE_EVENT() -> DEFINE_SINGLE_EVENT()? Sure, we want todo it 
> in a more quiet moment of the kernel cycle, not now.
> 
> (TRACE_EVENT_TEMPLATE OTOH has existed for just a few days so it's not a 
> problem.)

Yes the template name is new, I'm not talking about that on
particularly.

> 
> > A lot of developers have just learned about TRACE_EVENT and now it 
> > just disappeared. Well, not really, but in the sense of ' find 
> > linux.git -name '*.[ch]' | xargs grep TRACE_EVENT' it no longer 
> > exists.
> 
> A second problem with the TRACE_EVENT name is that it's not just for 
> tracing - we dont necessarily 'trace' events here. We can use the event 
> callbacks to collect pure counts:

Then we might as well rename the "trace_*" all over the kernel.

> 
> | aldebaran> perf stat -e sched:sched_wakeup ./hackbench 10
> | Time: 0.093
> |
> |  Performance counter stats for './hackbench 10':
> |
> |           15481  sched:sched_wakeup      
> |
> |     0.107390574  seconds time elapsed
> 
> etc.

Right, because it hooked into a trace_point.

> 
> A third problem is that the name 'TRACE_EVENT' does not tell us what is 
> being done. Do we declare it? Do we also define it?

That's exactly the point. It does both. I actually tried to avoid the
"DEFINE/DECLARE" because it becomes confusing to what it does. The
TRACE_EVENT macros are obviously unique in the kernel. There are
"DECLARE_*" and "DEFINE_*" all over the kernel. And they have an obvious
meaning. DECLARE_* is used to set up a declaration for a header.
DEFINE_* creates the instance.  But TRACE_EVENT will default declare
event, but when CREATE_TRACE_POINTS is set, it defines the instances. Oh
we should rename that to CREATE_EVENTS?

> 
> DEFINE_SINGLE_EVENT() solves all these problems:
> 
>  - It's obvious what it does
> 
>  - It suggests users of it that there's another non-single-event 
>    facility, gently nudging them towards the use of the more efficient
>    DEFINE_EVENT_CLASS() + DEFINE_EVENT() method.
> 
>  - It fits nicely into the rest of the naming scheme.

Like I said earlier, I'm not really attached to the name. Except that
there's already a lot of documentation (I've given tutorials about it)
using the TRACE_EVENT name. But who am I to decide?

-- Steve


