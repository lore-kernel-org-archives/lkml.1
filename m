Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbYHLNrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbYHLNrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 09:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYHLNqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 09:46:35 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:22490 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbYHLNqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 09:46:34 -0400
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>, "of-ewg" <ewg@lists.openfabrics.org>,
       "of-general" <general@lists.openfabrics.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "linuxppc-dev" <linuxppc-dev@ozlabs.org>
Subject: [PATCH 3/5 try2] ib/ehca: repoll on invalid opcode
Date: Tue, 12 Aug 2008 15:46:20 +0200
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
Message-Id: <200808121546.20787.alexs@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ehca driver detects an invalid opcode in a CQE, it currently passes
the CQE to the application and returns with success. This patch changes the
CQE handling to discard CQEs with invalid opcodes and to continue reading the
next CQE from the CQ.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -667,7 +667,7 @@ repoll:
 		ehca_dmp(cqe, 64, "ehca_cq=%p cq_num=%x",
 			 my_cq, my_cq->cq_number);
 		/* update also queue adder to throw away this entry!!! */
-		goto poll_cq_one_exit0;
+		goto repoll;
 	}
 
 	/* eval ib_wc_status */
