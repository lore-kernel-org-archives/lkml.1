Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZGMVZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZGMVZ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757292AbZGMVZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:25:56 -0400
Received: from server1.wserver.cz ([82.113.45.157]:49988 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757155AbZGMVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:25:55 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jul 2009 17:25:55 EDT
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, james.smart@emulex.com,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] SCSI: lpfc, don't dereference NULL
Date: Mon, 13 Jul 2009 23:25:54 +0200
Message-Id: <1247520354-32145-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kzalloc fails in lpfc_hba_alloc, don't dereference the NULL by
lpfc_printf_log. Use dev_err instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index fc67cc6..2452dc9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -4130,8 +4130,7 @@ lpfc_hba_alloc(struct pci_dev *pdev)
 	/* Allocate memory for HBA structure */
 	phba = kzalloc(sizeof(struct lpfc_hba), GFP_KERNEL);
 	if (!phba) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1417 Failed to allocate hba struct.\n");
+		dev_err(&pdev->dev, "failed to allocate hba struct\n");
 		return NULL;
 	}
 
-- 
1.6.3.2

