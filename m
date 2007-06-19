Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbXFSMHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbXFSMHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXFSMHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:07:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62543 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbXFSMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:07:33 -0400
Date: Tue, 19 Jun 2007 08:04:57 -0400
From: Chris Mason <chris.mason@oracle.com>
To: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070619120457.GD14108@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <4676C2D6.8030708@vlnb.net> <46779DB1.7060807@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46779DB1.7060807@draigBrady.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 10:11:13AM +0100, Pádraig Brady wrote:
> Vladislav Bolkhovitin wrote:
> > 
> > I would also suggest one more feature: support for block level
> > de-duplication. I mean:
> > 
> > 1. Ability for Btrfs to have blocks in several files to point to the
> > same block on disk
> > 
> > 2. Support for new syscall or IOCTL to de-duplicate as a single
> > transaction two or more blocks on disk, i.e. link them to one of them
> > and free others
> > 
> > 3. De-de-duplicate blocks on disk, i.e. copy them on write
> > 
> > I suppose that de-duplication itself would be done by some user space
> > process that would scan files, determine blocks with the same data and
> > then de-duplicate them by using syscall or IOCTL (2).
> > 
> > That would be very usable feature, which in most cases would allow to
> > shrink occupied disk space on 50-90%.
> 
> Have you references for this number?
> In my experience one gets a lot of benefit from
> the much simpler process of "de-duplication" of files.

Yes, I would expect simple hard links to be a better solution for this,
but the feature request is not that out of line.  I actually had plans
on implementing auto duplicate block reuse earlier in btrfs.

Snapshots already share duplicate blocks between files, and so all of
the reference counting needed to implement this already exists.
Snapshots are writable, and data mods are copy on write, and in general
things work.

But, to help fsck, the extent allocation tree has a back pointer to the
inode that owns an extent.  If you're doing snapshots, all of the owners
of the extent have the same inode number.   If you're sharing duplicate
blocks, the owners can have any inode number, and fsck becomes much more
complex.

In general, when I have to decide between fsck and a feature, I'm going
to pick fsck.  The features are much more fun, but fsck is one of the
main motivations for doing this work.

Thanks for the input,
Chris
