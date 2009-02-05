Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbZBEA0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbZBEA0N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 19:26:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755076AbZBEAZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 19:25:54 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:15872 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZBEAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 19:25:53 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2.6.29] cxgb3 - Fix lro switch
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, kxie@chelsio.com
Date: Wed, 04 Feb 2009 16:25:47 -0800
Message-ID: <20090205002547.26126.47373.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

The LRO switch is always set to 1 in the rx processing loop.
It breaks the accelerated iSCSI receive traffic.
Fix its computation.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 379a132..d31791f 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2276,8 +2276,7 @@ no_mem:
 		} else if ((len = ntohl(r->len_cq)) != 0) {
 			struct sge_fl *fl;
 
-			if (eth)
-				lro = qs->lro_enabled && is_eth_tcp(rss_hi);
+			lro &= eth && is_eth_tcp(rss_hi);
 
 			fl = (len & F_RSPD_FLQ) ? &qs->fl[1] : &qs->fl[0];
 			if (fl->use_pages) {

