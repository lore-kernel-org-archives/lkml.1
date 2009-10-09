Return-Path: <linux-kernel-owner+w=401wt.eu-S933125AbZJIN7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933125AbZJIN7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 09:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932548AbZJIN6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 09:58:48 -0400
Received: from server1.wserver.cz ([82.113.45.157]:37648 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760854AbZJIN6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 09:58:45 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, James Smart <james.smart@emulex.com>
Subject: [PATCH -repost 3/4] SCSI: lpfc, fix memory leak
Date: Fri,  9 Oct 2009 15:58:07 +0200
Message-Id: <1255096688-23399-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
References: <1255096688-23399-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse found a memory leak on one fail path in lpfc_sli4_read_rev.

Add there kfree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: James Smart <james.smart@emulex.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/lpfc/lpfc_sli.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 43cbe33..7750868 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -4211,6 +4211,7 @@ lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 	if (rc) {
 		dma_free_coherent(&phba->pcidev->dev, dma_size,
 				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
 		return -EIO;
 	}
 
-- 
1.6.4.2

