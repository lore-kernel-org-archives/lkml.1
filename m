Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbXITR1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbXITR1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXITR1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:27:47 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4278 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbXITR1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:27:45 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: 2.6.23-rc6-mm1: atomic counter underflow
Date: Thu, 20 Sep 2007 19:27:37 +0200
User-Agent: KMail/1.9.7
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <gregkh@suse.de>
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <20070919200205.057e3fbc@gondolin.boeblingen.de.ibm.com> <20070920153518.15e72a24@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070920153518.15e72a24@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709201927.38066.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > -ECONFUSED. Perhaps DEBUG_DRIVER may help some more. Or /me getting
> > some sleep.
> 
> Sleeping helped (improved reading abilities).
> 
> From: Cornelia Huck <cornelia.huck@de.ibm.com>
> 
> mmc: Avoid double sdio_unregister_bus() on module unload.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Ok - I can confirm that this patch fixes the problem.

Thanks,

	Mariusz

> ---
>  drivers/mmc/core/core.c |    1 -
>  1 files changed, 1 deletion(-)
> 
> --- linux-2.6.orig/drivers/mmc/core/core.c
> +++ linux-2.6/drivers/mmc/core/core.c
> @@ -820,7 +820,6 @@ static void __exit mmc_exit(void)
>  {
>  	sdio_unregister_bus();
>  	mmc_unregister_key_type();
> -	sdio_unregister_bus();
>  	mmc_unregister_host_class();
>  	mmc_unregister_bus();
>  	destroy_workqueue(workqueue);
