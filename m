Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYITSA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYITSA4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 14:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbYITSAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 14:00:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60251 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYITSAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 14:00:43 -0400
Date: Sat, 20 Sep 2008 19:00:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Message-ID: <20080920180018.GD9873@flint.arm.linux.org.uk>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809200832.15440.david-b@pacbell.net> <20080920161111.GA9873@flint.arm.linux.org.uk> <200809201018.42127.david-b@pacbell.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809201018.42127.david-b@pacbell.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 10:18:41AM -0700, David Brownell wrote:
> > None that I know about - generally other drivers look up their private
> > data in some kind of array and assign to file->private_data in their
> > open() method - in much the same way that watchdog and misc drivers do.
> 
> Yet i_private gets set up *somewhere* else that field wouldn't exist.
> Look around; you'll see it gets used.  (My quick grep started in the
> USB tree, where it turns out both usbfs and gadgetfs use it.)

Both of which are filesystems which have more control over the lifetime
of the inode.  Device drivers don't have such luxuries.

> > The simplest solution is as the watchdog drivers are doing.
> 
> I'll disagree.  It requires extra state even in this simple case;
> state of a generically undesirable flavor (global).  And likewise,
> it requires lookup mechanisms ... which if you look around, tend
> to be rather error prone, locking often gets goofed up there.
> 
> Familiar and simple != simplest, != best.  It will often become
> cargo cult programming.

Well, are you going to manufacture a patch to update all the watchdog
drivers to use your new i_private method, and get that merged into
Wim's tree now, so that then the omap watchdog drivers can satisfy
your apparant objection (which Wim _has_ taken as an objection against
them going in)?

> > And anyway, the point of these patches is not to fix issues like this.
> > It's to get what's in mainline updated to what's in the OMAP tree so
> > stuff can move forwards.  So, let's not go down rabbit warrens trying
> > to find obscure new issues which lots of other code already "suffers"
> > from.
> 
> Right, my original comment pointed out one thing that was clearly
> wrong (extra/unused struct field) and one odd thing (the global).
> 
> You said "not that odd, here's why"; I said "hmm, well OK but it's
> still got problem X, which isn't for fixing in this patchset".

The "well OK" didn't come over at all - neither I nor Wim seem to have
received that point.

> > We're into the third day on this one driver.  If every OMAP driver takes
> > this long ...
> 
> That seems like a strange way to account things.  It presumes
> that the only time review comments should be accepted is within
> a day of the patch getting posted.  Regardless of whether the
> reviewer has time at that point.

You define accounting for things in real time as "strange" - lol.  Your
following sentences don't follow either.

My point is that we currently have a BIG problem, and that is the OMAP
fork being so far out of line with mainline, it isn't funny.  It's
causing lots of pain for everyone here.  Folk are screaming for mainline
to be buildable for OMAP.

There are two approaches to achieve that: take each driver, polish it
for weeks on end until it's nice and shiney, and then submit it upstream.
Eventually, given enough man hours, you'll get to the point where you've
pushed everything upstream, but in the mean time, new work has been
queued so you need to start at the beginning again.  You've got a job
for life constantly polishing code.

The other approach is to decide that we have what we have, and that in
the interests of efficiently reducing divergence, merging the upstream
changes with the downstream changes and pushing the result upstream ASAP.
Once merged, further improvements and cleanups can be made by pushing
them separately upstream along with any other bug fixes.

Given the amount of divergence, the only approach which gives realistic
progress is the second one.

If you think the first approach is the way to go, then please join in
with Tony and myself reviewing the _entire_ OMAP tree, polishing every
patch, and pushing it upstream.  And I mean _everything_.  Not just the
USB stuff.  Encourage everyone else to do the same - because it will
take an army of individuals to make any forward progress.

> If you *really* wanted to avoid wasting time you wouldn't have
> replied to my previous post, which agreed that one point I raised
> was a non-issue for this particular patch series.

Wim said: "Will add patches 1 to 3 when everyone is OK with them. I
still saw some comments from David."

So, would you like to clearly tell Wim what your comments mean as far
as merging this patch series?  It seems I'm not the only one who's
confused as to the intention and meaning of your comments.
