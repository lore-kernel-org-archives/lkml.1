Return-Path: <linux-kernel-owner+w=401wt.eu-S935435AbXHGUwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935435AbXHGUwq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935349AbXHGUsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:48:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56064 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935297AbXHGUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:48:16 -0400
Date: Tue, 7 Aug 2007 13:44:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Al Viro <viro@zeniv.linux.org.uk>,
       "David S. Miller" <davem@davemloft.net>
Subject: [2.6.22.2 review 16/84] Fix ipv6 tunnel endianness bug.
Message-ID: <20070807204407.GQ23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-ipv6-tunnel-endianness-bug.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Al Viro <viro@zeniv.linux.org.uk>

[IPV6]: endianness bug in ip6_tunnel

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv6/ip6_tunnel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -962,8 +962,8 @@ ip4ip6_tnl_xmit(struct sk_buff *skb, str
 	dsfield = ipv4_get_dsfield(iph);
 
 	if ((t->parms.flags & IP6_TNL_F_USE_ORIG_TCLASS))
-		fl.fl6_flowlabel |= ntohl(((__u32)iph->tos << IPV6_TCLASS_SHIFT)
-					  & IPV6_TCLASS_MASK);
+		fl.fl6_flowlabel |= htonl((__u32)iph->tos << IPV6_TCLASS_SHIFT)
+					  & IPV6_TCLASS_MASK;
 
 	err = ip6_tnl_xmit2(skb, dev, dsfield, &fl, encap_limit, &mtu);
 	if (err != 0) {

-- 
