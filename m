Return-Path: <linux-kernel-owner+w=401wt.eu-S935661AbXEUTvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935661AbXEUTvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933932AbXEUT3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:29:25 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:52649 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933740AbXEUT3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:29:23 -0400
Message-Id: <20070521191747.857874000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Mon, 21 May 2007 12:17:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, David Miller <davem@davemloft.net>,
       bunk@stusta.de, Jamal Hadi Salim <hadi@cyberus.ca>
Subject: [patch 51/69] NET_SCHED: prio qdisc boundary condition
Content-Disposition: inline; filename=net_sched-prio-qdisc-boundary-condition.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Jamal Hadi Salim <hadi@cyberus.ca>

This fixes an out-of-boundary condition when the classified
band equals q->bands. Caught by Alexey

Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/sched/sch_prio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.21.1.orig/net/sched/sch_prio.c
+++ linux-2.6.21.1/net/sched/sch_prio.c
@@ -74,7 +74,7 @@ prio_classify(struct sk_buff *skb, struc
 		band = res.classid;
 	}
 	band = TC_H_MIN(band) - 1;
-	if (band > q->bands)
+	if (band >= q->bands)
 		return q->queues[q->prio2band[0]];
 
 	return q->queues[band];

-- 
