Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbYKETNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbYKETNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 14:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYKETN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 14:13:26 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39104 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYKETNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 14:13:25 -0500
Date: Wed, 5 Nov 2008 20:12:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <tj@kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Block: use round_jiffies_up()
Message-ID: <20081105191201.GO21867@kernel.dk>
References: <4911144E.3030404@kernel.org> <Pine.LNX.4.44L0.0811051120220.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0811051120220.2573-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05 2008, Alan Stern wrote:
> On Wed, 5 Nov 2008, Tejun Heo wrote:
> 
> > Hello,
> > 
> > Alan Stern wrote:
> > > @@ -78,13 +78,14 @@ void blk_delete_timer(struct request *re
> > >  	/*
> > >  	 * Nothing to detach
> > >  	 */
> > > -	if (!q->rq_timed_out_fn || !req->deadline)
> > > +	if (!req->deadline)
> > >  		return;
> > >  
> > >  	list_del_init(&req->timeout_list);
> > >  
> > >  	if (list_empty(&q->timeout_list))
> > >  		del_timer(&q->timeout);
> > > +	req->deadline = 0;
> > >  }
> > 
> > Actually, this can just be
> > 
> > blk_delete_timer()
> > {
> > 	list_del_init(&req->timeout_list);
> > 	if (list_empty(&q->timeout_list))
> > 		del_timer(&q->timeout);
> > }
> > 
> > and none of req->deadline trick is necessary.
> 
> True.  And if we do this, then there's no need to test and increment
> req->deadline in blk_add_timer().

It was an optimization for drivers that don't use block layer timers,
but we can get rid of it.

-- 
Jens Axboe

