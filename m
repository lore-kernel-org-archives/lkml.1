Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbZG3OTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbZG3OTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbZG3OTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:19:31 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:50616 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZG3OT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:19:29 -0400
Date: Thu, 30 Jul 2009 16:10:54 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: paul.moore@hp.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/5] net/netlabel: Add kmalloc NULL tests
Message-ID: <Pine.LNX.4.64.0907301610230.8734@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The test on map4 should be a test on map6.

The semantic match that finds this problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression *x;
identifier f;
constant char *C;
@@

x = \(kmalloc\|kcalloc\|kzalloc\)(...);
... when != x == NULL
    when != x != NULL
    when != (x || ...)
(
kfree(x)
|
f(...,C,...,x,...)
|
*f(...,x,...)
|
*x->f
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netlabel/netlabel_kapi.c        |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 3ff6f32..6ce0020 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -151,7 +151,7 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
 			addr6 = addr;
 			mask6 = mask;
 			map6 = kzalloc(sizeof(*map6), GFP_ATOMIC);
-			if (map4 == NULL)
+			if (!map6)
 				goto cfg_unlbl_map_add_failure;
 			map6->type = NETLBL_NLTYPE_UNLABELED;
 			ipv6_addr_copy(&map6->list.addr, addr6);
