Return-Path: <linux-kernel-owner+w=401wt.eu-S1758723AbYCNFWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723AbYCNFWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 01:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758362AbYCNFVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 01:21:50 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:40428 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758344AbYCNFVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 01:21:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QobN94UbfUbpPgiPsTx+RLrOeVUtpw6Dzov2G18DYRZ8L33e7mymeqqsJIiSTy0Y5V6dAkTRm2dpse9Q/qPROrkHWFDrrnuRGbDUxvK8LOSC9O8qdb2DxUxrnI2vgU2V98B6/8qzaV1fck+OtFAFPH0Q3Hl6uaYQLFOlhpZ9q3M=
Subject: [PATCH 10/10] dccp: ccid2.c, ccid3.c use clamp(), clamp_t()
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 22:21:46 -0700
Message-Id: <1205472107.19712.30.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the intention of the nested min/max clear.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 net/dccp/ccids/ccid2.c |    2 +-
 net/dccp/ccids/ccid3.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/dccp/ccids/ccid2.c b/net/dccp/ccids/ccid2.c
index b5b52eb..8e95808 100644
--- a/net/dccp/ccids/ccid2.c
+++ b/net/dccp/ccids/ccid2.c
@@ -716,7 +716,7 @@ static int ccid2_hc_tx_init(struct ccid *ccid, struct sock *sk)
 	 * packets for new connections, following the rules from [RFC3390]".
 	 * We need to convert the bytes of RFC3390 into the packets of RFC 4341.
 	 */
-	hctx->ccid2hctx_cwnd = min(4U, max(2U, 4380U / dp->dccps_mss_cache));
+	hctx->ccid2hctx_cwnd = clamp(4380U / dp->dccps_mss_cache, 2U, 4U);
 
 	/* Make sure that Ack Ratio is enabled and within bounds. */
 	max_ratio = DIV_ROUND_UP(hctx->ccid2hctx_cwnd, 2);
diff --git a/net/dccp/ccids/ccid3.c b/net/dccp/ccids/ccid3.c
index e76f460..cd61dea 100644
--- a/net/dccp/ccids/ccid3.c
+++ b/net/dccp/ccids/ccid3.c
@@ -88,8 +88,8 @@ static void ccid3_hc_tx_set_state(struct sock *sk,
 static inline u64 rfc3390_initial_rate(struct sock *sk)
 {
 	const struct ccid3_hc_tx_sock *hctx = ccid3_hc_tx_sk(sk);
-	const __u32 w_init = min_t(__u32, 4 * hctx->ccid3hctx_s,
-				   max_t(__u32, 2 * hctx->ccid3hctx_s, 4380));
+	const __u32 w_init = clamp_t(__u32, 4380U,
+			2 * hctx->ccid3hctx_s, 4 * hctx->ccid3hctx_s);
 
 	return scaled_div(w_init << 6, hctx->ccid3hctx_rtt);
 }
-- 
1.5.4.4.653.g7cf1e

