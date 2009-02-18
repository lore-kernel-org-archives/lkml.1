Return-Path: <linux-kernel-owner+w=401wt.eu-S1756536AbZBRTVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbZBRTVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZBRTVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:21:32 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:40666 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbZBRTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:21:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=INoa1XzqAavjlAZvA5py8RqbE4QnEmvcdQ6BJ8Glth4N8EGtILpTyWKnaeA7yI1nyB
         KazjLUGsLAzu9T56ihd3uCgocx1uW9owDfCsF/xylKpnySuoy0j8adwe2W2t+AReliqf
         E3kLphEdRtnUM+4xhOKqbaiWsL5JhD0EK+PGE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-cd: document capacity hack
Date: Wed, 18 Feb 2009 20:18:51 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182018.52195.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-cd: document capacity hack

Just copy the comment from drivers/scsi/sr.c::sr_done()
(from which the capacity hack has been originated).

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -189,6 +189,14 @@ static void cdrom_analyze_sense_data(ide
 			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
 			sector &= ~(bio_sectors - 1);
 
+			/*
+			 * The SCSI specification allows for the value
+			 * returned by READ CAPACITY to be up to 75 2K
+			 * sectors past the last readable block.
+			 * Therefore, if we hit a medium error within the
+			 * last 75 2K sectors, we decrease the saved size
+			 * value.
+			 */
 			if (sector < get_capacity(info->disk) &&
 			    drive->probed_capacity - sector < 4 * 75)
 				set_capacity(info->disk, sector);
