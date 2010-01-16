Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab0APP5q (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 10:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453Ab0APP5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 10:57:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:44160 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111Ab0APP5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 10:57:42 -0500
Date: Sat, 16 Jan 2010 16:57:39 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/9] drivers/misc: Eliminate useless code
Message-ID: <Pine.LNX.4.64.1001161657170.28745@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable priv is initialized twice to the same (side effect-free)
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
 drivers/misc/iwmc3200top/main.c     |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/iwmc3200top/main.c b/drivers/misc/iwmc3200top/main.c
index dd0a391..3b7292a 100644
--- a/drivers/misc/iwmc3200top/main.c
+++ b/drivers/misc/iwmc3200top/main.c
@@ -597,10 +597,8 @@ static void iwmct_remove(struct sdio_func *func)
 	struct iwmct_work_struct *read_req;
 	struct iwmct_priv *priv = sdio_get_drvdata(func);
 
-	priv = sdio_get_drvdata(func);
-
 	LOG_INFO(priv, INIT, "enter\n");
 
 	sdio_claim_host(func);
