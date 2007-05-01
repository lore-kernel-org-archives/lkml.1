Return-Path: <linux-kernel-owner+w=401wt.eu-S1161794AbXEATIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161794AbXEATIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 15:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161790AbXEATIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 15:08:48 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:38037 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161794AbXEATIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 15:08:47 -0400
Date: Tue, 1 May 2007 21:08:36 +0200 (MEST)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070501190607.32350.4822.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] block: Convert to generic boolean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to generic boolean

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested but most arch/conf tested failed for other reasons then this
Diffed against Linus' git-tree.

 ps2esdi.c |    8 ++++----
 z2ram.c   |    3 ---
 2 files changed, 4 insertions(+), 7 deletions(-)


diff --git a/drivers/block/ps2esdi.c b/drivers/block/ps2esdi.c
index 688a4fb..96b40bc 100644
--- a/drivers/block/ps2esdi.c
+++ b/drivers/block/ps2esdi.c
@@ -94,7 +94,7 @@ static u_int dma_arb_level;		/* DMA arbitration level */
 
 static DECLARE_WAIT_QUEUE_HEAD(ps2esdi_int);
 
-static int no_int_yet;
+static bool no_int_yet;
 static int ps2esdi_drives;
 static u_short io_base;
 static DEFINE_TIMER(esdi_timer, ps2esdi_reset_timer, 0, 0);
@@ -455,7 +455,7 @@ static void __init ps2esdi_get_device_cfg(void)
 	current_int_handler = ps2esdi_geometry_int_handler;
 	cmd_blk[0] = CMD_GET_DEV_CONFIG | 0x600;
 	cmd_blk[1] = 0;
-	no_int_yet = TRUE;
+	no_int_yet = true;
 	ps2esdi_out_cmd_blk(cmd_blk);
 	if (no_int_yet)
 		sleep_on(&ps2esdi_int);
@@ -464,7 +464,7 @@ static void __init ps2esdi_get_device_cfg(void)
 		printk("%s: Drive 1\n", DEVICE_NAME);	/*BA */
 		cmd_blk[0] = CMD_GET_DEV_CONFIG | (1 << 5) | 0x600;
 		cmd_blk[1] = 0;
-		no_int_yet = TRUE;
+		no_int_yet = true;
 		ps2esdi_out_cmd_blk(cmd_blk);
 		if (no_int_yet)
 			sleep_on(&ps2esdi_int);
@@ -843,7 +843,7 @@ static void ps2esdi_geometry_int_handler(u_int int_ret_code)
 	}
 
 	wake_up(&ps2esdi_int);
-	no_int_yet = FALSE;
+	no_int_yet = false;
 	outb(CTRL_ENABLE_INTR, ESDI_CONTROL);
 
 }
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 7cc2685..2abf94c 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -44,9 +44,6 @@
 extern int m68k_realnum_memory;
 extern struct mem_info m68k_memory[NUM_MEMINFO];
 
-#define TRUE                  (1)
-#define FALSE                 (0)
-
 #define Z2MINOR_COMBINED      (0)
 #define Z2MINOR_Z2ONLY        (1)
 #define Z2MINOR_CHIPONLY      (2)
