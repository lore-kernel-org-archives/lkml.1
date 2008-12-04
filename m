Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbYLDGn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbYLDGn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 01:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755329AbYLDGnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 01:43:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37198 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbYLDGni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 01:43:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=vI1mu96DneOS5yqaIEX0hLtVtx9SKWYvApFbwFrurNa+6jLlzP9e2+0Rqgrtvv92eh
         bB2GwaKX9xuzmnvNRgif6cz/HHcR1AGn5glamNQFlQ2LYKYUNiWl6hW+ywAZwiQ9BEk+
         agD26qgmRuCx2rMEIdwuMJyAOeuAsWm77eLuk=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 4/6] ide-atapi: setup dma for ide-cd
Date: Thu,  4 Dec 2008 07:43:27 +0100
Message-Id: <1228373010-20249-5-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
References: <1228373010-20249-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 7162317..8884877 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -588,8 +588,9 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 		ide_dma_off(drive);
 	}
 
-	if ((pc->flags & PC_FLAG_DMA_OK) &&
-	    (drive->dev_flags & IDE_DFLAG_USING_DMA)) {
+	if (((pc->flags & PC_FLAG_DMA_OK) &&
+		(drive->dev_flags & IDE_DFLAG_USING_DMA)) ||
+	    drive->dma) {
 		if (scsi)
 			hwif->sg_mapped = 1;
 		drive->dma = !hwif->dma_ops->dma_setup(drive);
-- 
1.6.0.4

