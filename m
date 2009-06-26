Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbZFZMfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbZFZMfh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbZFZMfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:35:31 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40516 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbZFZMfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:35:31 -0400
Date: Fri, 26 Jun 2009 14:35:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
Message-ID: <20090626123533.GM23611@kernel.dk>
References: <1245839904.3210.85.camel@localhost.localdomain> <200906252010.33535.a1426z@gawab.com> <20090626050245.GL31415@kernel.dk> <200906261437.16995.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906261437.16995.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26 2009, Al Boldi wrote:
> Jens Axboe wrote:
> > On Thu, Jun 25 2009, Al Boldi wrote:
> > > Jens Axboe wrote:
> > > > The test case is random mmap writes to files that have been laid out
> > > > sequentially. So it's all seeks. The target drive is an SSD disk
> > > > though, so it doesn't matter a whole lot (it's a good SSD).
> > >
> > > Oh, SSD.  What numbers do you get for normal disks?
> >
> > I haven't run this particular test on rotating storage. The type of
> > drive should not matter a lot, I'm mostly interested in comparing
> > vanilla and the writeback patches on identical workloads and storage.
> 
> I think drive type matters a lot.  Access strategy on drives with high seek 
> delays differs from those with no seek delays.  So it would probably be of 
> interest to see this test run on rotating storage, unless the writeback 
> patches are only meant for SSD?

Don't get me wrong, I've tested a lot on rotating drives too. The
changelog for one of the patches even mentions results and vmstat for a
10 disk setup, all rotating disks.

What I'm saying is that this particular test is tailored for SSD's and
writeback. The patchset is not for SSD's in particular, it applies
equally across the board (even for non-block IO, like NFS).

-- 
Jens Axboe

