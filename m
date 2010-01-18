Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919Ab0ARIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0ARIM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 03:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739Ab0ARIMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 03:12:25 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:44854 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab0ARIMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:12:24 -0500
Date: Mon, 18 Jan 2010 09:12:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Miller <davem@davemloft.net>
Cc: ron.mercer@qlogic.com, linux-driver@qlogic.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/9] drivers/net: Eliminate useless code
In-Reply-To: <20100117.193140.153138395.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.1001180911080.12648@ask.diku.dk>
References: <Pine.LNX.4.64.1001161657400.28745@ask.diku.dk>
 <20100117.193140.153138395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable qdev is initialized twice to the same (side effect-free)
expression.  Drop one initialization.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@forall@
idexpression *x;
identifier f!=ERR_PTR;
@@

x = f(...)
... when != x
(
x = f(...,<+...x...+>,...)
|
* x = f(...)
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/qla3xxx.c               |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index f922294..4ef0afb 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -4087,7 +4087,6 @@ static void __devexit ql3xxx_remove(struct pci_dev *pdev)
 	struct ql3_adapter *qdev = netdev_priv(ndev);
 
 	unregister_netdev(ndev);
-	qdev = netdev_priv(ndev);
 
 	ql_disable_interrupts(qdev);
 
