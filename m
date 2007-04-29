Return-Path: <linux-kernel-owner+w=401wt.eu-S1030995AbXD2RhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030995AbXD2RhO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbXD2Rb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:29 -0400
Received: from gw.goop.org ([64.81.55.164]:58998 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965085AbXD2Raa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:30 -0400
Message-Id: <20070429172916.861677000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:29:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch 31/32] xen: --- drivers/net/xen-netfront.c | 6 +++--- 1 file changed, 3 insertions(+), 3 deletions(-)
Content-Disposition: inline; filename=xen-netfront-netif_poll-nobh.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1213,10 +1213,10 @@ static int netif_poll(struct net_device 
 	int pages_flipped = 0;
 	int err;
 
-	spin_lock_bh(&np->rx_lock);
+	spin_lock(&np->rx_lock);
 
 	if (unlikely(!netfront_carrier_ok(np))) {
-		spin_unlock_bh(&np->rx_lock);
+		spin_unlock(&np->rx_lock);
 		return 0;
 	}
 
@@ -1357,7 +1357,7 @@ err:
 		local_irq_restore(flags);
 	}
 
-	spin_unlock_bh(&np->rx_lock);
+	spin_unlock(&np->rx_lock);
 
 	return more_to_do;
 }

-- 

