Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633AbZBATPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633AbZBATPU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 14:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZBATPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 14:15:04 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:22397 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbZBATPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 14:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=cXBXRUI8Ow8QVtb1vUe18YuLDd2HEA99ngqIxyR0xxjwI04QeJmorzycFrho8tU9ZE
         eOVRWlNU/0p7IEWRmfLiH5k88RUDVjUMyEwS3eYHKG6IJT/UQJ6ssUocxRav4yul/b4I
         KfP+RoYU0P0MXUSS8kDBYN7y1XfzzitvRDUV8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] icside: icside_dma_setup() fixes
Date: Sun, 1 Feb 2009 20:12:23 +0100
User-Agent: KMail/1.10.4 (Linux/2.6.29-rc2-next-20090126; KDE/4.1.4; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200902012012.23761.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for ide_build_sglist() return value and re-map sg table if necessary.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/icside.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -326,6 +326,10 @@ static int icside_dma_setup(ide_drive_t 
 	BUG_ON(dma_channel_active(ec->dma));
 
 	hwif->sg_nents = ide_build_sglist(drive, rq);
+	if (hwif->sg_nents == 0) {
+		ide_map_sg(drive, rq);
+		return 1;
+	}
 
 	/*
 	 * Ensure that we have the right interrupt routed.
