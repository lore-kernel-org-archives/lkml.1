Return-Path: <linux-kernel-owner+w=401wt.eu-S1758641AbXHVDvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641AbXHVDvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757197AbXHVDtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:49:35 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:23952 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069AbXHVDtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:49:33 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 6/11 RESEND] cxgb3 - Fatal error update
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 21 Aug 2007 20:49:31 -0700
Message-ID: <20070822034931.9350.31170.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Stop the MAC when a fatal error is detected.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/cxgb3_main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
index dc5d269..a1f94cf 100644
--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -2270,6 +2270,10 @@ void t3_fatal_err(struct adapter *adapter)
 
 	if (adapter->flags & FULL_INIT_DONE) {
 		t3_sge_stop(adapter);
+		t3_write_reg(adapter, A_XGM_TX_CTRL, 0);
+		t3_write_reg(adapter, A_XGM_RX_CTRL, 0);
+		t3_write_reg(adapter, XGM_REG(A_XGM_TX_CTRL, 1), 0);
+		t3_write_reg(adapter, XGM_REG(A_XGM_RX_CTRL, 1), 0);
 		t3_intr_disable(adapter);
 	}
 	CH_ALERT(adapter, "encountered fatal error, operation suspended\n");
