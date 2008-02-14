Return-Path: <linux-kernel-owner+w=401wt.eu-S964812AbYBNVZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbYBNVZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934347AbYBNVYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:24:25 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51798 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934338AbYBNVYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:24:23 -0500
Date: Thu, 14 Feb 2008 23:24:02 +0200
From: Adrian Bunk <bunk@kernel.org>
To: James Smart <james.smart@emulex.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make lpfc_disable_node() static
Message-ID: <20080214212402.GF23227@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes theneedlessly global lpfc_disable_node() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/scsi/lpfc/lpfc_crtn.h    |    1 -
 drivers/scsi/lpfc/lpfc_hbadisc.c |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

c3ed441728e0116d0e545837d84cbe337740a3de diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 848d977..0819f5f 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -55,7 +55,6 @@ void lpfc_mbx_cmpl_ns_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_enqueue_node(struct lpfc_vport *, struct lpfc_nodelist *);
 void lpfc_dequeue_node(struct lpfc_vport *, struct lpfc_nodelist *);
-void lpfc_disable_node(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_nodelist *lpfc_enable_node(struct lpfc_vport *,
 					struct lpfc_nodelist *, int);
 void lpfc_nlp_set_state(struct lpfc_vport *, struct lpfc_nodelist *, int);
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index bd572d6..9766534 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1694,7 +1694,7 @@ lpfc_dequeue_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 				NLP_STE_UNUSED_NODE);
 }
 
-void
+static void
 lpfc_disable_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 {
 	if ((ndlp->nlp_flag & NLP_DELAY_TMO) != 0)

