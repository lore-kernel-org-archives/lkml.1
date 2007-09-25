Return-Path: <linux-kernel-owner+w=401wt.eu-S1752993AbXIYLWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbXIYLWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 07:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751835AbXIYLWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 07:22:05 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7546 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbXIYLWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 07:22:05 -0400
Date: Tue, 25 Sep 2007 13:23:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mel Gorman <mel@skynet.ie>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       neilb@suse.de, Geert.Uytterhoeven@sonycom.com,
       geoffrey.levand@am.sony.com
Subject: Re: 2.6.23-rc7-mm1
Message-ID: <20070925112324.GY2367@kernel.dk>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org> <46F812DF.4010909@linux.vnet.ibm.com> <20070925102356.GB8076@skynet.ie> <20070925103119.GX2367@kernel.dk> <20070925111520.GC8076@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070925111520.GC8076@skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25 2007, Mel Gorman wrote:
> On (25/09/07 12:31), Jens Axboe didst pronounce:
> > On Tue, Sep 25 2007, Mel Gorman wrote:
> > > On (25/09/07 01:11), Kamalesh Babulal didst pronounce:
> > > 
> > > Hi Kamalesh,
> > > 
> > > > The build fails with following error
> > > > 
> > > > CC drivers/block/ps3disk.o
> > > > drivers/block/ps3disk.c: In function ???ps3disk_scatter_gather???:
> > > > drivers/block/ps3disk.c:115: error: ???bio??? undeclared (first use in this
> > > > function)
> > > > drivers/block/ps3disk.c:115: error: (Each undeclared identifier is
> > > > reported only once
> > > > drivers/block/ps3disk.c:115: error: for each function it appears in.)
> > > > drivers/block/ps3disk.c:115: error: ???j??? undeclared (first use in this
> > > > function)
> > > > drivers/block/ps3disk.c:116: error: implicit declaration of function
> > > > ???bio_kunmap_bvec???
> > > > make[2]: *** [drivers/block/ps3disk.o] Error 1
> > > > make[1]: *** [drivers/block] Error 2
> > > > make: *** [drivers] Error 2
> > > > 
> > > > The function bio_kunmap_bvec is missing.I tried checking the git-block.patch
> > > > as well as the linux/kernel/git/axboe/linux-2.6-block.git and did not
> > > > find this function.
> > > > 
> > > > Previously this function was replaced by __bio_kunmap_atomic();
> > > > This patch does not solves the implicit "declaration of function
> > > > ???bio_kunmap_bvec???"
> > > > 
> > > > Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com
> > > > <mailto:kamalesh@linux.vnet.ibm.com>>
> > > 
> > > Your mailer appears to have mangled both your signoff and the whitespace in
> > > the patch and it does not apply. However, fixing it does not solve the problem
> > > because of this mysterious bio_kunmap_bvec() that is only referenced by this
> > > driver. Was it accidently added during the addition of sg chaining support?
> > 
> > This should fix things up.
> > 
> 
> This builds although I lack the hardware to really test it. However, in
> 2.6.23-rc8-mm1 it collides with git-block-ps3disk-fix.patch. This is a
> version on top of that stack but I guess the best thing to do is replace
> git-block-ps3disk-fix.patch with Jens patch once it is signed off.
> 
> Not signing off because this is just a rebase. Assuming the other one
> gets signed off, consider it;

Thanks, but I already integrated the fix into the existing patch, so
that bisect will work.

-- 
Jens Axboe

