Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbZC0Ts6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbZC0Ts6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 15:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZC0Tst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 15:48:49 -0400
Received: from THUNK.ORG ([69.25.196.29]:42591 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZC0Tst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 15:48:49 -0400
Date: Fri, 27 Mar 2009 15:48:36 -0400
From: Theodore Tso <tytso@mit.edu>
To: Gene Heskett <gene.heskett@verizon.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327194836.GZ6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Gene Heskett <gene.heskett@verizon.net>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090327112438.GQ6239@mit.edu> <alpine.LFD.2.00.0903271058060.3994@localhost.localdomain> <20090327190339.GW6239@mit.edu> <200903271519.10921.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903271519.10921.gene.heskett@verizon.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:19:10PM -0400, Gene Heskett wrote:
> >You've said for a long that that ext3 is really bad in that it
> >inflicts this --- I agree with you.  People should use other
> >filesystems which are better.  This includes ext4, which is completely
> >format compatible with ext3.  They don't even have to switch on
> >extents support to get better behaviour.  Just mounting an ext3
> >filesystem with ext4 will result in better behaviour.
> 
> Ohkay.  But in a 'make xconfig' of 2.6.28.9, how much of ext4 can be turned on 
> without rendering the old ext3 fstab defaults incompatible should I be forced 
> to boot a kernel with no ext4 support?

Ext4 doesn't make any non-backwards compatible changes to the
filesystem.  So if you just take an ext3 filesystem, and mount it as
ext4, it will work just fine; you will get delayed allocation, you
will get a slightly boosted write priority for kjournald, and then
when you unmount it, that filesystem will work *just* *fine* on a
kernel with no ext4 support.  You can mount it as an ext3 filesystem.

If you use tune2fs to enable various ext4 features, such as extents,
etc., then when you mount the filesystem as ext4, you will get the
benefit of extents for any new files which are created, and once you
do that, the filesystem can't be mounted on an ext3-only system, since
ext3 doesn't know how to deal with extents.

And of course, if you want *all* of ext4's benefits, including the
full factor of 6-8 improvement in fsck times, then you will be best
served by creating a new ext4 filesystem from scratch and doing a
backup/reformat/restore pass.

But if you're just annoyed by the large latencies in Ingo's "make
-j32" example, simply taking the ext3 filesystem and mounting it as
ext4 should make those problems go away.  And it won't make any
incompatible changes to the filesystem.  (This didn't use to be true
in the pre-2.6.26 days, but I insisted on getting this fixed so people
could always mount an ext2 or ext3 filesystems using ext4 without the
kernel making any irreversible filesystem format changes behind the
user's back.)

					- Ted
