Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbXLKEd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbXLKEd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 23:33:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXLKEc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 23:32:56 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:39769 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbXLKEcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 23:32:54 -0500
Date: Tue, 11 Dec 2007 05:32:38 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: linux-pcmcia@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071211043412.28518.40867.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH 1/6] pcmcia/3c574_cs: Fix dubious bitfield warning
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   drivers/net/pcmcia/3c574_cs.c
drivers/net/pcmcia/3c574_cs.c:194:13: warning: dubious bitfield without explicit `signed' or `unsigned'
drivers/net/pcmcia/3c574_cs.c:196:14: warning: dubious bitfield without explicit `signed' or `unsigned'

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Is there a reason for not doing it this way?


diff --git a/drivers/net/pcmcia/3c574_cs.c b/drivers/net/pcmcia/3c574_cs.c
index ad134a6..97b6daa 100644
--- a/drivers/net/pcmcia/3c574_cs.c
+++ b/drivers/net/pcmcia/3c574_cs.c
@@ -190,10 +190,10 @@ enum Window3 {			/* Window 3: MAC/config bits. */
 union wn3_config {
 	int i;
 	struct w3_config_fields {
-		unsigned int ram_size:3, ram_width:1, ram_speed:2, rom_size:2;
-		int pad8:8;
-		unsigned int ram_split:2, pad18:2, xcvr:3, pad21:1, autoselect:1;
-		int pad24:7;
+		u8 ram_size:3, ram_width:1, ram_speed:2, rom_size:2;
+		u8 pad8;
+		u8 ram_split:2, pad18:2, xcvr:3, pad21:1;
+		u8 autoselect:1, pad24:7;
 	} u;
 };
 
