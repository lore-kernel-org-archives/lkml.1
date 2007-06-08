Return-Path: <linux-kernel-owner+w=401wt.eu-S967590AbXFHHYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967590AbXFHHYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938029AbXFHHR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:17:59 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33270 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937956AbXFHHR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:17:57 -0400
Message-Id: <20070608071533.025501000@sous-sol.org>
References: <20070608071511.159309000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:15:15 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jeff Garzik <jgarzik@pobox.com>, vwool@ru.mvista.com,
       dustin@sensoria.com, Vitaly Wool <vitalywool@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 04/32] smc911x: fix compilation breakage wjen debug is on
Content-Disposition: inline; filename=smc911x-fix-compilation-breakage-wjen-debug-is-on.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Vitaly Wool <vwool@ru.mvista.com>

the patch below fixes compilation breakage of smc911x driver when ENABLE_SMC_DEBUG_PKTS equals to 1.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/net/smc911x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.13.orig/drivers/net/smc911x.c
+++ linux-2.6.20.13/drivers/net/smc911x.c
@@ -499,7 +499,7 @@ static inline void	 smc911x_rcv(struct n
 		SMC_SET_RX_CFG(RX_CFG_RX_END_ALGN4_ | ((2<<8) & RX_CFG_RXDOFF_));
 		SMC_PULL_DATA(data, pkt_len+2+3);
 
-		DBG(SMC_DEBUG_PKTS, "%s: Received packet\n", dev->name,);
+		DBG(SMC_DEBUG_PKTS, "%s: Received packet\n", dev->name);
 		PRINT_PKT(data, ((pkt_len - 4) <= 64) ? pkt_len - 4 : 64);
 		dev->last_rx = jiffies;
 		skb->dev = dev;

-- 
