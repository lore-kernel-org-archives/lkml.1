Return-Path: <linux-kernel-owner+w=401wt.eu-S934586AbYBUQl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934586AbYBUQl2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 11:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757751AbYBUQlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 11:41:18 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52155 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762874AbYBUQlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 11:41:17 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] macb: Fix speed setting
Date: Thu, 21 Feb 2008 17:41:05 +0100
Message-Id: <1203612065-18192-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
References: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
conversion to generic PHY layer in kernel 2.6.23.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/net/macb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/macb.c b/drivers/net/macb.c
index 81bf005..1d210ed 100644
--- a/drivers/net/macb.c
+++ b/drivers/net/macb.c
@@ -148,7 +148,7 @@ static void macb_handle_link_change(struct net_device *dev)
 
 			if (phydev->duplex)
 				reg |= MACB_BIT(FD);
-			if (phydev->speed)
+			if (phydev->speed == SPEED_100)
 				reg |= MACB_BIT(SPD);
 
 			macb_writel(bp, NCFGR, reg);
-- 
1.5.4.1

