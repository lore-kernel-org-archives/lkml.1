Return-Path: <linux-kernel-owner+w=401wt.eu-S1754717AbYAACJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbYAACJS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 21:09:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYAACFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 21:05:50 -0500
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44509 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646AbYAACFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 21:05:33 -0500
X-Originating-IP: [68.222.90.230]
From: jacliburn@bellsouth.net
To: jeff@garzik.org
Cc: csnook@redhat.com, linux-kernel@vger.kernel.org,
       atl1-devel@lists.sourceforge.net, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 17/26] atl1: update phy config function
Date: Mon, 31 Dec 2007 19:59:55 -0600
Message-Id: <1199152804-3889-18-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.3.3
In-Reply-To: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jay Cliburn <jacliburn@bellsouth.net>

Update atl1_phy_config() to conform with current vendor driver version
1.2.40.2.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index abed547..6432956 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2344,11 +2344,11 @@ static void atl1_phy_config(unsigned long data)
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->lock, flags);
-	adapter->phy_timer_pending = false;
 	atl1_write_phy_reg(hw, MII_ADVERTISE, hw->mii_autoneg_adv_reg);
 	atl1_write_phy_reg(hw, MII_ATLX_CR, hw->mii_1000t_ctrl_reg);
 	atl1_write_phy_reg(hw, MII_BMCR, MII_CR_RESET | MII_CR_AUTO_NEG_EN);
 	spin_unlock_irqrestore(&adapter->lock, flags);
+	clear_bit(0, &adapter->cfg_phy);
 }
 
 int atl1_reset(struct atl1_adapter *adapter)
-- 
1.5.3.3

