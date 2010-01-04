Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559Ab0ADQPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab0ADQPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:15:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445Ab0ADQPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:15:24 -0500
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:22662 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0ADQPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:15:22 -0500
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Julia Lawall <julia@diku.dk>, ISS StorageDev <iss_storagedev@hp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 4 Jan 2010 16:14:53 +0000
Subject: RE: [PATCH 1/2] drivers/block: drop unnecesary memset
Thread-Topic: [PATCH 1/2] drivers/block: drop unnecesary memset
Thread-Index: AcqAfRvUNHdnf9OtQqyov+Out4/aMQM29Rtg
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77886995B7E02A@GVW0547EXC.americas.hpqcorp.net>
References: <Pine.LNX.4.64.0912190829470.30546@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0912190829470.30546@ask.diku.dk>
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

 

> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk] 
> Sent: Saturday, December 19, 2009 1:30 AM
> To: Miller, Mike (OS Dev); ISS StorageDev; 
> linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH 1/2] drivers/block: drop unnecesary memset
> 
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

Acked-by: Mike Miller <mike.miller@hp.com>

> 
> ---
>  drivers/block/cciss.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -4379,7 +4379,6 @@ static void cciss_shutdown(struct pci_de
>  		return;
>  	}
>  	/* write all data in the battery backed cache to disk */
> -	memset(flush_buf, 0, 4);
>  	return_code = sendcmd_withirq(CCISS_CACHE_FLUSH, 
> h->ctlr, flush_buf,
>  		4, 0, CTLR_LUNID, TYPE_CMD);
>  	kfree(flush_buf);
> 