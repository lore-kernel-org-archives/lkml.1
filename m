Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbXJXGrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbXJXGrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbXJXGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:47:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbXJXGrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:47:11 -0400
Date: Wed, 24 Oct 2007 08:47:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [SPARC64]: More SG build fixes
Message-ID: <20071024064708.GU14671@kernel.dk>
References: <20071023.223756.34760847.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023.223756.34760847.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, David Miller wrote:
> 
> diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
> index c8313cb..217478a 100644
> --- a/arch/sparc64/kernel/ldc.c
> +++ b/arch/sparc64/kernel/ldc.c
> @@ -2121,7 +2121,7 @@ int ldc_map_sg(struct ldc_channel *lp,
>  	state.nc = 0;
>  
>  	for (i = 0; i < num_sg; i++)
> -		fill_cookies(&state, page_to_pfn(sg[i].page) << PAGE_SHIFT,
> +		fill_cookies(&state, page_to_pfn(sg_page(&sg[i])) << PAGE_SHIFT,
>  			     sg[i].offset, sg[i].length);
>  
>  	return state.nc;
> diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
> index 7276f7d..fac4c6c 100644
> --- a/drivers/block/sunvdc.c
> +++ b/drivers/block/sunvdc.c
> @@ -15,6 +15,7 @@
>  #include <linux/delay.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
> +#include <linux/scatterlist.h>
>  
>  #include <asm/vio.h>
>  #include <asm/ldc.h>

added

-- 
Jens Axboe

