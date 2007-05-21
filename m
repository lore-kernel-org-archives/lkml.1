Return-Path: <linux-kernel-owner+w=401wt.eu-S935083AbXEUTma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935083AbXEUTma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXEUT11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:27:27 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:35821 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765610AbXEUT1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:27:25 -0400
Message-Id: <20070521191727.668737000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:16:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Eric Sesterhenn <snakebyte@gmx.de>
Subject: [patch 31/69] IPV6: Fix slab corruption running ip6sic
Content-Disposition: inline; filename=ipv6-fix-slab-corruption-running-ip6sic.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Eric Sesterhenn <snakebyte@gmx.de>

---
 net/ipv6/xfrm6_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/net/ipv6/xfrm6_tunnel.c
+++ linux-2.6.21.1/net/ipv6/xfrm6_tunnel.c
@@ -261,7 +261,7 @@ static int xfrm6_tunnel_rcv(struct sk_bu
 	__be32 spi;
 
 	spi = xfrm6_tunnel_spi_lookup((xfrm_address_t *)&iph->saddr);
-	return xfrm6_rcv_spi(skb, spi);
+	return xfrm6_rcv_spi(skb, spi) > 0 ? : 0;
 }
 
 static int xfrm6_tunnel_err(struct sk_buff *skb, struct inet6_skb_parm *opt,

-- 
