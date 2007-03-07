Return-Path: <linux-kernel-owner+w=401wt.eu-S1422860AbXCGReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422860AbXCGReS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422821AbXCGRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:33:46 -0500
Received: from cantor.suse.de ([195.135.220.2]:44111 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422873AbXCGRQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:16:41 -0500
Message-Id: <20070307171502.716731431@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:41 -0800
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
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 066/101] Fix skb data reallocation handling in IPSEC
Content-Disposition: inline; filename=fix-skb-data-reallocation-handling-in-ipsec.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[XFRM_TUNNEL]: Reload header pointer after pskb_may_pull/pskb_expand_head

Please consider applying, this was found on your latest
net-2.6 tree while playing around with that ip_hdr() + turn
skb->nh/h/mac pointers  as offsets on 64 bits idea :-)

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/xfrm4_mode_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.20.1.orig/net/ipv4/xfrm4_mode_tunnel.c
+++ linux-2.6.20.1/net/ipv4/xfrm4_mode_tunnel.c
@@ -84,6 +84,7 @@ static int xfrm4_tunnel_input(struct xfr
 	    (err = pskb_expand_head(skb, 0, 0, GFP_ATOMIC)))
 		goto out;
 
+	iph = skb->nh.iph;
 	if (x->props.flags & XFRM_STATE_DECAP_DSCP)
 		ipv4_copy_dscp(iph, skb->h.ipiph);
 	if (!(x->props.flags & XFRM_STATE_NOECN))

--
