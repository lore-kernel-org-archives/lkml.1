Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbZDBVmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbZDBVmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 17:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753623AbZDBVma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 17:42:30 -0400
Received: from thunk.org ([69.25.196.29]:44767 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbZDBVma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 17:42:30 -0400
Date: Thu, 2 Apr 2009 17:42:17 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Rees <drees76@gmail.com>
Cc: Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090402214217.GL10642@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Rees <drees76@gmail.com>, Janne Grunau <j@jannau.net>,
	Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel> <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 02, 2009 at 09:29:59AM -0700, David Rees wrote:
> On Thu, Apr 2, 2009 at 4:05 AM, Janne Grunau <j@jannau.net> wrote:
> >> Current kernels just have too much IO latency
> >> with ext3 it seems.
> >
> > MythTV calls fsync every few seconds on ongoing recordings to prevent
> > stalls due to large cache writebacks on ext3.
> 
> Personally that is also one of my MythTV pet peeves.  A hack added to
> MythTV to work around a crappy ext3 latency bug that also causes these
> large files to get heavily fragmented.  That and the fact that yo have
> to patch MythTV to eliminate those forced fdatasyncs - there is no
> knob to turn it off if you're running MythTV on a filesystem which
> doesn't suffer from ext3's data=ordered fsync stalls.

So use XFS or ext4, and use fallocate() to get the disk blocks
allocated ahead of time.  That completely avoids the fragmentation
problem, altogether.  If you are using ext3 on a dedicated MythTV box,
I would certainly advise mounting with data=writeback, which will also
avoid the latency bug.

					- Ted
