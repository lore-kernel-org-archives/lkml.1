Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZLWPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZLWPJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZLWPJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:09:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:60720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756191AbZLWPJg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:09:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,442,1257148800"; 
   d="scan'208";a="478645079"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Julia Lawall <julia@diku.dk>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 23 Dec 2009 15:08:32 +0000
Subject: RE: [PATCH 1/6] drivers/dma: Correct use after free
Thread-Topic: [PATCH 1/6] drivers/dma: Correct use after free
Thread-Index: AcqDRcVjlceMVTLjT8K9R1dVrY6tegAm/p+A
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB370DD8@irsmsx504.ger.corp.intel.com>
References: <Pine.LNX.4.64.0912222130370.28669@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912222130370.28669@ask.diku.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Move the kfree after the iounmap that refers to the same structure.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x,e;
> identifier f;
> iterator I;
> statement S;
> @@
> 
> *kfree(x);
> ... when != &x
>     when != x = e
>     when != I(x,...) S
> *x->f
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/dma/coh901318.c             |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index 4a99cd9..b5f2ee0 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -1294,8 +1294,8 @@ static int __exit coh901318_remove(struct platform_device *pdev)
>  	dma_async_device_unregister(&base->dma_slave);
>  	coh901318_pool_destroy(&base->pool);
>  	free_irq(platform_get_irq(pdev, 0), base);
> -	kfree(base);
>  	iounmap(base->virtbase);
> +	kfree(base);
>  	release_mem_region(pdev->resource->start,
>  			   resource_size(pdev->resource));
>  	return 0;

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
