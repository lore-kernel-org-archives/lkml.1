Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZBKMx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZBKMx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 07:53:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZBKMxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 07:53:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45544 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbZBKMxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 07:53:48 -0500
Date: Wed, 11 Feb 2009 13:53:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86-tip.today: flood of WARNING: at include/linux/sched.h:2238
	run_posix_cpu_timers+0xea/0x79f()
Message-ID: <20090211125340.GK16535@elte.hu>
References: <1233910614.23431.18.camel@marge.simson.net> <20090206140134.GC3415@elte.hu> <1234280251.23438.73.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234280251.23438.73.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-02-06 at 15:01 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > Greetings,
> > > 
> > > Futzing with kerneltop this morning, I fired up amarok to give it
> > > something light to monitor while I hunt missing events.  Something bad
> > > happened, and when I finally (SysRq-E took minutes) got control of box
> > > back, dmesg was full of a steady stream of the below.
> > > 
> > > That warning can be kinda unfriendly.
> > > 
> > > 
> > > [ 9964.600004] ------------[ cut here ]------------
> > > [ 9964.600006] WARNING: at include/linux/sched.h:2238 run_posix_cpu_timers+0xea/0x79f()
> > 
> > ah, that's Peter's stuff:
> > 
> >  4cd4c1b: timers: split process wide cpu clocks/timers
> >  32bd671: signal: re-add dead task accumulation stats.
> > 
> > The discussion with Oleg resulted in the conclusion i 
> > think that the warning is spurious and should be removed.
> > 
> > I've commited the minimal fix below to tip:master. There's
> > more fixes needed too but this should solve the warning
> > flood at least.
> 
> I think this is the 'minimal' paranoia version.

applied to tip:timers/urgent, thanks Peter!

	Ingo
