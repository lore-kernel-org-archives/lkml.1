Return-Path: <linux-kernel-owner+w=401wt.eu-S1761629AbYEJDUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761629AbYEJDUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760739AbYEJDRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:17:25 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:54392 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761269AbYEJDRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:17:20 -0400
X-Originating-IP: [74.251.48.254]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, csnook@redhat.com,
       pelle@dsv.su.se, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH 1/4] atl1: add PHY power save mode
Date: Fri,  9 May 2008 22:12:06 -0500
Message-Id: <1210389129-3868-2-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net>
References: <1210389129-3868-1-git-send-email-jacliburn@bellsouth.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using vendor-provided magic, add code to enter power save mode
on the PHY.  We'll need this for suspend and wake-on-lan.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |   19 ++++++++-----------
 drivers/net/atlx/atlx.h |    3 +++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 0afe522..3beb44e 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -638,21 +638,18 @@ static s32 atl1_phy_leave_power_saving(struct atl1_hw *hw)
 }
 
 /*
- *TODO: do something or get rid of this
+ * Force the PHY into power saving mode using vendor magic.
  */
 #ifdef CONFIG_PM
-static s32 atl1_phy_enter_power_saving(struct atl1_hw *hw)
+static void atl1_phy_enter_power_saving(struct atl1_hw *hw)
 {
-/*    s32 ret_val;
- *    u16 phy_data;
- */
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 0);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x124E);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 2);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0x3000);
+	atl1_write_phy_reg(hw, MII_DBG_ADDR, 3);
+	atl1_write_phy_reg(hw, MII_DBG_DATA, 0);
 
-/*
-    ret_val = atl1_write_phy_reg(hw, ...);
-    ret_val = atl1_write_phy_reg(hw, ...);
-    ....
-*/
-	return 0;
 }
 #endif
 
diff --git a/drivers/net/atlx/atlx.h b/drivers/net/atlx/atlx.h
index 3be7c09..9672188 100644
--- a/drivers/net/atlx/atlx.h
+++ b/drivers/net/atlx/atlx.h
@@ -460,6 +460,9 @@ MODULE_VERSION(ATLX_DRIVER_VERSION);
 #define MII_ATLX_PSSR_100MBS		0x4000	/* 01=100Mbs */
 #define MII_ATLX_PSSR_1000MBS		0x8000	/* 10=1000Mbs */
 
+#define MII_DBG_ADDR			0x1D
+#define MII_DBG_DATA			0x1E
+
 /* PCI Command Register Bit Definitions */
 #define PCI_REG_COMMAND			0x04	/* PCI Command Register */
 #define CMD_IO_SPACE			0x0001
-- 
1.5.4.1

