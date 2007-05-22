Return-Path: <linux-kernel-owner+w=401wt.eu-S1762810AbXEVU56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbXEVU56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756353AbXEVU5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:57:49 -0400
Received: from hermes1.dur.ac.uk ([129.234.8.20]:35041 "EHLO hermes1.dur.ac.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756017AbXEVU5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:57:48 -0400
X-Greylist: delayed 923 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 May 2007 16:57:48 EDT
Date: Tue, 22 May 2007 21:42:22 +0100
From: Ash Milsted <thatistosayiseenem@gawab.com>
To: ck@vds.kolivas.org
Cc: linux-kernel@vger.kernel.org, ck list <ck@vds.kolivas.org>
Subject: Re: [ck] Re: [PATCH] mm: swap prefetch improvements
Message-Id: <20070522214222.8b197247.thatistosayiseenem@gawab.com>
In-Reply-To: <200705222037.54741.kernel@kolivas.org>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<200705222020.58474.kernel@kolivas.org>
	<20070522102530.GB2344@elte.hu>
	<200705222037.54741.kernel@kolivas.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-DurhamAcUk-MailScanner: Found to be clean, Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007 20:37:54 +1000
Con Kolivas <kernel@kolivas.org> wrote:

> On Tuesday 22 May 2007 20:25, Ingo Molnar wrote:
> > * Con Kolivas <kernel@kolivas.org> wrote:
> > > > > there was nothing else running on the system - so i suspect the
> > > > > swapin activity flagged 'itself' as some 'other' activity and
> > > > > stopped? The swapins happened in 4 bursts, separated by 5 seconds
> > > > > total idleness.
> > > >
> > > > I've noted burst swapins separated by some seconds of pause in my
> > > > desktop system too (with sp_tester and an idle gnome).
> > >
> > > That really is expected, as just about anything, including journal
> > > writeout, would be enough to put it back to sleep for 5 more seconds.
> >
> > note that nothing like that happened on my system - in the
> > swap-prefetch-off case there was _zero_ IO activity during the sleep
> > period.
> 
> Ok, granted it's _very_ conservative. I really don't want to risk its presence 
> being a burden on anything, and the iowait it induces probably makes it turn 
> itself off for another PREFETCH_DELAY (5s). I really don't want to cross the 
> line to where it is detrimental in any way. Not dropping out on a 
> cond_resched and perhaps making the delay tunable should be enough to make it 
> a little less "sleepy".
> 
> -- 
> -ck

Hi. I just did some video encoding on my desktop and I was noticing
(for the first time in a while) that running apps had to hit swap quite
a lot when I switched to them (the encoding was going at full blast for
most of the day, and most of the time other running apps were
idle). Now, a good half of my RAM appeared to be free during all this,
so I was thinking at the time that it would be nice if swap prefetch
could be tunably more aggressive. I guess it would be ideal in this
case if it could kick in during tunably low disk-IO periods, even if
the CPU is rather busy. I'm sure you've considered this, so I only butt
in here to cast a vote for it. :)

Of course, I could be completely wrong about the possibility.. and I
seem to remember that the disk cache can take up about half the ram by
default without this showing up in 'gnome-system-monitor'... which I
guess might happen during heavy encoding.. but even if it did, I could
have set the limit lower, and would then have still appreciated
prefetching.

Ash
