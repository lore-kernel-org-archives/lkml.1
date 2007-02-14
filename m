Return-Path: <linux-kernel-owner+w=401wt.eu-S1751008AbXBNL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008AbXBNL5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 06:57:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXBNL5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 06:57:40 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:40451 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXBNL5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 06:57:40 -0500
Date: Wed, 14 Feb 2007 12:57:22 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.20 14/14] nfnetlink_log: micro-optimization: inst->skb != NULL in __nfulnl_send()
Message-ID: <20070214115722.GA28422@rere.qmqm.pl>
References: <20070212003738.GA8262@rere.qmqm.pl> <20070212202052.GA28704@rere.qmqm.pl> <20070212202319.GE28704@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070212202319.GE28704@rere.qmqm.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch updated to apply after a new version of 13/14:

No other function calls __nfulnl_send() with inst->skb == NULL than nfulnl_timer().

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.12	2007-02-14 12:27:09.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-14 12:53:04.000000000 +0100
@@ -373,9 +373,6 @@ __nfulnl_send(struct nfulnl_instance *in
 {
 	int status;
 
-	if (!inst->skb)
-		return 0;
-
 	if (inst->qlen > 1)
 		inst->lastnlh->nlmsg_type = NLMSG_DONE;
 
@@ -399,7 +396,8 @@ static void nfulnl_timer(unsigned long d
 	UDEBUG("timer function called, flushing buffer\n");
 
 	spin_lock_bh(&inst->lock);
-	__nfulnl_send(inst);
+	if (inst->skb)
+		__nfulnl_send(inst);
 	spin_unlock_bh(&inst->lock);
 	instance_put(inst);
 }
