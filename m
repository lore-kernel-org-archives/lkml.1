Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0ARRPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0ARRPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246Ab0ARRPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:15:31 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:53275 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0ARRP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:15:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IGQFc0B+JP7ieu8tfpvSrN7u8O2BpOpuk0Fl5OpGpqNGrVCDgSq9IBgKPJPwdmTTsJ
         6wPJT6jxwWEmvAUcDXd2jyE7viUFcwKY8aCk6+IV4cdt1u2a3dY3wvyOhilY/WI5/qCK
         vbUniVtRN+BVcz8dp+wsGvQKUpX+4zJz2IMyc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:14:12 +0100
Message-Id: <20100118171412.14623.94854.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 03/64] pata_ali: cleanup ali_set_piomode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_ali: cleanup ali_set_piomode()

Merge ali_fifo_control() calls.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_ali.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -222,12 +222,9 @@ static void ali_set_piomode(struct ata_p
 	}
 
 	/* PIO FIFO is only permitted on ATA disk */
-	if (adev->class != ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x00);
-	ali_program_modes(ap, adev, &t, 0);
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x05);
+	ali_fifo_control(ap, adev, (adev->class == ATA_DEV_ATA) ? 0x05 : 0x00);
 
+	ali_program_modes(ap, adev, &t, 0);
 }
 
 /**
