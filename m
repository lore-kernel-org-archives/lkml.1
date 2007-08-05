Return-Path: <linux-kernel-owner+w=401wt.eu-S1763940AbXHCQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763940AbXHCQO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759915AbXHCQOt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 12:14:49 -0400
Received: from emulex.emulex.com ([138.239.112.1]:49752 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757344AbXHCQOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 12:14:48 -0400
Subject: [PATCH] lpfc : lpfc_debugfs.c kmalloc + memset conversion to
	kzalloc
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>
In-Reply-To: <46B34CA6.6010502@emulex.com>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	 <200707312027.55149.m.kozlowski@tuxland.pl>  <46B34CA6.6010502@emulex.com>
Content-Type: text/plain
Organization: Emulex Corporation
Date: Sun, 05 Aug 2007 06:00:17 -0400
Message-Id: <1186308017.2983.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 16:14:04.0201 (UTC) FILETIME=[4F8BD990:01C7D5E9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

One more area, introduced by the lpfc 8.2.2 patches, that need the 
  kmalloc+memset conversion.

This patch to be applied atop the 8.2.2 patches.

-- james s


Signed-off-by: James Smart <James.Smart@emulex.com>


diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 2e3c01b..ef99e2b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -856,9 +856,9 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 			goto debug_failed;
 		}
 		if (!phba->slow_ring_trc) {
-			phba->slow_ring_trc = kmalloc(
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc),
+			phba->slow_ring_trc = kcalloc(
+				lpfc_debugfs_max_slow_ring_trc,
+				sizeof(struct lpfc_debugfs_trc),
 				GFP_KERNEL);
 			if (!phba->slow_ring_trc) {
 				lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
@@ -867,9 +867,6 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				goto debug_failed;
 			}
 			atomic_set(&phba->slow_ring_trc_cnt, 0);
-			memset(phba->slow_ring_trc, 0,
-				(sizeof(struct lpfc_debugfs_trc) *
-				lpfc_debugfs_max_slow_ring_trc));
 		}
 	}
 


