Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYGYCsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYGYCsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 22:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbYGYCs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 22:48:28 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:27792 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYGYCs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 22:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AebZrpFME6uWKyLUsZzQgLcvbR2MGqpNG5ry1onMb2WRfXSqeenrv55KsfAMtP2mC/
         4pGe01icxPZgV9hz3cZSt6TxNld8oNI9e1YdnVnW5bX7emtLybO6wRv6sV8BQSZp3AIo
         MjSzdAXc94pPhhBF90vNS/4zkBePs196TND/k=
From: Denis ChengRq <crquan@gmail.com>
To: James Smart <james.smart@emulex.com>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/scsi/lpfc/: replace __FUNCTION__ with __func__
Date: Fri, 25 Jul 2008 10:48:02 +0800
Message-Id: <1216954082-31925-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis ChengRq <crquan@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c |    4 ++--
 drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c  |    6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5b6e539..08a026e 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2083,7 +2083,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 		if (iocbq_entry == NULL) {
 			printk(KERN_ERR "%s: only allocated %d iocbs of "
 				"expected %d count. Unloading driver.\n",
-				__FUNCTION__, i, LPFC_IOCB_LIST_CNT);
+				__func__, i, LPFC_IOCB_LIST_CNT);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
@@ -2093,7 +2093,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
 			kfree (iocbq_entry);
 			printk(KERN_ERR "%s: failed to allocate IOTAG. "
 			       "Unloading driver.\n",
-				__FUNCTION__);
+			       __func__);
 			error = -ENOMEM;
 			goto out_free_iocbq;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c94da4f..1bcebbd 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -341,7 +341,7 @@ lpfc_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_scsi_buf *lpfc_cmd)
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			printk(KERN_ERR "%s: Too many sg segments from "
 			       "dma_map_sg.  Config %d, seg_cnt %d",
-			       __FUNCTION__, phba->cfg_sg_seg_cnt,
+			       __func__, phba->cfg_sg_seg_cnt,
 			       lpfc_cmd->seg_cnt);
 			scsi_dma_unmap(scsi_cmnd);
 			return 1;
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index f40aa7b..17b8be8 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -219,7 +219,7 @@ lpfc_sli_iocb_cmd_type(uint8_t iocb_cmnd)
 	case CMD_IOCB_LOGENTRY_CN:
 	case CMD_IOCB_LOGENTRY_ASYNC_CN:
 		printk("%s - Unhandled SLI-3 Command x%x\n",
-				__FUNCTION__, iocb_cmnd);
+				__func__, iocb_cmnd);
 		type = LPFC_UNKNOWN_IOCB;
 		break;
 	default:
@@ -1715,7 +1715,7 @@ lpfc_sli_handle_slow_ring_event(struct lpfc_hba *phba,
 		rspiocbp = __lpfc_sli_get_iocbq(phba);
 		if (rspiocbp == NULL) {
 			printk(KERN_ERR "%s: out of buffers! Failing "
-			       "completion.\n", __FUNCTION__);
+					"completion.\n", __func__);
 			break;
 		}
 
@@ -3793,7 +3793,7 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 		break;
 	default:
 		printk(KERN_ERR "%s: Unknown context cmd type, value %d\n",
-			__FUNCTION__, ctx_cmd);
+				__func__, ctx_cmd);
 		break;
 	}
 
-- 
1.5.6.3

