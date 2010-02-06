Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab0BFIn0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:43:26 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52509 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753722Ab0BFInY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:43:24 -0500
Date: Sat, 6 Feb 2010 09:43:21 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/11] drivers/block/drbd: Correct NULL test
Message-ID: <Pine.LNX.4.64.1002060943040.8092@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Test the value that was just allocated rather than the previously tested one.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression *x;
expression e;
identifier l;
@@

if (x == NULL || ...) {
    ... when forall
    return ...; }
... when != goto l;
    when != x = e
    when != &x
*x == NULL
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/block/drbd/drbd_main.c      |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ab871e0..d0c38a6 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2770,7 +2770,7 @@ static int drbd_create_mempools(void)
 
 	drbd_ee_mempool = mempool_create(number,
 		mempool_alloc_slab, mempool_free_slab, drbd_ee_cache);
-	if (drbd_request_mempool == NULL)
+	if (drbd_ee_mempool == NULL)
 		goto Enomem;
 
 	/* drbd's page pool */
