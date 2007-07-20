Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXGTNwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXGTNwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763266AbXGTNvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:51:40 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:41975 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759647AbXGTNvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:51:37 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org
Subject: [PATCH 4/5] ehca: Make internal_create/destroy_qp() static
Date: Fri, 20 Jul 2007 16:03:09 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com, fenkes@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201603.10321.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joachim Fenkes <fenkes@de.ibm.com>
Date: Thu, 19 Jul 2007 21:40:00 +0200
Subject: [PATCH 4/5] IB/ehca: Make internal_{create,destroy}_qp() static

They're only used in ehca_qp.c

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 48e9cea..b916d9c 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -363,10 +363,11 @@ init_qp_queue1:
  * the value of the is_srq parameter. If init_attr and srq_init_attr share
  * fields, the field out of init_attr is used.
  */
-struct ehca_qp *internal_create_qp(struct ib_pd *pd,
-				   struct ib_qp_init_attr *init_attr,
-				   struct ib_srq_init_attr *srq_init_attr,
-				   struct ib_udata *udata, int is_srq)
+static struct ehca_qp *internal_create_qp(
+	struct ib_pd *pd,
+	struct ib_qp_init_attr *init_attr,
+	struct ib_srq_init_attr *srq_init_attr,
+	struct ib_udata *udata, int is_srq)
 {
 	struct ehca_qp *my_qp;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
@@ -752,8 +753,8 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	return IS_ERR(ret) ? (struct ib_qp *)ret : &ret->ib_qp;
 }
 
-int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
-			struct ib_uobject *uobject);
+static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
+			       struct ib_uobject *uobject);
 
 struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 			       struct ib_srq_init_attr *srq_init_attr,
@@ -1669,8 +1670,8 @@ query_srq_exit1:
 	return ret;
 }
 
-int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
-			struct ib_uobject *uobject)
+static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
+			       struct ib_uobject *uobject)
 {
 	struct ehca_shca *shca = container_of(dev, struct ehca_shca, ib_device);
 	struct ehca_pd *my_pd = container_of(my_qp->ib_qp.pd, struct ehca_pd,
-- 
1.5.2


