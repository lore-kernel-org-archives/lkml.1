Return-Path: <linux-kernel-owner+w=401wt.eu-S1946266AbXBCCl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946266AbXBCCl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 21:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946271AbXBCClO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 21:41:14 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:53385 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946267AbXBCClK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 21:41:10 -0500
Message-Id: <20070203024507.709863000@sous-sol.org>
References: <20070203023504.435051000@sous-sol.org>
User-Agent: quilt/0.45-1
Date: Fri, 02 Feb 2007 18:35:49 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andy Gospodarek <andy@greyhouse.net>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@osdl.org>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@osdl.org>
Subject: [patch 45/59] bonding: ARP monitoring broken on x86_64
Content-Disposition: inline; filename=bonding-arp-monitoring-broken-on-x86_64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Andy Gospodarek <andy@greyhouse.net>

While working with the latest bonding code I noticed a nasty problem that
will prevent arp monitoring from always functioning correctly on x86_64
systems.  Comparing ints to longs and expecting reliable results on x86_64
is a bad idea.  With this patch, arp monitoring works correctly again.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/bonding/bonding.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.19.2.orig/drivers/net/bonding/bonding.h
+++ linux-2.6.19.2/drivers/net/bonding/bonding.h
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
@@ -242,7 +242,8 @@ extern inline int slave_do_arp_validate(
 	return bond->params.arp_validate & (1 << slave->state);
 }
 
-extern inline u32 slave_last_rx(struct bonding *bond, struct slave *slave)
+extern inline unsigned long slave_last_rx(struct bonding *bond,
+					struct slave *slave)
 {
 	if (slave_do_arp_validate(bond, slave))
 		return slave->last_arp_rx;

--
