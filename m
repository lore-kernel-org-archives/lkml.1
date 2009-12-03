Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbZLCTwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbZLCTwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756160AbZLCTws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:52:48 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40945 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754938AbZLCTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IzDo/FWLEJlNPOKg4ymg705R1ay4Koa5kTogAHxivV0ZbwxvZrog5xfSRflysgLLCA
         JlF0Btb5v9+hQnGjIPR+jEBxr0aDRL/ZK+sJ84C/GX7uNOk6o9/glXc+AbbKd+Za/xLt
         uit7U16Pj0XuNDnwCMpJR1SxTDuxQE2SjurVc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Date: Thu, 03 Dec 2009 20:52:03 +0100
Message-Id: <20091203195203.9093.35271.sendpatchset@localhost>
In-Reply-To: <20091203195145.9093.88261.sendpatchset@localhost>
References: <20091203195145.9093.88261.sendpatchset@localhost>
Subject: [PATCH 2/6] cmd64x: remove no longer needed debugging code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cmd64x: remove no longer needed debugging code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cmd64x.c |   17 -----------------
 1 file changed, 17 deletions(-)

Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -20,14 +20,6 @@
 
 #define DRV_NAME "cmd64x"
 
-#define CMD_DEBUG 0
-
-#if CMD_DEBUG
-#define cmdprintk(x...)	printk(x)
-#else
-#define cmdprintk(x...)
-#endif
-
 /*
  * CMD64x specific registers definition.
  */
@@ -76,9 +68,6 @@ static void program_cycle_times (ide_dri
 		{15, 15, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 0};
 	static const u8 drwtim_regs[4] = {DRWTIM0, DRWTIM1, DRWTIM2, DRWTIM3};
 
-	cmdprintk("program_cycle_times parameters: total=%d, active=%d\n",
-		  cycle_time, active_time);
-
 	cycle_count	= quantize_timing( cycle_time, clock_time);
 	active_count	= quantize_timing(active_time, clock_time);
 	recovery_count	= cycle_count - active_count;
@@ -94,9 +83,6 @@ static void program_cycle_times (ide_dri
 	if (active_count > 16)		/* shouldn't actually happen... */
 	 	active_count = 16;
 
-	cmdprintk("Final counts: total=%d, active=%d, recovery=%d\n",
-		  cycle_count, active_count, recovery_count);
-
 	/*
 	 * Convert values to internal chipset representation
 	 */
@@ -106,7 +92,6 @@ static void program_cycle_times (ide_dri
 	/* Program the active/recovery counts into the DRWTIM register */
 	drwtim = (active_count << 4) | recovery_count;
 	(void) pci_write_config_byte(dev, drwtim_regs[drive->dn], drwtim);
-	cmdprintk("Write 0x%02x to reg 0x%x\n", drwtim, drwtim_regs[drive->dn]);
 }
 
 /*
@@ -150,7 +135,6 @@ static void cmd64x_tune_pio(ide_drive_t
 
 	if (setup_count > 5)		/* shouldn't actually happen... */
 		setup_count = 5;
-	cmdprintk("Final address setup count: %d\n", setup_count);
 
 	/*
 	 * Program the address setup clocks into the ARTTIM registers.
@@ -162,7 +146,6 @@ static void cmd64x_tune_pio(ide_drive_t
 	arttim &= ~0xc0;
 	arttim |= setup_values[setup_count];
 	(void) pci_write_config_byte(dev, arttim_regs[drive->dn], arttim);
-	cmdprintk("Write 0x%02x to reg 0x%x\n", arttim, arttim_regs[drive->dn]);
 }
 
 /*
