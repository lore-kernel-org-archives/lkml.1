Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbXLDSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbXLDSGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXLDSGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:06:25 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXLDSGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:06:23 -0500
Date: Tue, 04 Dec 2007 13:04:41 -0500 (EST)
Message-Id: <20071204.130441.41629552.k-ueda@ct.jp.nec.com>
To: bzolnier@gmail.com
Cc: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       dm-devel@redhat.com, j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 24/28] blk_end_request: changing ide normal caller
 (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
In-Reply-To: <200712041447.00238.bzolnier@gmail.com>
References: <200712012353.05187.bzolnier@gmail.com>
	<20071203.181252.58460084.k-ueda@ct.jp.nec.com>
	<200712041447.00238.bzolnier@gmail.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bartlomiej,

On Tue, 4 Dec 2007 14:47:00 +0100, Bartlomiej Zolnierkiewicz wrote:
> > > Hmmm, this seems to change the old behavior (the request should
> > > be dequeued from the queue only if 'dequeue' variable is set)
> > > and AFAIR some error handling code (in ide-cd?) depends on the
> > > old behavior so please revisit this patch.
> > 
> > blk_end_request() takes care of the dequeue like below,
> > so I think no problem.  (Please see PATCH 01)
> > 
> > > +	/* rq->queuelist of dequeued request should be list_empty() */
> > > +	if (!list_empty(&rq->queuelist))
> > > +		blkdev_dequeue_request(rq);
> > 
> > In the case of ide-cd,
> >   o 'dequeue' variable is 1 only when the request is still linked
> >     to the queue (i.e. rq->queuelist is not empty)
> >   o 'dequeue' variable is 0 only when the request has already been
> >     removed from the queue (i.e. rq->queuelist is empty)
> > So blk_end_request() can handle it correctly.
> 
> It would be helpful to add the above explanation to a patch description.
> 
> > If there are any drivers which don't want dequeue the queued request,
> > the code above would not work.
> > But, as far as I investigated, I have never seen such a requirement
> > in device drivers.
> > 
> > Do you think that ide may still gets a problem for the 'dequeue'?
> 
> Everything seems to be fine now.
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Thank you for the check.
OK, I'll add the explanation about the 'dequeue' to patch description.

Thanks,
Kiyoshi Ueda
