Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbXKVK0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbXKVK0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 05:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbXKVK0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 05:26:31 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:14486 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbXKVK0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 05:26:30 -0500
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Fix static rate regression
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Marcus Eder <meder@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2328
Date: Thu, 22 Nov 2007 12:26:26 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711221126.27465.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong choice of port number caused modify_qp() to fail -- fixed.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
Please apply this for 2.6.24-rc4 as it fixes a regression introduced in rc3.
Thanks!

 drivers/infiniband/hw/ehca/ehca_qp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 2e3e654..dd12668 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -1203,7 +1203,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->service_level = attr->ah_attr.sl;
 		update_mask |= EHCA_BMASK_SET(MQPCB_MASK_SERVICE_LEVEL, 1);
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->prim_phys_port,
 				  attr->ah_attr.static_rate,
 				  &mqpcb->max_static_rate)) {
 			ret = -EINVAL;
@@ -1302,7 +1302,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		mqpcb->source_path_bits_al = attr->alt_ah_attr.src_path_bits;
 		mqpcb->service_level_al = attr->alt_ah_attr.sl;
 
-		if (ehca_calc_ipd(shca, my_qp->init_attr.port_num,
+		if (ehca_calc_ipd(shca, mqpcb->alt_phys_port,
 				  attr->alt_ah_attr.static_rate,
 				  &mqpcb->max_static_rate_al)) {
 			ret = -EINVAL;
-- 
1.5.2



