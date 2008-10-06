Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbYJFXxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbYJFXxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYJFXx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:53:29 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47679 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYJFXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:53:28 -0400
Date: Mon, 6 Oct 2008 19:51:13 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 23/28] ipv6: Fix OOPS in ip6_dst_lookup_tail().
Message-ID: <20081006235113.GB29794@hmsreliant.think-freely.org>
References: <20081006225949.357365087@mini.kroah.org> <20081006231750.GX20567@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006231750.GX20567@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2008 at 04:17:50PM -0700, Greg KH wrote:
> 2.6.25-stable review patch.  If anyone has any objections, please let us
> know.
> 


Ack, Thanks Greg.
Neil

> ------------------
> From: Neil Horman <nhorman@tuxdriver.com>
> 
> [ Upstream commit e550dfb0c2c31b6363aa463a035fc9f8dcaa3c9b ]
> 
> This fixes kernel bugzilla 11469: "TUN with 1024 neighbours:
> ip6_dst_lookup_tail NULL crash"
> 
> dst->neighbour is not necessarily hooked up at this point
> in the processing path, so blindly dereferencing it is
> the wrong thing to do.  This NULL check exists in other
> similar paths and this case was just an oversight.
> 
> Also fix the completely wrong and confusing indentation
> here while we're at it.
> 
> Based upon a patch by Evgeniy Polyakov.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  net/ipv6/ip6_output.c |   64 +++++++++++++++++++++++++-------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -930,39 +930,39 @@ static int ip6_dst_lookup_tail(struct so
>  	}
>  
>  #ifdef CONFIG_IPV6_OPTIMISTIC_DAD
> -		/*
> -		 * Here if the dst entry we've looked up
> -		 * has a neighbour entry that is in the INCOMPLETE
> -		 * state and the src address from the flow is
> -		 * marked as OPTIMISTIC, we release the found
> -		 * dst entry and replace it instead with the
> -		 * dst entry of the nexthop router
> -		 */
> -		if (!((*dst)->neighbour->nud_state & NUD_VALID)) {
> -			struct inet6_ifaddr *ifp;
> -			struct flowi fl_gw;
> -			int redirect;
> -
> -			ifp = ipv6_get_ifaddr(&init_net, &fl->fl6_src,
> -					      (*dst)->dev, 1);
> -
> -			redirect = (ifp && ifp->flags & IFA_F_OPTIMISTIC);
> -			if (ifp)
> -				in6_ifa_put(ifp);
> -
> -			if (redirect) {
> -				/*
> -				 * We need to get the dst entry for the
> -				 * default router instead
> -				 */
> -				dst_release(*dst);
> -				memcpy(&fl_gw, fl, sizeof(struct flowi));
> -				memset(&fl_gw.fl6_dst, 0, sizeof(struct in6_addr));
> -				*dst = ip6_route_output(sk, &fl_gw);
> -				if ((err = (*dst)->error))
> -					goto out_err_release;
> -			}
> +	/*
> +	 * Here if the dst entry we've looked up
> +	 * has a neighbour entry that is in the INCOMPLETE
> +	 * state and the src address from the flow is
> +	 * marked as OPTIMISTIC, we release the found
> +	 * dst entry and replace it instead with the
> +	 * dst entry of the nexthop router
> +	 */
> +	if ((*dst)->neighbour && !((*dst)->neighbour->nud_state & NUD_VALID)) {
> +		struct inet6_ifaddr *ifp;
> +		struct flowi fl_gw;
> +		int redirect;
> +
> +		ifp = ipv6_get_ifaddr(&init_net, &fl->fl6_src,
> +				      (*dst)->dev, 1);
> +
> +		redirect = (ifp && ifp->flags & IFA_F_OPTIMISTIC);
> +		if (ifp)
> +			in6_ifa_put(ifp);
> +
> +		if (redirect) {
> +			/*
> +			 * We need to get the dst entry for the
> +			 * default router instead
> +			 */
> +			dst_release(*dst);
> +			memcpy(&fl_gw, fl, sizeof(struct flowi));
> +			memset(&fl_gw.fl6_dst, 0, sizeof(struct in6_addr));
> +			*dst = ip6_route_output(sk, &fl_gw);
> +			if ((err = (*dst)->error))
> +				goto out_err_release;
>  		}
> +	}
>  #endif
>  
>  	return 0;
> 
> -- 
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
