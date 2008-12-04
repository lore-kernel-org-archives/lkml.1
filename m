Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbYLDCau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbYLDCau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 21:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752697AbYLDCal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 21:30:41 -0500
Received: from sh.osrg.net ([192.16.179.4]:41781 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659AbYLDCak (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 21:30:40 -0500
Date: Thu, 4 Dec 2008 11:30:16 +0900
To: agk@redhat.com
Cc: fujita.tomonori@lab.ntt.co.jp, mbroz@redhat.com, jens.axboe@oracle.com,
       neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix setting of max_segment_size and
 seg_boundary mask
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081203120616.GM26097@agk.fab.redhat.com>
References: <493324D1.7010202@redhat.com>
	<20081203143112F.fujita.tomonori@lab.ntt.co.jp>
	<20081203120616.GM26097@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081204112959X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2008 12:06:16 +0000
Alasdair G Kergon <agk@redhat.com> wrote:

> On Wed, Dec 03, 2008 at 02:32:00PM +0900, FUJITA Tomonori wrote:
> > On Mon, 01 Dec 2008 00:42:09 +0100
> > Milan Broz <mbroz@redhat.com> wrote:
>  
> > > @@ -314,6 +317,7 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
> > >  	/* zero is "infinity" */
> > >  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
> > >  	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
> > > +	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
> > >  
> > >  	t->max_phys_segments = min(t->max_phys_segments, b->max_phys_segments);
> > >  	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
>  
> > Theoretically, blk_queue_stack_limits() better use min_not_zero
> > instead of min for max_phys_segments, max_hw_segments, and
> > max_segment_size?
> 
> But does zero have any valid use there?

I think that zero is invalid for all the parameters.

Setting max_phys_segments to zero means that we can't do any data
transfer... Ditto for max_hw_segments, and max_segment_size.

I think that the lowest layer (scsi in this case) needs to setup them
properly and the upper layers should inherit them.


> We left those alone for now, feeling that BUG_ON() might be more appropriate.

Yeah, the patch is fine for now.
