Return-Path: <linux-kernel-owner+w=401wt.eu-S935261AbXGLPyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261AbXGLPyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 11:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762123AbXGLPxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 11:53:55 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:15633 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbXGLPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 11:53:52 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: [PATCH 09/10] IB/ehca: Fix warnings issued by checkpatch.pl
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200707121745.27592.fenkes@de.ibm.com>
In-Reply-To: <200707121745.27592.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 25418
Date: Thu, 12 Jul 2007 17:53:47 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707121753.48434.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hoang-Nam Nguyen <hnguyen@de.ibm.com>

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_av.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_classes.h         |    4 +-
 drivers/infiniband/hw/ehca/ehca_classes_pSeries.h |  156 ++++++++++----------
 drivers/infiniband/hw/ehca/ehca_cq.c              |    2 +-
 drivers/infiniband/hw/ehca/ehca_eq.c              |    3 +-
 drivers/infiniband/hw/ehca/ehca_hca.c             |   28 +++-
 drivers/infiniband/hw/ehca/ehca_irq.c             |   56 ++++----
 drivers/infiniband/hw/ehca/ehca_iverbs.h          |    7 +-
 drivers/infiniband/hw/ehca/ehca_main.c            |   21 ++--
 drivers/infiniband/hw/ehca/ehca_mrmw.c            |   59 ++++----
 drivers/infiniband/hw/ehca/ehca_mrmw.h            |    7 +-
 drivers/infiniband/hw/ehca/ehca_qes.h             |   22 ++--
 drivers/infiniband/hw/ehca/ehca_qp.c              |   39 +++---
 drivers/infiniband/hw/ehca/ehca_reqs.c            |   15 ++-
 drivers/infiniband/hw/ehca/ehca_tools.h           |   28 ++--
 drivers/infiniband/hw/ehca/ehca_uverbs.c          |   10 +-
 drivers/infiniband/hw/ehca/hcp_if.c               |    8 +-
 drivers/infiniband/hw/ehca/hcp_phyp.c             |    2 +-
 drivers/infiniband/hw/ehca/hipz_fns_core.h        |    4 +-
 drivers/infiniband/hw/ehca/hipz_hw.h              |   24 ++--
 drivers/infiniband/hw/ehca/ipz_pt_fn.c            |    2 +-
 drivers/infiniband/hw/ehca/ipz_pt_fn.h            |    4 +-
 22 files changed, 261 insertions(+), 242 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_av.c b/drivers/infiniband/hw/ehca/ehca_av.c
index 3cd6bf3..e53a97a 100644
--- a/drivers/infiniband/hw/ehca/ehca_av.c
+++ b/drivers/infiniband/hw/ehca/ehca_av.c
@@ -79,7 +79,7 @@ struct ib_ah *ehca_create_ah(struct ib_pd *pd, struct ib_ah_attr *ah_attr)
 			av->av.ipd = (ah_mult > 0) ?
 				((ehca_mult - 1) / ah_mult) : 0;
 	} else
-	        av->av.ipd = ehca_static_rate;
+		av->av.ipd = ehca_static_rate;
 
 	av->av.lnh = ah_attr->ah_flags;
 	av->av.grh.word_0 = EHCA_BMASK_SET(GRH_IPVERSION_MASK, 6);
diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 92103df..1752821 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -215,7 +215,7 @@ struct ehca_mr {
 	u32 num_hwpages;	/* number of hw pages to form MR */
 	int acl;		/* ACL (stored here for usage in reregister) */
 	u64 *start;		/* virtual start address (stored here for */
-	                        /* usage in reregister) */
+				/* usage in reregister) */
 	u64 size;		/* size (stored here for usage in reregister) */
 	u32 fmr_page_size;	/* page size for FMR */
 	u32 fmr_max_pages;	/* max pages for FMR */
@@ -400,6 +400,6 @@ struct ehca_alloc_qp_parms {
 
 int ehca_cq_assign_qp(struct ehca_cq *cq, struct ehca_qp *qp);
 int ehca_cq_unassign_qp(struct ehca_cq *cq, unsigned int qp_num);
-struct ehca_qp* ehca_cq_get_qp(struct ehca_cq *cq, int qp_num);
+struct ehca_qp *ehca_cq_get_qp(struct ehca_cq *cq, int qp_num);
 
 #endif
diff --git a/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h b/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
index fb3df5c..1798e64 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes_pSeries.h
@@ -154,83 +154,83 @@ struct hcp_modify_qp_control_block {
 	u32 reserved_70_127[58];       /* 70 */
 };
 
-#define MQPCB_MASK_QKEY                         EHCA_BMASK_IBM(0,0)
-#define MQPCB_MASK_SEND_PSN                     EHCA_BMASK_IBM(2,2)
-#define MQPCB_MASK_RECEIVE_PSN                  EHCA_BMASK_IBM(3,3)
-#define MQPCB_MASK_PRIM_PHYS_PORT               EHCA_BMASK_IBM(4,4)
-#define MQPCB_PRIM_PHYS_PORT                    EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_ALT_PHYS_PORT                EHCA_BMASK_IBM(5,5)
-#define MQPCB_MASK_PRIM_P_KEY_IDX               EHCA_BMASK_IBM(6,6)
-#define MQPCB_PRIM_P_KEY_IDX                    EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_ALT_P_KEY_IDX                EHCA_BMASK_IBM(7,7)
-#define MQPCB_MASK_RDMA_ATOMIC_CTRL             EHCA_BMASK_IBM(8,8)
-#define MQPCB_MASK_QP_STATE                     EHCA_BMASK_IBM(9,9)
-#define MQPCB_QP_STATE                          EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_RDMA_NR_ATOMIC_RESP_RES      EHCA_BMASK_IBM(11,11)
-#define MQPCB_MASK_PATH_MIGRATION_STATE         EHCA_BMASK_IBM(12,12)
-#define MQPCB_MASK_RDMA_ATOMIC_OUTST_DEST_QP    EHCA_BMASK_IBM(13,13)
-#define MQPCB_MASK_DEST_QP_NR                   EHCA_BMASK_IBM(14,14)
-#define MQPCB_MASK_MIN_RNR_NAK_TIMER_FIELD      EHCA_BMASK_IBM(15,15)
-#define MQPCB_MASK_SERVICE_LEVEL                EHCA_BMASK_IBM(16,16)
-#define MQPCB_MASK_SEND_GRH_FLAG                EHCA_BMASK_IBM(17,17)
-#define MQPCB_MASK_RETRY_COUNT                  EHCA_BMASK_IBM(18,18)
-#define MQPCB_MASK_TIMEOUT                      EHCA_BMASK_IBM(19,19)
-#define MQPCB_MASK_PATH_MTU                     EHCA_BMASK_IBM(20,20)
-#define MQPCB_PATH_MTU                          EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_MAX_STATIC_RATE              EHCA_BMASK_IBM(21,21)
-#define MQPCB_MAX_STATIC_RATE                   EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_DLID                         EHCA_BMASK_IBM(22,22)
-#define MQPCB_DLID                              EHCA_BMASK_IBM(16,31)
-#define MQPCB_MASK_RNR_RETRY_COUNT              EHCA_BMASK_IBM(23,23)
-#define MQPCB_RNR_RETRY_COUNT                   EHCA_BMASK_IBM(29,31)
-#define MQPCB_MASK_SOURCE_PATH_BITS             EHCA_BMASK_IBM(24,24)
-#define MQPCB_SOURCE_PATH_BITS                  EHCA_BMASK_IBM(25,31)
-#define MQPCB_MASK_TRAFFIC_CLASS                EHCA_BMASK_IBM(25,25)
-#define MQPCB_TRAFFIC_CLASS                     EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_HOP_LIMIT                    EHCA_BMASK_IBM(26,26)
-#define MQPCB_HOP_LIMIT                         EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_SOURCE_GID_IDX               EHCA_BMASK_IBM(27,27)
-#define MQPCB_SOURCE_GID_IDX                    EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_FLOW_LABEL                   EHCA_BMASK_IBM(28,28)
-#define MQPCB_FLOW_LABEL                        EHCA_BMASK_IBM(12,31)
-#define MQPCB_MASK_DEST_GID                     EHCA_BMASK_IBM(30,30)
-#define MQPCB_MASK_SERVICE_LEVEL_AL             EHCA_BMASK_IBM(31,31)
-#define MQPCB_SERVICE_LEVEL_AL                  EHCA_BMASK_IBM(28,31)
-#define MQPCB_MASK_SEND_GRH_FLAG_AL             EHCA_BMASK_IBM(32,32)
-#define MQPCB_SEND_GRH_FLAG_AL                  EHCA_BMASK_IBM(31,31)
-#define MQPCB_MASK_RETRY_COUNT_AL               EHCA_BMASK_IBM(33,33)
-#define MQPCB_RETRY_COUNT_AL                    EHCA_BMASK_IBM(29,31)
-#define MQPCB_MASK_TIMEOUT_AL                   EHCA_BMASK_IBM(34,34)
-#define MQPCB_TIMEOUT_AL                        EHCA_BMASK_IBM(27,31)
-#define MQPCB_MASK_MAX_STATIC_RATE_AL           EHCA_BMASK_IBM(35,35)
-#define MQPCB_MAX_STATIC_RATE_AL                EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_DLID_AL                      EHCA_BMASK_IBM(36,36)
-#define MQPCB_DLID_AL                           EHCA_BMASK_IBM(16,31)
-#define MQPCB_MASK_RNR_RETRY_COUNT_AL           EHCA_BMASK_IBM(37,37)
-#define MQPCB_RNR_RETRY_COUNT_AL                EHCA_BMASK_IBM(29,31)
-#define MQPCB_MASK_SOURCE_PATH_BITS_AL          EHCA_BMASK_IBM(38,38)
-#define MQPCB_SOURCE_PATH_BITS_AL               EHCA_BMASK_IBM(25,31)
-#define MQPCB_MASK_TRAFFIC_CLASS_AL             EHCA_BMASK_IBM(39,39)
-#define MQPCB_TRAFFIC_CLASS_AL                  EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_HOP_LIMIT_AL                 EHCA_BMASK_IBM(40,40)
-#define MQPCB_HOP_LIMIT_AL                      EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_SOURCE_GID_IDX_AL            EHCA_BMASK_IBM(41,41)
-#define MQPCB_SOURCE_GID_IDX_AL                 EHCA_BMASK_IBM(24,31)
-#define MQPCB_MASK_FLOW_LABEL_AL                EHCA_BMASK_IBM(42,42)
-#define MQPCB_FLOW_LABEL_AL                     EHCA_BMASK_IBM(12,31)
-#define MQPCB_MASK_DEST_GID_AL                  EHCA_BMASK_IBM(44,44)
-#define MQPCB_MASK_MAX_NR_OUTST_SEND_WR         EHCA_BMASK_IBM(45,45)
-#define MQPCB_MAX_NR_OUTST_SEND_WR              EHCA_BMASK_IBM(16,31)
-#define MQPCB_MASK_MAX_NR_OUTST_RECV_WR         EHCA_BMASK_IBM(46,46)
-#define MQPCB_MAX_NR_OUTST_RECV_WR              EHCA_BMASK_IBM(16,31)
-#define MQPCB_MASK_DISABLE_ETE_CREDIT_CHECK     EHCA_BMASK_IBM(47,47)
-#define MQPCB_DISABLE_ETE_CREDIT_CHECK          EHCA_BMASK_IBM(31,31)
-#define MQPCB_QP_NUMBER                         EHCA_BMASK_IBM(8,31)
-#define MQPCB_MASK_QP_ENABLE                    EHCA_BMASK_IBM(48,48)
-#define MQPCB_QP_ENABLE                         EHCA_BMASK_IBM(31,31)
-#define MQPCB_MASK_CURR_SRQ_LIMIT               EHCA_BMASK_IBM(49,49)
-#define MQPCB_CURR_SRQ_LIMIT                    EHCA_BMASK_IBM(16,31)
-#define MQPCB_MASK_QP_AFF_ASYN_EV_LOG_REG       EHCA_BMASK_IBM(50,50)
-#define MQPCB_MASK_SHARED_RQ_HNDL               EHCA_BMASK_IBM(51,51)
+#define MQPCB_MASK_QKEY                         EHCA_BMASK_IBM( 0,  0)
+#define MQPCB_MASK_SEND_PSN                     EHCA_BMASK_IBM( 2,  2)
+#define MQPCB_MASK_RECEIVE_PSN                  EHCA_BMASK_IBM( 3,  3)
+#define MQPCB_MASK_PRIM_PHYS_PORT               EHCA_BMASK_IBM( 4,  4)
+#define MQPCB_PRIM_PHYS_PORT                    EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_ALT_PHYS_PORT                EHCA_BMASK_IBM( 5,  5)
+#define MQPCB_MASK_PRIM_P_KEY_IDX               EHCA_BMASK_IBM( 6,  6)
+#define MQPCB_PRIM_P_KEY_IDX                    EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_ALT_P_KEY_IDX                EHCA_BMASK_IBM( 7,  7)
+#define MQPCB_MASK_RDMA_ATOMIC_CTRL             EHCA_BMASK_IBM( 8,  8)
+#define MQPCB_MASK_QP_STATE                     EHCA_BMASK_IBM( 9,  9)
+#define MQPCB_QP_STATE                          EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_RDMA_NR_ATOMIC_RESP_RES      EHCA_BMASK_IBM(11, 11)
+#define MQPCB_MASK_PATH_MIGRATION_STATE         EHCA_BMASK_IBM(12, 12)
+#define MQPCB_MASK_RDMA_ATOMIC_OUTST_DEST_QP    EHCA_BMASK_IBM(13, 13)
+#define MQPCB_MASK_DEST_QP_NR                   EHCA_BMASK_IBM(14, 14)
+#define MQPCB_MASK_MIN_RNR_NAK_TIMER_FIELD      EHCA_BMASK_IBM(15, 15)
+#define MQPCB_MASK_SERVICE_LEVEL                EHCA_BMASK_IBM(16, 16)
+#define MQPCB_MASK_SEND_GRH_FLAG                EHCA_BMASK_IBM(17, 17)
+#define MQPCB_MASK_RETRY_COUNT                  EHCA_BMASK_IBM(18, 18)
+#define MQPCB_MASK_TIMEOUT                      EHCA_BMASK_IBM(19, 19)
+#define MQPCB_MASK_PATH_MTU                     EHCA_BMASK_IBM(20, 20)
+#define MQPCB_PATH_MTU                          EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_MAX_STATIC_RATE              EHCA_BMASK_IBM(21, 21)
+#define MQPCB_MAX_STATIC_RATE                   EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_DLID                         EHCA_BMASK_IBM(22, 22)
+#define MQPCB_DLID                              EHCA_BMASK_IBM(16, 31)
+#define MQPCB_MASK_RNR_RETRY_COUNT              EHCA_BMASK_IBM(23, 23)
+#define MQPCB_RNR_RETRY_COUNT                   EHCA_BMASK_IBM(29, 31)
+#define MQPCB_MASK_SOURCE_PATH_BITS             EHCA_BMASK_IBM(24, 24)
+#define MQPCB_SOURCE_PATH_BITS                  EHCA_BMASK_IBM(25, 31)
+#define MQPCB_MASK_TRAFFIC_CLASS                EHCA_BMASK_IBM(25, 25)
+#define MQPCB_TRAFFIC_CLASS                     EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_HOP_LIMIT                    EHCA_BMASK_IBM(26, 26)
+#define MQPCB_HOP_LIMIT                         EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_SOURCE_GID_IDX               EHCA_BMASK_IBM(27, 27)
+#define MQPCB_SOURCE_GID_IDX                    EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_FLOW_LABEL                   EHCA_BMASK_IBM(28, 28)
+#define MQPCB_FLOW_LABEL                        EHCA_BMASK_IBM(12, 31)
+#define MQPCB_MASK_DEST_GID                     EHCA_BMASK_IBM(30, 30)
+#define MQPCB_MASK_SERVICE_LEVEL_AL             EHCA_BMASK_IBM(31, 31)
+#define MQPCB_SERVICE_LEVEL_AL                  EHCA_BMASK_IBM(28, 31)
+#define MQPCB_MASK_SEND_GRH_FLAG_AL             EHCA_BMASK_IBM(32, 32)
+#define MQPCB_SEND_GRH_FLAG_AL                  EHCA_BMASK_IBM(31, 31)
+#define MQPCB_MASK_RETRY_COUNT_AL               EHCA_BMASK_IBM(33, 33)
+#define MQPCB_RETRY_COUNT_AL                    EHCA_BMASK_IBM(29, 31)
+#define MQPCB_MASK_TIMEOUT_AL                   EHCA_BMASK_IBM(34, 34)
+#define MQPCB_TIMEOUT_AL                        EHCA_BMASK_IBM(27, 31)
+#define MQPCB_MASK_MAX_STATIC_RATE_AL           EHCA_BMASK_IBM(35, 35)
+#define MQPCB_MAX_STATIC_RATE_AL                EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_DLID_AL                      EHCA_BMASK_IBM(36, 36)
+#define MQPCB_DLID_AL                           EHCA_BMASK_IBM(16, 31)
+#define MQPCB_MASK_RNR_RETRY_COUNT_AL           EHCA_BMASK_IBM(37, 37)
+#define MQPCB_RNR_RETRY_COUNT_AL                EHCA_BMASK_IBM(29, 31)
+#define MQPCB_MASK_SOURCE_PATH_BITS_AL          EHCA_BMASK_IBM(38, 38)
+#define MQPCB_SOURCE_PATH_BITS_AL               EHCA_BMASK_IBM(25, 31)
+#define MQPCB_MASK_TRAFFIC_CLASS_AL             EHCA_BMASK_IBM(39, 39)
+#define MQPCB_TRAFFIC_CLASS_AL                  EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_HOP_LIMIT_AL                 EHCA_BMASK_IBM(40, 40)
+#define MQPCB_HOP_LIMIT_AL                      EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_SOURCE_GID_IDX_AL            EHCA_BMASK_IBM(41, 41)
+#define MQPCB_SOURCE_GID_IDX_AL                 EHCA_BMASK_IBM(24, 31)
+#define MQPCB_MASK_FLOW_LABEL_AL                EHCA_BMASK_IBM(42, 42)
+#define MQPCB_FLOW_LABEL_AL                     EHCA_BMASK_IBM(12, 31)
+#define MQPCB_MASK_DEST_GID_AL                  EHCA_BMASK_IBM(44, 44)
+#define MQPCB_MASK_MAX_NR_OUTST_SEND_WR         EHCA_BMASK_IBM(45, 45)
+#define MQPCB_MAX_NR_OUTST_SEND_WR              EHCA_BMASK_IBM(16, 31)
+#define MQPCB_MASK_MAX_NR_OUTST_RECV_WR         EHCA_BMASK_IBM(46, 46)
+#define MQPCB_MAX_NR_OUTST_RECV_WR              EHCA_BMASK_IBM(16, 31)
+#define MQPCB_MASK_DISABLE_ETE_CREDIT_CHECK     EHCA_BMASK_IBM(47, 47)
+#define MQPCB_DISABLE_ETE_CREDIT_CHECK          EHCA_BMASK_IBM(31, 31)
+#define MQPCB_QP_NUMBER                         EHCA_BMASK_IBM( 8, 31)
+#define MQPCB_MASK_QP_ENABLE                    EHCA_BMASK_IBM(48, 48)
+#define MQPCB_QP_ENABLE                         EHCA_BMASK_IBM(31, 31)
+#define MQPCB_MASK_CURR_SRQ_LIMIT               EHCA_BMASK_IBM(49, 49)
+#define MQPCB_CURR_SRQ_LIMIT                    EHCA_BMASK_IBM(16, 31)
+#define MQPCB_MASK_QP_AFF_ASYN_EV_LOG_REG       EHCA_BMASK_IBM(50, 50)
+#define MQPCB_MASK_SHARED_RQ_HNDL               EHCA_BMASK_IBM(51, 51)
 
 #endif /* __EHCA_CLASSES_PSERIES_H__ */
diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index 97da51e..ba1bcb9 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -97,7 +97,7 @@ int ehca_cq_unassign_qp(struct ehca_cq *cq, unsigned int real_qp_num)
 	return ret;
 }
 
-struct ehca_qp* ehca_cq_get_qp(struct ehca_cq *cq, int real_qp_num)
+struct ehca_qp *ehca_cq_get_qp(struct ehca_cq *cq, int real_qp_num)
 {
 	struct ehca_qp *ret = NULL;
 	unsigned int key = real_qp_num & (QP_HASHTAB_LEN-1);
diff --git a/drivers/infiniband/hw/ehca/ehca_eq.c b/drivers/infiniband/hw/ehca/ehca_eq.c
index d443bcb..78a2e5a 100644
--- a/drivers/infiniband/hw/ehca/ehca_eq.c
+++ b/drivers/infiniband/hw/ehca/ehca_eq.c
@@ -111,7 +111,8 @@ struct ehca_eq *ehca_create_eq(struct ehca_shca *shca,
 	for (i = 0; i < nr_pages; i++) {
 		u64 rpage;
 
-		if (!(vpage = ipz_qpageit_get_inc(&eq->ipz_queue))) {
+		vpage = ipz_qpageit_get_inc(&eq->ipz_queue);
+		if (!vpage) {
 			ret = -ENOMEM;
 			goto create_eq_exit2;
 		}
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index bbd3c6a..fc19ef9 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -127,6 +127,7 @@ int ehca_query_port(struct ib_device *ibdev,
 		    u8 port, struct ib_port_attr *props)
 {
 	int ret = 0;
+	u64 h_ret;
 	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca,
 					      ib_device);
 	struct hipz_query_port *rblock;
@@ -137,7 +138,8 @@ int ehca_query_port(struct ib_device *ibdev,
 		return -ENOMEM;
 	}
 
-	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+	h_ret = hipz_h_query_port(shca->ipz_hca_handle, port, rblock);
+	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't query port properties");
 		ret = -EINVAL;
 		goto query_port1;
@@ -197,6 +199,7 @@ int ehca_query_sma_attr(struct ehca_shca *shca,
 			u8 port, struct ehca_sma_attr *attr)
 {
 	int ret = 0;
+	u64 h_ret;
 	struct hipz_query_port *rblock;
 
 	rblock = ehca_alloc_fw_ctrlblock(GFP_ATOMIC);
@@ -205,7 +208,8 @@ int ehca_query_sma_attr(struct ehca_shca *shca,
 		return -ENOMEM;
 	}
 
-	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+	h_ret = hipz_h_query_port(shca->ipz_hca_handle, port, rblock);
+	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't query port properties");
 		ret = -EINVAL;
 		goto query_sma_attr1;
@@ -230,9 +234,11 @@ query_sma_attr1:
 int ehca_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 {
 	int ret = 0;
-	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca, ib_device);
+	u64 h_ret;
+	struct ehca_shca *shca;
 	struct hipz_query_port *rblock;
 
+	shca = container_of(ibdev, struct ehca_shca, ib_device);
 	if (index > 16) {
 		ehca_err(&shca->ib_device, "Invalid index: %x.", index);
 		return -EINVAL;
@@ -244,7 +250,8 @@ int ehca_query_pkey(struct ib_device *ibdev, u8 port, u16 index, u16 *pkey)
 		return -ENOMEM;
 	}
 
-	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+	h_ret = hipz_h_query_port(shca->ipz_hca_handle, port, rblock);
+	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't query port properties");
 		ret = -EINVAL;
 		goto query_pkey1;
@@ -262,6 +269,7 @@ int ehca_query_gid(struct ib_device *ibdev, u8 port,
 		   int index, union ib_gid *gid)
 {
 	int ret = 0;
+	u64 h_ret;
 	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca,
 					      ib_device);
 	struct hipz_query_port *rblock;
@@ -277,7 +285,8 @@ int ehca_query_gid(struct ib_device *ibdev, u8 port,
 		return -ENOMEM;
 	}
 
-	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+	h_ret = hipz_h_query_port(shca->ipz_hca_handle, port, rblock);
+	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't query port properties");
 		ret = -EINVAL;
 		goto query_gid1;
@@ -302,11 +311,12 @@ int ehca_modify_port(struct ib_device *ibdev,
 		     struct ib_port_modify *props)
 {
 	int ret = 0;
-	struct ehca_shca *shca = container_of(ibdev, struct ehca_shca, ib_device);
+	struct ehca_shca *shca;
 	struct hipz_query_port *rblock;
 	u32 cap;
 	u64 hret;
 
+	shca = container_of(ibdev, struct ehca_shca, ib_device);
 	if ((props->set_port_cap_mask | props->clr_port_cap_mask)
 	    & ~allowed_port_caps) {
 		ehca_err(&shca->ib_device, "Non-changeable bits set in masks  "
@@ -325,7 +335,8 @@ int ehca_modify_port(struct ib_device *ibdev,
 		goto modify_port1;
 	}
 
-	if (hipz_h_query_port(shca->ipz_hca_handle, port, rblock) != H_SUCCESS) {
+	hret = hipz_h_query_port(shca->ipz_hca_handle, port, rblock);
+	if (hret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "Can't query port properties");
 		ret = -EINVAL;
 		goto modify_port2;
@@ -337,7 +348,8 @@ int ehca_modify_port(struct ib_device *ibdev,
 	hret = hipz_h_modify_port(shca->ipz_hca_handle, port,
 				  cap, props->init_type, port_modify_mask);
 	if (hret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "Modify port failed  hret=%lx", hret);
+		ehca_err(&shca->ib_device, "Modify port failed  hret=%lx",
+			 hret);
 		ret = -EINVAL;
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 7a4071a..1f043d0 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -49,26 +49,26 @@
 #include "hipz_fns.h"
 #include "ipz_pt_fn.h"
 
-#define EQE_COMPLETION_EVENT   EHCA_BMASK_IBM(1,1)
-#define EQE_CQ_QP_NUMBER       EHCA_BMASK_IBM(8,31)
-#define EQE_EE_IDENTIFIER      EHCA_BMASK_IBM(2,7)
-#define EQE_CQ_NUMBER          EHCA_BMASK_IBM(8,31)
-#define EQE_QP_NUMBER          EHCA_BMASK_IBM(8,31)
-#define EQE_QP_TOKEN           EHCA_BMASK_IBM(32,63)
-#define EQE_CQ_TOKEN           EHCA_BMASK_IBM(32,63)
-
-#define NEQE_COMPLETION_EVENT  EHCA_BMASK_IBM(1,1)
-#define NEQE_EVENT_CODE        EHCA_BMASK_IBM(2,7)
-#define NEQE_PORT_NUMBER       EHCA_BMASK_IBM(8,15)
-#define NEQE_PORT_AVAILABILITY EHCA_BMASK_IBM(16,16)
-#define NEQE_DISRUPTIVE        EHCA_BMASK_IBM(16,16)
-
-#define ERROR_DATA_LENGTH      EHCA_BMASK_IBM(52,63)
-#define ERROR_DATA_TYPE        EHCA_BMASK_IBM(0,7)
+#define EQE_COMPLETION_EVENT   EHCA_BMASK_IBM( 1,  1)
+#define EQE_CQ_QP_NUMBER       EHCA_BMASK_IBM( 8, 31)
+#define EQE_EE_IDENTIFIER      EHCA_BMASK_IBM( 2,  7)
+#define EQE_CQ_NUMBER          EHCA_BMASK_IBM( 8, 31)
+#define EQE_QP_NUMBER          EHCA_BMASK_IBM( 8, 31)
+#define EQE_QP_TOKEN           EHCA_BMASK_IBM(32, 63)
+#define EQE_CQ_TOKEN           EHCA_BMASK_IBM(32, 63)
+
+#define NEQE_COMPLETION_EVENT  EHCA_BMASK_IBM( 1,  1)
+#define NEQE_EVENT_CODE        EHCA_BMASK_IBM( 2,  7)
+#define NEQE_PORT_NUMBER       EHCA_BMASK_IBM( 8, 15)
+#define NEQE_PORT_AVAILABILITY EHCA_BMASK_IBM(16, 16)
+#define NEQE_DISRUPTIVE        EHCA_BMASK_IBM(16, 16)
+
+#define ERROR_DATA_LENGTH      EHCA_BMASK_IBM(52, 63)
+#define ERROR_DATA_TYPE        EHCA_BMASK_IBM( 0,  7)
 
 static void queue_comp_task(struct ehca_cq *__cq);
 
-static struct ehca_comp_pool* pool;
+static struct ehca_comp_pool *pool;
 #ifdef CONFIG_HOTPLUG_CPU
 static struct notifier_block comp_pool_callback_nb;
 #endif
@@ -85,8 +85,8 @@ static inline void comp_event_callback(struct ehca_cq *cq)
 	return;
 }
 
-static void print_error_data(struct ehca_shca * shca, void* data,
-			     u64* rblock, int length)
+static void print_error_data(struct ehca_shca *shca, void *data,
+			     u64 *rblock, int length)
 {
 	u64 type = EHCA_BMASK_GET(ERROR_DATA_TYPE, rblock[2]);
 	u64 resource = rblock[1];
@@ -94,7 +94,7 @@ static void print_error_data(struct ehca_shca * shca, void* data,
 	switch (type) {
 	case 0x1: /* Queue Pair */
 	{
-		struct ehca_qp *qp = (struct ehca_qp*)data;
+		struct ehca_qp *qp = (struct ehca_qp *)data;
 
 		/* only print error data if AER is set */
 		if (rblock[6] == 0)
@@ -107,7 +107,7 @@ static void print_error_data(struct ehca_shca * shca, void* data,
 	}
 	case 0x4: /* Completion Queue */
 	{
-		struct ehca_cq *cq = (struct ehca_cq*)data;
+		struct ehca_cq *cq = (struct ehca_cq *)data;
 
 		ehca_err(&shca->ib_device,
 			 "CQ 0x%x (resource=%lx) has errors.",
@@ -564,7 +564,7 @@ void ehca_tasklet_eq(unsigned long data)
 	ehca_process_eq((struct ehca_eq *)data, 1);
 }
 
-static inline int find_next_online_cpu(struct ehca_comp_pool* pool)
+static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 {
 	int cpu;
 	unsigned long flags;
@@ -628,7 +628,7 @@ static void queue_comp_task(struct ehca_cq *__cq)
 	__queue_comp_task(__cq, cct);
 }
 
-static void run_comp_task(struct ehca_cpu_comp_task* cct)
+static void run_comp_task(struct ehca_cpu_comp_task *cct)
 {
 	struct ehca_cq *cq;
 	unsigned long flags;
@@ -658,12 +658,12 @@ static void run_comp_task(struct ehca_cpu_comp_task* cct)
 
 static int comp_task(void *__cct)
 {
-	struct ehca_cpu_comp_task* cct = __cct;
+	struct ehca_cpu_comp_task *cct = __cct;
 	int cql_empty;
 	DECLARE_WAITQUEUE(wait, current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while(!kthread_should_stop()) {
+	while (!kthread_should_stop()) {
 		add_wait_queue(&cct->wait_queue, &wait);
 
 		spin_lock_irq(&cct->task_lock);
@@ -737,7 +737,7 @@ static void take_over_work(struct ehca_comp_pool *pool,
 
 	list_splice_init(&cct->cq_list, &list);
 
-	while(!list_empty(&list)) {
+	while (!list_empty(&list)) {
 		cq = list_entry(cct->cq_list.next, struct ehca_cq, entry);
 
 		list_del(&cq->entry);
@@ -760,7 +760,7 @@ static int comp_pool_callback(struct notifier_block *nfb,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		ehca_gen_dbg("CPU: %x (CPU_PREPARE)", cpu);
-		if(!create_comp_task(pool, cpu)) {
+		if (!create_comp_task(pool, cpu)) {
 			ehca_gen_err("Can't create comp_task for cpu: %x", cpu);
 			return NOTIFY_BAD;
 		}
@@ -830,7 +830,7 @@ int ehca_create_comp_pool(void)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	comp_pool_callback_nb.notifier_call = comp_pool_callback;
-	comp_pool_callback_nb.priority =0;
+	comp_pool_callback_nb.priority = 0;
 	register_cpu_notifier(&comp_pool_callback_nb);
 #endif
 
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index bf8fbf7..99881e3 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -81,8 +81,9 @@ struct ib_mr *ehca_reg_phys_mr(struct ib_pd *pd,
 			       int num_phys_buf,
 			       int mr_access_flags, u64 *iova_start);
 
-struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt,
-			       int mr_access_flags, struct ib_udata *udata);
+struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			       u64 virt, int mr_access_flags,
+			       struct ib_udata *udata);
 
 int ehca_rereg_phys_mr(struct ib_mr *mr,
 		       int mr_rereg_mask,
@@ -191,7 +192,7 @@ void ehca_poll_eqs(unsigned long data);
 void *ehca_alloc_fw_ctrlblock(gfp_t flags);
 void ehca_free_fw_ctrlblock(void *ptr);
 #else
-#define ehca_alloc_fw_ctrlblock(flags) ((void *) get_zeroed_page(flags))
+#define ehca_alloc_fw_ctrlblock(flags) ((void *)get_zeroed_page(flags))
 #define ehca_free_fw_ctrlblock(ptr) free_page((unsigned long)(ptr))
 #endif
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 57c551e..ecf4ef4 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -116,7 +116,7 @@ static DEFINE_SPINLOCK(shca_list_lock);
 static struct timer_list poll_eqs_timer;
 
 #ifdef CONFIG_PPC_64K_PAGES
-static struct kmem_cache *ctblk_cache = NULL;
+static struct kmem_cache *ctblk_cache;
 
 void *ehca_alloc_fw_ctrlblock(gfp_t flags)
 {
@@ -219,8 +219,8 @@ static void ehca_destroy_slab_caches(void)
 #endif
 }
 
-#define EHCA_HCAAVER  EHCA_BMASK_IBM(32,39)
-#define EHCA_REVID    EHCA_BMASK_IBM(40,63)
+#define EHCA_HCAAVER  EHCA_BMASK_IBM(32, 39)
+#define EHCA_REVID    EHCA_BMASK_IBM(40, 63)
 
 static struct cap_descr {
 	u64 mask;
@@ -314,7 +314,7 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 		if (EHCA_BMASK_GET(hca_cap_descr[i].mask, shca->hca_cap))
 			ehca_gen_dbg("   %s", hca_cap_descr[i].descr);
 
-	port = (struct hipz_query_port *) rblock;
+	port = (struct hipz_query_port *)rblock;
 	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
 	if (h_ret != H_SUCCESS) {
 		ehca_gen_err("Cannot query port properties. h_ret=%lx",
@@ -463,7 +463,7 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 		return -EPERM;
 	}
 
-	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void*)(-1), 10, 0);
+	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void *)(-1), 10, 0);
 	if (IS_ERR(ibcq)) {
 		ehca_err(&shca->ib_device, "Cannot create AQP1 CQ.");
 		return PTR_ERR(ibcq);
@@ -730,7 +730,7 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 	}
 
 	/* create internal protection domain */
-	ibpd = ehca_alloc_pd(&shca->ib_device, (void*)(-1), NULL);
+	ibpd = ehca_alloc_pd(&shca->ib_device, (void *)(-1), NULL);
 	if (IS_ERR(ibpd)) {
 		ehca_err(&shca->ib_device, "Cannot create internal PD.");
 		ret = PTR_ERR(ibpd);
@@ -944,18 +944,21 @@ int __init ehca_module_init(void)
 		return -EINVAL;
 	}
 
-	if ((ret = ehca_create_comp_pool())) {
+	ret = ehca_create_comp_pool();
+	if (ret) {
 		ehca_gen_err("Cannot create comp pool.");
 		return ret;
 	}
 
-	if ((ret = ehca_create_slab_caches())) {
+	ret = ehca_create_slab_caches();
+	if (ret) {
 		ehca_gen_err("Cannot create SLAB caches");
 		ret = -ENOMEM;
 		goto module_init1;
 	}
 
-	if ((ret = ibmebus_register_driver(&ehca_driver))) {
+	ret = ibmebus_register_driver(&ehca_driver);
+	if (ret) {
 		ehca_gen_err("Cannot register eHCA device driver");
 		ret = -EINVAL;
 		goto module_init2;
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index 93c26cc..6262c54 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -61,9 +61,9 @@ static struct ehca_mr *ehca_mr_new(void)
 	struct ehca_mr *me;
 
 	me = kmem_cache_zalloc(mr_cache, GFP_KERNEL);
-	if (me) {
+	if (me)
 		spin_lock_init(&me->mrlock);
-	} else
+	else
 		ehca_gen_err("alloc failed");
 
 	return me;
@@ -79,9 +79,9 @@ static struct ehca_mw *ehca_mw_new(void)
 	struct ehca_mw *me;
 
 	me = kmem_cache_zalloc(mw_cache, GFP_KERNEL);
-	if (me) {
+	if (me)
 		spin_lock_init(&me->mwlock);
-	} else
+	else
 		ehca_gen_err("alloc failed");
 
 	return me;
@@ -111,7 +111,7 @@ struct ib_mr *ehca_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 			goto get_dma_mr_exit0;
 		}
 
-		ret = ehca_reg_maxmr(shca, e_maxmr, (u64*)KERNELBASE,
+		ret = ehca_reg_maxmr(shca, e_maxmr, (u64 *)KERNELBASE,
 				     mr_access_flags, e_pd,
 				     &e_maxmr->ib.ib_mr.lkey,
 				     &e_maxmr->ib.ib_mr.rkey);
@@ -246,8 +246,9 @@ reg_phys_mr_exit0:
 
 /*----------------------------------------------------------------------*/
 
-struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt,
-			       int mr_access_flags, struct ib_udata *udata)
+struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
+			       u64 virt, int mr_access_flags,
+			       struct ib_udata *udata)
 {
 	struct ib_mr *ib_mr;
 	struct ehca_mr *e_mr;
@@ -295,7 +296,7 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt
 	e_mr->umem = ib_umem_get(pd->uobject->context, start, length,
 				 mr_access_flags);
 	if (IS_ERR(e_mr->umem)) {
-		ib_mr = (void *) e_mr->umem;
+		ib_mr = (void *)e_mr->umem;
 		goto reg_user_mr_exit1;
 	}
 
@@ -322,8 +323,9 @@ struct ib_mr *ehca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length, u64 virt
 						     (&e_mr->umem->chunk_list),
 						     list);
 
-	ret = ehca_reg_mr(shca, e_mr, (u64*) virt, length, mr_access_flags, e_pd,
-			  &pginfo, &e_mr->ib.ib_mr.lkey, &e_mr->ib.ib_mr.rkey);
+	ret = ehca_reg_mr(shca, e_mr, (u64 *)virt, length, mr_access_flags,
+			  e_pd, &pginfo, &e_mr->ib.ib_mr.lkey,
+			  &e_mr->ib.ib_mr.rkey);
 	if (ret) {
 		ib_mr = ERR_PTR(ret);
 		goto reg_user_mr_exit2;
@@ -420,7 +422,7 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 			goto rereg_phys_mr_exit0;
 		}
 		if (!phys_buf_array || num_phys_buf <= 0) {
-			ehca_err(mr->device, "bad input values: mr_rereg_mask=%x"
+			ehca_err(mr->device, "bad input values mr_rereg_mask=%x"
 				 " phys_buf_array=%p num_phys_buf=%x",
 				 mr_rereg_mask, phys_buf_array, num_phys_buf);
 			ret = -EINVAL;
@@ -444,10 +446,10 @@ int ehca_rereg_phys_mr(struct ib_mr *mr,
 
 	/* set requested values dependent on rereg request */
 	spin_lock_irqsave(&e_mr->mrlock, sl_flags);
-	new_start = e_mr->start;  /* new == old address */
-	new_size  = e_mr->size;	  /* new == old length */
-	new_acl   = e_mr->acl;	  /* new == old access control */
-	new_pd    = container_of(mr->pd,struct ehca_pd,ib_pd); /*new == old PD*/
+	new_start = e_mr->start;
+	new_size = e_mr->size;
+	new_acl = e_mr->acl;
+	new_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
 
 	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
 		new_start = iova_start;	/* change address */
@@ -517,7 +519,7 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 	struct ehca_pd *my_pd = container_of(mr->pd, struct ehca_pd, ib_pd);
 	u32 cur_pid = current->tgid;
 	unsigned long sl_flags;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
 	    (my_pd->ownpid != cur_pid)) {
@@ -629,7 +631,7 @@ struct ib_mw *ehca_alloc_mw(struct ib_pd *pd)
 	struct ehca_pd *e_pd = container_of(pd, struct ehca_pd, ib_pd);
 	struct ehca_shca *shca =
 		container_of(pd->device, struct ehca_shca, ib_device);
-	struct ehca_mw_hipzout_parms hipzout = {{0},0};
+	struct ehca_mw_hipzout_parms hipzout;
 
 	e_mw = ehca_mw_new();
 	if (!e_mw) {
@@ -826,7 +828,7 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 			      EHCA_PAGESIZE);
 	pginfo.u.fmr.fmr_pgsize = e_fmr->fmr_page_size;
 
-	ret = ehca_rereg_mr(shca, e_fmr, (u64*)iova,
+	ret = ehca_rereg_mr(shca, e_fmr, (u64 *)iova,
 			    list_len * e_fmr->fmr_page_size,
 			    e_fmr->acl, e_pd, &pginfo, &tmp_lkey, &tmp_rkey);
 	if (ret)
@@ -841,8 +843,7 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 map_phys_fmr_exit0:
 	if (ret)
 		ehca_err(fmr->device, "ret=%x fmr=%p page_list=%p list_len=%x "
-			 "iova=%lx",
-			 ret, fmr, page_list, list_len, iova);
+			 "iova=%lx", ret, fmr, page_list, list_len, iova);
 	return ret;
 } /* end ehca_map_phys_fmr() */
 
@@ -960,12 +961,12 @@ int ehca_reg_mr(struct ehca_shca *shca,
 	int ret;
 	u64 h_ret;
 	u32 hipz_acl;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
 	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
 	if (ehca_use_hp_mr == 1)
-	        hipz_acl |= 0x00000001;
+		hipz_acl |= 0x00000001;
 
 	h_ret = hipz_h_alloc_resource_mr(shca->ipz_hca_handle, e_mr,
 					 (u64)iova_start, size, hipz_acl,
@@ -1127,7 +1128,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 	u64 *kpage;
 	u64 rpage;
 	struct ehca_mr_pginfo pginfo_save;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
 	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
@@ -1167,7 +1168,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 			  "(Rereg1), h_ret=%lx e_mr=%p", h_ret, e_mr);
 		*pginfo = pginfo_save;
 		ret = -EAGAIN;
-	} else if ((u64*)hipzout.vaddr != iova_start) {
+	} else if ((u64 *)hipzout.vaddr != iova_start) {
 		ehca_err(&shca->ib_device, "PHYP changed iova_start in "
 			 "rereg_pmr, iova_start=%p iova_start_out=%lx e_mr=%p "
 			 "mr_handle=%lx lkey=%x lkey_out=%x", iova_start,
@@ -1305,7 +1306,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 	struct ehca_mr save_fmr;
 	u32 tmp_lkey, tmp_rkey;
 	struct ehca_mr_pginfo pginfo;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 	struct ehca_mr save_mr;
 
 	if (e_fmr->fmr_max_pages <= MAX_RPAGES) {
@@ -1397,7 +1398,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 	int ret = 0;
 	u64 h_ret;
 	u32 hipz_acl;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
 	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
@@ -1462,7 +1463,7 @@ int ehca_reg_internal_maxmr(
 
 	/* register internal max-MR on HCA */
 	size_maxmr = (u64)high_memory - PAGE_OFFSET;
-	iova_start = (u64*)KERNELBASE;
+	iova_start = (u64 *)KERNELBASE;
 	ib_pbuf.addr = 0;
 	ib_pbuf.size = size_maxmr;
 	num_kpages = NUM_CHUNKS(((u64)iova_start % PAGE_SIZE) + size_maxmr,
@@ -1519,7 +1520,7 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 	u64 h_ret;
 	struct ehca_mr *e_origmr = shca->maxmr;
 	u32 hipz_acl;
-	struct ehca_mr_hipzout_parms hipzout = {{0},0,0,0,0,0};
+	struct ehca_mr_hipzout_parms hipzout;
 
 	ehca_mrmw_map_acl(acl, &hipz_acl);
 	ehca_mrmw_set_pgsize_hipz_acl(&hipz_acl);
@@ -1865,7 +1866,7 @@ int ehca_mr_is_maxmr(u64 size,
 {
 	/* a MR is treated as max-MR only if it fits following: */
 	if ((size == ((u64)high_memory - PAGE_OFFSET)) &&
-	    (iova_start == (void*)KERNELBASE)) {
+	    (iova_start == (void *)KERNELBASE)) {
 		ehca_gen_dbg("this is a max-MR");
 		return 1;
 	} else
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.h b/drivers/infiniband/hw/ehca/ehca_mrmw.h
index fb69ede..24f13fe 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.h
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.h
@@ -101,15 +101,10 @@ int ehca_fmr_check_page_list(struct ehca_mr *e_fmr,
 			     u64 *page_list,
 			     int list_len);
 
-int ehca_set_pagebuf(struct ehca_mr *e_mr,
-		     struct ehca_mr_pginfo *pginfo,
+int ehca_set_pagebuf(struct ehca_mr_pginfo *pginfo,
 		     u32 number,
 		     u64 *kpage);
 
-int ehca_set_pagebuf_1(struct ehca_mr *e_mr,
-		       struct ehca_mr_pginfo *pginfo,
-		       u64 *rpage);
-
 int ehca_mr_is_maxmr(u64 size,
 		     u64 *iova_start);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_qes.h b/drivers/infiniband/hw/ehca/ehca_qes.h
index 8707d29..8188030 100644
--- a/drivers/infiniband/hw/ehca/ehca_qes.h
+++ b/drivers/infiniband/hw/ehca/ehca_qes.h
@@ -53,13 +53,13 @@ struct ehca_vsgentry {
 	u32 length;
 };
 
-#define GRH_FLAG_MASK        EHCA_BMASK_IBM(7,7)
-#define GRH_IPVERSION_MASK   EHCA_BMASK_IBM(0,3)
-#define GRH_TCLASS_MASK      EHCA_BMASK_IBM(4,12)
-#define GRH_FLOWLABEL_MASK   EHCA_BMASK_IBM(13,31)
-#define GRH_PAYLEN_MASK      EHCA_BMASK_IBM(32,47)
-#define GRH_NEXTHEADER_MASK  EHCA_BMASK_IBM(48,55)
-#define GRH_HOPLIMIT_MASK    EHCA_BMASK_IBM(56,63)
+#define GRH_FLAG_MASK        EHCA_BMASK_IBM( 7,  7)
+#define GRH_IPVERSION_MASK   EHCA_BMASK_IBM( 0,  3)
+#define GRH_TCLASS_MASK      EHCA_BMASK_IBM( 4, 12)
+#define GRH_FLOWLABEL_MASK   EHCA_BMASK_IBM(13, 31)
+#define GRH_PAYLEN_MASK      EHCA_BMASK_IBM(32, 47)
+#define GRH_NEXTHEADER_MASK  EHCA_BMASK_IBM(48, 55)
+#define GRH_HOPLIMIT_MASK    EHCA_BMASK_IBM(56, 63)
 
 /*
  * Unreliable Datagram Address Vector Format
@@ -206,10 +206,10 @@ struct ehca_wqe {
 
 };
 
-#define WC_SEND_RECEIVE EHCA_BMASK_IBM(0,0)
-#define WC_IMM_DATA     EHCA_BMASK_IBM(1,1)
-#define WC_GRH_PRESENT  EHCA_BMASK_IBM(2,2)
-#define WC_SE_BIT       EHCA_BMASK_IBM(3,3)
+#define WC_SEND_RECEIVE EHCA_BMASK_IBM(0, 0)
+#define WC_IMM_DATA     EHCA_BMASK_IBM(1, 1)
+#define WC_GRH_PRESENT  EHCA_BMASK_IBM(2, 2)
+#define WC_SE_BIT       EHCA_BMASK_IBM(3, 3)
 #define WC_STATUS_ERROR_BIT 0x80000000
 #define WC_STATUS_REMOTE_ERROR_FLAGS 0x0000F800
 #define WC_STATUS_PURGE_BIT 0x10
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index f6f4ef6..3bd13e1 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -602,10 +602,10 @@ struct ehca_qp *internal_create_qp(struct ib_pd *pd,
 			/* UD circumvention */
 			parms.act_nr_send_sges -= 2;
 			parms.act_nr_recv_sges -= 2;
-			swqe_size = offsetof(struct ehca_wqe,
-					     u.ud_av.sg_list[parms.act_nr_send_sges]);
-			rwqe_size = offsetof(struct ehca_wqe,
-					     u.ud_av.sg_list[parms.act_nr_recv_sges]);
+			swqe_size = offsetof(struct ehca_wqe, u.ud_av.sg_list[
+						     parms.act_nr_send_sges]);
+			rwqe_size = offsetof(struct ehca_wqe, u.ud_av.sg_list[
+						     parms.act_nr_recv_sges]);
 		}
 
 		if (IB_QPT_GSI == qp_type || IB_QPT_SMI == qp_type) {
@@ -690,8 +690,8 @@ struct ehca_qp *internal_create_qp(struct ib_pd *pd,
 	if (my_qp->send_cq) {
 		ret = ehca_cq_assign_qp(my_qp->send_cq, my_qp);
 		if (ret) {
-			ehca_err(pd->device, "Couldn't assign qp to send_cq ret=%x",
-				 ret);
+			ehca_err(pd->device,
+				 "Couldn't assign qp to send_cq ret=%x", ret);
 			goto create_qp_exit4;
 		}
 	}
@@ -749,7 +749,7 @@ struct ib_qp *ehca_create_qp(struct ib_pd *pd,
 	struct ehca_qp *ret;
 
 	ret = internal_create_qp(pd, qp_init_attr, NULL, udata, 0);
-	return IS_ERR(ret) ? (struct ib_qp *) ret : &ret->ib_qp;
+	return IS_ERR(ret) ? (struct ib_qp *)ret : &ret->ib_qp;
 }
 
 int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
@@ -780,7 +780,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 
 	my_qp = internal_create_qp(pd, &qp_init_attr, srq_init_attr, udata, 1);
 	if (IS_ERR(my_qp))
-		return (struct ib_srq *) my_qp;
+		return (struct ib_srq *)my_qp;
 
 	/* copy back return values */
 	srq_init_attr->attr.max_wr = qp_init_attr.cap.max_recv_wr;
@@ -875,7 +875,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 			 my_qp, qp_num, h_ret);
 		return ehca2ib_return_code(h_ret);
 	}
-	bad_send_wqe_p = (void*)((u64)bad_send_wqe_p & (~(1L<<63)));
+	bad_send_wqe_p = (void *)((u64)bad_send_wqe_p & (~(1L << 63)));
 	ehca_dbg(&shca->ib_device, "qp_num=%x bad_send_wqe_p=%p",
 		 qp_num, bad_send_wqe_p);
 	/* convert wqe pointer to vadr */
@@ -890,7 +890,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 	}
 
 	/* loop sets wqe's purge bit */
-	wqe = (struct ehca_wqe*)ipz_qeit_calc(squeue, q_ofs);
+	wqe = (struct ehca_wqe *)ipz_qeit_calc(squeue, q_ofs);
 	*bad_wqe_cnt = 0;
 	while (wqe->optype != 0xff && wqe->wqef != 0xff) {
 		if (ehca_debug_level)
@@ -898,7 +898,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 		wqe->nr_of_data_seg = 0; /* suppress data access */
 		wqe->wqef = WQEF_PURGE; /* WQE to be purged */
 		q_ofs = ipz_queue_advance_offset(squeue, q_ofs);
-		wqe = (struct ehca_wqe*)ipz_qeit_calc(squeue, q_ofs);
+		wqe = (struct ehca_wqe *)ipz_qeit_calc(squeue, q_ofs);
 		*bad_wqe_cnt = (*bad_wqe_cnt)+1;
 	}
 	/*
@@ -1003,7 +1003,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		goto modify_qp_exit1;
 	}
 
-	ehca_dbg(ibqp->device,"ehca_qp=%p qp_num=%x current qp_state=%x "
+	ehca_dbg(ibqp->device, "ehca_qp=%p qp_num=%x current qp_state=%x "
 		 "new qp_state=%x attribute_mask=%x",
 		 my_qp, ibqp->qp_num, qp_cur_state, attr->qp_state, attr_mask);
 
@@ -1019,7 +1019,8 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		goto modify_qp_exit1;
 	}
 
-	if ((mqpcb->qp_state = ib2ehca_qp_state(qp_new_state)))
+	mqpcb->qp_state = ib2ehca_qp_state(qp_new_state);
+	if (mqpcb->qp_state)
 		update_mask = EHCA_BMASK_SET(MQPCB_MASK_QP_STATE, 1);
 	else {
 		ret = -EINVAL;
@@ -1077,7 +1078,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			spin_lock_irqsave(&my_qp->spinlock_s, flags);
 			squeue_locked = 1;
 			/* mark next free wqe */
-			wqe = (struct ehca_wqe*)
+			wqe = (struct ehca_wqe *)
 				ipz_qeit_get(&my_qp->ipz_squeue);
 			wqe->optype = wqe->wqef = 0xff;
 			ehca_dbg(ibqp->device, "qp_num=%x next_free_wqe=%p",
@@ -1312,7 +1313,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
 		ehca_err(ibqp->device, "hipz_h_modify_qp() failed rc=%lx "
-			 "ehca_qp=%p qp_num=%x",h_ret, my_qp, ibqp->qp_num);
+			 "ehca_qp=%p qp_num=%x", h_ret, my_qp, ibqp->qp_num);
 		goto modify_qp_exit2;
 	}
 
@@ -1411,7 +1412,7 @@ int ehca_query_qp(struct ib_qp *qp,
 	}
 
 	if (qp_attr_mask & QP_ATTR_QUERY_NOT_SUPPORTED) {
-		ehca_err(qp->device,"Invalid attribute mask "
+		ehca_err(qp->device, "Invalid attribute mask "
 			 "ehca_qp=%p qp_num=%x qp_attr_mask=%x ",
 			 my_qp, qp->qp_num, qp_attr_mask);
 		return -EINVAL;
@@ -1419,7 +1420,7 @@ int ehca_query_qp(struct ib_qp *qp,
 
 	qpcb = ehca_alloc_fw_ctrlblock(GFP_KERNEL);
 	if (!qpcb) {
-		ehca_err(qp->device,"Out of memory for qpcb "
+		ehca_err(qp->device, "Out of memory for qpcb "
 			 "ehca_qp=%p qp_num=%x", my_qp, qp->qp_num);
 		return -ENOMEM;
 	}
@@ -1431,7 +1432,7 @@ int ehca_query_qp(struct ib_qp *qp,
 
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
-		ehca_err(qp->device,"hipz_h_query_qp() failed "
+		ehca_err(qp->device, "hipz_h_query_qp() failed "
 			 "ehca_qp=%p qp_num=%x h_ret=%lx",
 			 my_qp, qp->qp_num, h_ret);
 		goto query_qp_exit1;
@@ -1442,7 +1443,7 @@ int ehca_query_qp(struct ib_qp *qp,
 
 	if (qp_attr->cur_qp_state == -EINVAL) {
 		ret = -EINVAL;
-		ehca_err(qp->device,"Got invalid ehca_qp_state=%x "
+		ehca_err(qp->device, "Got invalid ehca_qp_state=%x "
 			 "ehca_qp=%p qp_num=%x",
 			 qpcb->qp_state, my_qp, qp->qp_num);
 		goto query_qp_exit1;
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 61da65e..94eed70 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -79,7 +79,8 @@ static inline int ehca_write_rwqe(struct ipz_queue *ipz_rqueue,
 	}
 
 	if (ehca_debug_level) {
-		ehca_gen_dbg("RECEIVE WQE written into ipz_rqueue=%p", ipz_rqueue);
+		ehca_gen_dbg("RECEIVE WQE written into ipz_rqueue=%p",
+			     ipz_rqueue);
 		ehca_dmp( wqe_p, 16*(6 + wqe_p->nr_of_data_seg), "recv wqe");
 	}
 
@@ -99,7 +100,7 @@ static void trace_send_wr_ud(const struct ib_send_wr *send_wr)
 		struct ib_mad_hdr *mad_hdr = send_wr->wr.ud.mad_hdr;
 		struct ib_sge *sge = send_wr->sg_list;
 		ehca_gen_dbg("send_wr#%x wr_id=%lx num_sge=%x "
-			     "send_flags=%x opcode=%x",idx, send_wr->wr_id,
+			     "send_flags=%x opcode=%x", idx, send_wr->wr_id,
 			     send_wr->num_sge, send_wr->send_flags,
 			     send_wr->opcode);
 		if (mad_hdr) {
@@ -116,7 +117,7 @@ static void trace_send_wr_ud(const struct ib_send_wr *send_wr)
 				     mad_hdr->attr_mod);
 		}
 		for (j = 0; j < send_wr->num_sge; j++) {
-			u8 *data = (u8 *) abs_to_virt(sge->addr);
+			u8 *data = (u8 *)abs_to_virt(sge->addr);
 			ehca_gen_dbg("send_wr#%x sge#%x addr=%p length=%x "
 				     "lkey=%x",
 				     idx, j, data, sge->length, sge->lkey);
@@ -534,9 +535,11 @@ poll_cq_one_read_cqe:
 
 	cqe_count++;
 	if (unlikely(cqe->status & WC_STATUS_PURGE_BIT)) {
-		struct ehca_qp *qp=ehca_cq_get_qp(my_cq, cqe->local_qp_number);
+		struct ehca_qp *qp;
 		int purgeflag;
 		unsigned long flags;
+
+		qp = ehca_cq_get_qp(my_cq, cqe->local_qp_number);
 		if (!qp) {
 			ehca_err(cq->device, "cq_num=%x qp_num=%x "
 				 "could not find qp -> ignore cqe",
@@ -551,8 +554,8 @@ poll_cq_one_read_cqe:
 		spin_unlock_irqrestore(&qp->spinlock_s, flags);
 
 		if (purgeflag) {
-			ehca_dbg(cq->device, "Got CQE with purged bit qp_num=%x "
-				 "src_qp=%x",
+			ehca_dbg(cq->device,
+				 "Got CQE with purged bit qp_num=%x src_qp=%x",
 				 cqe->local_qp_number, cqe->remote_qp_number);
 			if (ehca_debug_level)
 				ehca_dmp(cqe, 64, "qp_num=%x src_qp=%x",
diff --git a/drivers/infiniband/hw/ehca/ehca_tools.h b/drivers/infiniband/hw/ehca/ehca_tools.h
index fd8238b..678b813 100644
--- a/drivers/infiniband/hw/ehca/ehca_tools.h
+++ b/drivers/infiniband/hw/ehca/ehca_tools.h
@@ -93,14 +93,14 @@ extern int ehca_debug_level;
 #define ehca_gen_dbg(format, arg...) \
 	do { \
 		if (unlikely(ehca_debug_level)) \
-			printk(KERN_DEBUG "PU%04x EHCA_DBG:%s " format "\n",\
+			printk(KERN_DEBUG "PU%04x EHCA_DBG:%s " format "\n", \
 			       get_paca()->paca_index, __FUNCTION__, ## arg); \
 	} while (0)
 
 #define ehca_gen_warn(format, arg...) \
 	do { \
 		if (unlikely(ehca_debug_level)) \
-			printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n",\
+			printk(KERN_INFO "PU%04x EHCA_WARN:%s " format "\n", \
 			       get_paca()->paca_index, __FUNCTION__, ## arg); \
 	} while (0)
 
@@ -114,12 +114,12 @@ extern int ehca_debug_level;
  * <format string> adr=X ofs=Y <8 bytes hex> <8 bytes hex>
  */
 #define ehca_dmp(adr, len, format, args...) \
-	do {				       \
-		unsigned int x;			      \
+	do { \
+		unsigned int x; \
 		unsigned int l = (unsigned int)(len); \
-		unsigned char *deb = (unsigned char*)(adr);	\
+		unsigned char *deb = (unsigned char *)(adr); \
 		for (x = 0; x < l; x += 16) { \
-			printk("EHCA_DMP:%s " format \
+			printk(KERN_INFO "EHCA_DMP:%s " format \
 			       " adr=%p ofs=%04x %016lx %016lx\n", \
 			       __FUNCTION__, ##args, deb, x, \
 			       *((u64 *)&deb[0]), *((u64 *)&deb[8])); \
@@ -128,16 +128,16 @@ extern int ehca_debug_level;
 	} while (0)
 
 /* define a bitmask, little endian version */
-#define EHCA_BMASK(pos,length) (((pos)<<16)+(length))
+#define EHCA_BMASK(pos, length) (((pos) << 16) + (length))
 
 /* define a bitmask, the ibm way... */
-#define EHCA_BMASK_IBM(from,to) (((63-to)<<16)+((to)-(from)+1))
+#define EHCA_BMASK_IBM(from, to) (((63 - to) << 16) + ((to) - (from) + 1))
 
 /* internal function, don't use */
-#define EHCA_BMASK_SHIFTPOS(mask) (((mask)>>16)&0xffff)
+#define EHCA_BMASK_SHIFTPOS(mask) (((mask) >> 16) & 0xffff)
 
 /* internal function, don't use */
-#define EHCA_BMASK_MASK(mask) (0xffffffffffffffffULL >> ((64-(mask))&0xffff))
+#define EHCA_BMASK_MASK(mask) (~0ULL >> ((64 - (mask)) & 0xffff))
 
 /**
  * EHCA_BMASK_SET - return value shifted and masked by mask
@@ -145,14 +145,14 @@ extern int ehca_debug_level;
  * variable&=~EHCA_BMASK_SET(MY_MASK,-1) clears the bits from the mask
  * in variable
  */
-#define EHCA_BMASK_SET(mask,value) \
-	((EHCA_BMASK_MASK(mask) & ((u64)(value)))<<EHCA_BMASK_SHIFTPOS(mask))
+#define EHCA_BMASK_SET(mask, value) \
+	((EHCA_BMASK_MASK(mask) & ((u64)(value))) << EHCA_BMASK_SHIFTPOS(mask))
 
 /**
  * EHCA_BMASK_GET - extract a parameter from value by mask
  */
-#define EHCA_BMASK_GET(mask,value) \
-	(EHCA_BMASK_MASK(mask)& (((u64)(value))>>EHCA_BMASK_SHIFTPOS(mask)))
+#define EHCA_BMASK_GET(mask, value) \
+	(EHCA_BMASK_MASK(mask) & (((u64)(value)) >> EHCA_BMASK_SHIFTPOS(mask)))
 
 
 /* Converts ehca to ib return code */
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 3031b3b..05c4157 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -70,7 +70,7 @@ int ehca_dealloc_ucontext(struct ib_ucontext *context)
 
 static void ehca_mm_open(struct vm_area_struct *vma)
 {
-	u32 *count = (u32*)vma->vm_private_data;
+	u32 *count = (u32 *)vma->vm_private_data;
 	if (!count) {
 		ehca_gen_err("Invalid vma struct vm_start=%lx vm_end=%lx",
 			     vma->vm_start, vma->vm_end);
@@ -86,7 +86,7 @@ static void ehca_mm_open(struct vm_area_struct *vma)
 
 static void ehca_mm_close(struct vm_area_struct *vma)
 {
-	u32 *count = (u32*)vma->vm_private_data;
+	u32 *count = (u32 *)vma->vm_private_data;
 	if (!count) {
 		ehca_gen_err("Invalid vma struct vm_start=%lx vm_end=%lx",
 			     vma->vm_start, vma->vm_end);
@@ -215,7 +215,8 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 	case 2: /* qp rqueue_addr */
 		ehca_dbg(qp->ib_qp.device, "qp_num=%x rqueue",
 			 qp->ib_qp.qp_num);
-		ret = ehca_mmap_queue(vma, &qp->ipz_rqueue, &qp->mm_count_rqueue);
+		ret = ehca_mmap_queue(vma, &qp->ipz_rqueue,
+				      &qp->mm_count_rqueue);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
 				 "ehca_mmap_queue(rq) failed rc=%x qp_num=%x",
@@ -227,7 +228,8 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 	case 3: /* qp squeue_addr */
 		ehca_dbg(qp->ib_qp.device, "qp_num=%x squeue",
 			 qp->ib_qp.qp_num);
-		ret = ehca_mmap_queue(vma, &qp->ipz_squeue, &qp->mm_count_squeue);
+		ret = ehca_mmap_queue(vma, &qp->ipz_squeue,
+				      &qp->mm_count_squeue);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
 				 "ehca_mmap_queue(sq) failed rc=%x qp_num=%x",
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 4776a8b..3394e05 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -501,8 +501,8 @@ u64 hipz_h_register_rpage_qp(const struct ipz_adapter_handle adapter_handle,
 		return H_PARAMETER;
 	}
 
-	return hipz_h_register_rpage(adapter_handle,pagesize,queue_type,
-				     qp_handle.handle,logical_address_of_page,
+	return hipz_h_register_rpage(adapter_handle, pagesize, queue_type,
+				     qp_handle.handle, logical_address_of_page,
 				     count);
 }
 
@@ -522,9 +522,9 @@ u64 hipz_h_disable_and_get_wqe(const struct ipz_adapter_handle adapter_handle,
 				qp_handle.handle,	   /* r6 */
 				0, 0, 0, 0, 0, 0);
 	if (log_addr_next_sq_wqe2processed)
-		*log_addr_next_sq_wqe2processed = (void*)outs[0];
+		*log_addr_next_sq_wqe2processed = (void *)outs[0];
 	if (log_addr_next_rq_wqe2processed)
-		*log_addr_next_rq_wqe2processed = (void*)outs[1];
+		*log_addr_next_rq_wqe2processed = (void *)outs[1];
 
 	return ret;
 }
diff --git a/drivers/infiniband/hw/ehca/hcp_phyp.c b/drivers/infiniband/hw/ehca/hcp_phyp.c
index 0b1a477..069c69e 100644
--- a/drivers/infiniband/hw/ehca/hcp_phyp.c
+++ b/drivers/infiniband/hw/ehca/hcp_phyp.c
@@ -50,7 +50,7 @@ int hcall_map_page(u64 physaddr, u64 *mapaddr)
 
 int hcall_unmap_page(u64 mapaddr)
 {
-	iounmap((volatile void __iomem*)mapaddr);
+	iounmap((volatile void __iomem *)mapaddr);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/ehca/hipz_fns_core.h b/drivers/infiniband/hw/ehca/hipz_fns_core.h
index 20898a1..868735f 100644
--- a/drivers/infiniband/hw/ehca/hipz_fns_core.h
+++ b/drivers/infiniband/hw/ehca/hipz_fns_core.h
@@ -53,10 +53,10 @@
 #define hipz_galpa_load_cq(gal, offset) \
 	hipz_galpa_load(gal, CQTEMM_OFFSET(offset))
 
-#define hipz_galpa_store_qp(gal,offset, value) \
+#define hipz_galpa_store_qp(gal, offset, value) \
 	hipz_galpa_store(gal, QPTEMM_OFFSET(offset), value)
 #define hipz_galpa_load_qp(gal, offset) \
-	hipz_galpa_load(gal,QPTEMM_OFFSET(offset))
+	hipz_galpa_load(gal, QPTEMM_OFFSET(offset))
 
 static inline void hipz_update_sqa(struct ehca_qp *qp, u16 nr_wqes)
 {
diff --git a/drivers/infiniband/hw/ehca/hipz_hw.h b/drivers/infiniband/hw/ehca/hipz_hw.h
index dad6dea..d9739e5 100644
--- a/drivers/infiniband/hw/ehca/hipz_hw.h
+++ b/drivers/infiniband/hw/ehca/hipz_hw.h
@@ -161,11 +161,11 @@ struct hipz_qptemm {
 /* 0x1000      */
 };
 
-#define QPX_SQADDER EHCA_BMASK_IBM(48,63)
-#define QPX_RQADDER EHCA_BMASK_IBM(48,63)
-#define QPX_AAELOG_RESET_SRQ_LIMIT EHCA_BMASK_IBM(3,3)
+#define QPX_SQADDER EHCA_BMASK_IBM(48, 63)
+#define QPX_RQADDER EHCA_BMASK_IBM(48, 63)
+#define QPX_AAELOG_RESET_SRQ_LIMIT EHCA_BMASK_IBM(3, 3)
 
-#define QPTEMM_OFFSET(x) offsetof(struct hipz_qptemm,x)
+#define QPTEMM_OFFSET(x) offsetof(struct hipz_qptemm, x)
 
 /* MRMWPT Entry Memory Map */
 struct hipz_mrmwmm {
@@ -187,7 +187,7 @@ struct hipz_mrmwmm {
 
 };
 
-#define MRMWMM_OFFSET(x) offsetof(struct hipz_mrmwmm,x)
+#define MRMWMM_OFFSET(x) offsetof(struct hipz_mrmwmm, x)
 
 struct hipz_qpedmm {
 	/* 0x00 */
@@ -238,7 +238,7 @@ struct hipz_qpedmm {
 	u64 qpedx_rrva3;
 };
 
-#define QPEDMM_OFFSET(x) offsetof(struct hipz_qpedmm,x)
+#define QPEDMM_OFFSET(x) offsetof(struct hipz_qpedmm, x)
 
 /* CQ Table Entry Memory Map */
 struct hipz_cqtemm {
@@ -263,12 +263,12 @@ struct hipz_cqtemm {
 /* 0x1000 */
 };
 
-#define CQX_FEC_CQE_CNT           EHCA_BMASK_IBM(32,63)
-#define CQX_FECADDER              EHCA_BMASK_IBM(32,63)
-#define CQX_N0_GENERATE_SOLICITED_COMP_EVENT EHCA_BMASK_IBM(0,0)
-#define CQX_N1_GENERATE_COMP_EVENT EHCA_BMASK_IBM(0,0)
+#define CQX_FEC_CQE_CNT           EHCA_BMASK_IBM(32, 63)
+#define CQX_FECADDER              EHCA_BMASK_IBM(32, 63)
+#define CQX_N0_GENERATE_SOLICITED_COMP_EVENT EHCA_BMASK_IBM(0, 0)
+#define CQX_N1_GENERATE_COMP_EVENT EHCA_BMASK_IBM(0, 0)
 
-#define CQTEMM_OFFSET(x) offsetof(struct hipz_cqtemm,x)
+#define CQTEMM_OFFSET(x) offsetof(struct hipz_cqtemm, x)
 
 /* EQ Table Entry Memory Map */
 struct hipz_eqtemm {
@@ -293,7 +293,7 @@ struct hipz_eqtemm {
 
 };
 
-#define EQTEMM_OFFSET(x) offsetof(struct hipz_eqtemm,x)
+#define EQTEMM_OFFSET(x) offsetof(struct hipz_eqtemm, x)
 
 /* access control defines for MR/MW */
 #define HIPZ_ACCESSCTRL_L_WRITE  0x00800000
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.c b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
index bf7a400..9606f13 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.c
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.c
@@ -114,7 +114,7 @@ int ipz_queue_ctor(struct ipz_queue *queue,
 	 */
 	f = 0;
 	while (f < nr_of_pages) {
-		u8 *kpage = (u8*)get_zeroed_page(GFP_KERNEL);
+		u8 *kpage = (u8 *)get_zeroed_page(GFP_KERNEL);
 		int k;
 		if (!kpage)
 			goto ipz_queue_ctor_exit0; /*NOMEM*/
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index 007f088..39a4f64 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -240,7 +240,7 @@ void *ipz_qeit_eq_get_inc(struct ipz_queue *queue);
 static inline void *ipz_eqit_eq_get_inc_valid(struct ipz_queue *queue)
 {
 	void *ret = ipz_qeit_get(queue);
-	u32 qe = *(u8 *) ret;
+	u32 qe = *(u8 *)ret;
 	if ((qe >> 7) != (queue->toggle_state & 1))
 		return NULL;
 	ipz_qeit_eq_get_inc(queue); /* this is a good one */
@@ -250,7 +250,7 @@ static inline void *ipz_eqit_eq_get_inc_valid(struct ipz_queue *queue)
 static inline void *ipz_eqit_eq_peek_valid(struct ipz_queue *queue)
 {
 	void *ret = ipz_qeit_get(queue);
-	u32 qe = *(u8 *) ret;
+	u32 qe = *(u8 *)ret;
 	if ((qe >> 7) != (queue->toggle_state & 1))
 		return NULL;
 	return ret;
-- 
1.5.2


