Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYAQOEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYAQOEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 09:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYAQOD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 09:03:59 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:3318 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbYAQOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 09:03:58 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 1/4] IB/ehca: Remove CQ-QP-link before destroying QP in error path of create_qp()
Date: Thu, 17 Jan 2008 15:03:55 +0100
User-Agent: KMail/1.9.1
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200801171502.34287.fenkes@de.ibm.com>
In-Reply-To: <200801171502.34287.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171503.56348.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index f116eb7..26c6a94 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -769,12 +769,15 @@ static struct ehca_qp *internal_create_qp(
 		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
 			ehca_err(pd->device, "Copy to udata failed");
 			ret = -EINVAL;
-			goto create_qp_exit4;
+			goto create_qp_exit5;
 		}
 	}
 
 	return my_qp;
 
+create_qp_exit5:
+	ehca_cq_unassign_qp(my_qp->send_cq, my_qp->real_qp_num);
+
 create_qp_exit4:
 	if (HAS_RQ(my_qp))
 		ipz_queue_dtor(my_pd, &my_qp->ipz_rqueue);
-- 
1.5.2


