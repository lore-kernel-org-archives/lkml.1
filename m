Return-Path: <linux-kernel-owner+w=401wt.eu-S1755398AbZFUUxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbZFUUxB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 16:53:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZFUUwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 16:52:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60266 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZFUUws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 16:52:48 -0400
Date: Sun, 21 Jun 2009 22:52:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Marco <marco.stornelli@gmail.com>
Cc: Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
Message-ID: <20090621205245.GC3254@elf.ucw.cz>
References: <4A33A7A2.1050608@gmail.com> <20090613155957.GA16220@shareable.org> <4A34A394.5040509@gmail.com> <20090621064040.GC1656@ucw.cz> <4A3E6F28.4090404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A3E6F28.4090404@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >> 1. Disk-based filesystems such as ext2/ext3 were designed for optimum
> >>    performance on spinning disk media, so they implement features such
> >>    as block groups, which attempts to group inode data into a contiguous
> >>    set of data blocks to minimize disk seeking when accessing files. For
> >>    RAM there is no such concern; a file's data blocks can be scattered
> >>    throughout the media with no access speed penalty at all. So block
> >>    groups in a filesystem mounted over RAM just adds unnecessary
> >>    complexity. A better approach is to use a filesystem specifically
> >>    tailored to RAM media which does away with these disk-based features.
> >>    This increases the efficient use of space on the media, i.e. more
> >>    space is dedicated to actual file data storage and less to meta-data
> >>    needed to maintain that file data.
> > 
> > So... what is the performance difference between ext2 and your new
> > filesystem?
> > 
> 
> About the "space" you can read a detailed documentation on the site:
> 
> http://pramfs.sourceforge.net/pramfs-spec.html

I do not see any numbers there. Do you think you can save significant
memory when storing for example kernel source trees?

> In addition I can do an example of "compact" information: ext2 uses
> directory entry objects ("dentries") to associate file names to
> inodes,

I'm not sure that on-disk directory entry == dentry.

> and these dentries are located in data blocks owned by the parent
> directory. In pramfs, directory inode's do not need to own any data
> blocks, because all dentry information is contained within the inode's
> themselves.

How do you handle hard-links, then?

> >From performance point of view:
> 
> Sometimes ago I uploaded here (http://elinux.org/Pram_Fs) some benchmark
> results to compare the performance with and without XIP in a real
> embedded environment with bonnie++. You could use it as reference point.

Well, so XIP helps. ext2 can do XIP too, IIRC. Is your performance
better than ext2?

Wait... those numbers you pointed me... claim to be as slow as
13MB/sec. That's very very bad. My harddrive is faster than that.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
