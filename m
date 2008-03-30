Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbYC3PdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbYC3PdR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 11:33:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYC3Pcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 11:32:33 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:11240 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbYC3Pcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 11:32:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=s8ZkVoSbVLRqtPpMhRio0W3OhnpHOgJPHzqeqHCdaI8WNdMOi8JiJXpUOuLQlDtxA/kNMlY6CkotzP3VxF46AbKTbc0L5GXM8x0OrNnzHFGClakFO3pLYckhWEmfbiAGn7WPmI9yhBY5iz8mVe64dftMqxVkCfpRQBpw0lgFPZQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ide: use ->ata_input_data in ide_driveid_update()
Date: Sun, 30 Mar 2008 17:11:19 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803301711.19315.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use ->ata_input_data method instead of calling ata_input_data() directly.

Currently it matters only for (broken) ide-cris host driver but it may
change in the future.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -674,7 +674,7 @@ int ide_driveid_update(ide_drive_t *driv
 		local_irq_restore(flags);
 		return 0;
 	}
-	ata_input_data(drive, id, SECTOR_WORDS);
+	hwif->ata_input_data(drive, id, SECTOR_WORDS);
 	(void)ide_read_status(drive);	/* clear drive IRQ */
 	local_irq_enable();
 	local_irq_restore(flags);
