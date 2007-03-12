Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbXCLUgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbXCLUgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 16:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752896AbXCLUgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 16:36:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:38906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752890AbXCLUgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 16:36:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+YArcpEwaYVt9VeCQo2x1BbIRovi0xxiP7mb+5Sa
	ZgX07UbE63031q
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Mike Galbraith <efault@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <1173697024.8014.19.camel@Homer.simpson.net>
	 <20070312110833.GA12835@elte.hu>  <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0703120808110.9690@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 21:36:51 +0100
Message-Id: <1173731811.6431.48.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 08:26 -0700, Linus Torvalds wrote:
> 
> On Mon, 12 Mar 2007, Mike Galbraith wrote:
> >
> > On Mon, 2007-03-12 at 22:23 +1100, Con Kolivas wrote:
> > 
> > > Mike the cpu is being proportioned out perfectly according to fairness as I 
> > > mentioned in the prior email, yet X is getting the lower latency scheduling. 
> > > I'm not sure within the bounds of fairness what more would you have happen to 
> > > your liking with this test case?
> > 
> > It has been said that "perfection is the enemy of good".  The two
> > interactive tasks receiving 40% cpu while two niced background jobs
> > receive 60% may well be perfect, but it's damn sure not good.
> 
> Well, the real problem is really "server that works on behalf of somebody 
> else".

Yes, exactly.  We have a disconnect.  The process consists of both.  If
either client or server doesn't get enough, the process is a failure.

> X is just the worst *practical* example of this, since not only is it the 
> most common such server, it's also a case where people see interactive 
> issues really easily.
> 
> And the problem is that a lot of clients actually end up doing *more* in 
> the X server than they do themselves directly. Doing things like showing a 
> line of text on the screen is a lot more expensive than just keeping track 
> of that line of text, so you end up with the X server easily being marked 
> as getting "too much" CPU time, and the clients as being starved for CPU 
> time. And then you get bad interactive behaviour.
> 
> So "good fairness" really should involve some notion of "work done for 
> others". It's just not very easy to do..

Purely from the interactivity side, I connected via a simple tag X as
TASK_INTERACTIVE thingy, and boosted the tasks it was waking.  Worked
for things like the heavy cpu visualizations while other things are
going on in the background.  It was full of evilness though.

	-Mike

