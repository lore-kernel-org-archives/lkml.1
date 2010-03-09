Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0CIEIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 23:08:12 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:59915 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0CIEIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 23:08:10 -0500
Date: Tue, 9 Mar 2010 15:08:07 +1100
From: Simon Horman <horms@verge.net.au>
To: Joe Perches <joe@perches.com>
Cc: Wensong Zhang <wensong@linux-vs.org>, Julian Anastasov <ja@ssi.bg>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
       lvs-devel <lvs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/netfilter/ipvs/ip_vs_ftp.c: Remove use of NIPQUAD
Message-ID: <20100309040805.GA23772@verge.net.au>
References: <1268094699.1617.5.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268094699.1617.5.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 08, 2010 at 04:31:39PM -0800, Joe Perches wrote:
> NIPQUAD has very few uses left.
> 
> Remove this use and make the code have the identical form of the only
> other use of "%u,%u,%u,%u,%u,%u" in net/ipv4/netfilter/nf_nat_ftp.c
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  net/netfilter/ipvs/ip_vs_ftp.c |   10 ++++++++--
>  1 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ftp.c
> b/net/netfilter/ipvs/ip_vs_ftp.c
> index 73f38ea..9f63283 100644
> --- a/net/netfilter/ipvs/ip_vs_ftp.c
> +++ b/net/netfilter/ipvs/ip_vs_ftp.c
> @@ -208,8 +208,14 @@ static int ip_vs_ftp_out(struct ip_vs_app *app,
> struct ip_vs_conn *cp,
>  		 */
>  		from.ip = n_cp->vaddr.ip;
>  		port = n_cp->vport;
> -		sprintf(buf, "%u,%u,%u,%u,%u,%u", NIPQUAD(from.ip),
> -			(ntohs(port)>>8)&255, ntohs(port)&255);
> +		snprintf(buf, sizeof(buf), "%u,%u,%u,%u,%u,%u",
> +			 ((unsigned char *)&from.ip)[0],
> +			 ((unsigned char *)&from.ip)[1],
> +			 ((unsigned char *)&from.ip)[2],
> +			 ((unsigned char *)&from.ip)[3],
> +			 ntohs(port) >> 8,
> +			 ntohs(port) & 0xFF);
> +
>  		buf_len = strlen(buf);
>  
>  		/*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe lvs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
