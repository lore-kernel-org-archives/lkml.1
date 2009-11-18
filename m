Return-Path: <linux-kernel-owner+w=401wt.eu-S932232AbZKRSVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232AbZKRSVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbZKRSVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:21:43 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:45439 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932183AbZKRSVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:21:41 -0500
Date: Wed, 18 Nov 2009 19:21:45 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Francois Romieu <romieu@fr.zoreil.com>,
       Sorbica Shieh <sorbica@icplus.com.tw>,
       Jesse Huang <jesse@icplus.com.tw>, netdev@vger.kernel.org,
       arnd@arndb.de, joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/16] drivers/net/ipg.c: remove exceptional & on function
 name
Message-ID: <Pine.LNX.4.64.0911181921050.20943@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this file, function names are otherwise used as pointers without &.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/ipg.c                   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ipg.c b/drivers/net/ipg.c
index 63056e7..ba8d246 100644
--- a/drivers/net/ipg.c
+++ b/drivers/net/ipg.c
@@ -1751,7 +1751,7 @@ static int ipg_nic_open(struct net_device *dev)
 	/* Register the interrupt line to be used by the IPG within
 	 * the Linux system.
 	 */
-	rc = request_irq(pdev->irq, &ipg_interrupt_handler, IRQF_SHARED,
+	rc = request_irq(pdev->irq, ipg_interrupt_handler, IRQF_SHARED,
 			 dev->name, dev);
 	if (rc < 0) {
 		printk(KERN_INFO "%s: Error when requesting interrupt.\n",
