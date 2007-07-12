Return-Path: <linux-kernel-owner+w=401wt.eu-S934776AbXGLPuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934776AbXGLPuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934676AbXGLPtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:49:43 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:15446 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934409AbXGLPtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:49:41 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 03/10] IB/ehca: fix memory leak in error path of ehca_get_dma_mr()
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:48:22 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121748.23065.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_mrmw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index add79bd..98f2531 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -111,6 +111,7 @@ struct ib_mr *ehca_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 				     &e_maxmr->ib.ib_mr.lkey,
 				     &e_maxmr->ib.ib_mr.rkey);
 		if (ret) {
+			ehca_mr_delete(e_maxmr);
 			ib_mr = ERR_PTR(ret);
 			goto get_dma_mr_exit0;
 		}
-- 
1.5.2


