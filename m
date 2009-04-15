Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbZDOLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbZDOLam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZDOLad
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:30:33 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50725 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbZDOLac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:30:32 -0400
Date: Wed, 15 Apr 2009 13:30:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: tiobench read 50% regression with 2.6.30-rc1
Message-ID: <20090415113031.GY5178@kernel.dk>
References: <1239265763.2567.769.camel@ymzhang> <20090409095706.GD5178@kernel.dk> <1239330541.2567.779.camel@ymzhang> <20090414121431.GH5178@kernel.dk> <x49fxgaimq8.fsf@segfault.boston.devel.redhat.com> <20090415062649.GO5178@kernel.dk> <x49ws9mgnv0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ws9mgnv0.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15 2009, Jeff Moyer wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:
> 
> > On Wed, Apr 15 2009, Jeff Moyer wrote:
> >> I tested this using iozone to read a file from an NFS client.  The
> >> iozone command line was:
> >>   iozone -s 2000000 -r 64 -f /mnt/test/testfile -i 1 -w
> >> 
> >> The numbers in the nfsd's row represent the number of nfsd threads.  I
> >> included numbers for the deadline scheduler as well for comparison.
> >> 
> >>                v2.6.29
> >> 
> >> nfsd's  |   1    |  2   |   4   |   8
> >> --------+---------------+-------+------
> >> cfq     | 91356 | 66391 | 61942 | 51674
> >> deadline| 43207 | 67436 | 96289 | 107784
> >> 
> >>               2.6.30-rc1
> >> 
> >> nfsd's  |   1   |   2   |   4   |   8
> >> --------+---------------+-------+------
> >> cfq     | 43127 | 22354 | 20858 | 21179
> >> deadline| 43732 | 68059 | 76659 | 83231
> >> 
> >>           2.6.30-rc1 + cfq fix
> >> 
> >> nfsd's  |   1    |    2   |   4   |   8
> >> --------+-----------------+-------+------
> >> cfq     | 114602 | 102280 | 43479 | 43160
> >> 
> >> As you can see, for 1 and 2 threads, the patch *really* helps out.  We
> >> still don't get back the performance for 4 and 8 nfsd threads, though.
> >> It's interesting to note that the deadline scheduler regresses for 4 and
> >> 8 threads, as well.  I think we've still got some digging to do.
> >
> > Wow, that does indeed look pretty good!
> 
> Please don't lose the later part of the message, which is that both CFQ
> and deadline regress for 4 and 8 threads when moving from 2.6.29 to
> 2.6.30-rc1!  There have been way too many changes to keep track of in
> this area recently, and I'd like to get some confidence that we
> understand the performance implications of them.

I'm definitely not, in fact pending patches should make it better! For
the nfs case, I'm still a big proponent of explicitly getting the io
context sharing in place, instead of adding code at the other end to
try and fix things up.

> >> I'll try the cfq close cooperator patches next.
> >
> > I have a pending update on the coop patch that isn't pushed out yet, I
> > hope to have it finalized and tested later today. Hopefully, with that,
> > we should be able to maintain > 100Mb/sec for 4 and 8 threads.
> 
> OK, please let me know when and where this is available and I'll give it
> a try.

I sent you email about ~10 minutes ago or so about that very patch.

-- 
Jens Axboe

