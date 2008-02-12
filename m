Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYBLTSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYBLTSZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:18:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYBLTSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:18:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49438 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbYBLTSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:18:13 -0500
Date: Tue, 12 Feb 2008 11:15:53 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       arjan@infradead.org, sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080212191552.GA20883@kroah.com>
References: <20080211203146.3d28d1a0@laptopd505.fenrus.org> <20080212044314.GA4888@kroah.com> <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <20080212174824.GA1919@kroah.com> <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121011280.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 10:26:53AM -0800, Linus Torvalds wrote:
> On Tue, 12 Feb 2008, Greg KH wrote:
> > 
> > I may be a bit defensive here, but I hope that all of the recent
> > kobject/kset/driver core changes have been done with the thought of
> > "what are we doing wrong".
> 
> .. but are we expecting it to be finished?

Nope, never.

> That's the point.

Not it isn't.  To quote you a number of years ago:
	"Linux is evolution, not intelligent design"

We need to constantly be able to make these kinds of changes in order to
continue to remain relevant.

> This whole "Linux-next" discussion so far has almost been predicated on 
> the whole assumption that this is an on-going concern. And it really 
> should NOT be.
> 
> If it's an on-going concern, we need to tackle *that* issue, not the issue 
> that cross-subsystem merges are hard. They simply seem to happen too much.
> 
> In other words, I'm not AT ALL interested in the merges we've already 
> done. That's over and done with, and we'll never ever do those merges 
> again. Who cares? I don't.
> 
> I'm purely and _only_ interested in the merges of the future. You don't 
> need to be defensive about the things that led up to this discussion, I'm 
> more hoping that we can aim at fixing the problem at the source, rather 
> than trying to work around it.
> 
> We simply shouldn't have all that many conflicts. We've had *way* too many 
> of them lately, and I think it's because people have felt it wasn't too
> painful. 

Oh, it's been painful at times, but they are, overall, very rare.

If you look at the rate of change we are currently running at, it's
amazing that we do not get _more_ of these kinds of problems.

Remember, we are currently clocking along at the steady rate of:
	4000 lines added every day
	1900 lines removed every day
	1300 lines modified every day

And the rate of change in each major portion of the kernel (drivers,
arch, core, network, etc) is exactly proportional to the amount of the
kernel that that portion takes up (I have detailed numbers if people
really want to see them.)

Because of this rate of change, we are surviving, and evolving into what
is exactly needed at this point in time from a kernel.  To try to quench
this change, and force us to stick with things that are no longer
optimal, is going to cause us to make the same mistakes that AIX and
Solaris and Vista have.  To stop this, is to die :)

> Put another way: back when we worked with just patches, we avoided renames 
> like hell, and we also tried to simply even re-architect the whole tree so 
> that you didn't have so many patch conflicts. One main reason as far as I 
> was concerned for things like per-directory Kconfig files and the whole 
> initcall() stuff was the fact that the old single Kconfig file and the old 
> crazy init/main.c file were total *nightmares* when it came to conflict 
> resolution.
> 
> So we split things up more, and we didn't do renames (or were very careful 
> about it). We avoided the things that caused pain.
> 
> I think we need to remember that: yes, we'll always have to have ways to 
> fix the pain that does happen, but even more importantly, we should strive 
> for models where it doesn't happen in the first place!

We have done very good at that.  The problem comes in when one subsystem
depends on another one.

Like the kobject core, or driver core.  Or network core.  Changes there
trickle out into the other portions of the kernel that depend on them.
And we fix them up, and move on.  And so far, we're doing this very
well, at a rate faster than any other software project ever has.

> And simply avoiding cross-subsystem API changes unless there is a major 
> *MAJOR* reason for them is the obvious thing to do. Simply face the fact 
> that even in open source there are major reasons to stay with an old 
> interface even if it's not optimal.

I strongly disagree here.  We lived with that kset/ktype crap for years,
and I finally broke down and cleaned it up, simplifying things, removing
code, making the kernel smaller, leaner, and easier for others to change
and use in the future.  With your statement, such a change should have
never taken place as it what we had at the time was "not optimal", but
good enough to live with.

> We absolutely MUST NOT have the mindset that "cross-subsystem conflicts 
> happen all the time". 

They usually don't, by virtue of our current development model and how
we have the kernel structured.

But they do happen about once or twice a kernel release, just by virtue
of the way things need to happen.  And since the last kernel had 10353
different commits, only 2 conflicts is a pretty good rate of merge
issues :)

And when they happen, so far _everyone_ involved instantly rushes to fix
them up.  I say the fact that we are able to detect these problems, fix
them, and continue to move on and work, is a testament to the fact that
our current model is working _very_ well.

I think that you aren't seeing all of the "whacks" that Andrew is
constantly giving us that break his -mm tree with problems at times, so
when it gets to you, things are cleaned up.

The goal of -next is to take that "whacking" chore off of Andrew's
shoulders, and onto others, so Andrew can move off doing something like
development better.

My point is that the -next tree needs to work like -mm does today, a
policy of "merge broke, drop the tree" isn't going to help us subsystem
maintainers out in the end, we need a way to shim it up for a while as
merges and other communication happens, just like -mm provides, so that
when we get to the 2 week merge window, things are properly worked out
and what goes to you is all clean and purty.

thanks,

greg k-h
