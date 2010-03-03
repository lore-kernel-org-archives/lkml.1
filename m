Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab0CCTuH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 14:50:07 -0500
Received: from stargate.chelsio.com ([67.207.112.58]:20618 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab0CCTuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 14:50:03 -0500
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH] cxgb3: fix hot plug removal crash
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Date: Wed, 03 Mar 2010 11:49:47 -0800
Message-ID: <20100303194947.31628.5933.stgit@speedy5.asicdesigners.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

queue restart tasklets need to be stopped after napi handlers are stopped
since the latter can restart them.  So stop them after stopping napi.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index 6fd968a..cecdec1 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -1280,6 +1280,7 @@ static void cxgb_down(struct adapter *adapter)
 
 	free_irq_resources(adapter);
 	quiesce_rx(adapter);
+	t3_sge_stop(adapter);
 	flush_workqueue(cxgb3_wq);	/* wait for external IRQ handler */
 }
 

