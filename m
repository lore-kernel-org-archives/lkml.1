Return-Path: <linux-kernel-owner+w=401wt.eu-S933130AbXBLJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130AbXBLJIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933137AbXBLJIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:53 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:52789 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:40:42 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 10/10] nfnetlink_log: enable packet timestamps
Message-ID: <20070212004042.GK8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's nice to log packet arrival time of those little filthy packets. ;)

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.8	2007-02-11 23:59:01.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-12 00:19:16.000000000 +0100
@@ -195,6 +195,10 @@ instance_create(u_int16_t group_num, int
 
 	write_unlock_bh(&instances_lock);
 
+	/* we want timestamps! we want to log those bastards! */
+	if (inst)
+		net_enable_timestamp();
+
 	return inst;
 }
 
@@ -230,6 +234,9 @@ _instance_destroy2(struct nfulnl_instanc
 
 	/* and finally put the refcount */
 	instance_put(inst);
+
+	/* we don't want timestamps anymore (decrement the counter) */
+	net_disable_timestamp();
 }
 
 static inline void
