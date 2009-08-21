Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbZHUNVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbZHUNVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 09:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZHUNVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 09:21:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:56108 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZHUNVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 09:21:34 -0400
Subject: [PATCH 1/2] netpoll: warning for ndo_start_xmit returns with
	interrupts enabled
From: DDD <Dongdong.deng@windriver.com>
To: Matt Mackall <mpm@selenic.com>, David Miller <davem@davemloft.net>,
       Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Jason Wessel <jason.wessel@windriver.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Aug 2009 21:33:36 +0800
Message-Id: <1250861616.24178.20.camel@dengdd-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 21 Aug 2009 13:21:00.0596 (UTC) FILETIME=[39D63740:01CA2262]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARN_ONCE for ndo_start_xmit() enable interrupts in netpoll_send_skb(),
because the NETPOLL API requires that interrupts remain disabled in
netpoll_send_skb().

Signed-off-by: Dongdong Deng <dongdong.deng@windriver.com>
---
 net/core/netpoll.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index df30feb..1b76eb1 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -319,6 +319,11 @@ static void netpoll_send_skb(struct netpoll *np, struct sk_buff *skb)
 
 			udelay(USEC_PER_POLL);
 		}
+
+		WARN_ONCE(!irqs_disabled(),
+			"netpoll_send_skb(): %s enabled interrupts in poll (%pF)\n",
+			dev->name, ops->ndo_start_xmit);
+
 		local_irq_restore(flags);
 	}
 
-- 
1.6.0.4


