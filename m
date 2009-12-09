Return-Path: <linux-kernel-owner+w=401wt.eu-S1752985AbZLIOvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbZLIOvK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZLIOvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:51:09 -0500
Received: from relais.videotron.ca ([24.201.245.36]:30421 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbZLIOvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:51:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Wed, 09 Dec 2009 09:51:14 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Mike Frysinger <vapier@gentoo.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smc91x: fix unused flags warnings on UP systems
In-reply-to: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
Message-id: <alpine.LFD.2.00.0912090950460.31174@xanadu.home>
References: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Dec 2009, Mike Frysinger wrote:

> Local flags variables will be declared whenever these functions get used,
> but obviously on UP systems the flags parameter won't be touched.  So add
> some dummy ops that get optimized away anyways to satisfy gcc's warnings.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Acked-by: Nicolas Pitre <nico@fluxnic.net>


> ---
>  drivers/net/smc91x.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
> index ae4983a..b0c92b6 100644
> --- a/drivers/net/smc91x.c
> +++ b/drivers/net/smc91x.c
> @@ -534,9 +534,9 @@ static inline void  smc_rcv(struct net_device *dev)
>  #define smc_special_lock(lock, flags)		spin_lock_irqsave(lock, flags)
>  #define smc_special_unlock(lock, flags) 	spin_unlock_irqrestore(lock, flags)
>  #else
> -#define smc_special_trylock(lock, flags)	(1)
> -#define smc_special_lock(lock, flags)   	do { } while (0)
> -#define smc_special_unlock(lock, flags)	do { } while (0)
> +#define smc_special_trylock(lock, flags)	(flags == flags)
> +#define smc_special_lock(lock, flags)   	do { flags = 0; } while (0)
> +#define smc_special_unlock(lock, flags)	do { flags = 0; } while (0)
>  #endif
>  
>  /*
> -- 
> 1.6.5.5
> 
