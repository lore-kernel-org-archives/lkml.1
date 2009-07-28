Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZG1QLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZG1QLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZG1QLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:11:19 -0400
Received: from ru.mvista.com ([213.79.90.228]:25748 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754686AbZG1QLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:11:18 -0400
Date: Tue, 28 Jul 2009 20:11:15 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Julia Lawall <julia@diku.dk>
Cc: linuxppc-dev@ozlabs.org, sdhci-devel@lists.ossman.eu,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 8/9] drivers/mmc: correct error-handling code
Message-ID: <20090728161115.GA8091@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0907281755340.28189@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907281755340.28189@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 05:56:00PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> sdhci_alloc_host returns an ERR_PTR value in an error case instead of NULL.
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
> x = sdhci_alloc_host(...)
> ... when != x = E
> (
> *  if (x == NULL || ...) S1 else S2
> |
> *  if (x == NULL && ...) S1 else S2
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Anton Vorontsov <avorontsov@ru.mvista.com>

Thanks,

> ---
>  drivers/mmc/host/sdhci-of.c         |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-of.c b/drivers/mmc/host/sdhci-of.c
> index d79fa55..fb00bc5 100644
> --- a/drivers/mmc/host/sdhci-of.c
> +++ b/drivers/mmc/host/sdhci-of.c
> @@ -226,7 +226,7 @@ static int __devinit sdhci_of_probe(struct of_device *ofdev,
>  		return -ENODEV;
>  
>  	host = sdhci_alloc_host(&ofdev->dev, sizeof(*of_host));
> -	if (!host)
> +	if (IS_ERR(host))
>  		return -ENOMEM;
>  
>  	of_host = sdhci_priv(host);

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
