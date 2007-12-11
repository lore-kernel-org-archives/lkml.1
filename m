Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbXLKEd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbXLKEd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXLKEdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:33:05 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39776 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbXLKEdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:33:03 -0500
Date: Tue, 11 Dec 2007 05:32:54 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043428.28518.24891.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
References: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 4/6] pcmcia/axnet_cs: Make use of 'max()' instead of handcrafted one
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use 'max(x,y)' instead of 'x < y ? y : x'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---


diff --git a/drivers/net/pcmcia/axnet_cs.c b/drivers/net/pcmcia/axnet_cs.c
index 8d910a3..96931cc 100644
--- a/drivers/net/pcmcia/axnet_cs.c
+++ b/drivers/net/pcmcia/axnet_cs.c
@@ -1091,8 +1091,8 @@ static int ei_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	
 	ei_local->irqlock = 1;
 
-	send_length = ETH_ZLEN < length ? length : ETH_ZLEN;
-	
+	send_length = max(length, ETH_ZLEN);
+
 	/*
 	 * We have two Tx slots available for use. Find the first free
 	 * slot, and then perform some sanity checks. With two Tx bufs,
