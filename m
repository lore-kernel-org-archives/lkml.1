Return-Path: <linux-kernel-owner+w=401wt.eu-S1754135AbZF0Kpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbZF0Kpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 06:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbZF0Kp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 06:45:29 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53430 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbZF0Kp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 06:45:27 -0400
Date: Wed, 24 Jun 2009 16:21:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090624142102.GA1512@ucw.cz>
References: <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090614114613.GC9514@shareable.org> <4A351FA9.1090808@gmail.com> <20090616150750.GF29040@shareable.org> <4A37EF4A.1080006@gmail.com> <20090624174140.GH14121@shareable.org> <2ea1731b0906242344x5c8a6e58t5f82377be3d73411@mail.gmail.com> <20090626113016.GB17737@shareable.org> <4A44FDDB.1000902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A44FDDB.1000902@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>> If it loses power when doing atomic rename (to replace config files,
> >>> for example), it's likely that the whole /pramfs/configs/ directory
> >>> will be corrupt, because the rename is writing to the directory inode,
> >>> so you lose access to all names in that directory?
> >>>
> >>> That sounds like it can't be used for persistent configuration data.
> >> It's true from this point of view currently there is a lack for this
> >> and it needs a bit of effort to resolve this problem.  >From this
> >> point of view I'd like to point out that I know that there was some
> >> aspects to study in a deeper way, so I'll need of more then one
> >> review :) but since this fs has been abandoned since 2004 and it
> >> hadn't ever reviewed, it was important to do a serious review with
> >> the kernel community to understand all the problems.
> > 
> > That's reasonable.
> > 
> > What do you think of my suggestion to double-buffer writes using a
> > single fixed position block, as explained elsewhere in this thread?
> > 
> > It should give the power fail safety with very little code.  I don't
> > know how much it would slwo down writing.  That probably depends on
> > whether it's the checksum which is slow (which only needs to be done
> > once when double-buffering), or the writing.
> 
> Yeah it can be a choice. For this fs it's important to use "simple" but
> useful mechanism. What do you exactly mean with "fixed position block"?
> A fixed position in the fs? For example superblock+inodetable+in-use
> bitmap+blocks+"double-buffering block"? Using a temp block of the same
> size of blocks used, isn't it? I agree, but I think it needs more then
> 100 lines of code. Even with this simple schema it needs a mechanism
> with a timeout to do the "commit" of the temp block, it needs a
> mechanism to read the temp block instead of the "old" block or a
> mechanism to write-back the temp block. So it can be implemented but it
> needs a bit of effort. I think I'll implement it in the next release.

I think you should really use ext3 over special block device.

Initially this filesystem was presented as fast (it is not) then you
claim it is reliable (it is not). If you want it to get reliable
you'll need journalling+fsck. Good luck.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
