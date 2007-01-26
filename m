Return-Path: <linux-kernel-owner+w=401wt.eu-S1030696AbXAZOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030696AbXAZOyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 09:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030691AbXAZOyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 09:54:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:59542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030631AbXAZOyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 09:54:21 -0500
Date: Fri, 26 Jan 2007 09:46:32 -0500
From: Andy Gospodarek <andy@greyhouse.net>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: akpm@osdl.org, fubar@us.ibm.com, michael.monnerie@it-management.at
Subject: [PATCH] bonding: ARP monitoring broken on x86_64
Message-ID: <20070126144630.GA30601@gospo.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.10i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While working with the latest bonding code I noticed a nasty problem
that will prevent arp monitoring from always functioning correctly on
x86_64 systems. Comparing ints to longs and expecting reliable results
on x86_64 is a bad idea. With this patch, arp monitoring works correctly
again.  

This also needs to make its way into the 2.6.19 stable series.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
---

 bonding.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bonding.h b/drivers/net/bonding/bonding.h
index dc434fb..cae0e59 100644
--- a/drivers/net/bonding/bonding.h
+++ b/drivers/net/bonding/bonding.h
@@ -151,8 +151,8 @@ struct slave {
 	struct slave *next;
 	struct slave *prev;
 	int    delay;
-	u32    jiffies;
-	u32    last_arp_rx;
+	unsigned long jiffies;
+	unsigned long last_arp_rx;
 	s8     link;    /* one of BOND_LINK_XXXX */
 	s8     state;   /* one of BOND_STATE_XXXX */
 	u32    original_flags;
@@ -242,7 +242,7 @@ extern inline int slave_do_arp_validate(struct bonding *bond, struct slave *slav
 	return bond->params.arp_validate & (1 << slave->state);
 }
 
-extern inline u32 slave_last_rx(struct bonding *bond, struct slave *slave)
+extern inline unsigned long slave_last_rx(struct bonding *bond, struct slave *slave)
 {
 	if (slave_do_arp_validate(bond, slave))
 		return slave->last_arp_rx;
