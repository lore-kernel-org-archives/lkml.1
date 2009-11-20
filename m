Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZKTODv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZKTODv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 09:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZKTODu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 09:03:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:55764 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbZKTODu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 09:03:50 -0500
Subject: [PATCH] ixgbe: move tc variable to CONFIG_IXGBE_DCB
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Miller <davem@davemloft.net>, Yi Zou <yi.zou@intel.com>,
       Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
       netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Nov 2009 19:32:27 +0530
Message-Id: <1258725747.3562.5.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tc is required by CONFIG_IXGBE_DCB.
This also fixes compilation warning:

 drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_tx_is_paused’:
 drivers/net/ixgbe/ixgbe_main.c:245: warning: unused variable ‘tc’

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/net/ixgbe/ixgbe_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index ebcec30..61a02ce 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -242,11 +242,11 @@ static void ixgbe_unmap_and_free_tx_resource(struct ixgbe_adapter *adapter,
 static inline bool ixgbe_tx_is_paused(struct ixgbe_adapter *adapter,
                                       struct ixgbe_ring *tx_ring)
 {
-	int tc;
 	u32 txoff = IXGBE_TFCS_TXOFF;
 
 #ifdef CONFIG_IXGBE_DCB
 	if (adapter->flags & IXGBE_FLAG_DCB_ENABLED) {
+		int tc;
 		int reg_idx = tx_ring->reg_idx;
 		int dcb_i = adapter->ring_feature[RING_F_DCB].indices;
 
-- 
1.6.5.3


