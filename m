Return-Path: <linux-kernel-owner+w=401wt.eu-S1763806AbXHVOyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763806AbXHVOyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 10:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762711AbXHVOxw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 10:53:52 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:47196 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762556AbXHVOxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 10:53:48 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
Subject: [PATCH 3/4] ehea: fix queue destructor
Date: Wed, 22 Aug 2007 16:21:28 +0200
User-Agent: KMail/1.8.2
MIME-Version: 1.0
Content-Disposition: inline
To: Jeff Garzik <jeff@garzik.org>
Cc: netdev <netdev@vger.kernel.org>, Christoph Raisch <raisch@de.ibm.com>,
       "Jan-Bernd Themann" <themann@de.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ppc" <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       Thomas Klein <tklein@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708221621.28487.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Includes hcp_epas_dtor in eq/cq/qp destructors to unmap
HW register.

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

---
 drivers/net/ehea/ehea_qmr.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ehea/ehea_qmr.c b/drivers/net/ehea/ehea_qmr.c
index a36fa6c..c82e245 100644
--- a/drivers/net/ehea/ehea_qmr.c
+++ b/drivers/net/ehea/ehea_qmr.c
@@ -235,6 +235,8 @@ int ehea_destroy_cq(struct ehea_cq *cq)
 	if (!cq)
 		return 0;
 
+	hcp_epas_dtor(&cq->epas);
+
 	if ((hret = ehea_destroy_cq_res(cq, NORMAL_FREE)) == H_R_STATE) {
 		ehea_error_data(cq->adapter, cq->fw_handle);
 		hret = ehea_destroy_cq_res(cq, FORCE_FREE);
@@ -361,6 +363,8 @@ int ehea_destroy_eq(struct ehea_eq *eq)
 	if (!eq)
 		return 0;
 
+	hcp_epas_dtor(&eq->epas);
+
 	if ((hret = ehea_destroy_eq_res(eq, NORMAL_FREE)) == H_R_STATE) {
 		ehea_error_data(eq->adapter, eq->fw_handle);
 		hret = ehea_destroy_eq_res(eq, FORCE_FREE);
@@ -541,6 +545,8 @@ int ehea_destroy_qp(struct ehea_qp *qp)
 	if (!qp)
 		return 0;
 
+	hcp_epas_dtor(&qp->epas);
+
 	if ((hret = ehea_destroy_qp_res(qp, NORMAL_FREE)) == H_R_STATE) {
 		ehea_error_data(qp->adapter, qp->fw_handle);
 		hret = ehea_destroy_qp_res(qp, FORCE_FREE);
-- 
1.5.2

