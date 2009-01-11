Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbZAKU2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbZAKU2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 15:28:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZAKU2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 15:28:41 -0500
Received: from THUNK.ORG ([69.25.196.29]:46046 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbZAKU2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 15:28:41 -0500
Date: Sun, 11 Jan 2009 15:28:38 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alex Buell <alex.buell@munted.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Online ext4 defragmention
Message-ID: <20090111202838.GA29383@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alex Buell <alex.buell@munted.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090111134443.581cfc83@lithium.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090111134443.581cfc83@lithium.local.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 11, 2009 at 01:44:43PM +0000, Alex Buell wrote:
> Can someone confirm if the online ext4 defragmentation ioctls will
> be going into 2.6.29? Thanks, I'm planning a migration from a
> disparate collection of filesystems to ext4 over the next few months. 

Unfortunately, the defragmentation patches need to a lot of work (to
be honest, largely refactored and almost rewritten) before they are
ready to for mainline yes.  I am also concerned that the current
defrag patches also try too hard to keep blocks in the same block
group, even as a higher priority keeping them non-fragmented.

Also, note that some of the benefits of ext4 only show up if you do a
backup, mkfs, and restore; that's because there are layout changes
that can only take place if you reformat the filesystem.  Finally,
there are some allocation algorithm changes which didn't make the
2.6.29 merge window which I think will make a long-term difference.
So you'll probably want to use 2.6.29 with the ext4 patch set.

So if you want the best performance and fastest fsck times (which I
infer given your query about the defragmentation ioctls), you may want
to consider doing a reformat and restore operation as part of your
ext4 migration, at least for filesystem that you plan to use for
active use.  If the filesystem is just going to be an mp3 archive, for
example, it might not be worth it to do the backup/reformat/restore
path.

Regards,

						- Ted
