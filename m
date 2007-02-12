Return-Path: <linux-kernel-owner+w=401wt.eu-S964791AbXBLJJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964791AbXBLJJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964796AbXBLJIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:08:55 -0500
Received: from rere.qmqm.pl ([86.63.132.164]:56426 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933136AbXBLJIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:08:49 -0500
Date: Mon, 12 Feb 2007 01:39:06 +0100
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: netfilter-devel@lists.netfilter.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.20 04/10] nfnetlink_log: fix possible use-after-free
Message-ID: <20070212003906.GE8262@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paranoia: instance_put() might have freed the inst pointer when we
spin_unlock_bh().

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>

--- linux-2.6.20/net/netfilter/nfnetlink_log.c.2	2007-02-11 20:43:24.000000000 +0100
+++ linux-2.6.20/net/netfilter/nfnetlink_log.c	2007-02-11 20:46:33.000000000 +0100
@@ -393,8 +393,8 @@ static void nfulnl_timer(unsigned long d
 
 	spin_lock_bh(&inst->lock);
 	__nfulnl_send(inst);
-	instance_put(inst);
 	spin_unlock_bh(&inst->lock);
+	instance_put(inst);
 }
 
 /* This is an inline function, we don't really care about a long
