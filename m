Return-Path: <linux-kernel-owner+w=401wt.eu-S1761309AbXFRJpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761309AbXFRJpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 05:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758883AbXFRJpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 05:45:30 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:35778 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825AbXFRJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 05:45:28 -0400
Date: Mon, 18 Jun 2007 03:45:24 -0600
From: Andreas Dilger <adilger@clusterfs.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618094524.GF5181@schatzie.adilger.int>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	alan <alan@clueserver.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jack Stone <jack@hawkeye.stone.uk.eu.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@zeniv.linux.org.uk
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070616145337.GA13391@lazybastard.org>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 16, 2007  16:53 +0200, Jörn Engel wrote:
> On Fri, 15 June 2007 15:51:07 -0700, alan wrote:
> > >Thus, in the end it turns out that this stuff is better handled by
> > >explicit version-control systems (which require explicit operations to
> > >manage revisions) and atomic snapshots (for backup.)
> > 
> > ZFS is the cool new thing in that space.  Too bad the license makes it 
> > hard to incorporate it into the kernel.
> 
> It may be the coolest, but there are others as well.  Btrfs looks good,
> nilfs finally has a cleaner and may be worth a try, logfs will get
> snapshots sooner or later.  Heck, even my crusty old cowlinks can be
> viewed as snapshots.
> 
> If one has spare cycles to waste, working on one of those makes more
> sense than implementing file versioning.

Too bad everyone is spending time on 10 similar-but-slightly-different
filesystems.  This will likely end up with a bunch of filesystems that
implement some easy subset of features, but will not get polished for
users or have a full set of features implemented (e.g. ACL, quota, fsck,
etc).  While I don't think there is a single answer to every question,
it does seem that the number of filesystem projects has climbed lately.

Maybe there should be a BOF at OLS to merge these filesystem projects
(btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
people working on getting it solid, scalable (parallel readers/writers on
lots of CPUs), robust (checksums, failure localization), recoverable, etc.
I thought Val's FS summits were designed to get developers to collaborate,
but it seems everyone has gone back to their corners to work on their own
filesystem?

Working on getting hooks into DM/MD so that the filesystem and RAID layers
can move beyond "ignorance is bliss" when talking to each other would be
great.  Not rebuilding empty parts of the fs, limit parity resync to parts
of the fs that were in the previous transaction, use fs-supplied checksums
to verify on-disk data is correct, use RAID geometry when doing allocations,
etc.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

