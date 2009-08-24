Return-Path: <linux-kernel-owner+w=401wt.eu-S1751819AbZHXH6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbZHXH6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751904AbZHXH6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:58:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbZHXH6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:58:01 -0400
Date: Mon, 24 Aug 2009 09:58:03 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org, benh@kernel.crashing.org,
       htejun@gmail.com, bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/4] direct-io: unify argument passing by adding a
	dio_args structure
Message-ID: <20090824075803.GX12579@kernel.dk>
References: <1250763466-24282-1-git-send-email-jens.axboe@oracle.com> <1250763466-24282-2-git-send-email-jens.axboe@oracle.com> <20090820170306.93388637.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820170306.93388637.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20 2009, Andrew Morton wrote:
> On Thu, 20 Aug 2009 12:17:36 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > The O_DIRECT IO path is a mess of arguments. Clean that up by passing
> > those arguments in a dedicated dio_args structure.
> > 
> > This is in preparation for changing the internal implementation to be
> > page based instead of using iovecs.
> > 
> > ...
> >
> > +/*
> > + * Arguments passwed to aops->direct_IO()
> 
> cnat tpye

Ineedd, thanks.

> > + */
> > +struct dio_args {
> > +	int rw;
> > +	const struct iovec *iov;
> > +	unsigned long length;
> > +	loff_t offset;
> > +	unsigned long nr_segs;
> > +};
> 
> It would be nice to have some documentation.  Especially for that
> pestiferous `rw' thing.
> 
> nr_segs is associated with the iovec and might as well be contiguous
> with it in the struct.

Agree on both accounts, I'll add some comment above/inside that struct.

-- 
Jens Axboe

