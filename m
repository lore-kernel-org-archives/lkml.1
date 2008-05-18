Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYERSk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYERSk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbYERSh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:59 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497AbYERSh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=fcdd5F6BmE4DN5qMBD3EAUByVvyAtSnwH/NvE6a0ki1npP6eHhWR4LnXxNQmedge5ByPk5HcQefPMLE7jCYcjHZ/EXIJkNV9Cd3b9qxO0c/QxWSRbA/Dfm6rWLikL3yAFwf6vVR+Zg0FkRQJiW1DbOpLuuye1+YBO2cU13KIjmE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:55:22 +0200
Message-Id: <20080518185522.5636.90985.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/40] ide-scsi: remove superfluous BUG_ON() from idescsi_transfer_pc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ide_set_handler() bugs on ->handler == NULL so no need to do it
in idescsi_transfer_pc().

There should be no functional changes caused by this patch.

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -469,7 +469,7 @@ static ide_startstop_t idescsi_transfer_
 				"issuing a packet command\n");
 		return ide_do_reset (drive);
 	}
-	BUG_ON(HWGROUP(drive)->handler != NULL);
+
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 
