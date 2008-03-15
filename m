Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYCOQDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYCOQDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 12:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYCOQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 12:03:25 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51736 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYCOQDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 12:03:22 -0400
Date: Sat, 15 Mar 2008 17:03:20 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: davem@davemloft.net, pekkas@netcore.fi, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] net/ipv6/ndisc.c: remove unused variable
Message-ID: <Pine.LNX.4.64.0803151702580.24178@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable hlen is initialized but never used otherwise.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
identifier i;
constant C;
@@

(
extern T i;
|
- T i;
  <+... when != i
- i = C;
  ...+>
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 net/ipv6/ndisc.c |    2 --
 1 file changed, 2 deletions(-)

diff -u -p a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
--- a/net/ipv6/ndisc.c 2008-03-12 14:13:15.000000000 +0100
+++ b/net/ipv6/ndisc.c 2008-03-15 07:30:11.000000000 +0100
@@ -1420,7 +1420,6 @@ void ndisc_send_redirect(struct sk_buff 
 	u8 *opt;
 	int rd_len;
 	int err;
-	int hlen;
 	u8 ha_buf[MAX_ADDR_LEN], *ha = NULL;
 
 	dev = skb->dev;
@@ -1491,7 +1490,6 @@ void ndisc_send_redirect(struct sk_buff 
 		return;
 	}
 
-	hlen = 0;
 
 	skb_reserve(buff, LL_RESERVED_SPACE(dev));
 	ip6_nd_hdr(sk, buff, dev, &saddr_buf, &ipv6_hdr(skb)->saddr,
