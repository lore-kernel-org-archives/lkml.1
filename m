Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYKEQV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYKEQV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYKEQVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:21:50 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45660 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751740AbYKEQVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:21:49 -0500
Date: Wed, 5 Nov 2008 11:21:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Jens Axboe <jens.axboe@oracle.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] Block: use round_jiffies_up()
In-Reply-To: <4911144E.3030404@kernel.org>
Message-ID: <Pine.LNX.4.44L0.0811051120220.2573-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Nov 2008, Tejun Heo wrote:

> Hello,
> 
> Alan Stern wrote:
> > @@ -78,13 +78,14 @@ void blk_delete_timer(struct request *re
> >  	/*
> >  	 * Nothing to detach
> >  	 */
> > -	if (!q->rq_timed_out_fn || !req->deadline)
> > +	if (!req->deadline)
> >  		return;
> >  
> >  	list_del_init(&req->timeout_list);
> >  
> >  	if (list_empty(&q->timeout_list))
> >  		del_timer(&q->timeout);
> > +	req->deadline = 0;
> >  }
> 
> Actually, this can just be
> 
> blk_delete_timer()
> {
> 	list_del_init(&req->timeout_list);
> 	if (list_empty(&q->timeout_list))
> 		del_timer(&q->timeout);
> }
> 
> and none of req->deadline trick is necessary.

True.  And if we do this, then there's no need to test and increment
req->deadline in blk_add_timer().

Alan Stern

