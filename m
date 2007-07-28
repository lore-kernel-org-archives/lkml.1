Return-Path: <linux-kernel-owner+w=401wt.eu-S1755027AbXG1FBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027AbXG1FBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXG1FBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:01:46 -0400
Received: from mail.suse.de ([195.135.220.2]:38211 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbXG1FBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:01:45 -0400
Date: Sat, 28 Jul 2007 07:01:41 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Chris Snook <csnook@redhat.com>
Cc: tim.c.chen@linux.intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: pluggable scheduler thread (was Re: Volanomark slows by 80% under CFS)
Message-ID: <20070728050141.GC31622@v2.random>
References: <1185573687.19777.44.camel@localhost.localdomain> <46AA8E57.8010105@redhat.com> <20070728005920.GA31622@v2.random> <46AABB5B.3030702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46AABB5B.3030702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 11:43:23PM -0400, Chris Snook wrote:
> I'm pretty sure the point of posting a patch that triples CFS performance 
> on a certain benchmark and arguably improves the semantics of sched_yield 
> was to improve CFS.  You have a point, but it is a point for a different 
> thread.  I have taken the liberty of starting this thread for you.

I've no real interest in starting or participating in flamewars
(especially the ones not backed by hard numbers). So I adjusted the
subject a bit in the hope the discussion will not degenerate as you
predicted, hope you don't mind.

I'm pretty sure the point of posting that email was to show the
remaining performance regression with the sched_yield fix applied
too. Given you considered my post both offtopic and inflammatory, I
guess you think it's possible and reasonably easy to fix that
remaining regression without a pluggable scheduler, right? So please
enlighten us on your intend to achieve it.

Also consider the other numbers likely used nptl so they shouldn't be
affected by sched_yield changes.

> Sure there is.  We can run a fully-functional POSIX OS without using any 
> block devices at all.  We cannot run a fully-functional POSIX OS without a 
> scheduler. Any feature without which the OS cannot execute userspace code 
>  is sufficiently primitive that somewhere there is a device on which it will 
> be impossible to debug if that feature fails to initialize.  It is quite 
> reasonable to insist on only having one implementation of such features in 
> any given kernel build.

Sounds like a red-herring to me... There aren't just pluggable I/O
schedulers in the kernel, there are pluggable packet schedulers too
(see `tc qdisc`). And both are switchable at runtime (not just at boot
time).

Can you run your fully-functional POSIX OS without a packet scheduler
and without an I/O scheduler? I wonder where are you going to
read/write data without HD and network?

Also those pluggable things don't increase the risk of crash much, if
compared to the complexity of the schedulers.

> Whether or not these alternatives belong in the source tree as config-time 
> options is a political question, but preserving boot-time debugging 
> capability is a perfectly reasonable technical motivation.

The scheduler is invoked very late in the boot process (printk and
serial console, kdb are working for ages when scheduler kicks in), so
it's fully debuggable (no debugger depends on the scheduler, they run
inside the nmi handler...), I don't really see your point.

And even if there would be a subtle bug in the scheduler you'll never
trigger it at boot with so few tasks and so few context switches.
