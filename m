Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbXCAMPE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbXCAMPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:15:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933259AbXCAMPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:15:04 -0500
Received: from www.osadl.org ([213.239.205.134]:53673 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933254AbXCAMPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:15:01 -0500
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200703012305.53997.kernel@kolivas.org>
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org>
	 <200703012213.25629.kernel@kolivas.org>
	 <1172748837.11473.53.camel@localhost.localdomain>
	 <200703012305.53997.kernel@kolivas.org>
Content-Type: text/plain
Date: Thu, 01 Mar 2007 13:20:42 +0100
Message-Id: <1172751642.11473.57.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 23:05 +1100, Con Kolivas wrote:
> > > And that's the depressing part because of course I was interested in that
> > > as the original approach to the problem (and it was a big problem). When
> > > I spoke to Intel and AMD (of course to date no SMT AMD chip exists) at
> > > kernel summit they said it was too hard to implement hardware priorities
> > > well. Which is real odd since IBM have already done it with Power...
> > >
> > > Still I think it has been working fine in software till now, but now it
> > > has to deal with the added confusion of dynticks, so I already know what
> > > will happen to it.
> >
> > Well, it's not a dyntick problem in the first place. Even w/o dynticks
> > we go idle with local_softirq_pending(). Dynticks contains an explicit
> > check for that, which makes it visible.
> 
> Oops I'm sorry if I made it sound like there's a dynticks problem. That was 
> not my intent and I said as much in an earlier email. Even though I'm finding 
> myself defending code that has already been softly tagged for redundancy, 
> let's be clear here; we're talking about at most a further 70ms delay in 
> scheduling a niced task in the presence of a nice 0 task, which is a 
> reasonable delay for ksoftirqd which we nice the eyeballs out of in mainline. 
> Considering under load our scheduler has been known to cause scheduling 
> delays of 10 seconds I still don't see this as a bug. Dynticks just "points 
> it out to us".

Well, dyntick might end up to delay it for X seconds as well, which _is_
observable and that's why the check was put there in the first place.

	tglx


