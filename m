Return-Path: <linux-kernel-owner+w=401wt.eu-S1758926AbYJLMuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926AbYJLMuo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYJLMub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:50:31 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52567 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYJLMua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:50:30 -0400
Date: Sun, 12 Oct 2008 15:49:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>, jgarzik@pobox.com,
       Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [2.6 patch] net/tc35815.c: fix compilation
Message-ID: <20081012124934.GH31153@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an obvious typo introduced by
commit 298cf9beb9679522de995e249eccbd82f7c51999
(phylib: move to dynamic allocation of struct mii_bus).

<--  snip  -->

...
  CC      drivers/net/tc35815.o
drivers/net/tc35815.c: In function 'tc_mii_init':
drivers/net/tc35815.c:799: error: 'err_out_free_mii_bus' undeclared (first use in this function)
drivers/net/tc35815.c:799: error: (Each undeclared identifier is reported only once
drivers/net/tc35815.c:799: error: for each function it appears in.)
drivers/net/tc35815.c:781: error: label 'err_out_free_mii_bus' used but not defined
make[3]: *** [drivers/net/tc35815.o] Error 1

<--  snip  -->


Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

diff --git a/drivers/net/tc35815.c b/drivers/net/tc35815.c
index 4980b12..df20caf 100644
--- a/drivers/net/tc35815.c
+++ b/drivers/net/tc35815.c
@@ -796,7 +796,7 @@ err_out_unregister_bus:
 	mdiobus_unregister(lp->mii_bus);
 err_out_free_mdio_irq:
 	kfree(lp->mii_bus->irq);
-err_out_free_mii_bus;
+err_out_free_mii_bus:
 	mdiobus_free(lp->mii_bus);
 err_out:
 	return err;

