Return-Path: <linux-kernel-owner+w=401wt.eu-S932794AbXAaDpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbXAaDpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbXAaDoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:44:34 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:28881 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584AbXAaDoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:44:24 -0500
From: Divy Le Ray <None@chelsio.com>
Subject: [PATCH 7/10] cxgb3 - Remove BUG_ON from t3b_intr_napi
Date: Tue, 30 Jan 2007 19:44:18 -0800
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Message-Id: <20070131034418.8640.29593.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

In some cases, SG_DATA_INTR won't clear on read and the following 
interrupt may cause us to assert because NAPI is already scheduled. 
Remove the assertion, NAPI can handle attempts to rearm it while
it's already scheduled.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/sge.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/sge.c b/drivers/net/cxgb3/sge.c
index 8b3c824..daef7fd 100644
--- a/drivers/net/cxgb3/sge.c
+++ b/drivers/net/cxgb3/sge.c
@@ -2199,14 +2199,12 @@ static irqreturn_t t3b_intr_napi(int irq
 	if (likely(map & 1)) {
 		dev = adap->sge.qs[0].netdev;
 
-		BUG_ON(napi_is_scheduled(dev));
 		if (likely(__netif_rx_schedule_prep(dev)))
 			__netif_rx_schedule(dev);
 	}
 	if (map & 2) {
 		dev = adap->sge.qs[1].netdev;
 
-		BUG_ON(napi_is_scheduled(dev));
 		if (likely(__netif_rx_schedule_prep(dev)))
 			__netif_rx_schedule(dev);
 	}
