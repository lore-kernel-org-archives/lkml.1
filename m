Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYBUNul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYBUNul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYBUNud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:50:33 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:64456 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbYBUNud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:50:33 -0500
Date: Thu, 21 Feb 2008 22:50:54 +0900 (JST)
Message-Id: <20080221.225054.61509660.anemo@mba.ocn.ne.jp>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] macb: Fix speed setting
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix NCFGR.SPD setting on 10Mbps.  This bug was introduced by
conversion to generic PHY layer in kernel 2.6.23.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
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
