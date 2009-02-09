Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZBIRWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZBIRWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755406AbZBIRWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:22:24 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43377 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbZBIRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:22:23 -0500
Date: Mon, 9 Feb 2009 09:22:17 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Dai Haruki <dai.haruki@freescale.com>,
       Andy Fleming <afleming@freescale.com>
Subject: Re: [BUG BISECTED] boot hangs while bringing up gianfar ethernet
Message-ID: <20090209172216.GA11312@ovro.caltech.edu>
Mail-Followup-To: Jarek Poplawski <jarkao2@gmail.com>,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Dai Haruki <dai.haruki@freescale.com>,
	Andy Fleming <afleming@freescale.com>
References: <20090129194145.GA4647@ovro.caltech.edu> <20090207225555.GA2680@ami.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090207225555.GA2680@ami.dom.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 09 Feb 2009 09:22:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 07, 2009 at 11:55:56PM +0100, Jarek Poplawski wrote:
> 
> Hi,
> 
> Could you try this patch?
> 
> Thanks,
> Jarek P.
> ---
> 
>  drivers/net/gianfar.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index acae2d8..1335d89 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -1629,6 +1629,8 @@ static void gfar_schedule_cleanup(struct net_device *dev)
>  	if (netif_rx_schedule_prep(&priv->napi)) {
>  		gfar_write(&priv->regs->imask, IMASK_RTX_DISABLED);
>  		__netif_rx_schedule(&priv->napi);
> +	} else {
> +		gfar_write(&priv->regs->ievent, IEVENT_RTX_MASK);
>  	}
>  
>  	spin_unlock(&priv->rxlock);
> 

It works fine for me, the board now boots up normally.

Thanks for the patch,
Ira
