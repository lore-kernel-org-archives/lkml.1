Return-Path: <linux-kernel-owner+w=401wt.eu-S1758081AbYFMOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758081AbYFMOl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 10:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYFMOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 10:41:48 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:39411 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYFMOlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 10:41:47 -0400
Message-Id: <48524EE30200005A00038BA7@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 13 Jun 2008 08:41:39 -0600
From: "Gregory Haskins" <GHaskins@novell.com>
To: <a.p.zijlstra@chello.nl>, <dmitry.adamushko@gmail.com>
Cc: <mingo@elte.hu>, <rostedt@goodmis.org>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize
	non-migratabletasks over migratable ones"
References: <48524EDA0200005A00038BA4@sinclair.provo.novell.com>
 <48524EE30200005A00038BA7@sinclair.provo.novell.com>
In-Reply-To: <48524EE30200005A00038BA7@sinclair.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for topposting....still on vaca via blackberry..

I am in favor of dropping too...this patch was really just an RFC in response to Dmity's observation....its probably too premature to include this type of thing, if ever at all..

-Greg 
-----Original Message-----
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Gregory Haskins <GHaskins@novell.com>
Cc:  <linux-kernel@vger.kernel.org>

Sent: 6/13/2008 7:08:04 AM
Subject: Re: [sched-devel, patch-rfc] rework of "prioritize non-migratabletasks over migratable ones"

On Wed, 2008-06-11 at 12:05 +0200, Dmitry Adamushko wrote:
> 2008/6/11 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> > On Wed, 2008-06-11 at 00:58 +0200, Dmitry Adamushko wrote:
> >> Hi Gregory,
> >>
> >>
> >> regarding this commit: 45c01e824991b2dd0a332e19efc4901acb31209f
> >>
> >>
> >> I think we can do it simpler. Please take a look at the patch below.
> >>
> >> Instead of having 2 separate arrays (which is + ~800 bytes on x86_32 and twice so on x86_64),
> >> let's add "exclusive" (the ones that are bound to this CPU) tasks to the head of the queue
> >> and "shared" ones -- to the end.
> >>
> >> In case of a few newly woken up "exclusive" tasks, they are 'stacked' (not queued as now), meaning that
> >> a task {i+1} is being placed in front of the previously woken up task {i}. But I don't think that
> >> this behavior may cause any realistic problems.
> >
> > Doesn't this violate POSIX ?
> >
> 
> If so, then the idea of "prioritize non-migratable tasks over
> migratable ones" violates it, not just an artefact of this particular
> implementation.
> 
> No matter which implementation is used, we have a situation when a
> woken-up single-CPU-bound task (let's call it 'p') can preempt a
> current task with effects as follows:
> 
> - 'current' is not guaranteed to get another CPU;
> 
> - there might have been other pending tasks (of equal prio) on this
> queue. As a result, 'p' starts running before them violating currently
> used (explicitly requested by POSIX?) round-robin behavior.

> We may just consider dropping this idea completely.
> (my 0.02$)

If we cannot guarantee POSIX compliant scheduling I think we should get
rid of this.


