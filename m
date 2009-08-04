Return-Path: <linux-kernel-owner+w=401wt.eu-S932327AbZHDEti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbZHDEti (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 00:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbZHDEth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 00:49:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:54969 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867AbZHDEtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 00:49:36 -0400
Message-ID: <4A77BDCC.1070502@kernel.org>
Date: Tue, 04 Aug 2009 13:49:16 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, geomatsi@gmail.com
Subject: Re: [PATCH 9/10] drivers/ata: introduce missing kfree
References: <Pine.LNX.4.64.0908011055050.23408@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0908011055050.23408@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 04 Aug 2009 04:49:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
...
> ---
>  drivers/ata/pata_at91.c             |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/pata_at91.c b/drivers/ata/pata_at91.c
> index 5702aff..46fb883 100644
> --- a/drivers/ata/pata_at91.c
> +++ b/drivers/ata/pata_at91.c
> @@ -261,7 +261,8 @@ static int __devinit pata_at91_probe(struct platform_device *pdev)
>  
>  	if (IS_ERR(info->mck)) {
>  		dev_err(dev, "failed to get access to mck clock\n");
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto err_clk_get;
>  	}
>  
>  	info->cs    = board->chipselect;
> @@ -308,6 +309,7 @@ err_alt_ioremap:
>  
>  err_ide_ioremap:
>  	clk_put(info->mck);
> +err_clk_get:
>  	kfree(info);

cc'ing Matyukevich Sergey.  Matyukevich, is it possible to use
devm_kzalloc() instead?

Thanks.

-- 
tejun
