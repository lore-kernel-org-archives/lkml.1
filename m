Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbYBBA0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbYBBA0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762963AbYBBAYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:24:17 -0500
Received: from ns.suse.de ([195.135.220.2]:54541 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762951AbYBBAYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:24:15 -0500
Date: Fri, 1 Feb 2008 16:20:09 -0800
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
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/27] NET: Correct two mistaken skb_reset_mac_header()
	conversions.
Message-ID: <20080202002009.GG8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-correct-two-mistaken-skb_reset_mac_header-conversions.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

[NET]: Correct two mistaken skb_reset_mac_header() conversions.

[ Upstream commit: c6e6ca712b5cc06a662f900c0484d49d7334af64 ]

This operation helper abstracts:

	skb->mac_header = skb->data;

but it was done in two more places which were actually:

	skb->mac_header = skb->network_header;

and those are corrected here.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ax25/ax25_in.c  |    2 +-
 net/netrom/nr_dev.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -124,7 +124,7 @@ int ax25_rx_iframe(ax25_cb *ax25, struct
 		}
 
 		skb_pull(skb, 1);	/* Remove PID */
-		skb_reset_mac_header(skb);
+		skb->mac_header = skb->network_header;
 		skb_reset_network_header(skb);
 		skb->dev      = ax25->ax25_dev->dev;
 		skb->pkt_type = PACKET_HOST;
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -56,7 +56,7 @@ int nr_rx_ip(struct sk_buff *skb, struct
 
 	/* Spoof incoming device */
 	skb->dev      = dev;
-	skb_reset_mac_header(skb);
+	skb->mac_header = skb->network_header;
 	skb_reset_network_header(skb);
 	skb->pkt_type = PACKET_HOST;
 

-- 
