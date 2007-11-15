Return-Path: <linux-kernel-owner+w=401wt.eu-S1760273AbXKOOuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760273AbXKOOuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbXKOOtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:49:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:59908 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541AbXKOOtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:49:50 -0500
Date: Thu, 15 Nov 2007 14:49:47 +0000
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix build failure when CONFIG_INFINIBAND_IPOIB_CM is not defined.
Message-ID: <20071115144946.GJ5128@skynet.ie>
References: <20071113175906.497a1a6a.akpm@linux-foundation.org> <20071114034019.GI24243@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071114034019.GI24243@bakeyournoodle.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (14/11/07 14:40), Tony Breeds didst pronounce:
> Fixes:
>   CC [M]  drivers/infiniband/ulp/ipoib/ipoib_main.o
> drivers/infiniband/ulp/ipoib/ipoib_main.c: In function ???ipoib_init_module???:
> drivers/infiniband/ulp/ipoib/ipoib_main.c:1269: error: invalid lvalue in assignment
> 
> In the case where CONFIG_INFINIBAND_IPOIB_CM is not defined ipoib_max_conn_qp is #defined to 0.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> 
> ---
> 
>  drivers/infiniband/ulp/ipoib/ipoib_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> index 623458e..aeb5a01 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
> @@ -1265,8 +1265,9 @@ static int __init ipoib_init_module(void)
>  	ipoib_sendq_size = roundup_pow_of_two(ipoib_sendq_size);
>  	ipoib_sendq_size = min(ipoib_sendq_size, IPOIB_MAX_QUEUE_SIZE);
>  	ipoib_sendq_size = max(ipoib_sendq_size, IPOIB_MIN_QUEUE_SIZE);
> -
> +#ifdef CONFIG_INFINIBAND_IPOIB_CM
>  	ipoib_max_conn_qp = min(ipoib_max_conn_qp, IPOIB_CM_MAX_CONN_QP);
> +#endif

The patch fixes the compile although having a variable name #defined as 0
seems a bit of an unexpected suprise.

Either way, when applied with the hotfixes, bl6-13 on
http://test.kernel.org successfully boots.

>  
>  	ret = ipoib_register_debugfs();
>  	if (ret)
> 
> Yours Tony
> 
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
