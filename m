Return-Path: <linux-kernel-owner+w=401wt.eu-S1757504AbXKCSQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbXKCSQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 14:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXKCSQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 14:16:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38562 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbXKCSQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 14:16:47 -0400
Date: Sat, 3 Nov 2007 19:16:42 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 5/6] sched: SCHED_FIFO/SCHED_RR watchdog timer
Message-ID: <20071103181641.GA7914@one.firstfloor.org>
References: <20071031211030.310581000@chello.nl> <20071031211249.531637000@chello.nl> <p73fxzr2bv4.fsf@bingen.suse.de> <1193868208.5911.3.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193868208.5911.3.camel@lappy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 11:03:28PM +0100, Peter Zijlstra wrote:
> 
> On Wed, 2007-10-31 at 22:49 +0100, Andi Kleen wrote:
> > Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> > 
> > > Introduce a new rlimit that allows the user to set a runtime timeout
> > > on real-time tasks. Once this limit is exceeded the task will receive
> > > SIGXCPU.
> > 
> > Nice idea.
> > 
> > It would be even nicer if you could allow a couple of them. Partition
> > the RT priorities into a few classes and have an own limit for each them.
> > 
> > A small number of classes (3-4) would be probably enough and not bloat
> > the rlimits too much.
> > 
> > I'm thinking of the case where you have different kinds of real
> > time processes. Like your mp3 player which you want to be slightly
> > real time, but with a low SIGXCPU limit. 
> > 
> > And then something else real time which is more important and
> > you would set a higher limit. etc.
> 
> But its an rlimit, it can be set per process. Not sure what multiple

That's impractical -- you would need to patch the process or call
it from a special program, which is not nice.

rlimits are useful to set a limit during log in. For that the
children can be all kinds of different processes and possibly use
different settings.

> classes per process would gain us, let alone how that process has to
> figure out which class to use.

You set the classes once per rlimit (e.g. in a pam module)
Then the processes set different scheduling priorities by themselves
(standard programs do that). Then that priority would map to a different
class.

-Andi

