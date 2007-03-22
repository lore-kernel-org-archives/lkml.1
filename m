Return-Path: <linux-kernel-owner+w=401wt.eu-S933175AbXCVTXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175AbXCVTXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933982AbXCVTXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:23:14 -0400
Received: from saeurebad.de ([85.214.36.134]:44978 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933175AbXCVTXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:23:13 -0400
Date: Thu, 22 Mar 2007 20:22:34 +0100
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: null pointer dereference in cfq_dispatch_requests (2.6.21-rc2 and 2.6.20)
Message-ID: <20070322192233.GA5873@localhost>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org
References: <1172685755.5773.6.camel@dwillia2-linux.ch.intel.com> <200703011308.28266.linux@f-seidel.de> <20070301123057.GO23985@kernel.dk> <loom.20070321T135132-397@post.gmane.org> <20070321190359.GD16768@leiferikson> <20070322184235.GZ19922@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070322184235.GZ19922@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Mar 22, 2007 at 07:42:35PM +0100, Jens Axboe wrote:
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index b6491c0..ca84f0b 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -961,8 +961,8 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> >  		/*
> >  		 * follow expired path, else get first next available
> >  		 */
> > -		if ((rq = cfq_check_fifo(cfqq)) == NULL)
> > -			rq = cfqq->next_rq;
> > +		if (!(rq = cfq_check_fifo(cfqq)) && !(rq = cfqq->next_rq))
> > +			break;
> 
> That still only hides a bug. It is illegal for ->next_rq to be NULL
> while the RB tree is non-empty.

As I noticed afterwards this isn't even the point where the NULL ptr is
dereferenced.  It must be in the next code-line, cfqd->queue or
cfqd->queue->elevator was NULL when the oops occured or am I wrong?

'Hannes
