Return-Path: <linux-kernel-owner+w=401wt.eu-S965722AbYD1TxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965722AbYD1TxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964884AbYD1TxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:53:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57268 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964846AbYD1TxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:53:05 -0400
Subject: Re: [patch 00/37] Linux Kernel Markers instrumentation for
	sched-devel.git
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080428113610.b2d1e8e4.akpm@linux-foundation.org>
References: <20080424150324.802695381@polymtl.ca>
	 <1209238735.6441.4.camel@lappy>
	 <20080428113610.b2d1e8e4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 21:52:39 +0200
Message-Id: <1209412359.6433.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-28 at 11:36 -0700, Andrew Morton wrote:
> On Sat, 26 Apr 2008 21:38:54 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Thu, 2008-04-24 at 11:03 -0400, Mathieu Desnoyers wrote:
> > > Hi Ingo,
> > > 
> > > Here is a rather large patchset applying kernel instrumentation to
> > > sched-devel.git. It includes, mainly :
> > 
> > I saw this land in sched-devel, how about this:
> > 
> > ---
> > Subject: sched: de-uglyfy marker impact
> > 
> > These trace_mark() things look like someone puked all over the code,
> 
> lol.

Glad to lighten your day a little ;-)

> > lets hide the ugly bits.
> 
> It hides the cosmetically-ugly bits, but not the deeply ugly: each of these
> trace points is an extension to the kernel->userspace API, with all that
> this implies.

Agreed, and I'm rather concerned about that as well. OTOH its very
unlikely we'll ever have a Linux that will not have a context switch, or
task wakeup operation.

So tracing these and things like syscall seem safe enough to do -
although I wish it wouldn't look so ugly. 

As for some of these other trace points in this set, dubious.

We can of course clearly state that any marker is free of API
constraints and users will have to cope with them changing. But I'm not
sure that's a realistic position.

> > +static inline
> > +void trace_kernel_sched_wakeup(struct rq *rq, struct task_struct *p)
> 
> When doing this please put the newline immediately preceding the function
> name.  Putting it between the `inline' and the return-type-declaration is
> weird.

Sure. Just to clarify my rationale, I like to keep the return type on
the same line when possible so you get a complete picture - the static
and inline qualifiers seem less important, but I don't particularly
care.



