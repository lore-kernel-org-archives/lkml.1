Return-Path: <linux-kernel-owner+w=401wt.eu-S934101AbYDQBbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934101AbYDQBbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760959AbYDQBKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:10:14 -0400
Received: from sous-sol.org ([216.99.217.87]:59039 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbYDQBKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:10:13 -0400
Message-Id: <20080417010404.851588962@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:02:26 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Jeff Garzik <jgarzik@redhat.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: macb: Call phy_disconnect on removing
Content-Disposition: inline; filename=macb-call-phy_disconnect-on-removing.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

upstream commit: 84b7901f8d5a17536ef2df7fd628ab865df8fe3a

Call phy_disconnect() on remove routine.  Otherwise the phy timer
causes a kernel crash when unloading.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/macb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -1257,6 +1257,8 @@ static int __devexit macb_remove(struct 
 
 	if (dev) {
 		bp = netdev_priv(dev);
+		if (bp->phy_dev)
+			phy_disconnect(bp->phy_dev);
 		mdiobus_unregister(&bp->mii_bus);
 		kfree(bp->mii_bus.irq);
 		unregister_netdev(dev);

-- 
