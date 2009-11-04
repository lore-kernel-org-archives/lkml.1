Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbZKDHko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbZKDHko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 02:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZKDHko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 02:40:44 -0500
Received: from [95.166.99.235] ([95.166.99.235]:56141 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbZKDHkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 02:40:43 -0500
Date: Wed, 4 Nov 2009 08:40:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Alex Shi <alex.shi@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel building regression on 32-rc5 kernel
Message-ID: <20091104074048.GT8742@kernel.dk>
References: <F7C8A4D3A9905B45A80E4C194793FA651553C00D3D@PDSMSX501.ccr.corp.intel.com> <20091103183235.GD8742@kernel.dk> <1257297690.3819.256.camel@alexs-hp.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257297690.3819.256.camel@alexs-hp.sh.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04 2009, Alex Shi wrote:
> On Wed, 2009-11-04 at 02:32 +0800, Jens Axboe wrote:
> > On Tue, Nov 03 2009, Shi, Alex wrote:
> > > I found the kernel building will have about 20%~ 30% regressions on
> > > our NHM machines. My kernel build do the following things 15 times:
> > > 
> > > make mrproper; echo \"3\">/proc/sys/vm/drop_caches; make defconfig;
> > > make -j${2timescpunumbers}
> > > 
> > > 
> > > 
> > > Bisect found it is due to the commitment:
> > > 
> > > commit a6151c3a5c8e1ff5a28450bc8d6a99a2a0add0a7
> > 
> > I looked over that commit and found one typo, can you check with this
> > patch applied?
> > 
> > diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> > index 069a610..5802e32 100644
> > --- a/block/cfq-iosched.c
> > +++ b/block/cfq-iosched.c
> > @@ -2051,7 +2051,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
> >  	 * it's a metadata request and the current queue is doing regular IO.
> >  	 */
> >  	if (rq_is_meta(rq) && !cfqq->meta_pending)
> > -		return false;
> > +		return true;
> >  
> >  	/*
> >  	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
>
> Yes, the performance recovered with this patch on 32-rc6 kernel. 

Great! The patch just missed -rc6, as I had already queued it up and
asked for a pull. It's in current -git. Thanks a lot for reporting!

-- 
Jens Axboe

