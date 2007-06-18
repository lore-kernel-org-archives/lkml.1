Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbXFRNo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbXFRNo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 09:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760614AbXFRNoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 09:44:21 -0400
Received: from thunk.org ([69.25.196.29]:45768 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389AbXFRNoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 09:44:21 -0400
Date: Mon, 18 Jun 2007 09:44:13 -0400
From: Theodore Tso <tytso@mit.edu>
To: Magnus Naeslund <mag@kite.se>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, linux-kernel@vger.kernel.org
Subject: Re: ARC-1260: No space left on device, when there is (or should be) free space left
Message-ID: <20070618134413.GC30244@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Magnus Naeslund <mag@kite.se>,
	"Robert P. J. Day" <rpjday@mindspring.com>,
	linux-kernel@vger.kernel.org
References: <4676679E.5040901@kite.se> <Pine.LNX.4.64.0706180730320.14972@localhost.localdomain> <4676787F.30609@kite.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4676787F.30609@kite.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2007 at 02:20:15PM +0200, Magnus Naeslund wrote:
> Duh, this was it!
> What is the recommended method on how to increase the inode count on the filesystem (there is no need for online resize in this case)?
> I have the resize_inode option set when looking at the tune2fs -l output.

Unfortunately, at the moment there isn't a way to increase the inode
count without resizing the filesystem (which will add more blocks and
inodes as you add more blockgroups).  That's because the number of
inodes per block group is fixed at mke2fs time.   

In theory it should be possible to whip up a program which would
implement this, but it would be a non-trivial exercise.  So at the
moment, the only solution is to recreate it with a larger number of
inodes, or resize the filesystem.

How are you using the filesystem?  This wouldn't happen to be one of
the backup schemes that use hard links and huge numbers of
directories, would it?  And how did you create the filesystem
originally?  Normally mke2fs is quite generous with the number of
inodes it creates to avoid this problem.  Did you use -T largefile or
-T largefile4 by any chance?  Or did you manually specify a
non-standard inode_ratio size?

						- Ted

