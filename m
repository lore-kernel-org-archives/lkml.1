Return-Path: <linux-kernel-owner+w=401wt.eu-S932692AbXAaDoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692AbXAaDoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 22:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXAaDoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 22:44:18 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:18963 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbXAaDoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 22:44:13 -0500
From: Divy Le Ray <None@chelsio.com>
Subject: [PATCH 5/10] cxgb3 - Clean up HW init routine
Date: Tue, 30 Jan 2007 19:44:07 -0800
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Message-Id: <20070131034407.8618.61437.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Clean up the tp_config() routine.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/t3_hw.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/cxgb3/t3_hw.c b/drivers/net/cxgb3/t3_hw.c
index 2215400..7112bac 100644
--- a/drivers/net/cxgb3/t3_hw.c
+++ b/drivers/net/cxgb3/t3_hw.c
@@ -2328,8 +2328,6 @@ static inline void tp_wr_indirect(struct
 
 static void tp_config(struct adapter *adap, const struct tp_params *p)
 {
-	unsigned int v;
-
 	t3_write_reg(adap, A_TP_GLOBAL_CONFIG, F_TXPACINGENABLE | F_PATHMTU |
 		     F_IPCHECKSUMOFFLOAD | F_UDPCHECKSUMOFFLOAD |
 		     F_TCPCHECKSUMOFFLOAD | V_IPTTL(64));
@@ -2348,15 +2346,11 @@ static void tp_config(struct adapter *ad
 			 adap->params.rev > 0 ? F_ENABLEESND : F_T3A_ENABLEESND,
 			 0);
 
-	v = t3_read_reg(adap, A_TP_PC_CONFIG);
-	v &= ~(F_ENABLEEPCMDAFULL | F_ENABLEOCSPIFULL);
-	t3_write_reg(adap, A_TP_PC_CONFIG, v | F_TXDEFERENABLE |
-		     F_MODULATEUNIONMODE | F_HEARBEATDACK |
-		     F_TXCONGESTIONMODE | F_RXCONGESTIONMODE);
-
-	v = t3_read_reg(adap, A_TP_PC_CONFIG2);
-	v &= ~F_CHDRAFULL;
-	t3_write_reg(adap, A_TP_PC_CONFIG2, v);
+	t3_set_reg_field(adap, A_TP_PC_CONFIG,
+			 F_ENABLEEPCMDAFULL | F_ENABLEOCSPIFULL,
+			 F_TXDEFERENABLE | F_HEARBEATDACK | F_TXCONGESTIONMODE |
+			 F_RXCONGESTIONMODE);
+	t3_set_reg_field(adap, A_TP_PC_CONFIG2, F_CHDRAFULL, 0);
 
 	if (adap->params.rev > 0) {
 		tp_wr_indirect(adap, A_TP_EGRESS_CONFIG, F_REWRITEFORCETOSIZE);
