Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbYBGRz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbYBGRz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 12:55:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756341AbYBGRzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 12:55:50 -0500
Received: from brick.kernel.dk ([87.55.233.238]:16337 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755962AbYBGRzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 12:55:49 -0500
Date: Thu, 7 Feb 2008 18:55:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, arjan@linux.intel.com, dgc@sgi.com,
       npiggin@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@gmail.com>
Subject: Re: [patch] block layer: kmemcheck fixes
Message-ID: <20080207175544.GL15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Linus Torvalds wrote:
> 
> 
> On Thu, 7 Feb 2008, Ingo Molnar wrote:
> >  	INIT_HLIST_NODE(&rq->hash);
> >  	RB_CLEAR_NODE(&rq->rb_node);
> > -	rq->ioprio = 0;
> > -	rq->buffer = NULL;
> > -	rq->ref_count = 1;
> > -	rq->q = q;
> > -	rq->special = NULL;
> > -	rq->data_len = 0;
> > -	rq->data = NULL;
> > -	rq->nr_phys_segments = 0;
> > -	rq->sense = NULL;
> > -	rq->end_io = NULL;
> > -	rq->end_io_data = NULL;
> > -	rq->completion_data = NULL;
> > -	rq->next_rq = NULL;
> > +	rq->completion_data		= NULL;
> > +	/* rq->elevator_private			*/
> > +	/* rq->elevator_private2		*/
> > +	/* rq->rq_disk				*/
> > +	/* rq->start_time			*/
> > +	rq->nr_phys_segments		= 0;
> > +	/* rq->nr_hw_segments			*/
> > +	rq->ioprio			= 0;
> > +	rq->special			= NULL;
> > +	rq->buffer			= NULL;
> ...
> 
> Can we please just stop doing these one-by-one assignments, and just do 
> something like
> 
> 	memset(rq, 0, sizeof(*rq));
> 	rq->q = q;
> 	rq->ref_count = 1;
> 	INIT_HLIST_NODE(&rq->hash);
> 	RB_CLEAR_NODE(&rq->rb_node);
> 
> instead?
> 
> The memset() is likely faster and smaller than one-by-one assignments 
> anyway, even if the one-by-ones can avoid initializing some field or there 
> ends up being a double initialization..

I completely agree, the fidgeting with single members quickly loses
appeal. Ingo, I'll merge and integrate your fixes before leaving, I'll
be here all day tomorrow as well.

-- 
Jens Axboe

