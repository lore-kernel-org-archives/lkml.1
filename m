Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbZDPQnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbZDPQnK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZDPQmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:42:55 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48217 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753745AbZDPQmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:42:55 -0400
Date: Thu, 16 Apr 2009 18:42:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: simplify I/O stat accounting
Message-ID: <20090416164253.GU5178@kernel.dk>
References: <49E72F19.1030400@redhat.com> <20090416163456.GR5178@kernel.dk> <20090416163728.GS5178@kernel.dk> <20090416163831.GT5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090416163831.GT5178@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16 2009, Jens Axboe wrote:
> On Thu, Apr 16 2009, Jens Axboe wrote:
> > On Thu, Apr 16 2009, Jens Axboe wrote:
> > > On Thu, Apr 16 2009, Jerome Marchand wrote:
> > > > 
> > > > This simplifies I/O stat accounting switching code and separates it
> > > > completely from I/O scheduler switch code.
> > > > 
> > > > Requests are accounted according to the state of their request queue
> > > > at the time of the request allocation. There is no need anymore to
> > > > flush the request queue when switching I/O accounting state.
> > > 
> > > This is cleaner, I like it. I'll apply it, but I'm changing this one:
> > > 
> > > > @@ -792,9 +792,10 @@ static struct request *get_request(struct
> > > > request_queue *q, int rw_flags,
> > > >  	if (priv)
> > > >  		rl->elvpriv++;
> > > > 
> > > > +	iostat = blk_queue_io_stat(q) ? REQ_IO_STAT : 0;
> > > >  	spin_unlock_irq(q->queue_lock);
> > > 
> > > to a regular if, I hate these ?: constructs. An if is much more
> > > readable, imho.
> > 
> > Grmbl, your patch is line wrapped. Please fix your mailer.
> 
> And it doesn't apply to current -git. Looks like a hand apply, but
> please be a little more careful in the future.

OK, it doesn't even compile either:

+#define blk_rq_io_stat(rq)     ((rq)->flags & REQ_IO_STAT)

that wants to be ->cmd_flags.

Please resend when you have something that at least compiles. If you
send untested stuff my way, at least tell me.

-- 
Jens Axboe

