Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYK3Eny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYK3Eny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 23:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbYK3Enm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 23:43:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48970
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754366AbYK3Enl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 23:43:41 -0500
Date: Sat, 29 Nov 2008 20:43:41 -0800 (PST)
Message-Id: <20081129.204341.88799313.davem@davemloft.net>
To: jirislaby@gmail.com
Cc: chas@cmf.nrl.navy.mil, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] ATM: horizon, fix hrz_probe fail path
From: David Miller <davem@davemloft.net>
In-Reply-To: <1227994465-20220-1-git-send-email-jirislaby@gmail.com>
References: <1227994465-20220-1-git-send-email-jirislaby@gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>
Date: Sat, 29 Nov 2008 22:34:25 +0100

> One fail path in hrz_probe omitted device disable. Fix it.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

Applied, but please post all networking patches to
netdev@vger.kernel.org, in particular so that they
get properly tracked at:

	http://patchwork.ozlabs.org/project/netdev/list/

I feel like I type this in at least 10 times a day, so
people please start making sure netdev is on the CC: for
all networking patches.

Thanks!

> ---
>  drivers/atm/horizon.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
> index 6154123..6b969f8 100644
> --- a/drivers/atm/horizon.c
> +++ b/drivers/atm/horizon.c
> @@ -2705,7 +2705,7 @@ static int __devinit hrz_probe(struct pci_dev *pci_dev, const struct pci_device_
>  
>  	/* XXX DEV_LABEL is a guess */
>  	if (!request_region(iobase, HRZ_IO_EXTENT, DEV_LABEL)) {
> -		return -EINVAL;
> +		err = -EINVAL;
>  		goto out_disable;
>  	}
>  
> -- 
> 1.6.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
