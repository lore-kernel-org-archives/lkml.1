Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbXEJLVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbXEJLVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 07:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbXEJLVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 07:21:05 -0400
Received: from brick.kernel.dk ([80.160.20.94]:24538 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476AbXEJLVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 07:21:04 -0400
Date: Thu, 10 May 2007 13:20:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] ll_rw_blk: temporarily enable max_segments  tweaking
Message-ID: <20070510112034.GO4629@kernel.dk>
References: <11787925152319-git-send-email-jens.axboe@oracle.com> <11787925162730-git-send-email-jens.axboe@oracle.com> <20070510034926.7ae29119.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510034926.7ae29119.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10 2007, Andrew Morton wrote:
> On Thu, 10 May 2007 12:21:54 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > Expose this setting for now, so that users can play with enabling
> > large commands without defaulting it to on globally.
> > 
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  block/ll_rw_blk.c |   22 ++++++++++++++++++++++
> >  1 files changed, 22 insertions(+), 0 deletions(-)
> > 
> > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > index b01a5f2..cf05396 100644
> > --- a/block/ll_rw_blk.c
> > +++ b/block/ll_rw_blk.c
> > @@ -3930,7 +3930,22 @@ static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
> >  	return queue_var_show(max_hw_sectors_kb, (page));
> >  }
> >  
> > +static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
> > +{
> > +	return queue_var_show(q->max_phys_segments, page);
> > +}
> > +
> > +static ssize_t queue_max_segments_store(struct request_queue *q, const char *page, size_t count)
> 
> 100-col xterm?

It's a debug thing, it'll go away for the final versions. So I didn't
pay much attention to details.

-- 
Jens Axboe

