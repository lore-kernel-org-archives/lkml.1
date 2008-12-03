Return-Path: <linux-kernel-owner+w=401wt.eu-S1753361AbYLCMGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbYLCMGm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:06:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbYLCMGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:06:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34977 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbYLCMGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:06:33 -0500
Date: Wed, 3 Dec 2008 12:06:16 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mbroz@redhat.com, jens.axboe@oracle.com, neilb@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: fix setting of max_segment_size and seg_boundary mask
Message-ID: <20081203120616.GM26097@agk.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mbroz@redhat.com,
	jens.axboe@oracle.com, neilb@suse.de, linux-kernel@vger.kernel.org
References: <493324D1.7010202@redhat.com> <20081203143112F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203143112F.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 02:32:00PM +0900, FUJITA Tomonori wrote:
> On Mon, 01 Dec 2008 00:42:09 +0100
> Milan Broz <mbroz@redhat.com> wrote:
 
> > @@ -314,6 +317,7 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
> >  	/* zero is "infinity" */
> >  	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
> >  	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
> > +	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask, b->seg_boundary_mask);
> >  
> >  	t->max_phys_segments = min(t->max_phys_segments, b->max_phys_segments);
> >  	t->max_hw_segments = min(t->max_hw_segments, b->max_hw_segments);
 
> Theoretically, blk_queue_stack_limits() better use min_not_zero
> instead of min for max_phys_segments, max_hw_segments, and
> max_segment_size?

But does zero have any valid use there?
We left those alone for now, feeling that BUG_ON() might be more appropriate.
 
Alasdair
-- 
agk@redhat.com
