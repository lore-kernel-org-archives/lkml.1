Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbXLKEeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbXLKEeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXLKEdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:33:10 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39781 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXLKEdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:33:08 -0500
Date: Tue, 11 Dec 2007 05:32:59 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043433.28518.30708.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 5/6] pcmcia/fmvj18x_cs: Fix 'shadow variable' warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   drivers/net/pcmcia/fmvj18x_cs.c
drivers/net/pcmcia/fmvj18x_cs.c:1205:6: warning: symbol 'i' shadows an earlier one
drivers/net/pcmcia/fmvj18x_cs.c:1179:9: originally declared here

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---


diff --git a/drivers/net/pcmcia/fmvj18x_cs.c b/drivers/net/pcmcia/fmvj18x_cs.c
index 8c719b4..4f604ae 100644
--- a/drivers/net/pcmcia/fmvj18x_cs.c
+++ b/drivers/net/pcmcia/fmvj18x_cs.c
@@ -1202,8 +1202,7 @@ static void set_rx_mode(struct net_device *dev)
 	outb(1, ioaddr + RX_MODE);	/* Ignore almost all multicasts. */
     } else {
 	struct dev_mc_list *mclist;
-	int i;
-	
+
 	memset(mc_filter, 0, sizeof(mc_filter));
 	for (i = 0, mclist = dev->mc_list; mclist && i < dev->mc_count;
 	     i++, mclist = mclist->next) {
