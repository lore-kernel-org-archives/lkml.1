Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbZHYWkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbZHYWkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 18:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbZHYWkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 18:40:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38189 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170AbZHYWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 18:40:13 -0400
Date: Wed, 26 Aug 2009 00:40:05 +0200
From: Pavel Machek <pavel@ucw.cz>
To: david@lang.hm
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
Message-ID: <20090825224004.GD4300@elf.ucw.cz>
References: <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz> <20090825161110.GP17684@mit.edu> <20090825222112.GB4300@elf.ucw.cz> <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908251526290.28411@asgard.lang.hm>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2009-08-25 15:33:08, david@lang.hm wrote:
> On Wed, 26 Aug 2009, Pavel Machek wrote:
>
>>> It seems that you are really hung up on whether or not the filesystem
>>> metadata is consistent after a power failure, when I'd argue that the
>>> problem with using storage devices that don't have good powerfail
>>> properties have much bigger problems (such as the potential for silent
>>> data corruption, or even if fsck will fix a trashed inode table with
>>> ext2, massive data loss).  So instead of your suggested patch, it
>>> might be better simply to have a file in Documentation/filesystems
>>> that states something along the lines of:
>>>
>>> "There are storage devices that high highly undesirable properties
>>> when they are disconnected or suffer power failures while writes are
>>> in progress; such devices include flash devices and software RAID 5/6
>>> arrays without journals,
>
> is it under all conditions, or only when you have already lost redundancy?

I'd prefer not to specify.

> prior discussions make me think this was only if the redundancy is 
> already lost.

I'm not so sure now.

Lets say you are writing to the (healthy) RAID5 and have a powerfail.

So now data blocks do not correspond to the parity block. You don't
yet have the corruption, but you already have a problem.

If you get a disk failing at this point, you'll get corruption.

> also, the talk about software RAID 5/6 arrays without journals will be  
> confusing (after all, if you are using ext3/XFS/etc you are using a  
> journal, aren't you?)

Slightly confusing, yes. Should I just say "MD RAID 5" and avoid
talking about hardware RAID arrays, where that's really
manufacturer-specific?

> in addition, even with a single drive you will loose some data on power  
> loss (unless you do sync mounts with disabled write caches), full data  
> journaling can help protect you from this, but the default journaling 
> just protects the metadata.

"Data loss" here means "damaging data that were already fsynced". That
will not happen on single disk (with barriers on etc), but will happen
on RAID5 and flash.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
