Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbXJHGUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbXJHGUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 02:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbXJHGUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 02:20:21 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:2696 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751535AbXJHGUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 02:20:20 -0400
Date: Mon, 8 Oct 2007 14:19:42 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, dlunev@gmail.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, den@openvz.org
Subject: Re: [NET] IPv6 oops bisected
Message-ID: <20071008061942.GA842@gondor.apana.org.au>
References: <4708E016.9020300@garzik.org> <4708E3CF.4000401@gmail.com> <4708F387.1060602@garzik.org> <20071007.231608.104667710.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071007.231608.104667710.davem@davemloft.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2007 at 11:16:08PM -0700, David Miller wrote:
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index a7db84c..7109ad6 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -1188,7 +1188,7 @@ int ip6_route_add(struct fib6_config *cfg)
>  	if ((cfg->fc_flags & RTF_REJECT) ||
>  	    (dev && (dev->flags&IFF_LOOPBACK) && !(addr_type&IPV6_ADDR_LOOPBACK))) {
>  		/* hold loopback dev/idev if we haven't done so. */
> -		if (dev != dev->nd_net->loopback_dev) {
> +		if (!dev || (dev != dev->nd_net->loopback_dev)) {
>  			if (dev) {
>  				dev_put(dev);
>  				in6_dev_put(idev);

Unfortunately this'll still oops a few lines down when it tries
to assign dev->nd_net->loopabck_dev to dev.  The issue here is
which namespace are we in if dev is NULL.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
