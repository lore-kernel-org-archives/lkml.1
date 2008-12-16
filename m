Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYLPPPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYLPPPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758104AbYLPPPO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:15:14 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59604 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758558AbYLPPPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:15:11 -0500
Date: Tue, 16 Dec 2008 16:15:08 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 9/11] drivers/scsi: Move a dereference below a NULL test
Message-ID: <Pine.LNX.4.64.0812161614500.20444@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In each case, if the NULL test is necessary, then the dereference should be
moved below the NULL test.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/lpfc/lpfc_init.c       |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 909be33..9a01cf0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1736,12 +1736,13 @@ lpfc_block_mgmt_io(struct lpfc_hba * phba)
 int
 lpfc_online(struct lpfc_hba *phba)
 {
-	struct lpfc_vport *vport = phba->pport;
+	struct lpfc_vport *vport;
 	struct lpfc_vport **vports;
 	int i;
 
 	if (!phba)
 		return 0;
+	vport = phba->pport;
 
 	if (!(vport->fc_flag & FC_OFFLINE_MODE))
 		return 0;
