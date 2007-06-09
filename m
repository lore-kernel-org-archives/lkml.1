Return-Path: <linux-kernel-owner+w=401wt.eu-S1032109AbXFIBVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032109AbXFIBVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030408AbXFIBUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:20:50 -0400
Received: from rhun.apana.org.au ([64.62.148.172]:3392 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S939356AbXFIBUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:20:48 -0400
From: Herbert Xu <herbert@gondor.apana.org.au>
To: chrisw@sous-sol.org (Chris Wright)
Subject: Re: [patch 23/32] IPV4: Correct rp_filter help text.
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Organization: Core
In-Reply-To: <20070608071553.469107000@sous-sol.org>
X-Newsgroups: apana.lists.os.linux.kernel
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1HwpdD-0008Il-00@gondolin.me.apana.org.au>
Date: Sat, 09 Jun 2007 11:20:43 +1000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright <chrisw@sous-sol.org> wrote:
> 
> --- linux-2.6.20.13.orig/net/ipv4/Kconfig
> +++ linux-2.6.20.13/net/ipv4/Kconfig
> @@ -43,11 +43,11 @@ config IP_ADVANCED_ROUTER
>          asymmetric routing (packets from you to a host take a different path
>          than packets from that host to you) or if you operate a non-routing
>          host which has several IP addresses on different interfaces. To turn
> -         rp_filter off use:
> +         rp_filter on use:
> 
> -         echo 0 > /proc/sys/net/ipv4/conf/<device>/rp_filter
> +         echo 1 > /proc/sys/net/ipv4/conf/<device>/rp_filter
>          or
> -         echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
> +         echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter

BTW, this documentation is actually wrong.  You can't enable rp_filter
on all interfaces with

	echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter

You must do that in conjunction with

	echo 1 > /proc/sys/net/ipv4/conf/<device>/rp_filter

for it to work for <device>.

This is really counter-intuitive but it's apparently how it's always
worked.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
