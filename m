Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYGVVSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYGVVSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756548AbYGVVPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:15:11 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:1590 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406AbYGVVPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:15:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=x/EW8xk03izV6mdgfPSE0h2tn96KLdUZ/gM7YG6v7jANTxgf7MwhQlGKhomUhOgZ8s
         E/HJiuwudIUJ1IR1tPOV0Hpo16ya/qP7LY0d6nYhj2vUErgk1jVL31viGU7Y1Tab+234
         QBzZrKAWPgbEfMIuqhrWZAfVQbICKA9Ve+vKI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jul 2008 23:12:57 +0200
Message-Id: <20080722211257.20478.36786.sendpatchset@localhost.localdomain>
In-Reply-To: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
References: <20080722211159.20478.74184.sendpatchset@localhost.localdomain>
Subject: [PATCH 08/10] ide: use ata_id_current_chs_valid()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded checks by ata_id_current_chs_valid().

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -69,9 +69,7 @@ static void ide_disk_init_chs(ide_drive_
 	}
 
 	/* Handle logical geometry translation by the drive */
-	if ((id[ATA_ID_FIELD_VALID] & 1) && id[ATA_ID_CUR_CYLS] &&
-	    id[ATA_ID_CUR_HEADS] && id[ATA_ID_CUR_HEADS] <= 16 &&
-	    id[ATA_ID_CUR_SECTORS]) {
+	if (ata_id_current_chs_valid(id)) {
 		drive->cyl  = id[ATA_ID_CUR_CYLS];
 		drive->head = id[ATA_ID_CUR_HEADS];
 		drive->sect = id[ATA_ID_CUR_SECTORS];
