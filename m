Return-Path: <linux-kernel-owner+w=401wt.eu-S1756973AbZIRLyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973AbZIRLyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 07:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756621AbZIRLyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 07:54:05 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:45685 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbZIRLyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 07:54:04 -0400
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: Kusanagi Kouichi <slash@ma.neweb.ne.jp>
Subject: Re: tun: Return -EINVAL if neither IFF_TUN nor IFF_TAP is set.
Date: Fri, 18 Sep 2009 07:54:05 -0400
User-Agent: KMail/1.12.1 (Linux/2.6.30-gentoo-r7; KDE/4.3.1; i686; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090917073614.15217260031@msa105lp.auone-net.jp>
In-Reply-To: <20090917073614.15217260031@msa105lp.auone-net.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909180754.05817.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009 03:36:13 am Kusanagi Kouichi wrote:
> After commit 2b980dbd77d229eb60588802162c9659726b11f4
> ("lsm: Add hooks to the TUN driver") tun_set_iff doesn't
> return -EINVAL though neither IFF_TUN nor IFF_TAP is set.
> 
> Signed-off-by: Kusanagi Kouichi <slash@ma.neweb.ne.jp>

Sorry about that, my mistake, thanks for finding and fixing this.

Reviewed-by: Paul Moore <paul.moore@hp.com>

> ---
>  drivers/net/tun.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 3f5d288..e091756 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -946,8 +946,6 @@ static int tun_set_iff(struct net *net, struct file
>  *file, struct ifreq *ifr) char *name;
>  		unsigned long flags = 0;
> 
> -		err = -EINVAL;
> -
>  		if (!capable(CAP_NET_ADMIN))
>  			return -EPERM;
>  		err = security_tun_dev_create();
> @@ -964,7 +962,7 @@ static int tun_set_iff(struct net *net, struct file
>  *file, struct ifreq *ifr) flags |= TUN_TAP_DEV;
>  			name = "tap%d";
>  		} else
> -			goto failed;
> +			return -EINVAL;
> 
>  		if (*ifr->ifr_name)
>  			name = ifr->ifr_name;
> 

-- 
paul moore
linux @ hp
