Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbXLTBu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbXLTBu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 20:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758503AbXLTBgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 20:36:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:12844 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756306AbXLTBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 20:34:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=tDDhxfPGFNLsJu1pRYMHR0ghtokK6LdqJAsogpMA619jm8cwehRX9tr0bzRfF4nKs0QM9C3Q8A62/SFksc5dukYbs6geh8Awa7dvL64jVSPgEPOr7po0BEGq+aRkUX9D8WDGeo6zUWDveHcx4zyiGjI1CDbJy7SnUg713mmjoy8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 50/63] ide-cd: remove cdrom_do_pc_continuation()
Date: Thu, 20 Dec 2007 02:30:27 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712200230.27388.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cdrom_do_pc_continuation() is now identical to cdrom_do_newpc_cont()
so just always use the latter function.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
-49 bytes
 drivers/ide/ide-cd.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1061,18 +1061,7 @@ static void ide_cd_request_sense_fixup(s
 		}
 }
 
-static ide_startstop_t cdrom_newpc_intr(ide_drive_t *);
-
-static ide_startstop_t cdrom_do_pc_continuation (ide_drive_t *drive)
-{
-	struct request *rq = HWGROUP(drive)->rq;
-
-	if (!rq->timeout)
-		rq->timeout = ATAPI_WAIT_PC;
-
-	/* Send the command to the drive and return. */
-	return cdrom_transfer_packet_command(drive, rq, cdrom_newpc_intr);
-}
+static ide_startstop_t cdrom_do_newpc_cont(ide_drive_t *);
 
 static ide_startstop_t cdrom_do_packet_command (ide_drive_t *drive)
 {
@@ -1085,7 +1074,7 @@ static ide_startstop_t cdrom_do_packet_c
 	len = rq->data_len;
 
 	/* Start sending the command to the drive. */
-	return cdrom_start_packet_command(drive, len, cdrom_do_pc_continuation);
+	return cdrom_start_packet_command(drive, len, cdrom_do_newpc_cont);
 }
 
 int ide_cd_queue_pc(ide_drive_t *drive, struct request *rq)
