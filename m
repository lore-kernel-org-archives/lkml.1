Return-Path: <linux-kernel-owner+w=401wt.eu-S2993286AbXDTQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993286AbXDTQyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993287AbXDTQyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:54:18 -0400
Received: from brick.kernel.dk ([80.160.20.94]:16566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993286AbXDTQyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:54:17 -0400
Date: Fri, 20 Apr 2007 18:51:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Adam Litke <aglitke@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <ak@suse.de>,
       Paul Jackson <pj@sgi.com>, Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 4/8] Enhance fallback functions in libs to support higher   order pages
Message-ID: <20070420165135.GB30100@kernel.dk>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com> <20070419163525.11948.3482.sendpatchset@schroedinger.engr.sgi.com> <a0a62dfc0704191148v15434469kc3130821cb251072@mail.gmail.com> <Pine.LNX.4.64.0704191208340.12936@schroedinger.engr.sgi.com> <20070420082129.GI6525@kernel.dk> <Pine.LNX.4.64.0704200900060.20068@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704200900060.20068@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20 2007, Christoph Lameter wrote:
> On Fri, 20 Apr 2007, Jens Axboe wrote:
> 
> > This works fine as long as you are in the submitter context, but once
> > you pass the into the block layer, we don't have any way to find the
> > address space (at least we don't want to). Would something like this be
> > workable, name withstanding:
> > 
> > static unsigned long page_size(struct page *page)
> > {
> >         struct address_space *mapping;
> >         int order = 0;
> > 
> >         mapping = page_mapping(page);
> >         if (mapping)
> >                 order = mapping->order;
> > 
> >         return PAGE_CACHE_SIZE << order;
> > }
> 
> There is much simpler solution (possible with mm)
> 
> PAGE_SIZE << compound_order(page)
> 
> compound_order will return 0 for a non compound page.

Ah perfect, much easier. I'll spin a patchset for the block bits.

-- 
Jens Axboe

