Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYG2RCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYG2RCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYG2RCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:02:07 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:50045 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750933AbYG2RCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:02:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0GAGDqjkhMRKxB/2dsb2JhbACBW4lEpVI
Date: Tue, 29 Jul 2008 13:01:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Avi Kivity <avi@qumranet.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       systemtap-ml <systemtap@sources.redhat.com>,
       linux-btrace@vger.kernel.org
Subject: Re: [RFC] LTTng merge plan
Message-ID: <20080729170151.GA24851@Krystal>
References: <20080717155724.897537670@polymtl.ca> <48862A30.7050701@qumranet.com> <y0mabg991c3.fsf@ton.toronto.redhat.com> <488635A7.2030609@qumranet.com> <20080722221204.GA14661@Krystal> <488C49CC.8040800@qumranet.com> <20080728005405.GA7941@Krystal> <20080729161836.GA10751@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080729161836.GA10751@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:56:07 up 54 days, 21:37,  5 users,  load average: 1.04, 1.45,
	1.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Hi, Mathieu -
> 
> > [...]
> > Currently, [my merge plan] looks like :
> > 
> > In Ingo's trees :
> > - Tracepoints, scheduler tracepoints instrumentation, ftrace port to
> >   tracepoints
> >   - Should make it into 2.6.27 since ftrace needs those.
> > [...]
> 
> This is the tracepoints infrastructure, and ...
> 
> > Short-term submission plan
> > 
> > In LTTng patchset
> > (http://ltt.polymtl.ca/lttng/patch-2.6.26-0.12.tar.bz2)
> > 
> > - Instrumentation
> >   - LTTng tracepoints
> >     - Used by LTTng, SystemTAP and usable specialized probes.
> > [...]
> 
> ... this is the "meat", which includes both the tracepoints
> and the the tracepoint-to-marker conversion modules, such as those in
> "lttng-instrumentation-*-tracepoint-probes.patch", right?
> 
> - FChE

Exactly. The tracepoint-to-markers conversion modules bridge between
the in-kernel API (tracepoints) which declares standard location for
kernel instrumentation and user-space visible "markers", so that there
is an indirection level between the instrumented kernel code and what is
visible from userspace.

For instance, we have

in kernel/sched.c:context_switch()
  trace_sched_switch(rq, prev, next);

Which exports a struct rq * and two struct task_struct *. They are used
by both ftrace, which needs access to these data structures, and by the
LTTng probes, which extracts the previous PID and state (running,
waiting..) and next PID to be scheduled in.

Basically, these modules turn the data exported by tracepoints,
meaningful only to kernel modules, into data useful for userspace trace
analysis.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
