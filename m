Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbYFLGmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbYFLGmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYFLGlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:9461 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYFLGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=k2xQ8BzOovEYXGTSn7qujJCKfTx5WLWjMeTyiojhbBu3bdeUDjARWHAKSiEfSzGdjQ
         Fbs0bQ6mRLnGsebGeNCf/AIeNLek11dkx9yNYLOBQUlvWF33Z6fjHZDFDmrlLUm2D+N0
         5rbSM1RpmN0l88hRpSD2ax/Ep8oL33szHcqL4=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 06/18] ide-cd: cdrom_start_seek: remove unused argument block
Date: Thu, 12 Jun 2008 08:40:58 +0200
Message-Id: <1213252870-20474-7-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 21c4510..40dab2b 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -778,7 +778,7 @@ static ide_startstop_t cdrom_start_seek_continuation(ide_drive_t *drive)
 	return cdrom_transfer_packet_command(drive, rq, &cdrom_seek_intr);
 }
 
-static ide_startstop_t cdrom_start_seek(ide_drive_t *drive, unsigned int block)
+static ide_startstop_t cdrom_start_seek(ide_drive_t *drive)
 {
 	struct cdrom_info *info = drive->driver_data;
 
@@ -1237,7 +1237,7 @@ static ide_startstop_t ide_do_rw_cdrom(ide_drive_t *drive, struct request *rq,
 		    IDE_LARGE_SEEK(info->last_block, block,
 				   IDECD_SEEK_THRESHOLD) &&
 		    drive->dsc_overlap)
-			action = cdrom_start_seek(drive, block);
+			action = cdrom_start_seek(drive);
 		else
 			action = cdrom_start_rw(drive, rq);
 		info->last_block = block;
-- 
1.5.5.1

