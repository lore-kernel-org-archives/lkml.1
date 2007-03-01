Return-Path: <linux-kernel-owner+w=401wt.eu-S964964AbXCAMH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964964AbXCAMH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 07:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965031AbXCAMH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 07:07:26 -0500
Received: from mail09.syd.optusnet.com.au ([211.29.132.190]:40655 "EHLO
	mail09.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964964AbXCAMH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 07:07:26 -0500
From: Con Kolivas <kernel@kolivas.org>
To: tglx@linutronix.de
Subject: Re: 2.6.21-rc1: known regressions (v2) (part 2)
Date: Thu, 1 Mar 2007 23:05:53 +1100
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200703012213.25629.kernel@kolivas.org> <1172748837.11473.53.camel@localhost.localdomain>
In-Reply-To: <1172748837.11473.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703012305.53997.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 22:33, Thomas Gleixner wrote:
> On Thu, 2007-03-01 at 22:13 +1100, Con Kolivas wrote:
> > > if then there should be a mechanism /in the hardware/ to set the
> > > priority of a CPU - and then the hardware could decide how to
> > > prioritize between siblings. Doing this in software is really hard.
> >
> > And that's the depressing part because of course I was interested in that
> > as the original approach to the problem (and it was a big problem). When
> > I spoke to Intel and AMD (of course to date no SMT AMD chip exists) at
> > kernel summit they said it was too hard to implement hardware priorities
> > well. Which is real odd since IBM have already done it with Power...
> >
> > Still I think it has been working fine in software till now, but now it
> > has to deal with the added confusion of dynticks, so I already know what
> > will happen to it.
>
> Well, it's not a dyntick problem in the first place. Even w/o dynticks
> we go idle with local_softirq_pending(). Dynticks contains an explicit
> check for that, which makes it visible.

Oops I'm sorry if I made it sound like there's a dynticks problem. That was 
not my intent and I said as much in an earlier email. Even though I'm finding 
myself defending code that has already been softly tagged for redundancy, 
let's be clear here; we're talking about at most a further 70ms delay in 
scheduling a niced task in the presence of a nice 0 task, which is a 
reasonable delay for ksoftirqd which we nice the eyeballs out of in mainline. 
Considering under load our scheduler has been known to cause scheduling 
delays of 10 seconds I still don't see this as a bug. Dynticks just "points 
it out to us".

-- 
-ck
