Return-Path: <linux-kernel-owner+w=401wt.eu-S1753250AbXLDLgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbXLDLgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 06:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbXLDLfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 06:35:52 -0500
Received: from mx2.suse.de ([195.135.220.15]:35445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbXLDLfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 06:35:51 -0500
Date: Tue, 4 Dec 2007 12:35:49 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, rob@landley.net,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch] rd: support XIP
Message-ID: <20071204113549.GA6751@wotan.suse.de>
References: <20071204042628.GA26636@wotan.suse.de> <200712041054.51599.borntraeger@de.ibm.com> <20071204101009.GB9618@wotan.suse.de> <20071204112100.GA20420@wotan.suse.de> <20071204032620.aaee039b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204032620.aaee039b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 03:26:20AM -0800, Andrew Morton wrote:
> On Tue, 4 Dec 2007 12:21:00 +0100 Nick Piggin <npiggin@suse.de> wrote:
> 
> > +	 *
> > +	 * Cannot support XIP and highmem, because our ->direct_access
> > +	 * routine for XIP must return memory that is always addressable.
> > +	 * If XIP was reworked to use pfns and kmap throughout, this
> > +	 * restriction might be able to be lifted.
> >  	 */
> > +	gfp_flags = GFP_NOIO | __GFP_ZERO;
> > +#ifndef CONFIG_BLK_DEV_XIP
> > +	gfp_flags |= __GFP_HIGHMEM;
> > +#endif
> 
> A dubious tradeoff?

On big highmem machines certainly. It may be somewhat useful on small
memory systems... but having the config option there is nice for a VM
developer without an s390 easily available ;)

But don't apply these XIP patches yet -- after a bit more testing I'm
seeing some data corruption, so I'll have to work out what's going
wrong with that first.
