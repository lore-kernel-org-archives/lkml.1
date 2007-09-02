Return-Path: <linux-kernel-owner+w=401wt.eu-S964880AbXIBBRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880AbXIBBRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933003AbXIBBRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:17:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41107 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052AbXIBBRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:17:04 -0400
Date: Sun, 2 Sep 2007 07:00:11 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: [PATCH -mm] net/sched/sch_cbq.c: Shut up uninitialized variable
 warning
In-Reply-To: <20070831215822.26e1432b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0709020656050.20781@enigma.security.iitk.ac.in>
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


net/sched/sch_cbq.c: In function 'cbq_enqueue':
net/sched/sch_cbq.c:383: warning: 'ret' may be used uninitialized in this function

has been verified to be a bogus case. So let's shut it up.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 net/sched/sch_cbq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1/net/sched/sch_cbq.c~fix	2007-09-02 06:45:08.000000000 +0530
+++ linux-2.6.23-rc4-mm1/net/sched/sch_cbq.c	2007-09-02 06:44:37.000000000 +0530
@@ -380,7 +380,7 @@ cbq_enqueue(struct sk_buff *skb, struct 
 {
 	struct cbq_sched_data *q = qdisc_priv(sch);
 	int len = skb->len;
-	int ret;
+	int uninitialized_var(ret);
 	struct cbq_class *cl = cbq_classify(skb, sch, &ret);
 
 #ifdef CONFIG_NET_CLS_ACT
