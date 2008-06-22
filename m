Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYFVTd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYFVTd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757671AbYFVTdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:33:43 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:39530 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757300AbYFVTdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:33:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=D2cIBJo01IL6n/I3ubIWbgDT+l25fMGMdGU1dq6n910Hh5CjvFPTKhKzYpIbvlFjVl
         QN4pOTeR97HyWou9Fs9ZKk9LfRyQSW/4/0kiRqzIW/uJJXcNl81KcLsEefOguxv7kJmz
         nlS8rmVAJuap4RCHOoe15JYQfUDEYGxPiOZTo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 22 Jun 2008 21:35:37 +0200
Message-Id: <20080622193537.5325.43764.sendpatchset@localhost.localdomain>
Subject: [PATCH 1/4] ide-generic: probing fix
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Don't skip probing IDE port if the corresponding ide_hwifs[] slot
  is already occupied.

* Remove duplicate idx[i] assignment.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-generic.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: b/drivers/ide/ide-generic.c
===================================================================
--- a/drivers/ide/ide-generic.c
+++ b/drivers/ide/ide-generic.c
@@ -118,15 +118,9 @@ static int __init ide_generic_init(void)
 				continue;
 			}
 
-			/*
-			 * Skip probing if the corresponding
-			 * slot is already occupied.
-			 */
 			hwif = ide_find_port();
-			if (hwif == NULL || hwif->index != i) {
-				idx[i] = 0xff;
+			if (hwif == NULL)
 				continue;
-			}
 
 			hwif->chipset = ide_generic;
 
