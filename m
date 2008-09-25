Return-Path: <linux-kernel-owner+w=401wt.eu-S1757124AbYIYReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757124AbYIYReS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYIYReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:34:03 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:23797 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953AbYIYReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:34:01 -0400
Date: Thu, 25 Sep 2008 07:49:23 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, Jeff Mahoney <jeffm@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Message-Id: <20080925074923.4845005b.randy.dunlap@oracle.com>
In-Reply-To: <20080925052725.GA5739@linux-sh.org>
References: <20080924230054.GA27730@suse.de>
	<f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
	<20080925020608.GA13869@suse.de>
	<f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	<20080925052725.GA5739@linux-sh.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 14:27:26 +0900 Paul Mundt wrote:

> On Wed, Sep 24, 2008 at 10:59:03PM -0400, Parag Warudkar wrote:
> > On Wed, Sep 24, 2008 at 10:06 PM, Greg KH <gregkh@suse.de> wrote:
> > > No, this is much different from EXPERIMENTAL.  That flag is pretty much
> > > useless right now.  This is for a temporary landing place for drivers
> > > that are not good enough to be merged, yet are useful enough for some
> > > people to use.
> > 
> > How? TAINT_EXPERIMENTAL (I'll stick to that, thanks :) and
> > CONFIG_EXPERIMENTAL are no different - neither to users nor to
> > developers. Here is why -
> > Both try to do the same thing - let people use the drivers on their
> > own risk (as if the stable ones are developer's risk - but let's keep
> > it aside for the moment) and give developers a chance to keep the code
> > in sync with mainline and improve it per user problem reports or
> > generally make it better.
> > 
> Uhm.. not quite. As the one that proposed the flag in the first place,
> perhaps it helps to cover the rationale (although Greg seems to have
> mostly covered that already).
> 
> EXPERIMENTAL today is pretty damn meaningless. What it tends to mean in

then it would be better if Greg/someone cleaned up the current tree's
problems instead of introducing more CRAP under a different name.
Oh well, his mind is already made up and I know how difficult it is to
change it.


> practice is that somethings needs some more testing, someone wants to be
> able to pull out the EXPERIMENTAL card when someone enables their option
> and their kernel blows up, the option/feature hasn't been around in the
> kernel for that long, or someone has just been too lazy to remove the
> flag (this last one probably covers about 90% of in-tree cases today).
> Stuff that is actively broken (in case of your kernel blowing up, not
> building, etc.) tends to be shoved under BROKEN instead.
> 
> Case in point:
> 
> 	$ find arch | grep _defconfig | wc -l
> 	336
> 	$ find arch | grep _defconfig | xargs grep 'CONFIG_EXPERIMENTAL=y' | wc -l
> 	324
> 	$ find arch | grep _defconfig | xargs grep 'CONFIG_BROKEN=y' | wc -l
> 	0
> 
> So given that, CONFIG_EXPERIMENTAL is something that's almost universally
> enabled, and has precisely _zero_ meaning. As others have mentioned in
> the past, it would be nice to try and audit each one of the EXPERIMENTAL
> users and try to get things under control a bit, so we can get back to a
> point where it actually means something, but we're definitely nowhere
> near that point today.
> 
> Now, TAINT_CRAP (other options were TAINT_INCOMPETENT_VENDOR and
> TAINT_GREG). This is something with a completely different meaning.
> staging/ drivers are there because there are users for these devices, and
> we actively want people looking at and cleaning up this code. As is
> evident by other proprietary driver usage statistics, it's evident that
> users will generally pick device functionality (whether perceived or
> otherwise) over system stability quite a lot of the time.
> 
> The stuff in this directory is by no means ready to be merged with the
> rest of the kernel, and is generally in pretty rough shape. While these
> drivers are generally audited to make sure they are not actively hostile
> to the system prior to being merged, they are still going to require
> heavy rewriting before the bugs get shaken out and it actually looks like
> kernel code. Vendor drivers will do such wonderful things as userspace
> file I/O (when they aren't busy doing active NULL pointer dereferences)
> from the kernel driver because that's what the windows driver did.
> EXPERIMENTAL doesn't even begin to cover it, this is simply crap.
> 
> The other key difference is that even with experimental stuff in the
> kernel, you will still get support, so it's not really a taintable
> offense. Stuff in staging/ on the other hand while potentially not
> actively hostile against the rest of the system, is still very much an
> unknown, and therefore the only safe thing to do is to taint the system
> and allow individual developers to make a choice regarding whether any
> resulting oopses are worth looking at or not.
> 
> Part of the benefits of staging/ is catching all of the one-shot patches
> that vendors toss out to meet their licensing requirements -- or so they
> can slap a Linux-friendly logo on their shrinkwrap, where there are
> already a good chunk of active users and folks interested in getting
> things cleaned up, long after the vendor has bailed. Doing this sort of
> work in-tree makes the most sense, as what's going on is immediately
> visible, and you get a lot more people testing and working on the driver
> in question. If we tried to force someone to make a sourceforge project
> for every abandoned vendor driver, we'd end up with some sort of
> wasteland of abandoned kernel code that looks something like, well,
> sourceforge. Doing this sort of work out-of-tree just isn't worth it. The
> staging/ tree has been doing well out-of-tree to date, but these sorts of
> things aren't going to get any real momentum without being integrated,
> with the users/developers and vendors forced to actually deal with the
> problem.
> --

---
~Randy
