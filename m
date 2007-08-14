Return-Path: <linux-kernel-owner+w=401wt.eu-S939154AbXHNAHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939154AbXHNAHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 20:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXHNAHZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 20:07:25 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:57011 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733AbXHNAHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 20:07:23 -0400
X-Greylist: delayed 1049 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 20:07:22 EDT
Date: Tue, 14 Aug 2007 02:07:09 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: mikep@linuxtr.net
Cc: netdev@vger.kernel.org, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070814000543.13576.62289.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] drivers/net/tokenring: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to generic boolean

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with all(yes|mod|no)config on x86(|_64) & sparc(|64)
Diffed against Linus' git-tree.
Sent 2007-05-01, no replys


diff --git a/drivers/net/tokenring/ibmtr.c b/drivers/net/tokenring/ibmtr.c
index 1e8958e..0c69eaa 100644
--- a/drivers/net/tokenring/ibmtr.c
+++ b/drivers/net/tokenring/ibmtr.c
@@ -116,9 +116,6 @@ in the event that chatty debug messages are desired - jjs 12/30/98 */
 #define ENABLE_PAGING 1		
 #endif
 
-#define FALSE 0
-#define TRUE (!FALSE)
-
 /* changes the output format of driver initialization */
 #define TR_VERBOSE	0
 
@@ -1542,7 +1539,7 @@ static void initial_tok_int(struct net_device *dev)
 	ti->ring_speed = init_status & 0x01 ? 16 : 4;
 	DPRINTK("Initial interrupt : %d Mbps, shared RAM base %08x.\n",
 				ti->ring_speed, (unsigned int)dev->mem_start);
-	ti->auto_speedsave=readb(ti->init_srb+INIT_STATUS_2_OFST)&4?TRUE:FALSE;
+	ti->auto_speedsave = (readb(ti->init_srb+INIT_STATUS_2_OFST) & 4) != 0;
 
         if (ti->open_mode == MANUAL)	wake_up(&ti->wait_for_reset);
 	else				tok_open_adapter((unsigned long)dev);
