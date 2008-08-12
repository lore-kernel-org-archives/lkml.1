Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176AbYHLMv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbYHLMv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 08:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbYHLMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 08:50:42 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:61741 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYHLMul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 08:50:41 -0400
Date: Tue, 12 Aug 2008 14:49:41 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: [PATCH 3/5] ib/ehca: repoll on invalid opcode
Message-ID: <20080812144941.7c89c18d@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
References: <20080812143542.0cbde755@BL3D1974.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the ehca driver detects an invalid opcode in a CQE, it currently
passes the CQE to the application and returns with success. This patch
changes the CQE handling to discard CQEs with invalid opcodes and to
continue reading the next CQE from the CQ.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_reqs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -667,7 +667,7 @@ repoll:
 		ehca_dmp(cqe, 64, "ehca_cq=%p cq_num=%x",
 			 my_cq, my_cq->cq_number);
 		/* update also queue adder to throw away this entry!!!
*/
-		goto poll_cq_one_exit0;
+		goto repoll;
 	}
 
 	/* eval ib_wc_status */
