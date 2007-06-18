Return-Path: <linux-kernel-owner+w=401wt.eu-S1760440AbXFRKaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760440AbXFRKaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 06:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761044AbXFRK3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 06:29:51 -0400
Received: from lazybastard.de ([212.112.238.170]:40470 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760664AbXFRK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 06:29:49 -0400
Date: Mon, 18 Jun 2007 12:13:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, alan <alan@clueserver.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk
Subject: Re: Versioning file system
Message-ID: <20070618101333.GA21275@lazybastard.org>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <467314E2.9010306@zytor.com> <Pine.LNX.4.64.0706151547200.27993@blackbox.fnordora.org> <20070616145337.GA13391@lazybastard.org> <20070618094524.GF5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070618094524.GF5181@schatzie.adilger.int>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 June 2007 03:45:24 -0600, Andreas Dilger wrote:
> 
> Too bad everyone is spending time on 10 similar-but-slightly-different
> filesystems.  This will likely end up with a bunch of filesystems that
> implement some easy subset of features, but will not get polished for
> users or have a full set of features implemented (e.g. ACL, quota, fsck,
> etc).  While I don't think there is a single answer to every question,
> it does seem that the number of filesystem projects has climbed lately.

There definitely seems to be an inflation of new filesystems.  These
days all the cool kids either write their own virtualization layer or
their own filesystem.  No idea why that happened, two years ago
filesystems seemed old and boring.

> Maybe there should be a BOF at OLS to merge these filesystem projects
> (btrfs, chunkfs, tilefs, logfs, etc) into a single project with multiple
> people working on getting it solid, scalable (parallel readers/writers on
> lots of CPUs), robust (checksums, failure localization), recoverable, etc.

Consider me sceptical.  Here is my personal opinion when looking at the
list:

Chunkfs, tilefs - research projects.
At this moment nobody knows whether either of the approaches works or
not.  Once that is proven, the tricks should get incorporated in
existing filesystems.

Dave Chinner seems to be working on similar stuff for XFS already.
Assuming he can deliver, a chunked/tiled/... XFS is useful while chunkfs
and tilefs are mostly educational.  It doesn't have to be XFS, Ext4
would do just as well.

Logfs - flash filesystem.
Btrfs - disk filesystem.
Disk optimization comes down to avoiding seeks like the plague.  Flash
requires garbage collection, wear leveling and avoiding writes like the
plague.

It is quite unlikely that either filesystem will do well in the other's
domain.  At least some amount of code will remain seperate.  Subsets of
code might be useful for both.  Collaboration on that level would be
useful.

Jörn

-- 
Joern's library part 4:
http://www.paulgraham.com/spam.html
