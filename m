Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbYHLNq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbYHLNq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbYHLNqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:20 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:36874 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYHLNqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:19 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 2/5 try2] ib/ehca: rename goto label
Date: Tue, 12 Aug 2008 15:46:13 +0200
User-Agent: KMail/1.9.9
Cc: Stefan Roscher <stefan.roscher@de.ibm.com>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200808121546.13860.alexs@linux.vnet.ibm.com>
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
 				 my_cq->cq_number, cqe->local_qp_number);
 			/* ignore this purged cqe */
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
 
