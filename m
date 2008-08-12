Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbYHLMuF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbYHLMuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:50:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYHLMtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:49:55 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:59313 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYHLMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:49:54 -0400
Date: Tue, 12 Aug 2008 14:49:36 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: [PATCH 2/5] ib/ehca: rename goto label
Message-ID: <20080812144936.0ed20333@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
References: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the "poll_cq_one_read_cqe" goto label to what it actually does,
"repoll".

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -589,7 +589,7 @@ static inline int ehca_poll_cq_one(struc
 	struct ehca_qp *my_qp;
 	int cqe_count = 0, is_error;
 
-poll_cq_one_read_cqe:
+repoll:
 	cqe = (struct ehca_cqe *)
 		ipz_qeit_get_inc_valid(&my_cq->ipz_queue);
 	if (!cqe) {
@@ -617,7 +617,7 @@ poll_cq_one_read_cqe:
 			ehca_dmp(cqe, 64, "cq_num=%x qp_num=%x",
 				 my_cq->cq_number,
cqe->local_qp_number); /* ignore this purged cqe */
-			goto poll_cq_one_read_cqe;
+			goto repoll;
 		}
 		spin_lock_irqsave(&qp->spinlock_s, flags);
 		purgeflag = qp->sqerr_purgeflag;
@@ -636,7 +636,7 @@ poll_cq_one_read_cqe:
 			 * that caused sqe and turn off purge flag
 			 */
 			qp->sqerr_purgeflag = 0;
-			goto poll_cq_one_read_cqe;
+			goto repoll;
 		}
 	}
 
