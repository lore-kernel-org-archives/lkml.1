Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbZAFSfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbZAFSfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZAFSfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:35:01 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:59614 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbZAFSe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:34:59 -0500
X-Greylist: delayed 85297 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 13:34:58 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=htF5ttig/foJ4yMnUcHP82Miw52UUcyMYdybq1syCivRSKEmOa08NrbHaNFp7/jDBB
         OyDFSETzXcJINrn0THc5GMKFKntv/R49KxpOj04WmsgiPBR6hhkIYEIAWzILaXxwhNwi
         FXo+4Bn1qQ3KWvD6NdRFYfpo+3eEKNSNbyznk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 06 Jan 2009 19:35:41 +0100
Message-Id: <20090106183541.21193.691.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain>
Subject: [PATCH 4/9] ide: fix IDE_DFLAG_NO_IO_32BIT handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix IDE_DFLAG_NO_IO_32BIT handling

* IDE_DFLAG_NO_IO_32BIT may be set by cmd640's ->init_dev method
  so don't clear it in ide_port_tune_devices() (+ no need to do it).

* Move IDE_DFLAG_NO_IO_32BIT handling to ide_port_init_devices().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -847,13 +847,6 @@ static void ide_port_tune_devices(ide_hw
 				ide_set_dma(drive);
 		}
 	}
-
-	ide_port_for_each_dev(i, drive, hwif) {
-		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
-			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
-		else
-			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
-	}
 }
 
 /*
@@ -1186,6 +1179,8 @@ static void ide_port_init_devices(ide_hw
 
 		if (hwif->host_flags & IDE_HFLAG_IO_32BIT)
 			drive->io_32bit = 1;
+		if (hwif->host_flags & IDE_HFLAG_NO_IO_32BIT)
+			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		if (hwif->host_flags & IDE_HFLAG_UNMASK_IRQS)
 			drive->dev_flags |= IDE_DFLAG_UNMASK;
 		if (hwif->host_flags & IDE_HFLAG_NO_UNMASK_IRQS)
