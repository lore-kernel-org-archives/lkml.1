Return-Path: <linux-kernel-owner+w=401wt.eu-S1760052AbXEZJbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052AbXEZJbw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 05:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbXEZJbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 05:31:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4890 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752866AbXEZJbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 05:31:17 -0400
Date: Thu, 24 May 2007 17:39:11 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>,
       Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
       Jesper Juhl <jesper.juhl@gmail.com>, linux-kernel@vger.kernel.org,
       ext3-users@redhat.com
Subject: Re: fs periodic check (was Re: 2.6.22-rc1 killed my ext3 filesystem cleanly unmounted)
Message-ID: <20070524173911.GA4541@ucw.cz>
References: <20070518090604.GA10841@ribosome.natur.cuni.cz> <9a8748490705180720u3baf9785l910581a2a76a6eb@mail.gmail.com> <20070518143529.GB14611@ribosome.natur.cuni.cz> <20070518215731.GB10655@thunk.org> <20070520195526.GA5235@ucw.cz> <20070522180158.GA4668@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522180158.GA4668@thunk.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > #1, This is why periodic checks are a good thing; it catches problems
> > > that could stay hidden and result in data loss sooner rather later.
> > 
> > Actually, I see something funny with periodic checks here. It claims
> > 'filesystem check on next boot' for >10 boots now.
> > 
> > It is sharp zaurus machine, and the filesystem tends to _never_ be
> > unmounted correctly (broken scripts), so I get journal replay each
> > time.
> 
> The Sharp Zaurus is a PDA which is almost always running on battery,
> right?   You need to add to /etc/e2fsck.conf:

Right. Could we get more helpful message here? 'Filesystem check on
next boot on AC power'? Or maybe keep counting, and when we reach 2x
mount-count-limit, force a fsck, battery power or not?

> [options]
> 	defer_check_on_battery = false

I guess openembedded people should make this default on zauruses...

> power.  But for a PDA running a flash drive which is almost always
> running on battery you'll want to change the default using
> e2fsck.conf.

I'll just remember to do it manually, I guess. 

But here's what I've got:

oot@spitz:/home/pavel# fsck.ext2 -f /dev/hda3
e2fsck 1.38 (30-Jun-2005)
Pass 1: Checking inodes, blocks, and sizes
Inode 371989 has illegal block(s).  Clear<y>? yes

Illegal block #2 (134217728) in inode 371989.  CLEARED.
Pass 2: Checking directory structure

i_file_acl for inode 371988 (/home/root/misc/zaurus/smail) is 131072,
should be zero.
Clear<y>? yes

Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -339972 +471044
Fix<y>? yes

Free blocks count wrong for group #10 (13882, counted=13883).
Fix<y>? yes

...kernel 2.6.16-preempt (on zaurus). Filesystem should have been clean -- I was
using it till crash for half a year, but that's what journal is for,
right? ...But I guess this is almost impossible to debug?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
