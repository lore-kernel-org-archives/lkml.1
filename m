Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZGHFuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZGHFuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758722AbZGHFtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:49:03 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:3106 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473AbZGHFtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:49:01 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 6/8 net-next-2.6] cxgb3: Fix mss table initialization
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 07 Jul 2009 22:48:59 -0700
Message-ID: <20090708054858.11344.86017.stgit@speedy5>
In-Reply-To: <20090708054832.11344.82449.stgit@speedy5>
References: <20090708054832.11344.82449.stgit@speedy5>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Fix the HW SMT table initialization to avoid random
mss miscomputations for offload connections.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index ef59921..49fe46d 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -470,6 +470,7 @@ static int init_tp_parity(struct adapter *adap)
 		memset(req, 0, sizeof(*req));
 		req->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));
 		OPCODE_TID(req) = htonl(MK_OPCODE_TID(CPL_SMT_WRITE_REQ, i));
+		req->mtu_idx = NMTUS - 1;
 		req->iff = i;
 		t3_mgmt_tx(adap, skb);
 		if (skb == adap->nofail_skb) {

