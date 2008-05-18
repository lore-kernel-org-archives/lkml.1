Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYERSs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYERSs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbYERSlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:41:11 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:17984 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757523AbYERSlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:41:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XXJ0KwSjQoU9JsMFT2p62JMIzKfyC6HqTERNFclckvjiIbQoaOKD3bs+0+lJspuASp4U8W/vOQqoNZ7aoTJSl1X3ZfBMOvDQY3cONLmoxJCZywtZRtz5AGKIsxtLSGfCW+19gwIvy4OUjJIUCu1gswwmcp0kzXxybAJcpfe1l90=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:58:31 +0200
Message-Id: <20080518185831.5636.90545.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 27/40] ide-scsi: set drive->scsi flag for devices handled by the driver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation for adding generic ide_transfer_pc() helper.

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -629,6 +629,8 @@ static void ide_scsi_remove(ide_drive_t 
 	put_disk(g);
 
 	ide_scsi_put(scsi);
+
+	drive->scsi = 0;
 }
 
 static int ide_scsi_probe(ide_drive_t *);
@@ -969,6 +971,8 @@ static int ide_scsi_probe(ide_drive_t *d
 	    !(host = scsi_host_alloc(&idescsi_template,sizeof(idescsi_scsi_t))))
 		return -ENODEV;
 
+	drive->scsi = 1;
+
 	g = alloc_disk(1 << PARTN_BITS);
 	if (!g)
 		goto out_host_put;
@@ -1009,6 +1013,7 @@ static int ide_scsi_probe(ide_drive_t *d
 
 	put_disk(g);
 out_host_put:
+	drive->scsi = 0;
 	scsi_host_put(host);
 	return err;
 }
