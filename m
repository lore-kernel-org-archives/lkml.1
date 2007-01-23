Return-Path: <linux-kernel-owner+w=401wt.eu-S932911AbXAWRDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbXAWRDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 12:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933093AbXAWRDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 12:03:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:20330 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932911AbXAWRDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 12:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AAkx51oAyuwhag0qH3lUCXYQtutm9RFAB0L8VZOHQi8tyOQY+YbHMuQH697sSvelrNUgKhxP++l/YPow1yS1ji1v5X7fqCGed7hICyqgEQ2c4NjGtIEOY9BM86OlgCLtI4+8KW2EEvac+HqUbcm5bH+3R4jXr81JzNwyR2zLbGk=
Message-ID: <7d01f9f00701230902x5876bba3y4d70b083151e16ad@mail.gmail.com>
Date: Tue, 23 Jan 2007 18:02:59 +0100
From: "Thibaut VARENE" <T-Bone@parisc-linux.org>
To: "Dale Farnsworth" <dale@farnsworth.org>
Subject: Re: [PATCH] mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs
Cc: "Jeff Garzik" <jgarzik@pobox.com>, "Jarek Poplawski" <jarkao2@o2.pl>,
       mlachwani@mvista.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070123165225.GA20153@xyzzy.farnsworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070123165225.GA20153@xyzzy.farnsworth.org>
X-Google-Sender-Auth: 54b3f3220a65273e
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/07, Dale Farnsworth <dale@farnsworth.org> wrote:
> From Dale Farnsworth <dale@farnsworth.org>
>
> mv643xx_eth: Fix race condition in mv643xx_eth_free_tx_descs
>
> This bug was found and isolated by Thibaut VARENE <T-Bone@parisc-linux.org>
> and Jarek Poplawski <jarkao2@o2.pl>.  This patch is a modification of their
> fixes.  We acquire and release the lock for each descriptor that is freed
> to minimize the time the lock is held.
>
> ---
>
>  drivers/net/mv643xx_eth.c |   11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
> index c41ae42..b3bf864 100644
> --- a/drivers/net/mv643xx_eth.c
> +++ b/drivers/net/mv643xx_eth.c
> @@ -332,13 +339,13 @@ int mv643xx_eth_free_tx_descs(struct net
>                 if (skb)
>                         mp->tx_skb[tx_index] = NULL;
>
> -               spin_unlock_irqrestore(&mp->lock, flags);
> -
>                 if (cmd_sts & ETH_ERROR_SUMMARY) {
>                         printk("%s: Error in TX\n", dev->name);
>                         mp->stats.tx_errors++;
>                 }

Note that this printk probably won't show immediately because IRQs are
disabled. But that's maybe not a big deal.

HTH

-- 
Thibaut VARENE
http://www.parisc-linux.org/~varenet/
