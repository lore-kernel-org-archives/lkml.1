Return-Path: <linux-kernel-owner+w=401wt.eu-S966464AbXG3Cry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966464AbXG3Cry (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 22:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965811AbXG3CrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 22:47:24 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:41606 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932933AbXG3CrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 22:47:22 -0400
Message-Id: <20070730024720.116454959@mvista.com>
References: <20070730024534.369897977@mvista.com>
User-Agent: quilt/0.46-1
Date: Sun, 29 Jul 2007 19:45:39 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=preempt-realtime-net-mismerge.patch
Subject: [PATCH -rt 5/9] net: fix mis-merge in qdisc_restart
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This mismerge caused my networking to malfunction. The interface would
come up, but no traffic would make it in/out ..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 net/sched/sch_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/net/sched/sch_generic.c
===================================================================
--- linux-2.6.22.orig/net/sched/sch_generic.c
+++ linux-2.6.22/net/sched/sch_generic.c
@@ -156,7 +156,7 @@ static inline int qdisc_restart(struct n
 #ifdef CONFIG_PREEMPT_RT
 		netif_tx_lock(dev);
 #else
-		if (netif_tx_trylock(dev))
+		if (!netif_tx_trylock(dev))
 			/* Another CPU grabbed the driver tx lock */
 			return handle_dev_cpu_collision(skb, dev, q);
 #endif

-- 
