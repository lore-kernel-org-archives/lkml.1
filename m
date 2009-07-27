Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872AbZG0JW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbZG0JW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbZG0JWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:22:25 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57774 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZG0JWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:22:24 -0400
Date: Mon, 27 Jul 2009 19:22:23 +1000
From: Simon Horman <horms@verge.net.au>
To: Hannes Eder <heder@google.com>
Cc: netdev@vger.kernel.org, lvs-users@linuxvirtualserver.org,
       malcolm@loadbalancer.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] IPVS: logging sizeof(struct ip_vs_conn) on startup
Message-ID: <20090727092219.GB26337@verge.net.au>
Mail-Followup-To: Hannes Eder <heder@google.com>, netdev@vger.kernel.org,
	lvs-users@linuxvirtualserver.org, malcolm@loadbalancer.org,
	linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>
References: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 11:08:34AM +0200, Hannes Eder wrote:
> No more guessing, how much memory is used by IPVS for a connection.

I like that.

> Signed-off-by: Hannes Eder <heder@google.com>

Signed-off-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
> index b021464..5b0997c 100644
> --- a/net/netfilter/ipvs/ip_vs_core.c
> +++ b/net/netfilter/ipvs/ip_vs_core.c
> @@ -1475,7 +1475,8 @@ static int __init ip_vs_init(void)
>  		goto cleanup_conn;
>  	}
>  
> -	IP_VS_INFO("ipvs loaded.\n");
> +	IP_VS_INFO("ipvs loaded (using %Zd bytes/connection).\n",
> +	       sizeof(struct ip_vs_conn));
>  	return ret;
>  
>    cleanup_conn:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
