Return-Path: <linux-kernel-owner+w=401wt.eu-S1766014AbZAPAss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766014AbZAPAss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 19:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbZAPAsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 19:48:36 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:17543 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbZAPAsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 19:48:35 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2.6.28] cxgb3 - Fix LRO misalignment
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, leedom@chelsio.com, rick.jones2@hp.com
Date: Thu, 15 Jan 2009 16:48:29 -0800
Message-ID: <20090116004829.7437.52798.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

The lro manager's frag_align_pad setting was missing,
leading to misaligned access to the skb passed up
to the stack.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 14f9fb3..379a132 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2104,6 +2104,7 @@ static void init_lro_mgr(struct sge_qset *qs, struct net_lro_mgr *lro_mgr)
 {
 	lro_mgr->dev = qs->netdev;
 	lro_mgr->features = LRO_F_NAPI;
+	lro_mgr->frag_align_pad = NET_IP_ALIGN;
 	lro_mgr->ip_summed = CHECKSUM_UNNECESSARY;
 	lro_mgr->ip_summed_aggr = CHECKSUM_UNNECESSARY;
 	lro_mgr->max_desc = T3_MAX_LRO_SES;

