Return-Path: <linux-kernel-owner+w=401wt.eu-S1752643AbXCIIda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbXCIIda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 03:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbXCIId3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 03:33:29 -0500
Received: from waste.org ([66.93.16.53]:32850 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbXCIId2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 03:33:28 -0500
Date: Fri, 9 Mar 2007 02:20:57 -0600
From: Matt Mackall <mpm@selenic.com>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: 2.6.21-rc3-mm1 RSDL results
Message-ID: <20070309082057.GB10394@waste.org>
References: <20070309053931.GA10459@waste.org> <200703091728.03978.kernel@kolivas.org> <20070309075358.GA10394@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309075358.GA10394@waste.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2007 at 01:53:58AM -0600, Matt Mackall wrote:
> On Fri, Mar 09, 2007 at 05:28:03PM +1100, Con Kolivas wrote:
> > On Friday 09 March 2007 16:39, Matt Mackall wrote:
> > > First off, let me say that I think your approach has great promise,
> > > but I'm afraid it doesn't work so well here yet.
> > >
> > > Box is an R51 Thinkpad, 1.7GHz Pentium M. I'm using a make -j 5 as a
> > > test load.
> > >
> > > With 2.6.21-rc2-mm2, I get slightly sluggish response for opening new
> > > terminals, scrolling in Galeon, and a bit jerky behaviour for spinning
> > > Beryl's 3D desktop. Playing MP3s off an sshfs FUSE mount works fine.
> > > Typing across ssh sessions has no noticeable lag. Mouse pointer
> > > movement is smooth.
> > >
> > > With 2.6.21-rc3-mm1, terminals take longer to open, Galeon is
> > > noticeably more sluggish, and Beryl's desktop switching goes from being
> > > jerky to a 5-second agony. Typing in shells, remote or not,
> > > lags noticeably. Mouse pointer is alternately smooth or jerky. But
> > > MP3s still work great!
> > >
> > > Problems persist with make -j 2 and make.
> > 
> > make -j5 sucks you'll get precisely 1/6th cpu for galeon with this scheduler 
> > which is perfectly fair and I make no apology for it, nor do I plan to 
> > optimise for it. With make (without jobs) you'll still only get 50% cpu so it 
> > should be precisely half speed unless you nice it. Does it feel precisely 
> > half speed? It's supposed to. This is one of the drawbacks of a perfectly 
> > fair approach; its... fair and will need more liberal use of nice.
> 
> Well then I suppose something must be broken. When my box is idle, I
> can grab my desktop and spin it around and generate less than 25% CPU
> with the CPU stepped all the way down from 1.7GHz to 600MHz (Beryl is
> actually much snappier than many conventional window managers by doing
> just about everything through GL). By comparison, grabbing the Galeon
> scroll bar and wiggling it will generate 100% CPU (still throttled
> though) but remain relatively smooth.
> 
> With a single non-parallel make running (all in cache, mind you), the
> system kicks up into just about 100% CPU usage at full speed. Desktop
> spinning becomes between 10x to 100x slower (from ~30fps to < 1fps).
> Galeon scrolling pauses for as much as a second. Mouse movement pauses
> for as much as a second. Typing in terminals lags noticeably.
> 
> This is not the expected behavior of a fair, low-latency scheduler.
> 
> For reference, this was with HZ=250, PREEMPT, PREEMPT_BKL, and !NO_HZ.

And I've just rebooted with NO_HZ and things are greatly improved. At
idle, Beryl effects are silky smooth (possibly better than stock) and
shows less load. Under 'make', Beryl is still responsive as is Galeon.
No sign of lagging mouse or typing.

Under make -j 5, things are intermittent. Galeon scrolling is
sometimes still responsive, but Beryl, terminals and mouse still drag
quite a bit.

-- 
Mathematics is the supreme nostalgia of our time.
