Return-Path: <linux-kernel-owner+w=401wt.eu-S1756072AbYE1VqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbYE1VqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYE1Voh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:44:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:51223 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775AbYE1Vof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:44:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=sqPpS2XGwvYNKaeLw2PQOo/3MMJ/fqRbZL43j99p5AoKURFXzzBEVinb8tWQ+oIsnUr5oNkOHRGzddP/v8eCOMpCvw+TznEBV3N0tX68LATCXiCCEpGiiV339JbuFY8v0kHZ/Q4a3dFukIqAwyG/sI+UOjEaB2hdSa8j3VdHXgo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:41:04 +0200
Message-Id: <20080528214104.16327.34235.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/21] ht6560b: convert to use ide_timing_find_mode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/Kconfig          |    1 +
 drivers/ide/legacy/ht6560b.c |    7 +++----
 2 files changed, 4 insertions(+), 4 deletions(-)

Index: b/drivers/ide/Kconfig
===================================================================
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1008,6 +1008,7 @@ config BLK_DEV_DTC2278
 
 config BLK_DEV_HT6560B
 	tristate "Holtek HT6560B support"
+	select IDE_TIMINGS
 	help
 	  This driver is enabled at runtime using the "ht6560b.probe" kernel
 	  boot parameter. It enables support for the secondary IDE interface
Index: b/drivers/ide/legacy/ht6560b.c
===================================================================
--- a/drivers/ide/legacy/ht6560b.c
+++ b/drivers/ide/legacy/ht6560b.c
@@ -216,6 +216,7 @@ static u8 ht_pio2timings(ide_drive_t *dr
 
         if (pio) {
 		unsigned int cycle_time;
+		struct ide_timing *t = ide_timing_find_mode(XFER_PIO_0 + pio);
 
 		cycle_time = ide_pio_cycle_time(drive, pio);
 
@@ -224,10 +225,8 @@ static u8 ht_pio2timings(ide_drive_t *dr
 		 *  actual cycle time for recovery and activity
 		 *  according system bus speed.
 		 */
-		active_time = ide_pio_timings[pio].active_time;
-		recovery_time = cycle_time
-			- active_time
-			- ide_pio_timings[pio].setup_time;
+		active_time = t->active;
+		recovery_time = cycle_time - active_time - t->setup;
 		/*
 		 *  Cycle times should be Vesa bus cycles
 		 */
