Return-Path: <linux-kernel-owner+w=401wt.eu-S933203AbYEHTXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933203AbYEHTXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYEHTWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:22:04 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:42280 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbYEHTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:21:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=RtxBbUP3Q3xnbkHUF4Kd59g7Ih/Zs5WY+74HiVrIuevNKvSSV5XJZpphQ4zQvTGesHukgkrjpMZZwPoSIWksJ4WsfbDsKbInp4wEO249r3VqnB3Hb9aqx63RXWHkUnIj7vUPam8g5rAPKktpMmLYlYgjdxXRcFU5kXlZIMKaOm0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: use ->OUTBSYNC in ide_set_irq()
Date: Thu, 8 May 2008 21:36:55 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082136.55417.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1325,7 +1325,8 @@ static inline void ide_set_irq(ide_drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	hwif->OUTB(drive->ctl | (on ? 0 : 2), hwif->io_ports.ctl_addr);
+	hwif->OUTBSYNC(hwif, drive->ctl | (on ? 0 : 2),
+		       hwif->io_ports.ctl_addr);
 }
 
 static inline u8 ide_read_status(ide_drive_t *drive)
