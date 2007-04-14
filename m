Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXDNVOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXDNVOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752308AbXDNVOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:14:10 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:46468
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXDNVOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:14:09 -0400
Date: Sat, 14 Apr 2007 14:13:55 -0700
To: Mike Snitzer <snitzer@gmail.com>
Cc: Neil Brown <neilb@suse.de>, "David R. Litwin" <presently42@gmail.com>,
       linux-kernel@vger.kernel.org,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070414211355.GC17993@gnuppy.monkey.org>
References: <op.tqqwdfzcftfxs2@localhost.localdomain> <17952.5537.364603.419364@notabene.brown> <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170fa0d20704140704l29d9db76q59195a3d9cad868a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 10:04:23AM -0400, Mike Snitzer wrote:
> ZFS does have some powerful features but much of it depends on their
> broken layering of volume management.  Embedding the equivalent of LVM
> into a filesystem _feels_ quite wrong.

They have a clustering concept in their volume management that isn't
expressable with something like LVM. That justifes their approach from
what I can see.
 
> That aside, the native snapshot capabilities of ZFS really stand out
> for me.  The redirect on write semantics aren't exclusive to ZFS;
> NetApp's WAFL employs the same.  But with both ZFS and WAFL they were
> designed to do snapshots extremely well from the ground up.

Write allocation for these kinds of system (especially when concerned
with mirroring) is non-trivial.

> Unfortunately in order for Linux to incorporate such a feature I'd
> imagine a new filesystem would need to be developed with redirect on
> write at its core.  Can't really see ext4 or any other existing Linux
> filesystem grafting such a feature into it.  But even though I can't
> see it; do others?

You also can't use the standard page cache to buffer all of the sophicated
semantics of these systems and have to create your own.

> I've learned that Sun and NetApp's lawyers had it out over the
> redirect on write capability of ZFS.  When the dust settled Sun had
> enough patent protection to motivate a truce with NetApp.

I think they are still talking and it's far from over the last I heard.
The creation of a new inode and decending indirect blocks is a fundamental
concept behind WAFL. Also ZFS tends to be a heavy weight as far as
metadata goes and quite possibly uneccessarily so which is likely to effect
performance for things related to keep a relevant block allocation map in
memory. ZFS is a complete pig compared to traditional file systems.

> The interesting side-effect is now ZFS is "open" and with that comes
> redirect on write in a file system other than WAFL.  But ZFS's CDDL
> conflicts with the GPL so I'm not too sure how Linux could hit the
> ground running in this potentially patent mired area of filesystem
> development.  The validity of NetApp having patented redirect on write
> aside; does the conflict between CDDL and GPL _really_ matter?  Or did
> the CDDL release of ZFS somehow undermine NetApp's WAFL patent?

That doesn't really matter. FUSE could be extended to handle this kind
of stuff and still have it be in userspace. The BSD get around including
Stephen Tweedy's (sp?) ext2 header file by making the user manually
compile it. That's not a problem for Linux folks that can download a
patch and compile a kernel.

FreeBSD already has a port of ZFS. Just for a kick, Google for that as
a possible basis for a Linux kernel port.

bill

