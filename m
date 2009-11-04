Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZKDBUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZKDBUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZKDBUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:20:12 -0500
Received: from mga02.intel.com ([134.134.136.20]:44514 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbZKDBUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:20:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,677,1249282800"; 
   d="scan'208";a="464109871"
Subject: Re: kernel building regression on 32-rc5 kernel
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091103183235.GD8742@kernel.dk>
References: <F7C8A4D3A9905B45A80E4C194793FA651553C00D3D@PDSMSX501.ccr.corp.intel.com>
	 <20091103183235.GD8742@kernel.dk>
Content-Type: text/plain
Organization: intel.com
Date: Wed, 04 Nov 2009 09:21:30 +0800
Message-Id: <1257297690.3819.256.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the performance recovered with this patch on 32-rc6 kernel. 


On Wed, 2009-11-04 at 02:32 +0800, Jens Axboe wrote:
> On Tue, Nov 03 2009, Shi, Alex wrote:
> > I found the kernel building will have about 20%~ 30% regressions on
> > our NHM machines. My kernel build do the following things 15 times:
> > 
> > make mrproper; echo \"3\">/proc/sys/vm/drop_caches; make defconfig;
> > make -j${2timescpunumbers}
> > 
> > 
> > 
> > Bisect found it is due to the commitment:
> > 
> > commit a6151c3a5c8e1ff5a28450bc8d6a99a2a0add0a7
> 
> I looked over that commit and found one typo, can you check with this
> patch applied?
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 069a610..5802e32 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -2051,7 +2051,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
>  	 * it's a metadata request and the current queue is doing regular IO.
>  	 */
>  	if (rq_is_meta(rq) && !cfqq->meta_pending)
> -		return false;
> +		return true;
>  
>  	/*
>  	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
> 

