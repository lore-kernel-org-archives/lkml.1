Return-Path: <linux-kernel-owner+w=401wt.eu-S1760468AbYBMCRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760468AbYBMCRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 21:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbYBMCRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 21:17:40 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:57537 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754363AbYBMCRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 21:17:38 -0500
Date: Tue, 12 Feb 2008 21:16:50 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
       jeff@garzik.org, arjan@infradead.org, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213021650.GA12785@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <greg@kroah.com>, David Miller <davem@davemloft.net>,
	jeff@garzik.org, arjan@infradead.org, sfr@canb.auug.org.au,
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
	linux-arch@vger.kernel.org, akpm@linux-foundation.org
References: <20080211211751.3e265754@laptopd505.fenrus.org> <20080211.221126.230471463.davem@davemloft.net> <47B1CB08.4020101@garzik.org> <20080212.155853.193190548.davem@davemloft.net> <20080213002948.GA8899@kroah.com> <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802121645320.2920@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 04:49:46PM -0800, Linus Torvalds wrote:
> On Tue, 12 Feb 2008, Greg KH wrote:
> > 
> > Perhaps you need to switch to using quilt.  This is the main reason why
> > I use it.
> 
> Btw, on that note: if some quilt user can send an "annotated history file" 
> of their quilt usage, it's something that git really can do, and I'll see 
> if I can merge (or rather, coax Junio to merge) the relevant part of stgit 
> to make it possible to just basically get "quilt behaviour" for the parts 
> of a git tree that you haven't pushed out yet.

So this is what I do for ext4 development.  We maintain a quilt series
in git, which is located here at: http://repo.or.cz/w/ext4-patch-queue.git

A number of ext4 developers have write access to commit into that
tree, and we coordinate amongst ourselves and on
linux-ext4@vger.kernel.org.  I tend to suck it into git using the
"guilt" package, and do periodic merge testing with a number of git
queues to detect potential merge conflicts.  Not as many as James
does, but I may start doing more of that once I steal his scripts.  :-)

The patch queue also gets automatic testing on a number different
platforms; for that reason the series files comments which version of
the kernel it was last based off of, so the ABAT system can know what
version of the kernel to use as the base of the quilt series.

I do a fair amount of QA, including copy editing and in some cases
rewriting the patch descriptions (which are often pretty vile, due to
a number of the ext4 developers not being native English speakers; not
their fault, but more than once I've had no idea what the patch
description is trying to say until I read through the patch very
closely, which is also good for me to do from a code QA point of view  :-).

Periodically, the patch queue gets pushed into the ext4.git tree and
as a patch series on ftp.kernel.org.

I've never been very happy with stgit because of past experiences
which has scarred me when it got get confused and lost my entire patch
series (this was before git reflogs, so recovery was.... interesting).
There's always been something deeply comforting about having the ASCII
patch series since it's easy to back it up and know you're in no
danger of losing everything in case of a bug.  Also, having the patch
series stored in ASCII as a quilt stack means that we can store the
quilt stack itself in git, and with repo.or.cz it allows us to have
multiple write access to the shared quilt stack, while still giving us
the off-line access advantages of git.  (Yes, I've spent plane rides
rewriting patch descriptions.  :-)

The other advantage of storing the patch stack as a an ASCII quilt
series is we have a history of changes of the patches, which we don't
necessarily have if you just use stgit to rewrite the patch.  So we
have the best of both worlds; what gets checked into Linus's tree is a
clean patch series, but we keep some history of different versions of
a patch over time in the ext4-patch-queue git repository.  (I wish we
had better changelog comments there too, but I'll take what I can
get.)

						- Ted
