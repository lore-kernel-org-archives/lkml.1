Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYE1Vs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYE1Vs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbYE1Vpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:45:41 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:26741 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755641AbYE1Vpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:45:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=jNHKZDmhm/fvyXOAgJYPouevbFybt89+SMlGu3tbV9vokdJmgfLHZ23Tart8ivRD+wwVqzBAlrlPE/rc+JhzGjlo0yQFvxNCkLELeEreFsOpziIzzg/EMFVWwsB0Sc05JZtv9MQcVxp4I9XoYnxlHQhaKp8kunm0a3UyMDQ+zq0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:43:13 +0200
Message-Id: <20080528214313.16327.9275.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 18/21] ide-pmac: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also update my Copyrights while at it.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ppc/pmac.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ppc/pmac.c
===================================================================
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -5,7 +5,7 @@
  * for doing DMA.
  *
  *  Copyright (C) 1998-2003 Paul Mackerras & Ben. Herrenschmidt
- *  Copyright (C)      2007 Bartlomiej Zolnierkiewicz
+ *  Copyright (C) 2007-2008 Bartlomiej Zolnierkiewicz
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -494,6 +494,7 @@ static void pmac_outbsync(ide_hwif_t *hw
 static void
 pmac_ide_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	struct ide_timing *tim = ide_timing_find_mode(XFER_PIO_0 + pio);
 	u32 *timings, t;
 	unsigned accessTicks, recTicks;
 	unsigned accessTime, recTime;
@@ -525,10 +526,9 @@ pmac_ide_set_pio_mode(ide_drive_t *drive
 		}
 	case controller_kl_ata4:
 		/* 66Mhz cell */
-		recTime = cycle_time - ide_pio_timings[pio].active_time
-				- ide_pio_timings[pio].setup_time;
+		recTime = cycle_time - tim->active - tim->setup;
 		recTime = max(recTime, 150U);
-		accessTime = ide_pio_timings[pio].active_time;
+		accessTime = tim->active;
 		accessTime = max(accessTime, 150U);
 		accessTicks = SYSCLK_TICKS_66(accessTime);
 		accessTicks = min(accessTicks, 0x1fU);
@@ -541,10 +541,9 @@ pmac_ide_set_pio_mode(ide_drive_t *drive
 	default: {
 		/* 33Mhz cell */
 		int ebit = 0;
-		recTime = cycle_time - ide_pio_timings[pio].active_time
-				- ide_pio_timings[pio].setup_time;
+		recTime = cycle_time - tim->active - tim->setup;
 		recTime = max(recTime, 150U);
-		accessTime = ide_pio_timings[pio].active_time;
+		accessTime = tim->active;
 		accessTime = max(accessTime, 150U);
 		accessTicks = SYSCLK_TICKS(accessTime);
 		accessTicks = min(accessTicks, 0x1fU);
