Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbXJ3Uqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbXJ3Uqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 16:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbXJ3UqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 16:46:25 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:47646 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbXJ3UqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 16:46:24 -0400
Message-ID: <472797FB.3050509@tiscali.nl>
Date: Tue, 30 Oct 2007 21:45:47 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix drivers/net/wan/lmc/ compilation
References: <20071030203136.GQ7227@stusta.de>
In-Reply-To: <20071030203136.GQ7227@stusta.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> Documentation/SubmitChecklist, point 1:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/net/wan/lmc/lmc_main.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c: In function ‘lmc_ioctl’:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/net/wan/lmc/lmc_main.c:239: error: expected expression before ‘else’
> ...
> make[5]: *** [drivers/net/wan/lmc/lmc_main.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> d5e92a30491abf073e0a7f4d46b466c7c97f0f61 
> diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
> index 64eb578..37c52e1 100644
> --- a/drivers/net/wan/lmc/lmc_main.c
> +++ b/drivers/net/wan/lmc/lmc_main.c
> @@ -234,7 +234,7 @@ int lmc_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
>          sc->lmc_xinfo.Magic1 = 0xDEADBEEF;
>  
>          if (copy_to_user(ifr->ifr_data, &sc->lmc_xinfo,
> -					sizeof(struct lmc_xinfo))) {
> +			 sizeof(struct lmc_xinfo)))
>  		ret = -EFAULT;
>  	else
>  		ret = 0;
> 

I am sorry, my patch broke this and Kristov Provost also noticed this.
See http://lkml.org/lkml/2007/10/30/355


