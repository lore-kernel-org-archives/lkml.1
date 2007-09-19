Return-Path: <linux-kernel-owner+w=401wt.eu-S1761133AbXISPH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761133AbXISPH6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758455AbXISPHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:07:45 -0400
Received: from stinky.trash.net ([213.144.137.162]:33658 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbXISPHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:07:44 -0400
Message-ID: <46F13999.30700@trash.net>
Date: Wed, 19 Sep 2007 17:00:41 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: lepton <ytht.net@gmail.com>
CC: lkm <linux-kernel@vger.kernel.org>,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH] 2.6.22.6 netfilter: sk_setup_caps in ip_make_route_harder
References: <20070919093648.GA7491@router.lepton.home>
In-Reply-To: <20070919093648.GA7491@router.lepton.home>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lepton wrote:
> Hi,
>   For local src packets, it is better to update sk_route_caps in
>   ip_route_me_harder.


This seems like a good idea to me. But why only for local src
(address) packets? This function can also be used for locally
generated packet that have been (f.i.) NATed to a foreign
address ...


> Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> 
> diff -pru -X linux-2.6.22.6/Documentation/dontdiff linux-2.6.22.6/net/ipv4/netfilter.c linux-2.6.22.6-lepton/net/ipv4/netfilter.c
> --- linux-2.6.22.6/net/ipv4/netfilter.c	2007-09-19 13:19:13.000000000 +0800
> +++ linux-2.6.22.6-lepton/net/ipv4/netfilter.c	2007-09-19 17:10:36.000000000 +0800
> @@ -37,6 +37,10 @@ int ip_route_me_harder(struct sk_buff **
>  		/* Drop old route. */
>  		dst_release((*pskb)->dst);
>  		(*pskb)->dst = &rt->u.dst;
> +		if((*pskb)->sk){
> +			dst_hold((*pskb)->dst);
> +			sk_setup_caps((*pskb)->sk, (*pskb)->dst);
> +		}
>  	} else {
>  		/* non-local src, find valid iif to satisfy
>  		 * rp-filter when calling ip_route_input. */
> 

