Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYE1Vny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYE1Vny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 17:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbYE1Vmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 17:42:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:49842 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbYE1Vmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 17:42:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=r8NmSfwzlomvNM8fId9j/AGNErGSBSRq37xE29LJx1RRFJKm5ObWJWUsimrzyfN/8ny5JJTCj4c7q52DlG0K1fHaqWcqm+QcJt2f/vBXBJdmvsAJDspQAEKRzROpyBcv+NkxncShUNKH0qFfEe/lZmgsEFN2cU4uZ36JV5UyRIk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 28 May 2008 23:40:10 +0200
Message-Id: <20080528214010.16327.75848.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/21] ide: use u8 for xfer modes in ide-timing.h
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timing.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: b/drivers/ide/ide-timing.h
===================================================================
--- a/drivers/ide/ide-timing.h
+++ b/drivers/ide/ide-timing.h
@@ -29,7 +29,7 @@
 #include <linux/hdreg.h>
 
 struct ide_timing {
-	short mode;
+	u8    mode;
 	short setup;	/* t1 */
 	short act8b;	/* t2 for 8-bit io */
 	short rec8b;	/* t2i for 8-bit io */
@@ -76,7 +76,7 @@ static struct ide_timing ide_timing[] = 
 
 	{ XFER_PIO_SLOW, 120, 290, 240, 960, 290, 240, 960,   0 },
 
-	{ -1 }
+	{ 0xff }
 };
 
 #define IDE_TIMING_SETUP	0x01
@@ -122,17 +122,18 @@ static void ide_timing_merge(struct ide_
 	if (what & IDE_TIMING_UDMA   ) m->udma    = max(a->udma,    b->udma);
 }
 
-static struct ide_timing* ide_timing_find_mode(short speed)
+static struct ide_timing *ide_timing_find_mode(u8 speed)
 {
 	struct ide_timing *t;
 
 	for (t = ide_timing; t->mode != speed; t++)
-		if (t->mode < 0)
+		if (t->mode == 0xff)
 			return NULL;
 	return t; 
 }
 
-static int ide_timing_compute(ide_drive_t *drive, short speed, struct ide_timing *t, int T, int UT)
+static int ide_timing_compute(ide_drive_t *drive, u8 speed,
+			      struct ide_timing *t, int T, int UT)
 {
 	struct hd_driveid *id = drive->id;
 	struct ide_timing *s, p;
