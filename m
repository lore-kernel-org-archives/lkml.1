Return-Path: <linux-kernel-owner+w=401wt.eu-S1756321AbZHPWrr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321AbZHPWrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 18:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZHPWrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 18:47:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756291AbZHPWrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 18:47:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 5/5] PM/Hibernate: Do not release preallocated memory unnecessarily (rev. 2)
Date: Mon, 17 Aug 2009 00:48:01 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "pavel@ucw.cz" <pavel@ucw.cz>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "alan-jenkins@tuffmail.co.uk" <alan-jenkins@tuffmail.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera> <200905060105.10800.rjw@sisk.pl> <20090816134610.GA6266@localhost>
In-Reply-To: <20090816134610.GA6266@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908170048.01609.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 August 2009, Wu Fengguang wrote:
> On Wed, May 06, 2009 at 07:05:09AM +0800, Rafael J. Wysocki wrote:
> > On Tuesday 05 May 2009, Wu Fengguang wrote:
> > > On Mon, May 04, 2009 at 08:22:38AM +0800, Rafael J. Wysocki wrote:
> > > > From: Rafael J. Wysocki <rjw@sisk.pl>
> > > > 
> > > > Since the hibernation code is now going to use allocations of memory
> > > > to create enough room for the image, it can also use the page frames
> > > > allocated at this stage as image page frames.  The low-level
> > > > hibernation code needs to be rearranged for this purpose, but it
> > > > allows us to avoid freeing a great number of pages and allocating
> > > > these same pages once again later, so it generally is worth doing.
> > > > 
> > > > [rev. 2: Change the strategy of preallocating memory to allocate as
> > > >  many pages as needed to get the right image size in one shot (the
> > > >  excessive allocated pages are released afterwards).]
> > > 
> > > Rafael, I tried out your patches and found doubled memory shrink speed!
> > >
> > > [  579.641781] PM: Preallocating image memory ... done (allocated 383900 pages, 128000 image pages kept)
> > > [  583.087875] PM: Allocated 1535600 kbytes in 3.43 seconds (447.69 MB/s)
> > 
> > Unfortunately, I'm observing a regression and a huge one.
> > 
> > On my Atom-based test box with 1 GB of RAM after a fresh boot and starting X
> > with KDE 4 there are ~256 MB free.  To create an image we need to free ~300 MB
> > and that takes ~2 s with the old code and ~15 s with the new one.
> > 
> > It helps to call shrink_all_memory() once with a sufficiently large argument
> > before the preallocation.
> 
> The 10 fold slowdown may be related to swapping IO:

I guess it is.

> shrink_all_memory() tends to be reclaiming less anon pages.
> 
> Is this box running on SSD? (Which can be slow on random writes.)

No, on a normal spinning-plate HDD (2.5'').

Thanks,
Rafael
