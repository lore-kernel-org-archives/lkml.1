Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831Ab0A2QDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab0A2QDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584Ab0A2QDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:03:38 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0A2QD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=c5rH2ICulefVDdGgib+pZEQTSTwqAremDHpwygqHw5hgNMWgTW68sgBjQhcGio4w8z
         0ftjItvBvSSgyZqWtsebR1Pb+GplCLJhan7sinHJD5Uvrciy+k030MTJNihiKWs5vQ/d
         ZSYGO0KZhD1E7dpESFenvhwOQwdLews/AOHhM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:03:21 +0100
Message-Id: <20100129160321.21495.15414.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 02/68] libata: CodingStyle fixes for ATA timings code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] libata: CodingStyle fixes for ATA timings code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/libata-core.c |   39 +++++++++++++++++++++++++--------------
 1 file changed, 25 insertions(+), 14 deletions(-)

Index: b/drivers/ata/libata-core.c
===================================================================
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3076,10 +3076,11 @@ static const struct ata_timing ata_timin
 	{ 0xFF }
 };
 
-#define ENOUGH(v, unit)		(((v)-1)/(unit)+1)
-#define EZ(v, unit)		((v)?ENOUGH(v, unit):0)
+#define ENOUGH(v, unit)		(((v) - 1) / (unit) + 1)
+#define EZ(v, unit)		((v) ? ENOUGH(v, unit) : 0)
 
-static void ata_timing_quantize(const struct ata_timing *t, struct ata_timing *q, int T, int UT)
+static void ata_timing_quantize(const struct ata_timing *t,
+				struct ata_timing *q, int T, int UT)
 {
 	q->setup	= EZ(t->setup      * 1000,  T);
 	q->act8b	= EZ(t->act8b      * 1000,  T);
@@ -3095,15 +3096,24 @@ static void ata_timing_quantize(const st
 void ata_timing_merge(const struct ata_timing *a, const struct ata_timing *b,
 		      struct ata_timing *m, unsigned int what)
 {
-	if (what & ATA_TIMING_SETUP  ) m->setup   = max(a->setup,   b->setup);
-	if (what & ATA_TIMING_ACT8B  ) m->act8b   = max(a->act8b,   b->act8b);
-	if (what & ATA_TIMING_REC8B  ) m->rec8b   = max(a->rec8b,   b->rec8b);
-	if (what & ATA_TIMING_CYC8B  ) m->cyc8b   = max(a->cyc8b,   b->cyc8b);
-	if (what & ATA_TIMING_ACTIVE ) m->active  = max(a->active,  b->active);
-	if (what & ATA_TIMING_RECOVER) m->recover = max(a->recover, b->recover);
-	if (what & ATA_TIMING_DMACK_HOLD) m->dmack_hold = max(a->dmack_hold, b->dmack_hold);
-	if (what & ATA_TIMING_CYCLE  ) m->cycle   = max(a->cycle,   b->cycle);
-	if (what & ATA_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
+	if (what & ATA_TIMING_SETUP)
+		m->setup      = max(a->setup,      b->setup);
+	if (what & ATA_TIMING_ACT8B)
+		m->act8b      = max(a->act8b,      b->act8b);
+	if (what & ATA_TIMING_REC8B)
+		m->rec8b      = max(a->rec8b,      b->rec8b);
+	if (what & ATA_TIMING_CYC8B)
+		m->cyc8b      = max(a->cyc8b,      b->cyc8b);
+	if (what & ATA_TIMING_ACTIVE)
+		m->active     = max(a->active,     b->active);
+	if (what & ATA_TIMING_RECOVER)
+		m->recover    = max(a->recover,    b->recover);
+	if (what & ATA_TIMING_DMACK_HOLD)
+		m->dmack_hold = max(a->dmack_hold, b->dmack_hold);
+	if (what & ATA_TIMING_CYCLE)
+		m->cycle      = max(a->cycle,      b->cycle);
+	if (what & ATA_TIMING_UDMA)
+		m->udma       = max(a->udma,       b->udma);
 }
 
 const struct ata_timing *ata_timing_find_mode(u8 xfer_mode)
@@ -3129,7 +3139,8 @@ int ata_timing_compute(struct ata_device
 	 * Find the mode.
 	 */
 
-	if (!(s = ata_timing_find_mode(speed)))
+	s = ata_timing_find_mode(speed);
+	if (!s)
 		return -EINVAL;
 
 	memcpy(t, s, sizeof(*s));
@@ -3162,7 +3173,7 @@ int ata_timing_compute(struct ata_device
 
 	/*
 	 * Even in DMA/UDMA modes we still use PIO access for IDENTIFY,
-	 * S.M.A.R.T * and some other commands. We have to ensure that the
+	 * S.M.A.R.T and some other commands. We have to ensure that the
 	 * DMA cycle timing is slower/equal than the fastest PIO timing.
 	 */
 
