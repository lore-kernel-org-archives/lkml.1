Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZCMHPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZCMHPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZCMHN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:13:58 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:27598 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZCMHN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:13:57 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-next 3/10] cxgb3: fix skb truesize in jumbo mode
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Fri, 13 Mar 2009 00:13:54 -0700
Message-ID: <20090313071354.21994.36111.stgit@speedy5>
In-Reply-To: <20090313071343.21994.85719.stgit@speedy5>
References: <20090313071343.21994.85719.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Update skb truesize correctly for the 2nd buffer from a Jumbo frame

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 808b8af..90f6f82 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -830,14 +830,15 @@ recycle:
 				   len - SGE_RX_PULL_LEN);
 		newskb->len = len;
 		newskb->data_len = len - SGE_RX_PULL_LEN;
+		newskb->truesize += newskb->data_len;
 	} else {
 		skb_fill_page_desc(newskb, skb_shinfo(newskb)->nr_frags,
 				   sd->pg_chunk.page,
 				   sd->pg_chunk.offset, len);
 		newskb->len += len;
 		newskb->data_len += len;
+		newskb->truesize += len;
 	}
-	newskb->truesize += newskb->data_len;
 
 	fl->credits--;
 	/*

