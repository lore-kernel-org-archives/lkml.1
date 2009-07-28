Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbZG1Raj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbZG1Raj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbZG1Rai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:30:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46911
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753606AbZG1Rah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:30:37 -0400
Date: Tue, 28 Jul 2009 10:30:44 -0700 (PDT)
Message-Id: <20090728.103044.179053537.davem@davemloft.net>
To: julia@diku.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/9] drivers/net/wireless: correct error-handling code
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>
References: <Pine.LNX.4.64.0907281753540.28189@ask.diku.dk>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>
Date: Tue, 28 Jul 2009 17:54:24 +0200 (CEST)

Wireless patches need to be CC:'d to linux-wireless so that
John Linville can notice and pick them up.  Added...

> From: Julia Lawall <julia@diku.dk>
> 
> iwm_wdev_alloc returns an ERR_PTR value in an error case instead of NULL.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @match exists@
> expression x, E;
> statement S1, S2;
> @@
> 
> x = iwm_wdev_alloc(...)
> ... when != x = E
> (
> *  if (x == NULL || ...) S1 else S2
> |
> *  if (x == NULL && ...) S1 else S2
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/net/wireless/iwmc3200wifi/netdev.c     |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
> index bb71f8a..e1c6693 100644
> --- a/drivers/net/wireless/iwmc3200wifi/netdev.c
> +++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
> @@ -99,7 +99,7 @@ void *iwm_if_alloc(int sizeof_bus, struct device *dev,
>  	int ret = 0;
>  
>  	wdev = iwm_wdev_alloc(sizeof_bus, dev);
> -	if (!wdev) {
> +	if (IS_ERR(wdev)) {
>  		dev_err(dev, "no memory for wireless device instance\n");
>  		return ERR_PTR(-ENOMEM);
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
