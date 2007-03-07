Return-Path: <linux-kernel-owner+w=401wt.eu-S1422824AbXCGRP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422824AbXCGRP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:15:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422787AbXCGRO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:59 -0500
Received: from ns2.suse.de ([195.135.220.15]:43085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422785AbXCGROu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:50 -0500
Message-Id: <20070307171312.560929602@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bunk@stusta.de,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 035/101] Clear TCP segmentation offload state in ipt_REJECT
Content-Disposition: inline; filename=clear-tcp-segmentation-offload-state-in-ipt_reject.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[NETFILTER]: Clear GSO bits for TCP reset packet

The TCP reset packet is copied from the original.  This
includes all the GSO bits which do not apply to the new
packet.  So we should clear those bits.

Spotted by Patrick McHardy.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/netfilter/ipt_REJECT.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.20.1.orig/net/ipv4/netfilter/ipt_REJECT.c
+++ linux-2.6.20.1/net/ipv4/netfilter/ipt_REJECT.c
@@ -79,6 +79,10 @@ static void send_reset(struct sk_buff *o
 	nskb->mark = 0;
 	skb_init_secmark(nskb);
 
+	skb_shinfo(nskb)->gso_size = 0;
+	skb_shinfo(nskb)->gso_segs = 0;
+	skb_shinfo(nskb)->gso_type = 0;
+
 	tcph = (struct tcphdr *)((u_int32_t*)nskb->nh.iph + nskb->nh.iph->ihl);
 
 	/* Swap source and dest */

--
