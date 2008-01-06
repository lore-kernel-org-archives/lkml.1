Return-Path: <linux-kernel-owner+w=401wt.eu-S1759678AbYAFQwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678AbYAFQwY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbYAFQvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:51:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19805 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425AbYAFQvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:51:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=qtUsjAe+jEsQ2MtQCmTkQpycyWeqTrIu4iC6/77qnG3GUe35AHwiiI+zMVHBwxV1PddG8fxvlQTG4pfiq8PokZFhj68JiKuK0cHpNIOBnVUEzwX9gipdHSbDf9gRY6g4xN44rHdIcap7I07t6/OTEVimpFRBfBtTiLG2lCj4aLk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:48 +0100
Message-Id: <20080106170248.6861.17796.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/8] macide: remove drive->capacity64 quirk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays IDE core always provides drive ID and ide-disk always setups
drive->capacity64 so this quirk is no longer needed.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/legacy/macide.c |   10 ----------
 1 file changed, 10 deletions(-)

Index: b/drivers/ide/legacy/macide.c
===================================================================
--- a/drivers/ide/legacy/macide.c
+++ b/drivers/ide/legacy/macide.c
@@ -123,16 +123,6 @@ static int __init macide_init(void)
 		ide_init_port_data(hwif, index);
 		ide_init_port_hw(hwif, &hw);
 
-		if (macintosh_config->ide_type == MAC_IDE_BABOON &&
-		    macintosh_config->ident == MAC_MODEL_PB190) {
-			/* Fix breakage in ide-disk.c: drive capacity	*/
-			/* is not initialized for drives without a 	*/
-			/* hardware ID, and we can't get that without	*/
-			/* probing the drive which freezes a 190.	*/
-			ide_drive_t *drive = &hwif->drives[0];
-			drive->capacity64 = drive->cyl*drive->head*drive->sect;
-		}
-
 		hwif->mmio = 1;
 
 		ide_device_add(idx);
