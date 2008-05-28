Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYE1Vtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYE1Vtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYE1Vqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:46:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:51746 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYE1Vqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:46:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=eL+aihkp7IN/kfmNkimKLlm4vFyh7V38BODjJ/tQx126mfarHI7fDqsqZXQPR6VJjIZIFEjHEExIbbPtg5c5K0/gmWSpIVhGXcOewm5T2FCHaMLNzGPAd5dyKELLRuQhQhdT0YaW6Luj25DKDLolpRKAUJUZqmAsTYHCUrEnE5U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:43:30 +0200
Message-Id: <20080528214330.16327.35293.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 20/21] ide: remove no longer used ide_pio_timings[]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-lib.c |   17 -----------------
 include/linux/ide.h   |    8 --------
 2 files changed, 25 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -76,23 +76,6 @@ static u8 ide_rate_filter(ide_drive_t *d
 }
 
 /*
- * Standard (generic) timings for PIO modes, from ATA2 specification.
- * These timings are for access to the IDE data port register *only*.
- * Some drives may specify a mode, while also specifying a different
- * value for cycle_time (from drive identification data).
- */
-const ide_pio_timings_t ide_pio_timings[6] = {
-	{ 70,	165,	600 },	/* PIO Mode 0 */
-	{ 50,	125,	383 },	/* PIO Mode 1 */
-	{ 30,	100,	240 },	/* PIO Mode 2 */
-	{ 30,	80,	180 },	/* PIO Mode 3 with IORDY */
-	{ 25,	70,	120 },	/* PIO Mode 4 with IORDY */
-	{ 20,	50,	100 }	/* PIO Mode 5 with IORDY (nonstandard) */
-};
-
-EXPORT_SYMBOL_GPL(ide_pio_timings);
-
-/*
  * Shared data/functions for determining best PIO mode for an IDE drive.
  * Most of this stuff originally lived in cmd640.c, and changes to the
  * ide_pio_blacklist[] table should be made with EXTREME CAUTION to avoid
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1290,15 +1290,7 @@ void ide_timing_merge(struct ide_timing 
 		      struct ide_timing *, unsigned int);
 int ide_timing_compute(ide_drive_t *, u8, struct ide_timing *, int, int);
 
-typedef struct ide_pio_timings_s {
-	int	setup_time;	/* Address setup (ns) minimum */
-	int	active_time;	/* Active pulse (ns) minimum */
-	int	cycle_time;	/* Cycle time (ns) minimum = */
-				/* active + recovery (+ setup for some chips) */
-} ide_pio_timings_t;
-
 u8 ide_get_best_pio_mode(ide_drive_t *, u8, u8);
-extern const ide_pio_timings_t ide_pio_timings[6];
 
 int ide_set_pio_mode(ide_drive_t *, u8);
 int ide_set_dma_mode(ide_drive_t *, u8);
