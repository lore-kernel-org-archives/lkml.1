Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYFLGlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYFLGlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbYFLGlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:41:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:9725 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYFLGlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:41:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=QCbY60t1ANMshAOObKJvQQgZn+D8phvbehj1Ezfxz8j/zPcn00i/dV6pu+jK1ouClv
         Vkpk7BdJEqC5j2V9H1JLx+eawjSR9DWL2t+lAMR/I4BTR7zW3+ysYUun/b8KuNl7qkX+
         eLU6r4Gl/t/qT7BkWNlOCf//88oFxXl24gGFo=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 01/18] ide-cd: remove wait-for-idle-controller bit in cdrom_start_packet_command
Date: Thu, 12 Jun 2008 08:40:53 +0200
Message-Id: <1213252870-20474-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is done in the request issue path anyway

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index d998471..92a8a36 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -517,14 +517,9 @@ static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
 						  int xferlen,
 						  ide_handler_t *handler)
 {
-	ide_startstop_t startstop;
 	struct cdrom_info *info = drive->driver_data;
 	ide_hwif_t *hwif = drive->hwif;
 
-	/* wait for the controller to be idle */
-	if (ide_wait_stat(&startstop, drive, 0, BUSY_STAT, WAIT_READY))
-		return startstop;
-
 	/* FIXME: for Virtual DMA we must check harder */
 	if (info->dma)
 		info->dma = !hwif->dma_ops->dma_setup(drive);
-- 
1.5.5.1

