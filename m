Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbXFMKjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbXFMKjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757227AbXFMKi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:38:57 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31038 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbXFMKi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:38:56 -0400
Date: Wed, 13 Jun 2007 06:35:22 -0400
From: Chris Mason <chris.mason@oracle.com>
To: John Stoffel <john@stoffel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Message-ID: <20070613103522.GW28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com> <18031.26764.586958.632146@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18031.26764.586958.632146@stoffel.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:46:20PM -0400, John Stoffel wrote:
> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
> 
> Chris> After the last FS summit, I started working on a new filesystem
> Chris> that maintains checksums of all file data and metadata.  Many
> Chris> thanks to Zach Brown for his ideas, and to Dave Chinner for his
> Chris> help on benchmarking analysis.
> 
> Chris> The basic list of features looks like this:
> 
> Chris> 	* Extent based file storage (2^64 max file size)
> Chris> 	* Space efficient packing of small files
> Chris> 	* Space efficient indexed directories
> Chris> 	* Dynamic inode allocation
> Chris> 	* Writable snapshots
> Chris> 	* Subvolumes (separate internal filesystem roots)
> Chris> 	- Object level mirroring and striping
> Chris> 	* Checksums on data and metadata (multiple algorithms available)
> Chris> 	- Strong integration with device mapper for multiple device support
> Chris> 	- Online filesystem check
> Chris> 	* Very fast offline filesystem check
> Chris> 	- Efficient incremental backup and FS mirroring
> 
> So, can you resize a filesystem both bigger and smaller?  Or is that
> implicit in the Object level mirroring and striping?  

Growing the FS is just either extending or adding a new extent tree.
Shrinking is more complex.  The extent trees do have back pointers to
the objectids that own the extent, but snapshotting makes that a little
non-deterministic.  The good news is there are no fixed locations for
any of the metadata.  So it is at least possible to shrink and pop out
arbitrary chunks.

> 
> As a user of Netapps, having quotas (if only for reporting purposes)
> and some way to migrate non-used files to slower/cheaper storage would
> be great.

So far, I'm not planning quotas beyond the subvolume level.

> 
> Ie. being able to setup two pools, one being RAID6, the other being
> RAID1, where all currently accessed files are in the RAID1 setup, but
> if un-used get migrated to the RAID6 area.  

HSM in general is definitely interesting.  I'm afraid it is a long ways
off, but it could be integrated into the scrubber that wanders the trees
in the background.

-chris

