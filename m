Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbZLWPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbZLWPIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 10:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbZLWPIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 10:08:13 -0500
Received: from mga09.intel.com ([134.134.136.24]:46734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbZLWPIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 10:08:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,442,1257148800"; 
   d="scan'208";a="581597924"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Julia Lawall <julia@diku.dk>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 23 Dec 2009 15:08:11 +0000
Subject: RE: [PATCH 2/2] drivers/dma: drop unnecesary memset
Thread-Topic: [PATCH 2/2] drivers/dma: drop unnecesary memset
Thread-Index: AcqAfSi/7aiwNhWAQPWxh6yYt8YGbQDZHL0A
Message-ID: <129600E5E5FB004392DDC3FB599660D7CB370DD6@irsmsx504.ger.corp.intel.com>
References: <Pine.LNX.4.64.0912190830110.30546@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912190830110.30546@ask.diku.dk>
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
> memset of 0 is not needed after kzalloc
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression x;
> statement S;
> @@
> 
> x = kzalloc(...);
> if (x == NULL) S
> ... when != x
> -memset(x,0,...);// </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/dma/dw_dmac.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff -u -p a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1270,8 +1270,6 @@ static int __init dw_probe(struct platfo
>  		goto err_kfree;
>  	}
> 
> -	memset(dw, 0, sizeof *dw);
> -
>  	dw->regs = ioremap(io->start, DW_REGLEN);
>  	if (!dw->regs) {
>  		err = -ENOMEM;

Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>