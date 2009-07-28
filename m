Return-Path: <linux-kernel-owner+w=401wt.eu-S1754305AbZG1OFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305AbZG1OFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZG1OFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:05:08 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:63171 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZG1OFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:05:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqEEAD+hbkpMQWXi/2dsb2JhbACBUdJRhAwF
Date: Tue, 28 Jul 2009 10:04:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, prasad@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 5/5] perfcounter: Add support for kernel hardware
	breakpoints
Message-ID: <20090728140459.GA30412@Krystal>
References: <c62985530907240702h2b2de14bw2f0d475f46067e4e@mail.gmail.com> <1248445569.6987.74.camel@twins> <20090724174723.GA11985@nowhere> <1248519416.5780.12.camel@laptop> <20090725141918.GA5295@nowhere> <1248538972.5780.25.camel@laptop> <20090725235702.GA5082@in.ibm.com> <1248684817.6987.1573.camel@twins> <20090728010349.GB5147@nowhere> <1248765877.6987.2754.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1248765877.6987.2754.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:49:34 up 150 days, 10:15,  3 users,  load average: 1.02, 0.97,
	0.74
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (a.p.zijlstra@chello.nl) wrote:
> On Tue, 2009-07-28 at 03:03 +0200, Frederic Weisbecker wrote:
> > > Thirdly, we can multiplex perf counters beyond their hardware maximum,
> > > something you simply cannot do for a debug interface.
> > 
> > 
> > Again, I'm stuck in what you mean by multiplexing here :-)
> 
> If you'd create say 16 breakpoint counters, we'd RR them over the 4
> available hardware breakpoints (or less when others are taken by someone
> else).
> 
> Since its all statistics anyway, we can simply scale the event counts up
> by the time-share they received.
> 

Although hw breakpoint and performance counters could be multiplexed to
be used in RR for profiling, I fear using these for tracing does not
necessarily fit well with these statistical artefacts.

Therefore I'd recommend leaving such bp RR as a feature separate from
a low-level breakpoint API, because it seem only useful to profilers.

I think we all have our very precise use-case in mind, and this is what
makes discussion so difficult. So, for my point of view (tracing), I'd
like to be able to set performance counters and breakpoints both
monitoring userspace and kernel. The userspace breakpoints would be
exchanged when a different process is scheduled.

I see 2 complementary ways to collect data into the trace:

- triggering an interrupt each X hardware events, trace this interrupt.
- reading the performance counter value at tracepoints identifying
  execution context change (e.g. system call entry/exit, interrupt
  entry/exit...)

As you see, none of these 2 ways to gather trace data allow statistical
RR. Therefore, having this feature in the low-level API does not seem to
make sense for tracing.

So if other use-cases could be explained, maybe we can factor out the
common interfaces.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
