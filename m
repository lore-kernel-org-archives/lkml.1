Return-Path: <linux-kernel-owner+w=401wt.eu-S1765615AbYBGAG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765615AbYBGAG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764400AbYBFX5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:57:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:60629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762069AbYBFX5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:57:06 -0500
Date: Wed, 6 Feb 2008 15:52:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Timo Teras <timo.teras@iki.fi>, "David S. Miller" <davem@davemloft.net>
Subject: [patch 27/73] IPV4: ip_gre: set mac_header correctly in receive
	path
Message-ID: <20080206235238.GB13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ipv4-ip_gre-set-mac_header-correctly-in-receive-path.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Timo Teras <timo.teras@iki.fi>

[IPV4] ip_gre: set mac_header correctly in receive path

[ Upstream commit: 1d0691674764098304ae4c63c715f5883b4d3784 ]

mac_header update in ipgre_recv() was incorrectly changed to
skb_reset_mac_header() when it was introduced.

Signed-off-by: Timo Teras <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -613,7 +613,7 @@ static int ipgre_rcv(struct sk_buff *skb
 				offset += 4;
 		}
 
-		skb_reset_mac_header(skb);
+		skb->mac_header = skb->network_header;
 		__pskb_pull(skb, offset);
 		skb_reset_network_header(skb);
 		skb_postpull_rcsum(skb, skb_transport_header(skb), offset);

-- 
