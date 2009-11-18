Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZKRSUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZKRSUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:20:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbZKRSUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:20:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45393 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757836AbZKRSUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:20:21 -0500
Date: Wed, 18 Nov 2009 19:20:24 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
       Jie Yang <jie.yang@atheros.com>, atl1-devel@lists.sourceforge.net,
       arnd@arndb.de, joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/16] drivers/net/atl1c: remove exceptional & on function
 name
Message-ID: <Pine.LNX.4.64.0911181920010.20943@ask.diku.dk>
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
 drivers/net/atl1c/atl1c_main.c      |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atl1c/atl1c_main.c b/drivers/net/atl1c/atl1c_main.c
index 5ef9e23..1e2f57d 100644
--- a/drivers/net/atl1c/atl1c_main.c
+++ b/drivers/net/atl1c/atl1c_main.c
@@ -2135,7 +2135,7 @@ static int atl1c_request_irq(struct atl1c_adapter *adapter)
 
 	if (!adapter->have_msi)
 		flags |= IRQF_SHARED;
-	err = request_irq(adapter->pdev->irq, &atl1c_intr, flags,
+	err = request_irq(adapter->pdev->irq, atl1c_intr, flags,
 			netdev->name, netdev);
 	if (err) {
 		if (netif_msg_ifup(adapter))
