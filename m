Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753856AbYLRHnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYLRHnj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:43:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbYLRHlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:18 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:60844 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYLRHlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=srsrt66mH8QeO6gLa+bu+vtLNlGZuIFxSkXyFYCM8gnPlWO3DxI6ks7RPeesuNaxOc
         q0xW5xD90C9eBWf3QJ6LqKq4Y4Y13ArxBrV0kP23T6OpMWROUDeYniyNbB7do8Yr5EPK
         BpyqyQZDmx0sS+ugLdP29IYPTEWBRZ4eabIwY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 7/8] ide-atapi: put the rest of non-ide-cd code into the else-clause of ide_transfer_pc
Date: Thu, 18 Dec 2008 08:40:51 +0100
Message-Id: <1229586052-3542-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index dbed09c..f3dea66 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -534,17 +534,17 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 							       : WAIT_TAPE_CMD;
 			expiry = NULL;
 		}
-	}
 
-	ireason = ide_read_ireason(drive);
-	if (drive->media == ide_tape)
-		ireason = ide_wait_ireason(drive, ireason);
+		ireason = ide_read_ireason(drive);
+		if (drive->media == ide_tape)
+			ireason = ide_wait_ireason(drive, ireason);
 
-	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
-		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
-				"a packet command\n", drive->name);
+		if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
+			printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
+					"a packet command\n", drive->name);
 
-		return ide_do_reset(drive);
+			return ide_do_reset(drive);
+		}
 	}
 
 	/* Set the interrupt routine */
-- 
1.6.0.4

