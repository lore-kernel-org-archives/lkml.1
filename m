Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbXLKEdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbXLKEdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbXLKEcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:32:54 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39770 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbXLKEcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:32:54 -0500
Date: Tue, 11 Dec 2007 05:32:43 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043417.28518.39249.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 2/6] pcmcia/3c574_cs: Fix 'shadow variable' warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   drivers/net/pcmcia/3c574_cs.c
drivers/net/pcmcia/3c574_cs.c:695:7: warning: symbol 'i' shadows an earlier one
drivers/net/pcmcia/3c574_cs.c:636:6: originally declared here

Signed-off-by: Richard Knutson <ricknu-0@student.ltu.se>
---


diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index ad134a6..97b6daa 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -692,7 +692,7 @@ static void tc574_reset(struct net_device *dev)
 	mdio_write(ioaddr, lp->phys, 4, lp->advertising);
 	if (!auto_polarity) {
 		/* works for TDK 78Q2120 series MII's */
-		int i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
+		i = mdio_read(ioaddr, lp->phys, 16) | 0x20;
 		mdio_write(ioaddr, lp->phys, 16, i);
 	}
 
