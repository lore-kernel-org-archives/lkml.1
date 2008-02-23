Return-Path: <linux-kernel-owner+w=401wt.eu-S934739AbYBWAlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934739AbYBWAlf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934749AbYBWAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:34:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934632AbYBWAen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:34:43 -0500
Date: Fri, 22 Feb 2008 16:30:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 17/38] IPCOMP: Fix reception of incompressible packets
Message-ID: <20080223003036.GR7268@suse.de>
References: <20080223001946.979768610@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipcomp-fix-reception-of-incompressible-packets.patch"
In-Reply-To: <20080223002907.GA7268@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us
know.

------------------
Upstream commit: b1641064a3f4a58644bc2e8edf40c025c58473b4

I made a silly typo by entering IPPROTO_IP (== 0) instead of
IPPROTO_IPIP (== 4).  This broke the reception of incompressible
packets.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/xfrm4_tunnel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -50,7 +50,7 @@ static struct xfrm_type ipip_type = {
 
 static int xfrm_tunnel_rcv(struct sk_buff *skb)
 {
-	return xfrm4_rcv_spi(skb, IPPROTO_IP, ip_hdr(skb)->saddr);
+	return xfrm4_rcv_spi(skb, IPPROTO_IPIP, ip_hdr(skb)->saddr);
 }
 
 static int xfrm_tunnel_err(struct sk_buff *skb, u32 info)

-- 
