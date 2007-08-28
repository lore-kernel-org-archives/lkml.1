Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbXH1H2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbXH1H2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 03:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXH1H2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 03:28:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:43498 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753165AbXH1H2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 03:28:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19AGBgdzilApB0XvmosBIkoD/Q4fw5yZrfuRDV1c/
	cmVfuQxVfAh0Nh
Subject: Re: CFS review
From: Mike Galbraith <efault@gmx.de>
To: Al Boldi <a1426z@gawab.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200708280823.53663.a1426z@gawab.com>
References: <200708111344.42934.a1426z@gawab.com>
	 <200708280737.53439.a1426z@gawab.com>
	 <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
	 <200708280823.53663.a1426z@gawab.com>
Content-Type: text/plain
Date: Tue, 28 Aug 2007 09:28:17 +0200
Message-Id: <1188286097.6317.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-28 at 08:23 +0300, Al Boldi wrote:
> Linus Torvalds wrote:
> > On Tue, 28 Aug 2007, Al Boldi wrote:
> > > No need for framebuffer.  All you need is X using the X.org vesa-driver.
> > > Then start gears like this:
> > >
> > >   # gears & gears & gears &
> > >
> > > Then lay them out side by side to see the periodic stallings for ~10sec.
> >
> > I don't think this is a good test.
> >
> > Why?
> >
> > If you're not using direct rendering, what you have is the X server doing
> > all the rendering, which in turn means that what you are testing is quite
> > possibly not so much about the *kernel* scheduling, but about *X-server*
> > scheduling!
> >
> > I'm sure the kernel scheduler has an impact, but what's more likely to be
> > going on is that you're seeing effects that are indirect, and not
> > necessarily at all even "good".
> >
> > For example, if the X server is the scheduling point, it's entirely
> > possible that it ends up showing effects that are more due to the queueing
> > of the X command stream than due to the scheduler - and that those
> > stalls are simply due to *that*.
> >
> > One thing to try is to run the X connection in synchronous mode, which
> > minimizes queueing issues. I don't know if gears has a flag to turn on
> > synchronous X messaging, though. Many X programs take the "[+-]sync" flag
> > to turn on synchronous mode, iirc.
> 
> I like your analysis, but how do you explain that these stalls vanish when 
> __update_curr is disabled?

When you disable __update_curr(), you're utterly destroying the
scheduler.  There may well be a scheduler connection, but disabling
__update_curr() doesn't tell you anything meaningful.  Basically, you're
letting all tasks run uninterrupted for just as long as they please
(which is why busy loops lock your box solid as a rock).  I'd suggest
gathering some sched_debug stats or something... shoot, _anything_ but
what you did :)

	-Mike

