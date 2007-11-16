Return-Path: <linux-kernel-owner+w=401wt.eu-S1765462AbXKPTWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765462AbXKPTWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760644AbXKPTVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:21:46 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:15825 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbXKPTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:21:45 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 1/9] cxgb3 - fix MSI-X failure path
To: jeff@garzik.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Date: Fri, 16 Nov 2007 11:21:39 -0800
Message-ID: <20071116192139.31024.31482.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Return error code when msi-x settings fail.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 61ffc92..bb0d1c8 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -839,7 +839,8 @@ static int cxgb_up(struct adapter *adap)
 		if (err)
 			goto irq_err;
 
-		if (request_msix_data_irqs(adap)) {
+		err = request_msix_data_irqs(adap);
+		if (err) {
 			free_irq(adap->msix_info[0].vec, adap);
 			goto irq_err;
 		}
