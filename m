Return-Path: <linux-kernel-owner+w=401wt.eu-S1761666AbZLJVNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761666AbZLJVNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 16:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761580AbZLJVNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 16:13:35 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9744 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbZLJVNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 16:13:35 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN936eMzz1202hzzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B216478.3080601@am.sony.com>
Date: Thu, 10 Dec 2009 13:13:28 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] ftrace - add function_duration tracer
References: <4B202778.4030801@am.sony.com> <20091210070800.GB16874@elte.hu>
In-Reply-To: <20091210070800.GB16874@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Dec 2009 21:13:29.0850 (UTC) FILETIME=[9F2955A0:01CA79DD]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tim Bird <tim.bird@am.sony.com> wrote:
> 
>> Add function duration tracer.
>>
>> Signed-off-by: Tim Bird <tim.bird@am.sony.com>
>> ---
>>  kernel/trace/Kconfig          |    8
>>  kernel/trace/Makefile         |    1
>>  kernel/trace/trace.c          |   32 ++
>>  kernel/trace/trace_duration.c |  527 ++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 568 insertions(+)
> 
> Please do it in a cleaner an more generic fashion: add a "function 
> event" that perf can see and process, so all the output embellishment 
> can be done outside of the kernel, in tools/perf/.

Sigh.  OK - where's the perf code?

It took me a while to wrap my head around ftrace, so if I've
got to switch to a completely different event-ing infrastructure,
it will probably be some time before I'm back again.

I have some patches to add function graph tracing for
ARM, and to make it possible to use arbitrary ftrace plugins
at boot time.  (There are issues with the current code for
anything other than the bootgraph plugin).

Are either of these still interesting?

I was about to start work on dynamic ftrace support for ARM.
What is the status of this?

> We want to wind down the current maze of ftrace plugins, not extend 
> them. We already obsoleted the following ftrace plugins: scheduler, 
> sysprof, blktrace, kmem, scheduler, etc. There's more work ongoing and 
> broad agreement between folks developing it that this is the way 
> forward.

It looks like all the tracers mentioned above are still in 2.6.32,
which was just released. In what sense are they "already obsoleted"?

In what time frame will the ftrace plugin feature be obsoleted?
I'm using this code on 2.6.29 for a variety of Sony products.
If the ftrace plugin stuff isn't going away for another year
or two that gives me several years of utility with the current
code (which I recognize I'd have to maintain myself out-of-tree).

Once things have settled down and you guys have figured out
for sure what's going on, I could come back and try to integrate
these features into perf.  As it stands now, I'm a little wary
of putting much effort into that.

Where are these things discussed?  Only on LKML?  It would be
handy if there were a separate list that could get CC-ed for
ftrace stuff, so I could monitor it more easily for big movements
like this.  I apologize if there is and I've just missed it.

> The function tracer / function graph tracer is a holdout due to its 
> complexity - but that by no means weakens the argument and the necessity 
> to migrate it.
> 
> ftrace plugins were a nice idea originally and a clear improvement over 
> existing alternatives, but now that we've got a technicaly superior, 
> unified event framework that can do what the old plugins did and much 
> more, we want to improve that and not look back ...

I'm a little worried about this.  ftrace is already an order
of magnitude more overhead than the previous tracer I was using.
I don't have ANY experience with perf, but if you're using it
for tracing, that already seems one step removed from it's
original use for reporting performance counters.  The complexity
described in the discussion related to this thread does not
raise my hopes that it will meet my needs.

I guess I'll have to start looking at perf to see if my
concerns are justified.  But first, I've got to get the mainline
kernel booting again on my embedded hardware.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

