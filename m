Return-Path: <linux-kernel-owner+w=401wt.eu-S1759333AbYHAU1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbYHAU1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYHAU1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:27:08 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:55182 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYHAU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:27:07 -0400
Date: Fri, 1 Aug 2008 13:57:14 -0500
From: Scott Wood <scottwood@freescale.com>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] fs-enet: remove code associated with !CONFIG_PPC_MERGE
Message-ID: <20080801185714.GA26062@ld0162-tx32.am.freescale.net>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org> <1217609060-6381-2-git-send-email-galak@kernel.crashing.org> <1217609060-6381-3-git-send-email-galak@kernel.crashing.org> <1217609060-6381-4-git-send-email-galak@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217609060-6381-4-git-send-email-galak@kernel.crashing.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 11:44:13AM -0500, Kumar Gala wrote:
> diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
> index 9a51ec8..e54d003 100644
> --- a/drivers/net/fs_enet/fs_enet-main.c
> +++ b/drivers/net/fs_enet/fs_enet-main.c
> @@ -669,7 +669,6 @@ static int fs_request_irq(struct net_device *dev, int irq, const char *name,
>  {
>  	struct fs_enet_private *fep = netdev_priv(dev);
>  
> -	(*fep->ops->pre_request_irq)(dev, irq);
>  	return request_irq(irq, irqf, IRQF_SHARED, name, dev);
>  }

This makes "fep" an unused variable.  Eliminate this function entirely,
and call request_irq directly from the caller.

>  
> @@ -678,7 +677,6 @@ static void fs_free_irq(struct net_device *dev, int irq)
>  	struct fs_enet_private *fep = netdev_priv(dev);
>  
>  	free_irq(irq, dev);
> -	(*fep->ops->post_free_irq)(dev, irq);
>  }

Likewise.

-Scott
