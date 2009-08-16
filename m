Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZHPNqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZHPNqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 09:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbZHPNqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 09:46:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:9453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908AbZHPNq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 09:46:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,389,1246863600"; 
   d="scan'208";a="176311387"
Date: Sun, 16 Aug 2009 21:46:10 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory
	unnecessarily (rev. 2)
Message-ID: <20090816134610.GA6266@localhost>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905040222.39062.rjw@sisk.pl> <20090505022427.GA10880@localhost> <200905060105.10800.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905060105.10800.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 07:05:09AM +0800, Rafael J. Wysocki wrote:
> On Tuesday 05 May 2009, Wu Fengguang wrote:
> > On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > 
> > > Since the hibernation code is now going to use allocations of memory
> > > to create enough room for the image, it can also use the page frames
> > > allocated at this stage as image page frames.  The low-level
> > > hibernation code needs to be rearranged for this purpose, but it
> > > allows us to avoid freeing a great number of pages and allocating
> > > these same pages once again later, so it generally is worth doing.
> > > 
> > > [rev. 2: Change the strategy of preallocating memory to allocate as
> > >  many pages as needed to get the right image size in one shot (the
> > >  excessive allocated pages are released afterwards).]
> > 
> > Rafael, I tried out your patches and found doubled memory shrink speed!
> >
> > [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> > [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
> 
> Unfortunately, I'm observing a regression and a huge one.
> 
> On my Atom-based test box with 1 GB of RAM after a fresh boot and starting X
> with KDE 4 there are ~256 MB free.  To create an image we need to free ~300 MB
> and that takes ~2 s with the old code and ~15 s with the new one.
> 
> It helps to call shrink_all_memory() once with a sufficiently large argument
> before the preallocation.

The 10 fold slowdown may be related to swapping IO:
shrink_all_memory() tends to be reclaiming less anon pages.

Is this box running on SSD? (Which can be slow on random writes.)

Thanks,
Fengguang
