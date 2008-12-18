Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752449AbYLROTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbYLROTR (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 09:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752003AbYLROSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 09:18:51 -0500
Received: from mail.inf.tu-dresden.de ([141.76.2.1]:62416 "EHLO
	mail.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYLROSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 09:18:50 -0500
Message-ID: <494A5BC9.7000605@inf.tu-dresden.de>
Date: Thu, 18 Dec 2008 15:18:49 +0100
From: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] ide: Fix drive's DWORD-IO handling
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitted on request.

According the documentation, id[ATA_ID_DWORD_IO] is non-zero if
the drive supports dword IO, while the code disables support by
setting IDE_DFLAG_NO_IO_32BIT. In addition, this word has been
reused by the ATA8 specification. This patch fixes both cases.

Signed-off-by: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
---
 drivers/ide/ide-probe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index c55bdbd..859b0e5 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -856,7 +856,7 @@ static void ide_port_tune_devices(ide_hwif_t *hwif)
 		ide_drive_t *drive = &hwif->drives[unit];

 		if ((hwif->host_flags & IDE_HFLAG_NO_IO_32BIT) ||
-		    drive->id[ATA_ID_DWORD_IO])
+		    !ata_id_has_dword_io(drive->id))
 			drive->dev_flags |= IDE_DFLAG_NO_IO_32BIT;
 		else
 			drive->dev_flags &= ~IDE_DFLAG_NO_IO_32BIT;
-- 
1.5.6.3

