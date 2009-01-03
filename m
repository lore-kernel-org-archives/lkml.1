Return-Path: <linux-kernel-owner+w=401wt.eu-S1759650AbZACUlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbZACUlr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 15:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbZACUlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 15:41:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38284 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810AbZACUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 15:41:34 -0500
Date: Sat, 3 Jan 2009 21:43:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Mohr <andi@lisas.de>, Sriram V <vshrirama@gmail.com>,
       Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: Power Management with rootfs on SDMMC.
Message-ID: <20090103204329.GD1666@elf.ucw.cz>
References: <8bf247760901012235v20bb448ch5c34fb2791ea83ca@mail.gmail.com> <20090102102152.GA26603@rhlx01.hs-esslingen.de> <20090102172407.GD1555@ucw.cz> <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0901031217261.3179@localhost.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-01-03 12:23:39, Linus Torvalds wrote:
> 
> 
> On Fri, 2 Jan 2009, Pavel Machek wrote:
> > 
> > > (or, slightly reworded: I think it's high time for some kernel God to buy a measly
> > > netbook or some such instead of 16-core mainframes to get a feeling for the
> > > amount of issues that one hits there)
> > 
> > I have one and yes, its full of problems; see my blog post about 'evil
> > little cards'.
> 
> Btw, why do people think that CONFIG_USB_PERSIST got removed, and is now 
> always on? Exactly because of this issue, and because one kernel God (me) 
> wanted to be able to suspend their netbook.
> 
> That said, right now most flash performance is so incredibly bad that I 
> can't reasonably be expected to use that thing for anything real. They may 
> say 15-20 MB/s, but that's best-case streaming performance. Real life 
> write performance is often in the tens of kB (yes, *kilo* bytes) per 
> second. I hope it will improve, and no, it's not just about ext3 journal 
> behavior, although that certainly makes some of the issues much much 
> worse.
> 
> So no, I don't use my netbook very much. But this _is_ largely fixed ont 
> he USB side, even if you may need to do
> 
> 	echo 1 >/sys/bus/usb/devices/.../power/persist
> 
> and I argued that we should default to it for any mounted device. It's 
> hard to do, since the device doesn't even know about whether it's mounted 
> or not.

Unfortunately, that corrupts filesystems by default on devices like
olympus c-750 digital camera:

* when USB is powered, olympus unmounts its filesystem, and goes into
mass storage mode.

* when USB is unpowered, olympus mounts it back.

So you have mounted filesystem on linux side and suspend. That powers
down the usb and camera mounts the filesystem automagically... then
linux resumes, and state of in-memory caches does not match real
filesystem state...

[Now, olympus uses VFAT and probably will not write to the filesystem
unless you take a picture... with mp3 player, I'd expect mtime to be
updated on the playlist files...]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
