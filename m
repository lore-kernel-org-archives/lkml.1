Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZLSHRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZLSHRA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 02:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZLSHQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 02:16:56 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:49312 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbZLSHQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 02:16:54 -0500
Date: Sat, 19 Dec 2009 08:16:52 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Divy Le Ray <divy@chelsio.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/7] drivers/net/cxgb3: Use kzalloc for allocating only one
 thing
Message-ID: <Pine.LNX.4.64.0912190816340.30546@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/cxgb3/cxgb3_offload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/cxgb3/cxgb3_offload.c b/drivers/net/cxgb3/cxgb3_offload.c
--- a/drivers/net/cxgb3/cxgb3_offload.c 2009-09-14 14:55:49.000000000 +0200
+++ b/drivers/net/cxgb3/cxgb3_offload.c 2009-12-19 07:52:52.000000000 +0100
@@ -1252,7 +1252,7 @@ int cxgb3_offload_activate(struct adapte
 	struct mtutab mtutab;
 	unsigned int l2t_capacity;
 
-	t = kcalloc(1, sizeof(*t), GFP_KERNEL);
+	t = kzalloc(sizeof(*t), GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 
