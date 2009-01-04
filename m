Return-Path: <linux-kernel-owner+w=401wt.eu-S932850AbZADART@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850AbZADART (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 19:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759988AbZADARH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 19:17:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41519 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbZADARG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 19:17:06 -0500
Date: Sun, 4 Jan 2009 01:19:00 +0100
From: Pavel Machek <pavel@suse.cz>
To: Martin =?utf-8?Q?MOKREJ=C5=A0?= <mmokrejs@ribosome.natur.cuni.cz>
Cc: Duane Griffin <duaneg@dghda.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, tytso@mit.edu, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org
Subject: Re: document ext3 requirements
Message-ID: <20090104001859.GH1666@elf.ucw.cz>
References: <20090103123813.GA1512@ucw.cz> <495FD5D7.2040907@ribosome.natur.cuni.cz> <e9e943910901031417m51c847fepf304650862f0cbc2@mail.gmail.com> <20090103222957.GG1666@elf.ucw.cz> <495FEE66.9080903@ribosome.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <495FEE66.9080903@ribosome.natur.cuni.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-01-04 00:01:58, Martin MOKREJŠ wrote:
> Pavel Machek wrote:
> > On Sat 2009-01-03 22:17:15, Duane Griffin wrote:
> >> [Fixed top-posting]
> >>
> >> 2009/1/3 Martin MOKREJŠ <mmokrejs@ribosome.natur.cuni.cz>:
> >>> Pavel Machek wrote:
> >>>> readonly mount does actually write to the media in some cases. Document that.
> >>>>
> >>> Can one avoid replay of the journal then if it would be unclean?
> >>> Just curious.
> >> Nope. If the underlying block device is read-only then mounting the
> >> filesystem will fail. I tried to fix this some time ago, and have a
> >> set of patches that almost always work, but "almost always" isn't good
> >> enough. Unfortunately I never managed to figure out a way to finish it
> >> off without disgusting hacks or major surgery.
> > 
> > Uhuh, can you just ignore the journal and mount it anyway?
> > ...basically treating it like an ext2?
> > 
> > ...ok, that will present "old" version of the filesystem to the
> > user... violating fsync() semantics.
> 
> Hmm, so if my dual-boot machine does not shutdown correctly and I boot
> accidentally in M$ Win where I use ext2 IFS driver and modify some
> stuff on the ext3 drive, after a while reboot to linux and the journal
> get re-played ... Mmm ...

ext2 driver should refuse to mount dirty ext3 filesystem. (Linux ext2
driver does that).

> > Still handy for recovering badly broken filesystems, I'd say.
> 
> Me as well. How about improving you doc patch with some summary of
> this thread (although it is probably not over yet)? ;-) Definitely,
> a note that one can mount it as ext2 while read-only would be helpful
> when doing some forensics on the disk.

No, you can't mount unclean ext3 as an ext2; patch to do that would be
possible but...

I believe the patch is correct & useful.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
