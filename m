Return-Path: <linux-kernel-owner+w=401wt.eu-S1753469AbYIVBpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbYIVBpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 21:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbYIVBpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 21:45:46 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:34926 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753145AbYIVBpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 21:45:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=dOTcsKq8ZMP75xO8V+EbrBaWYBwgD6lfT4BzK2YVZoHQgdKLCpRSkwO0oYI9qiIWDk0NEPdjaivsE6vmDaeTJ7mMUv6FzyuMidCB3n3kWaB4orRrcg3agI90DT/AE7XAQa1smccOzuptmZUZmKe3Rv53+5dkR9WXVfZ1i/mR7v8=  ;
X-YMail-OSG: 3Y9lUGkVM1koGVzwDPixPXDdxhkrkXInRIdrxFMLeJpC1ijzbnscK4j.wjd2sCC1DJZ23aiAw.Sj7VhqouAA3kZcojqfkLIGJkme2l4xGgbRjx5Aalw9i1po3xnmTeC1eT6WzjsgfGLWYmOqN4QxxV3r.2Zlq9BKFAOc00Mcz8rnH.7ugfaMqns-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Date: Sun, 21 Sep 2008 18:45:42 -0700
User-Agent: KMail/1.9.9
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <200809201018.42127.david-b@pacbell.net> <20080920180018.GD9873@flint.arm.linux.org.uk>
In-Reply-To: <20080920180018.GD9873@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809211845.42990.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 September 2008, Russell King - ARM Linux wrote:
> On Sat, Sep 20, 2008 at 10:18:41AM -0700, David Brownell wrote:
>
> > Yet i_private gets set up *somewhere* else that field wouldn't exist.
> > Look around; you'll see it gets used.  (My quick grep started in the
> > USB tree, where it turns out both usbfs and gadgetfs use it.)
> 
> Both of which are filesystems which have more control over the lifetime
> of the inode.  Device drivers don't have such luxuries.

Both of them are the *kernel part* of a *user mode device driver* ...
but regardless, that doesn't invalidate what I said (and showed!)
about how easy it is to initialize that (even in this watchdog case).


> Well, are you going to manufacture a patch to update all the watchdog
> drivers to use your new i_private method,

If Alan Cox hadn't reminded us about pending cleanups to create more
of a real watchdog framework, I might well have done so.  The core
update was trivial; driver updates could trickle in when convenient.
No "flag day" needed.  But as I noted:  Not part of this patch series.


> > > We're into the third day on this one driver.  If every OMAP driver
> > > takes this long ...
> > 
> > That seems like a strange way to account things.  It  presumes
> > that the only time review comments should be accepted is within
> > a day of the patch getting posted.  Regardless of whether the
> > reviewer has time at that point.
> 
> You define accounting for things in real time as "strange" - lol.  Your
> following sentences don't follow either.

Redefining my words doesn't help, unless you're intent on creating
arguments instead of consensus.

Review rarely happens all at once, unless very few people look at
the code.  Discouraging review is *extremely* strange.  Most developers
want loads more than they ever get.  Yet you complained about me
not reviewing at the same time you did (I happened to be traveling)
despite there being no rush to queue this.  Also strange.


> My point is that we currently have a BIG problem, and that is the OMAP
> fork being so far out of line with mainline, it isn't funny.

I call it a "branch" myself; "fork" sounds confrontational.

When more of the arch/arm/* core bits merge -- like the clock and
power domain updates ISTR you wanted to hold back -- then the rest
starts to make sense upstream.  Things like board support, and the
drivers needed by those boards.


> There are two approaches to achieve that: take each driver, polish it
> for weeks on end until it's nice and shiney, and then submit it upstream.
> ...
> The other approach is to decide that we have what we have, and that in
> the interests of efficiently reducing divergence, merging the upstream
> changes with the downstream changes and pushing the result upstream ASAP.

Those are two ends of a *spectrum* reflecting how much work to put in,
not two different "approaches".  Between those ends are MANY other
options.  Those two ends are rarely used.

Those options include what I've always thought is the norm:  review
drivers as part of upstream submission, and resolve most issues before
they get merged.  (It's an acknowledged issue that resolving them later
tends to be quite difficult...)


There's also the issue of strategy.  One can randomly take changes
and merge them ... possibly leaving upstream a bit chaotic.  One
could try to merge everything at once ... unrealistic.  One could
merge enough to meet specific functional targets ... which makes
more sense to me.  (Example:  "2.6.28 should boot beagleboard.org
and gumstix Overo from mainline."  That might even be achievable...)


> > If you *really* wanted to avoid wasting time you wouldn't have
> > replied to my previous post, which agreed that one point I raised
> > was a non-issue for this particular patch series.
> 
> Wim said: "Will add patches 1 to 3 when everyone is OK with them. I
> still saw some comments from David."

Yes, there are two unresolved issues in patch #1 which you seem
to have successfully buried with your flamage.  Easy fixes, just
strike a line and truncate a path.  The sort of thing that often
gets queued in the MM tree as a "fixup" and then merged into a
main patch.

- Dave
