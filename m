Return-Path: <linux-kernel-owner+w=401wt.eu-S935560AbXEUTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935560AbXEUTtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934071AbXEUT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:08 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52633 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932950AbXEUT3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:04 -0400
Message-Id: <20070521191746.926217000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:02 -0700
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
       bunk@stusta.de, Corey Mutter <crm-netdev@mutternet.com>,
       David L Stevens <dlstevens@us.ibm.com>
Subject: [patch 50/69] IPV6: Reverse sense of promisc tests in ip6_mc_input
Content-Disposition: inline; filename=ipv6-reverse-sense-of-promisc-tests-in-ip6_mc_input.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Corey Mutter <crm-netdev@mutternet.com>

Reverse the sense of the promiscuous-mode tests in ip6_mc_input(). 

Signed-off-by: Corey Mutter <crm-netdev@mutternet.com>
Signed-off-by: David L Stevens <dlstevens@us.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv6/ip6_input.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/net/ipv6/ip6_input.c
+++ linux-2.6.21.1/net/ipv6/ip6_input.c
@@ -235,7 +235,7 @@ int ip6_mc_input(struct sk_buff *skb)
 	IP6_INC_STATS_BH(ip6_dst_idev(skb->dst), IPSTATS_MIB_INMCASTPKTS);
 
 	hdr = skb->nh.ipv6h;
-	deliver = likely(!(skb->dev->flags & (IFF_PROMISC|IFF_ALLMULTI))) ||
+	deliver = unlikely(skb->dev->flags & (IFF_PROMISC|IFF_ALLMULTI)) ||
 	    ipv6_chk_mcast_addr(skb->dev, &hdr->daddr, NULL);
 
 	/*

-- 
