Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYGZNPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYGZNPv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 09:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751989AbYGZNPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 09:15:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43421 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYGZNPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 09:15:30 -0400
Date: Sat, 26 Jul 2008 09:15:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] ftrace: single CPU tracers use CPU clock
In-Reply-To: <20080726124058.GD20713@elte.hu>
Message-ID: <Pine.LNX.4.58.0807260905500.12953@gandalf.stny.rr.com>
References: <20080725220040.911370182@goodmis.org> <20080725220334.781928198@goodmis.org>
 <20080726124058.GD20713@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 26 Jul 2008, Ingo Molnar wrote:

>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > The current ftrace clock uses the sched_clock.c code. This code tries
> > to handle cases where the TSC is out of sync between different CPUs.
> > Unfortunately, even with insync TSCs, due to drifts between the CPU
> > clock and the GTOD clock, we might get some inaccuracy in a single CPU
> > trace.
> >

[...]

>
> this is not a good idea. We want to fix cpu_clock(), not work around any
> deficiencies it might have.

cpu_clock currently is "sched_clock" when the
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK is not set. Which is done via configuration,
and I noticed is set on my boxes with a stable TSC??

Perhaps we need to make cpu_clock change dynamically when an unstable
sched_clock is detected.

Even in this case, forcing the tracers that are single CPU to use a clock
source that modifies itself to try to look stable across CPUs still seems
wrong to me.  The goal of looking stable across CPUs will always be at odds
with the irqsoff tracer that does not care about other CPUS but cares
tremendously about accurate latencies.

-- Steve
