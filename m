Return-Path: <linux-kernel-owner+w=401wt.eu-S1759487AbZGHFul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487AbZGHFul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 01:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758919AbZGHFtI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 01:49:08 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:19086 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbZGHFtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 01:49:06 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 7/8 net-next-2.6] cxgb3: fix mac index mapping
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 07 Jul 2009 22:49:04 -0700
Message-ID: <20090708054904.11344.40175.stgit@speedy5>
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

Override the mac index computation for the gen2 adapter,
as each port is expected to use index 0.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)


diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 870d449..e78d341 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -3682,6 +3682,8 @@ static void mc7_prep(struct adapter *adapter, struct mc7 *mc7,
 void mac_prep(struct cmac *mac, struct adapter *adapter, int index)
 {
 	mac->adapter = adapter;
+	if (!adapter->params.vpd.xauicfg[1])
+		index = 0;
 	mac->offset = (XGMAC0_1_BASE_ADDR - XGMAC0_0_BASE_ADDR) * index;
 	mac->nucast = 1;
 

