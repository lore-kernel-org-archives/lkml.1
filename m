Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbXJPP0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbXJPP0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 11:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXJPP0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 11:26:23 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:52645 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933178AbXJPP0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 11:26:22 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 2/5] IB/ehca: Fix masking error in {,re}reg_phys_mr()
User-Agent: KMail/1.9.1
Cc: Roland Dreier <rolandd@cisco.com>, "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200710161722.29144.fenkes@de.ibm.com>
In-Reply-To: <200710161722.29144.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1982
Date: Tue, 16 Oct 2007 17:25:50 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200710161725.50371.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index da88738..16c9efd 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -259,7 +259,7 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
 		pginfo.next_hwpage =
-			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
+			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
 
 		ret = ehca_reg_mr(shca, e_mr, iova_start, size, mr_access_flags,
 				  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
@@ -547,7 +547,7 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 		pginfo.u.phy.num_phys_buf = num_phys_buf;
 		pginfo.u.phy.phys_buf_array = phys_buf_array;
 		pginfo.next_hwpage =
-			((u64)iova_start & ~(hw_pgsize - 1)) / hw_pgsize;
+			((u64)iova_start & ~PAGE_MASK) / hw_pgsize;
 	}
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		new_acl = mr_access_flags;
-- 
1.5.2


