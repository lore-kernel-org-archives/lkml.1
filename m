Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbYA1TBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbYA1TBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 14:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYA1TBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 14:01:23 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:35693 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYA1TBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 14:01:22 -0500
Date: Mon, 28 Jan 2008 14:00:55 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Max Krasnyanskiy <maxk@qualcomm.com>
cc: Paul Jackson <pj@sgi.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [CPUISOL] CPU isolation extensions
In-Reply-To: <479E2305.3040408@qualcomm.com>
Message-ID: <Pine.LNX.4.58.0801281358070.10419@gandalf.stny.rr.com>
References: <1201493382-29804-1-git-send-email-maxk@qualcomm.com>
 <1201511305.6149.30.camel@lappy> <20080128085910.7d38e9f5.pj@sgi.com>
 <20080128163450.GC12598@goodmis.org> <479E2305.3040408@qualcomm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 28 Jan 2008, Max Krasnyanskiy wrote:
> >>   [PATCH] [CPUISOL] Support for workqueue isolation
> >
> > The thing about workqueues is that they should only be woken on a CPU if
> > something on that CPU accessed them. IOW, the workqueue on a CPU handles
> > work that was called by something on that CPU. Which means that
> > something that high prio task did triggered a workqueue to do some work.
> > But this can also be triggered by interrupts, so by keeping interrupts
> > off the CPU no workqueue should be activated.

> No no no. That's what I though too ;-). The problem is that things like NFS and friends
> expect _all_ their workqueue threads to report back when they do certain things like
> flushing buffers and stuff. The reason I added this is because my machines were getting
> stuck because CPU0 was waiting for CPU1 to run NFS work queue threads even though no IRQs
> or other things are running on it.

This sounds more like we should fix NFS than add this for all workqueues.
Again, we want workqueues to run on the behalf of whatever is running on
that CPU, including those tasks that are running on an isolcpu.


>
> >>   [PATCH] [CPUISOL] Isolated CPUs should be ignored by the "stop machine"
> >
> > This I find very dangerous. We are making an assumption that tasks on an
> > isolated CPU wont be doing things that stopmachine requires. What stops
> > a task on an isolated CPU from calling something into the kernel that
> > stop_machine requires to halt?

> I agree in general. The thing is though that stop machine just kills any kind of latency
> guaranties. Without the patch the machine just hangs waiting for the stop-machine to run
> when module is inserted/removed. And running without dynamic module loading is not very
> practical on general purpose machines. So I'd rather have an option with a big red warning
> than no option at all :).

Well, that's something one of the greater powers (Linus, Andrew, Ingo)
must decide. ;-)


-- Steve

