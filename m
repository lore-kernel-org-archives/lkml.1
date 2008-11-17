Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbYKQMKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbYKQMKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 07:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbYKQMKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 07:10:33 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:43312 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200AbYKQMKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 07:10:32 -0500
Date: Mon, 17 Nov 2008 13:08:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Milton Miller <miltonm@bga.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi-ioctl: use clock_t <> jiffies
Message-ID: <20081117120847.GL26778@kernel.dk>
References: <31226729703643c98694.1714636915.miltonm@bga.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31226729703643c98694.1714636915.miltonm@bga.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15 2008, Milton Miller wrote:
> Convert the timeout ioctl scalling to use the clock_t functions
> which are much more accurate with some USER_HZ vs HZ combinations.
> 
> Signed-off-by: Milton Miller <miltonm@bga.com>
> ---
> While doing some work with low HZ rates for a simulator, 
> I saw a divide-by-zero warning that pointed out these 
> hz scales.
> 
> 
> Index: sim/block/scsi_ioctl.c
> ===================================================================
> --- sim.orig/block/scsi_ioctl.c	2008-11-11 01:19:29.000000000 -0600
> +++ sim/block/scsi_ioctl.c	2008-11-11 01:22:11.000000000 -0600
> @@ -60,7 +60,7 @@ static int scsi_get_bus(struct request_q
>  
>  static int sg_get_timeout(struct request_queue *q)
>  {
> -	return q->sg_timeout / (HZ / USER_HZ);
> +	return jiffies_to_clock_t(q->sg_timeout);
>  }
>  
>  static int sg_set_timeout(struct request_queue *q, int __user *p)
> @@ -68,7 +68,7 @@ static int sg_set_timeout(struct request
>  	int timeout, err = get_user(timeout, p);
>  
>  	if (!err)
> -		q->sg_timeout = timeout * (HZ / USER_HZ);
> +		q->sg_timeout = clock_t_to_jiffies(timeout);
>  
>  	return err;
>  }

Thanks, applied to for-2.6.29

-- 
Jens Axboe

