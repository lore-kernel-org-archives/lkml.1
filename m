Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbXIQLHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbXIQLHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 07:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbXIQLHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 07:07:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:28266 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622AbXIQLHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 07:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=X0g2yoTLoOx3TodkISqMHCgYoO5g46Q/2UPbHT1V55gp04+tZjB+GTjETXhKgqFglwIKsiEXoxKMhNukazHv8l8azQAGk73maHPIjAi3Zf3aWLwxkryhigRS+5uD3/rCSNt9i78xxcxp8qp7mmF36z9NyE+LPoJKguP6agxuEHI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patches] IDE fixes
Date: Mon, 17 Sep 2007 12:38:50 +0200
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709171238.50304.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/ide/ide-disk.c |    1 +
 drivers/ide/ppc/pmac.c |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)


Jorge Juan Chico (1):
      ide: ST320413A has the same problem as ST340823A

Stephen Rothwell (1):
      ide: remove unused variables from drivers/ide/ppc/pmac.c


diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index eba1adb..4754769 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -487,6 +487,7 @@ static inline int idedisk_supports_lba48(const struct hd_driveid *id)
  */
 static const struct drive_list_entry hpa_list[] = {
 	{ "ST340823A",	NULL },
+	{ "ST320413A",	NULL },
 	{ NULL,		NULL }
 };
 
diff --git a/drivers/ide/ppc/pmac.c b/drivers/ide/ppc/pmac.c
index 4b13cd9..f19eb6d 100644
--- a/drivers/ide/ppc/pmac.c
+++ b/drivers/ide/ppc/pmac.c
@@ -1802,9 +1802,7 @@ pmac_ide_dma_check(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
 	ide_hwif_t *hwif = HWIF(drive);
-	pmac_ide_hwif_t* pmif = (pmac_ide_hwif_t *)hwif->hwif_data;
 	int enable = 1;
-	int map;
 	drive->using_dma = 0;
 	
 	if (drive->media == ide_floppy)
