Return-Path: <linux-kernel-owner+w=401wt.eu-S1754525Ab0A2QFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0A2QFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431Ab0A2QFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:05:49 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab0A2QFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:05:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Nv4DpMGoA3k6Eo3YfY8/BkdMrbcGiQiSjDyYm18HNIFckUIMUPnKEPTYnj1naYxvSG
         NupDgaZiKcWJOo4gLYM/O1hpM6UTOAWd+USQ6j+h8lH5RfX5B3ufCwDRH4epYO+mrIeo
         4QihdBHMthmWhbSz4DMo0MxQANlA25yt+pK6Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:05:38 +0100
Message-Id: <20100129160538.21495.73166.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 23/68] ide: add drive->class field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add drive->class field

Add class field to ide_drive_t matching class field used in
struct ata_device.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -520,7 +520,13 @@ struct ide_drive_s {
         u8	dn;		/* now wide spread use */
 	u8	devno;		/* 0 or 1 */
 	u8	acoustic;	/* acoustic management */
-	u8	media;		/* disk, cdrom, tape, floppy, ... */
+
+	/* disk, cdrom, tape, floppy, ... */
+	union {
+		u8	media;
+		u8	class;
+	};
+
 	u8	ready_stat;	/* min status value for drive ready */
 	u8	mult_count;	/* current multiple sector setting */
 	u8	mult_req;	/* requested multiple sector setting */
