Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXIKNdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXIKNdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 09:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbXIKNc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 09:32:58 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:58339 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXIKNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 09:32:55 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH 06/12] IB/ehca: Print return codes as signed decimal integers
User-Agent: KMail/1.8.2
Cc: "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709111518.26276.fenkes@de.ibm.com>
In-Reply-To: <200709111518.26276.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 3006
Date: Tue, 11 Sep 2007 15:32:22 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200709111532.23051.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

...because -12 is easier to read than FFFFFFF4.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_cq.c     |   14 +++---
 drivers/infiniband/hw/ehca/ehca_hca.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_main.c   |   24 +++++-----
 drivers/infiniband/hw/ehca/ehca_mcast.c  |    4 +-
 drivers/infiniband/hw/ehca/ehca_mrmw.c   |   75 +++++++++++++++---------------
 drivers/infiniband/hw/ehca/ehca_qp.c     |   46 +++++++++---------
 drivers/infiniband/hw/ehca/ehca_reqs.c   |    2 +-
 drivers/infiniband/hw/ehca/ehca_sqp.c    |    2 +-
 drivers/infiniband/hw/ehca/ehca_uverbs.c |   18 ++++----
 drivers/infiniband/hw/ehca/hcp_if.c      |   20 ++++----
 10 files changed, 103 insertions(+), 104 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
index d68603d..79c25f5 100644
--- a/drivers/infiniband/hw/ehca/ehca_cq.c
+++ b/drivers/infiniband/hw/ehca/ehca_cq.c
@@ -190,7 +190,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 
 	if (h_ret != H_SUCCESS) {
 		ehca_err(device, "hipz_h_alloc_resource_cq() failed "
-			 "h_ret=%lx device=%p", h_ret, device);
+			 "h_ret=%li device=%p", h_ret, device);
 		cq = ERR_PTR(ehca2ib_return_code(h_ret));
 		goto create_cq_exit2;
 	}
@@ -198,7 +198,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 	ipz_rc = ipz_queue_ctor(NULL, &my_cq->ipz_queue, param.act_pages,
 				EHCA_PAGESIZE, sizeof(struct ehca_cqe), 0, 0);
 	if (!ipz_rc) {
-		ehca_err(device, "ipz_queue_ctor() failed ipz_rc=%x device=%p",
+		ehca_err(device, "ipz_queue_ctor() failed ipz_rc=%i device=%p",
 			 ipz_rc, device);
 		cq = ERR_PTR(-EINVAL);
 		goto create_cq_exit3;
@@ -226,7 +226,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 
 		if (h_ret < H_SUCCESS) {
 			ehca_err(device, "hipz_h_register_rpage_cq() failed "
-				 "ehca_cq=%p cq_num=%x h_ret=%lx counter=%i "
+				 "ehca_cq=%p cq_num=%x h_ret=%li counter=%i "
 				 "act_pages=%i", my_cq, my_cq->cq_number,
 				 h_ret, counter, param.act_pages);
 			cq = ERR_PTR(-EINVAL);
@@ -238,7 +238,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 			if ((h_ret != H_SUCCESS) || vpage) {
 				ehca_err(device, "Registration of pages not "
 					 "complete ehca_cq=%p cq_num=%x "
-					 "h_ret=%lx", my_cq, my_cq->cq_number,
+					 "h_ret=%li", my_cq, my_cq->cq_number,
 					 h_ret);
 				cq = ERR_PTR(-EAGAIN);
 				goto create_cq_exit4;
@@ -246,7 +246,7 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
 		} else {
 			if (h_ret != H_PAGE_REGISTERED) {
 				ehca_err(device, "Registration of page failed "
-					 "ehca_cq=%p cq_num=%x h_ret=%lx"
+					 "ehca_cq=%p cq_num=%x h_ret=%li"
 					 "counter=%i act_pages=%i",
 					 my_cq, my_cq->cq_number,
 					 h_ret, counter, param.act_pages);
@@ -298,7 +298,7 @@ create_cq_exit3:
 	h_ret = hipz_h_destroy_cq(adapter_handle, my_cq, 1);
 	if (h_ret != H_SUCCESS)
 		ehca_err(device, "hipz_h_destroy_cq() failed ehca_cq=%p "
-			 "cq_num=%x h_ret=%lx", my_cq, my_cq->cq_number, h_ret);
+			 "cq_num=%x h_ret=%li", my_cq, my_cq->cq_number, h_ret);
 
 create_cq_exit2:
 	write_lock_irqsave(&ehca_cq_idr_lock, flags);
@@ -362,7 +362,7 @@ int ehca_destroy_cq(struct ib_cq *cq)
 				 cq_num);
 	}
 	if (h_ret != H_SUCCESS) {
-		ehca_err(device, "hipz_h_destroy_cq() failed h_ret=%lx "
+		ehca_err(device, "hipz_h_destroy_cq() failed h_ret=%li "
 			 "ehca_cq=%p cq_num=%x", h_ret, my_cq, cq_num);
 		return ehca2ib_return_code(h_ret);
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index cf22472..3436c49 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -352,7 +352,7 @@ int ehca_modify_port(struct ib_device *ibdev,
 	hret = hipz_h_modify_port(shca->ipz_hca_handle, port,
 				  cap, props->init_type, port_modify_mask);
 	if (hret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "Modify port failed  hret=%lx",
+		ehca_err(&shca->ib_device, "Modify port failed  h_ret=%li",
 			 hret);
 		ret = -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 1a2c542..799f218 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -273,7 +273,7 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 
 	h_ret = hipz_h_query_hca(shca->ipz_hca_handle, rblock);
 	if (h_ret != H_SUCCESS) {
-		ehca_gen_err("Cannot query device properties. h_ret=%lx",
+		ehca_gen_err("Cannot query device properties. h_ret=%li",
 			     h_ret);
 		ret = -EPERM;
 		goto sense_attributes1;
@@ -332,7 +332,7 @@ int ehca_sense_attributes(struct ehca_shca *shca)
 	port = (struct hipz_query_port *)rblock;
 	h_ret = hipz_h_query_port(shca->ipz_hca_handle, 1, port);
 	if (h_ret != H_SUCCESS) {
-		ehca_gen_err("Cannot query port properties. h_ret=%lx",
+		ehca_gen_err("Cannot query port properties. h_ret=%li",
 			     h_ret);
 		ret = -EPERM;
 		goto sense_attributes1;
@@ -526,13 +526,13 @@ static int ehca_destroy_aqp1(struct ehca_sport *sport)
 
 	ret = ib_destroy_qp(sport->ibqp_aqp1);
 	if (ret) {
-		ehca_gen_err("Cannot destroy AQP1 QP. ret=%x", ret);
+		ehca_gen_err("Cannot destroy AQP1 QP. ret=%i", ret);
 		return ret;
 	}
 
 	ret = ib_destroy_cq(sport->ibcq_aqp1);
 	if (ret)
-		ehca_gen_err("Cannot destroy AQP1 CQ. ret=%x", ret);
+		ehca_gen_err("Cannot destroy AQP1 CQ. ret=%i", ret);
 
 	return ret;
 }
@@ -728,7 +728,7 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 	ret = ehca_reg_internal_maxmr(shca, shca->pd, &shca->maxmr);
 
 	if (ret) {
-		ehca_err(&shca->ib_device, "Cannot create internal MR ret=%x",
+		ehca_err(&shca->ib_device, "Cannot create internal MR ret=%i",
 			 ret);
 		goto probe5;
 	}
@@ -736,7 +736,7 @@ static int __devinit ehca_probe(struct ibmebus_dev *dev,
 	ret = ib_register_device(&shca->ib_device);
 	if (ret) {
 		ehca_err(&shca->ib_device,
-			 "ib_register_device() failed ret=%x", ret);
+			 "ib_register_device() failed ret=%i", ret);
 		goto probe6;
 	}
 
@@ -777,7 +777,7 @@ probe8:
 	ret = ehca_destroy_aqp1(&shca->sport[0]);
 	if (ret)
 		ehca_err(&shca->ib_device,
-			 "Cannot destroy AQP1 for port 1. ret=%x", ret);
+			 "Cannot destroy AQP1 for port 1. ret=%i", ret);
 
 probe7:
 	ib_unregister_device(&shca->ib_device);
@@ -826,7 +826,7 @@ static int __devexit ehca_remove(struct ibmebus_dev *dev)
 			if (ret)
 				ehca_err(&shca->ib_device,
 					 "Cannot destroy AQP1 for port %x "
-					 "ret=%x", ret, i);
+					 "ret=%i", ret, i);
 		}
 	}
 
@@ -835,20 +835,20 @@ static int __devexit ehca_remove(struct ibmebus_dev *dev)
 	ret = ehca_dereg_internal_maxmr(shca);
 	if (ret)
 		ehca_err(&shca->ib_device,
-			 "Cannot destroy internal MR. ret=%x", ret);
+			 "Cannot destroy internal MR. ret=%i", ret);
 
 	ret = ehca_dealloc_pd(&shca->pd->ib_pd);
 	if (ret)
 		ehca_err(&shca->ib_device,
-			 "Cannot destroy internal PD. ret=%x", ret);
+			 "Cannot destroy internal PD. ret=%i", ret);
 
 	ret = ehca_destroy_eq(shca, &shca->eq);
 	if (ret)
-		ehca_err(&shca->ib_device, "Cannot destroy EQ. ret=%x", ret);
+		ehca_err(&shca->ib_device, "Cannot destroy EQ. ret=%i", ret);
 
 	ret = ehca_destroy_eq(shca, &shca->neq);
 	if (ret)
-		ehca_err(&shca->ib_device, "Canot destroy NEQ. ret=%x", ret);
+		ehca_err(&shca->ib_device, "Canot destroy NEQ. ret=%i", ret);
 
 	ib_dealloc_device(&shca->ib_device);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_mcast.c b/drivers/infiniband/hw/ehca/ehca_mcast.c
index 32a8706..e3ef026 100644
--- a/drivers/infiniband/hw/ehca/ehca_mcast.c
+++ b/drivers/infiniband/hw/ehca/ehca_mcast.c
@@ -88,7 +88,7 @@ int ehca_attach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	if (h_ret != H_SUCCESS)
 		ehca_err(ibqp->device,
 			 "ehca_qp=%p qp_num=%x hipz_h_attach_mcqp() failed "
-			 "h_ret=%lx", my_qp, ibqp->qp_num, h_ret);
+			 "h_ret=%li", my_qp, ibqp->qp_num, h_ret);
 
 	return ehca2ib_return_code(h_ret);
 }
@@ -125,7 +125,7 @@ int ehca_detach_mcast(struct ib_qp *ibqp, union ib_gid *gid, u16 lid)
 	if (h_ret != H_SUCCESS)
 		ehca_err(ibqp->device,
 			 "ehca_qp=%p qp_num=%x hipz_h_detach_mcqp() failed "
-			 "h_ret=%lx", my_qp, ibqp->qp_num, h_ret);
+			 "h_ret=%li", my_qp, ibqp->qp_num, h_ret);
 
 	return ehca2ib_return_code(h_ret);
 }
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index d97eda3..4c8f3b3 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -159,7 +159,7 @@ struct ib_mr *ehca_get_dma_mr(struct ib_pd *pd, int mr_access_flags)
 
 get_dma_mr_exit0:
 	if (IS_ERR(ib_mr))
-		ehca_err(&shca->ib_device, "rc=%lx pd=%p mr_access_flags=%x ",
+		ehca_err(&shca->ib_device, "h_ret=%li pd=%p mr_access_flags=%x",
 			 PTR_ERR(ib_mr), pd, mr_access_flags);
 	return ib_mr;
 } /* end ehca_get_dma_mr() */
@@ -271,7 +271,7 @@ reg_phys_mr_exit1:
 	ehca_mr_delete(e_mr);
 reg_phys_mr_exit0:
 	if (IS_ERR(ib_mr))
-		ehca_err(pd->device, "rc=%lx pd=%p phys_buf_array=%p "
+		ehca_err(pd->device, "h_ret=%li pd=%p phys_buf_array=%p "
 			 "num_phys_buf=%x mr_access_flags=%x iova_start=%p",
 			 PTR_ERR(ib_mr), pd, phys_buf_array,
 			 num_phys_buf, mr_access_flags, iova_start);
@@ -403,8 +403,7 @@ reg_user_mr_exit1:
 	ehca_mr_delete(e_mr);
 reg_user_mr_exit0:
 	if (IS_ERR(ib_mr))
-		ehca_err(pd->device, "rc=%lx pd=%p mr_access_flags=%x"
-			 " udata=%p",
+		ehca_err(pd->device, "rc=%li pd=%p mr_access_flags=%x udata=%p",
 			 PTR_ERR(ib_mr), pd, mr_access_flags, udata);
 	return ib_mr;
 } /* end ehca_reg_user_mr() */
@@ -565,7 +564,7 @@ rereg_phys_mr_exit1:
 	spin_unlock_irqrestore(&e_mr->mrlock, sl_flags);
 rereg_phys_mr_exit0:
 	if (ret)
-		ehca_err(mr->device, "ret=%x mr=%p mr_rereg_mask=%x pd=%p "
+		ehca_err(mr->device, "ret=%i mr=%p mr_rereg_mask=%x pd=%p "
 			 "phys_buf_array=%p num_phys_buf=%x mr_access_flags=%x "
 			 "iova_start=%p",
 			 ret, mr, mr_rereg_mask, pd, phys_buf_array,
@@ -607,7 +606,7 @@ int ehca_query_mr(struct ib_mr *mr, struct ib_mr_attr *mr_attr)
 
 	h_ret = hipz_h_query_mr(shca->ipz_hca_handle, e_mr, &hipzout);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(mr->device, "hipz_mr_query failed, h_ret=%lx mr=%p "
+		ehca_err(mr->device, "hipz_mr_query failed, h_ret=%li mr=%p "
 			 "hca_hndl=%lx mr_hndl=%lx lkey=%x",
 			 h_ret, mr, shca->ipz_hca_handle.handle,
 			 e_mr->ipz_mr_handle.handle, mr->lkey);
@@ -625,7 +624,7 @@ query_mr_exit1:
 	spin_unlock_irqrestore(&e_mr->mrlock, sl_flags);
 query_mr_exit0:
 	if (ret)
-		ehca_err(mr->device, "ret=%x mr=%p mr_attr=%p",
+		ehca_err(mr->device, "ret=%i mr=%p mr_attr=%p",
 			 ret, mr, mr_attr);
 	return ret;
 } /* end ehca_query_mr() */
@@ -667,7 +666,7 @@ int ehca_dereg_mr(struct ib_mr *mr)
 	/* TODO: BUSY: MR still has bound window(s) */
 	h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_mr);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(mr->device, "hipz_free_mr failed, h_ret=%lx shca=%p "
+		ehca_err(mr->device, "hipz_free_mr failed, h_ret=%li shca=%p "
 			 "e_mr=%p hca_hndl=%lx mr_hndl=%lx mr->lkey=%x",
 			 h_ret, shca, e_mr, shca->ipz_hca_handle.handle,
 			 e_mr->ipz_mr_handle.handle, mr->lkey);
@@ -683,7 +682,7 @@ int ehca_dereg_mr(struct ib_mr *mr)
 
 dereg_mr_exit0:
 	if (ret)
-		ehca_err(mr->device, "ret=%x mr=%p", ret, mr);
+		ehca_err(mr->device, "ret=%i mr=%p", ret, mr);
 	return ret;
 } /* end ehca_dereg_mr() */
 
@@ -708,7 +707,7 @@ struct ib_mw *ehca_alloc_mw(struct ib_pd *pd)
 	h_ret = hipz_h_alloc_resource_mw(shca->ipz_hca_handle, e_mw,
 					 e_pd->fw_pd, &hipzout);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(pd->device, "hipz_mw_allocate failed, h_ret=%lx "
+		ehca_err(pd->device, "hipz_mw_allocate failed, h_ret=%li "
 			 "shca=%p hca_hndl=%lx mw=%p",
 			 h_ret, shca, shca->ipz_hca_handle.handle, e_mw);
 		ib_mw = ERR_PTR(ehca2ib_return_code(h_ret));
@@ -723,7 +722,7 @@ alloc_mw_exit1:
 	ehca_mw_delete(e_mw);
 alloc_mw_exit0:
 	if (IS_ERR(ib_mw))
-		ehca_err(pd->device, "rc=%lx pd=%p", PTR_ERR(ib_mw), pd);
+		ehca_err(pd->device, "h_ret=%li pd=%p", PTR_ERR(ib_mw), pd);
 	return ib_mw;
 } /* end ehca_alloc_mw() */
 
@@ -750,7 +749,7 @@ int ehca_dealloc_mw(struct ib_mw *mw)
 
 	h_ret = hipz_h_free_resource_mw(shca->ipz_hca_handle, e_mw);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(mw->device, "hipz_free_mw failed, h_ret=%lx shca=%p "
+		ehca_err(mw->device, "hipz_free_mw failed, h_ret=%li shca=%p "
 			 "mw=%p rkey=%x hca_hndl=%lx mw_hndl=%lx",
 			 h_ret, shca, mw, mw->rkey, shca->ipz_hca_handle.handle,
 			 e_mw->ipz_mw_handle.handle);
@@ -847,7 +846,7 @@ alloc_fmr_exit1:
 	ehca_mr_delete(e_fmr);
 alloc_fmr_exit0:
 	if (IS_ERR(ib_fmr))
-		ehca_err(pd->device, "rc=%lx pd=%p mr_access_flags=%x "
+		ehca_err(pd->device, "h_ret=%li pd=%p mr_access_flags=%x "
 			 "fmr_attr=%p", PTR_ERR(ib_fmr), pd,
 			 mr_access_flags, fmr_attr);
 	return ib_fmr;
@@ -916,7 +915,7 @@ int ehca_map_phys_fmr(struct ib_fmr *fmr,
 
 map_phys_fmr_exit0:
 	if (ret)
-		ehca_err(fmr->device, "ret=%x fmr=%p page_list=%p list_len=%x "
+		ehca_err(fmr->device, "ret=%i fmr=%p page_list=%p list_len=%x "
 			 "iova=%lx", ret, fmr, page_list, list_len, iova);
 	return ret;
 } /* end ehca_map_phys_fmr() */
@@ -979,7 +978,7 @@ int ehca_unmap_fmr(struct list_head *fmr_list)
 
 unmap_fmr_exit0:
 	if (ret)
-		ehca_gen_err("ret=%x fmr_list=%p num_fmr=%x unmap_fmr_cnt=%x",
+		ehca_gen_err("ret=%i fmr_list=%p num_fmr=%x unmap_fmr_cnt=%x",
 			     ret, fmr_list, num_fmr, unmap_fmr_cnt);
 	return ret;
 } /* end ehca_unmap_fmr() */
@@ -1003,7 +1002,7 @@ int ehca_dealloc_fmr(struct ib_fmr *fmr)
 
 	h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_fmr);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(fmr->device, "hipz_free_mr failed, h_ret=%lx e_fmr=%p "
+		ehca_err(fmr->device, "hipz_free_mr failed, h_ret=%li e_fmr=%p "
 			 "hca_hndl=%lx fmr_hndl=%lx fmr->lkey=%x",
 			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
 			 e_fmr->ipz_mr_handle.handle, fmr->lkey);
@@ -1016,7 +1015,7 @@ int ehca_dealloc_fmr(struct ib_fmr *fmr)
 
 free_fmr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x fmr=%p", ret, fmr);
+		ehca_err(&shca->ib_device, "ret=%i fmr=%p", ret, fmr);
 	return ret;
 } /* end ehca_dealloc_fmr() */
 
@@ -1046,7 +1045,7 @@ int ehca_reg_mr(struct ehca_shca *shca,
 					 (u64)iova_start, size, hipz_acl,
 					 e_pd->fw_pd, &hipzout);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "hipz_alloc_mr failed, h_ret=%lx "
+		ehca_err(&shca->ib_device, "hipz_alloc_mr failed, h_ret=%li "
 			 "hca_hndl=%lx", h_ret, shca->ipz_hca_handle.handle);
 		ret = ehca2ib_return_code(h_ret);
 		goto ehca_reg_mr_exit0;
@@ -1072,9 +1071,9 @@ int ehca_reg_mr(struct ehca_shca *shca,
 ehca_reg_mr_exit1:
 	h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_mr);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "h_ret=%lx shca=%p e_mr=%p "
+		ehca_err(&shca->ib_device, "h_ret=%li shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p lkey=%x "
-			 "pginfo=%p num_kpages=%lx num_hwpages=%lx ret=%x",
+			 "pginfo=%p num_kpages=%lx num_hwpages=%lx ret=%i",
 			 h_ret, shca, e_mr, iova_start, size, acl, e_pd,
 			 hipzout.lkey, pginfo, pginfo->num_kpages,
 			 pginfo->num_hwpages, ret);
@@ -1083,7 +1082,7 @@ ehca_reg_mr_exit1:
 	}
 ehca_reg_mr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p "
+		ehca_err(&shca->ib_device, "ret=%i shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p pginfo=%p "
 			 "num_kpages=%lx num_hwpages=%lx",
 			 ret, shca, e_mr, iova_start, size, acl, e_pd, pginfo,
@@ -1127,7 +1126,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 		ret = ehca_set_pagebuf(pginfo, rnum, kpage);
 		if (ret) {
 			ehca_err(&shca->ib_device, "ehca_set_pagebuf "
-				 "bad rc, ret=%x rnum=%x kpage=%p",
+				 "bad rc, ret=%i rnum=%x kpage=%p",
 				 ret, rnum, kpage);
 			goto ehca_reg_mr_rpages_exit1;
 		}
@@ -1155,7 +1154,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 			 */
 			if (h_ret != H_SUCCESS) {
 				ehca_err(&shca->ib_device, "last "
-					 "hipz_reg_rpage_mr failed, h_ret=%lx "
+					 "hipz_reg_rpage_mr failed, h_ret=%li "
 					 "e_mr=%p i=%x hca_hndl=%lx mr_hndl=%lx"
 					 " lkey=%x", h_ret, e_mr, i,
 					 shca->ipz_hca_handle.handle,
@@ -1167,7 +1166,7 @@ int ehca_reg_mr_rpages(struct ehca_shca *shca,
 				ret = 0;
 		} else if (h_ret != H_PAGE_REGISTERED) {
 			ehca_err(&shca->ib_device, "hipz_reg_rpage_mr failed, "
-				 "h_ret=%lx e_mr=%p i=%x lkey=%x hca_hndl=%lx "
+				 "h_ret=%li e_mr=%p i=%x lkey=%x hca_hndl=%lx "
 				 "mr_hndl=%lx", h_ret, e_mr, i,
 				 e_mr->ib.ib_mr.lkey,
 				 shca->ipz_hca_handle.handle,
@@ -1183,7 +1182,7 @@ ehca_reg_mr_rpages_exit1:
 	ehca_free_fw_ctrlblock(kpage);
 ehca_reg_mr_rpages_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p pginfo=%p "
+		ehca_err(&shca->ib_device, "ret=%i shca=%p e_mr=%p pginfo=%p "
 			 "num_kpages=%lx num_hwpages=%lx", ret, shca, e_mr,
 			 pginfo, pginfo->num_kpages, pginfo->num_hwpages);
 	return ret;
@@ -1244,7 +1243,7 @@ inline int ehca_rereg_mr_rereg1(struct ehca_shca *shca,
 		 * (MW bound or MR is shared)
 		 */
 		ehca_warn(&shca->ib_device, "hipz_h_reregister_pmr failed "
-			  "(Rereg1), h_ret=%lx e_mr=%p", h_ret, e_mr);
+			  "(Rereg1), h_ret=%li e_mr=%p", h_ret, e_mr);
 		*pginfo = pginfo_save;
 		ret = -EAGAIN;
 	} else if ((u64 *)hipzout.vaddr != iova_start) {
@@ -1273,7 +1272,7 @@ ehca_rereg_mr_rereg1_exit1:
 	ehca_free_fw_ctrlblock(kpage);
 ehca_rereg_mr_rereg1_exit0:
 	if ( ret && (ret != -EAGAIN) )
-		ehca_err(&shca->ib_device, "ret=%x lkey=%x rkey=%x "
+		ehca_err(&shca->ib_device, "ret=%i lkey=%x rkey=%x "
 			 "pginfo=%p num_kpages=%lx num_hwpages=%lx",
 			 ret, *lkey, *rkey, pginfo, pginfo->num_kpages,
 			 pginfo->num_hwpages);
@@ -1334,7 +1333,7 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 		h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_mr);
 		if (h_ret != H_SUCCESS) {
 			ehca_err(&shca->ib_device, "hipz_free_mr failed, "
-				 "h_ret=%lx e_mr=%p hca_hndl=%lx mr_hndl=%lx "
+				 "h_ret=%li e_mr=%p hca_hndl=%lx mr_hndl=%lx "
 				 "mr->lkey=%x",
 				 h_ret, e_mr, shca->ipz_hca_handle.handle,
 				 e_mr->ipz_mr_handle.handle,
@@ -1366,7 +1365,7 @@ int ehca_rereg_mr(struct ehca_shca *shca,
 
 ehca_rereg_mr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p e_mr=%p "
+		ehca_err(&shca->ib_device, "ret=%i shca=%p e_mr=%p "
 			 "iova_start=%p size=%lx acl=%x e_pd=%p pginfo=%p "
 			 "num_kpages=%lx lkey=%x rkey=%x rereg_1_hcall=%x "
 			 "rereg_3_hcall=%x", ret, shca, e_mr, iova_start, size,
@@ -1410,7 +1409,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 		 * FMRs are not shared and no MW bound to FMRs
 		 */
 		ehca_err(&shca->ib_device, "hipz_reregister_pmr failed "
-			 "(Rereg1), h_ret=%lx e_fmr=%p hca_hndl=%lx "
+			 "(Rereg1), h_ret=%li e_fmr=%p hca_hndl=%lx "
 			 "mr_hndl=%lx lkey=%x lkey_out=%x",
 			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
 			 e_fmr->ipz_mr_handle.handle,
@@ -1422,7 +1421,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 	h_ret = hipz_h_free_resource_mr(shca->ipz_hca_handle, e_fmr);
 	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "hipz_free_mr failed, "
-			 "h_ret=%lx e_fmr=%p hca_hndl=%lx mr_hndl=%lx "
+			 "h_ret=%li e_fmr=%p hca_hndl=%lx mr_hndl=%lx "
 			 "lkey=%x",
 			 h_ret, e_fmr, shca->ipz_hca_handle.handle,
 			 e_fmr->ipz_mr_handle.handle,
@@ -1457,7 +1456,7 @@ int ehca_unmap_one_fmr(struct ehca_shca *shca,
 
 ehca_unmap_one_fmr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x tmp_lkey=%x tmp_rkey=%x "
+		ehca_err(&shca->ib_device, "ret=%i tmp_lkey=%x tmp_rkey=%x "
 			 "fmr_max_pages=%x",
 			 ret, tmp_lkey, tmp_rkey, e_fmr->fmr_max_pages);
 	return ret;
@@ -1486,7 +1485,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 				    (u64)iova_start, hipz_acl, e_pd->fw_pd,
 				    &hipzout);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "hipz_reg_smr failed, h_ret=%lx "
+		ehca_err(&shca->ib_device, "hipz_reg_smr failed, h_ret=%li "
 			 "shca=%p e_origmr=%p e_newmr=%p iova_start=%p acl=%x "
 			 "e_pd=%p hca_hndl=%lx mr_hndl=%lx lkey=%x",
 			 h_ret, shca, e_origmr, e_newmr, iova_start, acl, e_pd,
@@ -1510,7 +1509,7 @@ int ehca_reg_smr(struct ehca_shca *shca,
 
 ehca_reg_smr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p e_origmr=%p "
+		ehca_err(&shca->ib_device, "ret=%i shca=%p e_origmr=%p "
 			 "e_newmr=%p iova_start=%p acl=%x e_pd=%p",
 			 ret, shca, e_origmr, e_newmr, iova_start, acl, e_pd);
 	return ret;
@@ -1585,7 +1584,7 @@ ehca_reg_internal_maxmr_exit1:
 	ehca_mr_delete(e_mr);
 ehca_reg_internal_maxmr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p e_pd=%p e_maxmr=%p",
+		ehca_err(&shca->ib_device, "ret=%i shca=%p e_pd=%p e_maxmr=%p",
 			 ret, shca, e_pd, e_maxmr);
 	return ret;
 } /* end ehca_reg_internal_maxmr() */
@@ -1612,7 +1611,7 @@ int ehca_reg_maxmr(struct ehca_shca *shca,
 				    (u64)iova_start, hipz_acl, e_pd->fw_pd,
 				    &hipzout);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(&shca->ib_device, "hipz_reg_smr failed, h_ret=%lx "
+		ehca_err(&shca->ib_device, "hipz_reg_smr failed, h_ret=%li "
 			 "e_origmr=%p hca_hndl=%lx mr_hndl=%lx lkey=%x",
 			 h_ret, e_origmr, shca->ipz_hca_handle.handle,
 			 e_origmr->ipz_mr_handle.handle,
@@ -1653,7 +1652,7 @@ int ehca_dereg_internal_maxmr(struct ehca_shca *shca)
 	ret = ehca_dereg_mr(&e_maxmr->ib.ib_mr);
 	if (ret) {
 		ehca_err(&shca->ib_device, "dereg internal max-MR failed, "
-			 "ret=%x e_maxmr=%p shca=%p lkey=%x",
+			 "ret=%i e_maxmr=%p shca=%p lkey=%x",
 			 ret, e_maxmr, shca, e_maxmr->ib.ib_mr.lkey);
 		shca->maxmr = e_maxmr;
 		goto ehca_dereg_internal_maxmr_exit0;
@@ -1663,7 +1662,7 @@ int ehca_dereg_internal_maxmr(struct ehca_shca *shca)
 
 ehca_dereg_internal_maxmr_exit0:
 	if (ret)
-		ehca_err(&shca->ib_device, "ret=%x shca=%p shca->maxmr=%p",
+		ehca_err(&shca->ib_device, "ret=%i shca=%p shca->maxmr=%p",
 			 ret, shca, shca->maxmr);
 	return ret;
 } /* end ehca_dereg_internal_maxmr() */
diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
index 3a3880f..d2ab84a 100644
--- a/drivers/infiniband/hw/ehca/ehca_qp.c
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -310,7 +310,7 @@ static inline int init_qp_queue(struct ehca_shca *shca,
 	}
 
 	if (!ipz_rc) {
-		ehca_err(ib_dev, "Cannot allocate page for queue. ipz_rc=%x",
+		ehca_err(ib_dev, "Cannot allocate page for queue. ipz_rc=%i",
 			 ipz_rc);
 		return -EBUSY;
 	}
@@ -334,7 +334,7 @@ static inline int init_qp_queue(struct ehca_shca *shca,
 		if (cnt == (nr_q_pages - 1)) {	/* last page! */
 			if (h_ret != expected_hret) {
 				ehca_err(ib_dev, "hipz_qp_register_rpage() "
-					 "h_ret= %lx ", h_ret);
+					 "h_ret=%li", h_ret);
 				ret = ehca2ib_return_code(h_ret);
 				goto init_qp_queue1;
 			}
@@ -348,7 +348,7 @@ static inline int init_qp_queue(struct ehca_shca *shca,
 		} else {
 			if (h_ret != H_PAGE_REGISTERED) {
 				ehca_err(ib_dev, "hipz_qp_register_rpage() "
-					 "h_ret= %lx ", h_ret);
+					 "h_ret=%li", h_ret);
 				ret = ehca2ib_return_code(h_ret);
 				goto init_qp_queue1;
 			}
@@ -617,7 +617,7 @@ static struct ehca_qp *internal_create_qp(
 
 	h_ret = hipz_h_alloc_resource_qp(shca->ipz_hca_handle, &parms);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(pd->device, "h_alloc_resource_qp() failed h_ret=%lx",
+		ehca_err(pd->device, "h_alloc_resource_qp() failed h_ret=%li",
 			 h_ret);
 		ret = ehca2ib_return_code(h_ret);
 		goto create_qp_exit1;
@@ -671,7 +671,7 @@ static struct ehca_qp *internal_create_qp(
 			&parms.squeue, swqe_size);
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize squeue "
-				 "and pages  ret=%x", ret);
+				 "and pages ret=%i", ret);
 			goto create_qp_exit2;
 		}
 	}
@@ -682,7 +682,7 @@ static struct ehca_qp *internal_create_qp(
 			H_SUCCESS, &parms.rqueue, rwqe_size);
 		if (ret) {
 			ehca_err(pd->device, "Couldn't initialize rqueue "
-				 "and pages ret=%x", ret);
+				 "and pages ret=%i", ret);
 			goto create_qp_exit3;
 		}
 	}
@@ -719,8 +719,8 @@ static struct ehca_qp *internal_create_qp(
 	if (qp_type == IB_QPT_GSI) {
 		h_ret = ehca_define_sqp(shca, my_qp, init_attr);
 		if (h_ret != H_SUCCESS) {
-			ehca_err(pd->device, "ehca_define_sqp() failed rc=%lx",
-				 h_ret);
+			ehca_err(pd->device, "ehca_define_sqp() failed "
+				 "h_ret=%li", h_ret);
 			ret = ehca2ib_return_code(h_ret);
 			goto create_qp_exit4;
 		}
@@ -730,7 +730,7 @@ static struct ehca_qp *internal_create_qp(
 		ret = ehca_cq_assign_qp(my_qp->send_cq, my_qp);
 		if (ret) {
 			ehca_err(pd->device,
-				 "Couldn't assign qp to send_cq ret=%x", ret);
+				 "Couldn't assign qp to send_cq ret=%i", ret);
 			goto create_qp_exit4;
 		}
 	}
@@ -847,7 +847,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
 		ehca_err(pd->device, "Could not modify SRQ to INIT"
-			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
 	}
@@ -861,7 +861,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
 		ehca_err(pd->device, "Could not enable SRQ"
-			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
 	}
@@ -875,7 +875,7 @@ struct ib_srq *ehca_create_srq(struct ib_pd *pd,
 				mqpcb, my_qp->galpas.kernel);
 	if (hret != H_SUCCESS) {
 		ehca_err(pd->device, "Could not modify SRQ to RTR"
-			 "ehca_qp=%p qp_num=%x hret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, hret);
 		goto create_srq2;
 	}
@@ -913,7 +913,7 @@ static int prepare_sqe_rts(struct ehca_qp *my_qp, struct ehca_shca *shca,
 					   &bad_send_wqe_p, NULL, 2);
 	if (h_ret != H_SUCCESS) {
 		ehca_err(&shca->ib_device, "hipz_h_disable_and_get_wqe() failed"
-			 " ehca_qp=%p qp_num=%x h_ret=%lx",
+			 " ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, qp_num, h_ret);
 		return ehca2ib_return_code(h_ret);
 	}
@@ -991,7 +991,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 				mqpcb, my_qp->galpas.kernel);
 	if (h_ret != H_SUCCESS) {
 		ehca_err(ibqp->device, "hipz_h_query_qp() failed "
-			 "ehca_qp=%p qp_num=%x h_ret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, ibqp->qp_num, h_ret);
 		ret = ehca2ib_return_code(h_ret);
 		goto modify_qp_exit1;
@@ -1027,7 +1027,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			ibqp, &smiqp_attr, smiqp_attr_mask, 1);
 		if (smirc) {
 			ehca_err(ibqp->device, "SMI RESET -> INIT failed. "
-				 "ehca_modify_qp() rc=%x", smirc);
+				 "ehca_modify_qp() rc=%i", smirc);
 			ret = H_PARAMETER;
 			goto modify_qp_exit1;
 		}
@@ -1129,7 +1129,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 		ret = prepare_sqe_rts(my_qp, shca, &bad_wqe_cnt);
 		if (ret) {
 			ehca_err(ibqp->device, "prepare_sqe_rts() failed "
-				 "ehca_qp=%p qp_num=%x ret=%x",
+				 "ehca_qp=%p qp_num=%x ret=%i",
 				 my_qp, ibqp->qp_num, ret);
 			goto modify_qp_exit2;
 		}
@@ -1354,7 +1354,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
-		ehca_err(ibqp->device, "hipz_h_modify_qp() failed rc=%lx "
+		ehca_err(ibqp->device, "hipz_h_modify_qp() failed h_ret=%li "
 			 "ehca_qp=%p qp_num=%x", h_ret, my_qp, ibqp->qp_num);
 		goto modify_qp_exit2;
 	}
@@ -1387,7 +1387,7 @@ static int internal_modify_qp(struct ib_qp *ibqp,
 			ret = ehca2ib_return_code(h_ret);
 			ehca_err(ibqp->device, "ENABLE in context of "
 				 "RESET_2_INIT failed! Maybe you didn't get "
-				 "a LID h_ret=%lx ehca_qp=%p qp_num=%x",
+				 "a LID h_ret=%li ehca_qp=%p qp_num=%x",
 				 h_ret, my_qp, ibqp->qp_num);
 			goto modify_qp_exit2;
 		}
@@ -1475,7 +1475,7 @@ int ehca_query_qp(struct ib_qp *qp,
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
 		ehca_err(qp->device, "hipz_h_query_qp() failed "
-			 "ehca_qp=%p qp_num=%x h_ret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, qp->qp_num, h_ret);
 		goto query_qp_exit1;
 	}
@@ -1650,7 +1650,7 @@ int ehca_modify_srq(struct ib_srq *ibsrq, struct ib_srq_attr *attr,
 
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
-		ehca_err(ibsrq->device, "hipz_h_modify_qp() failed rc=%lx "
+		ehca_err(ibsrq->device, "hipz_h_modify_qp() failed h_ret=%li "
 			 "ehca_qp=%p qp_num=%x",
 			 h_ret, my_qp, my_qp->real_qp_num);
 	}
@@ -1693,7 +1693,7 @@ int ehca_query_srq(struct ib_srq *srq, struct ib_srq_attr *srq_attr)
 	if (h_ret != H_SUCCESS) {
 		ret = ehca2ib_return_code(h_ret);
 		ehca_err(srq->device, "hipz_h_query_qp() failed "
-			 "ehca_qp=%p qp_num=%x h_ret=%lx",
+			 "ehca_qp=%p qp_num=%x h_ret=%li",
 			 my_qp, my_qp->real_qp_num, h_ret);
 		goto query_srq_exit1;
 	}
@@ -1743,7 +1743,7 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 		ret = ehca_cq_unassign_qp(my_qp->send_cq, qp_num);
 		if (ret) {
 			ehca_err(dev, "Couldn't unassign qp from "
-				 "send_cq ret=%x qp_num=%x cq_num=%x", ret,
+				 "send_cq ret=%i qp_num=%x cq_num=%x", ret,
 				 qp_num, my_qp->send_cq->cq_number);
 			return ret;
 		}
@@ -1755,7 +1755,7 @@ static int internal_destroy_qp(struct ib_device *dev, struct ehca_qp *my_qp,
 
 	h_ret = hipz_h_destroy_qp(shca->ipz_hca_handle, my_qp);
 	if (h_ret != H_SUCCESS) {
-		ehca_err(dev, "hipz_h_destroy_qp() failed rc=%lx "
+		ehca_err(dev, "hipz_h_destroy_qp() failed h_ret=%li "
 			 "ehca_qp=%p qp_num=%x", h_ret, my_qp, qp_num);
 		return ehca2ib_return_code(h_ret);
 	}
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 94eed70..ea91360 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -526,7 +526,7 @@ poll_cq_one_read_cqe:
 	if (!cqe) {
 		ret = -EAGAIN;
 		ehca_dbg(cq->device, "Completion queue is empty ehca_cq=%p "
-			 "cq_num=%x ret=%x", my_cq, my_cq->cq_number, ret);
+			 "cq_num=%x ret=%i", my_cq, my_cq->cq_number, ret);
 		goto  poll_cq_one_exit0;
 	}
 
diff --git a/drivers/infiniband/hw/ehca/ehca_sqp.c b/drivers/infiniband/hw/ehca/ehca_sqp.c
index 9f16e9c..f0792e5 100644
--- a/drivers/infiniband/hw/ehca/ehca_sqp.c
+++ b/drivers/infiniband/hw/ehca/ehca_sqp.c
@@ -82,7 +82,7 @@ u64 ehca_define_sqp(struct ehca_shca *shca,
 
 		if (ret != H_SUCCESS) {
 			ehca_err(&shca->ib_device,
-				 "Can't define AQP1 for port %x. rc=%lx",
+				 "Can't define AQP1 for port %x. h_ret=%li",
 				 port, ret);
 			return ret;
 		}
diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
index 84a16bc..5234d6c 100644
--- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
+++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
@@ -121,7 +121,7 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
 	ret = remap_4k_pfn(vma, vma->vm_start, physical >> EHCA_PAGESHIFT,
 			   vma->vm_page_prot);
 	if (unlikely(ret)) {
-		ehca_gen_err("remap_pfn_range() failed ret=%x", ret);
+		ehca_gen_err("remap_pfn_range() failed ret=%i", ret);
 		return -ENOMEM;
 	}
 
@@ -146,7 +146,7 @@ static int ehca_mmap_queue(struct vm_area_struct *vma, struct ipz_queue *queue,
 		page = virt_to_page(virt_addr);
 		ret = vm_insert_page(vma, start, page);
 		if (unlikely(ret)) {
-			ehca_gen_err("vm_insert_page() failed rc=%x", ret);
+			ehca_gen_err("vm_insert_page() failed rc=%i", ret);
 			return ret;
 		}
 		start += PAGE_SIZE;
@@ -169,7 +169,7 @@ static int ehca_mmap_cq(struct vm_area_struct *vma, struct ehca_cq *cq,
 		ret = ehca_mmap_fw(vma, &cq->galpas, &cq->mm_count_galpa);
 		if (unlikely(ret)) {
 			ehca_err(cq->ib_cq.device,
-				 "ehca_mmap_fw() failed rc=%x cq_num=%x",
+				 "ehca_mmap_fw() failed rc=%i cq_num=%x",
 				 ret, cq->cq_number);
 			return ret;
 		}
@@ -180,7 +180,7 @@ static int ehca_mmap_cq(struct vm_area_struct *vma, struct ehca_cq *cq,
 		ret = ehca_mmap_queue(vma, &cq->ipz_queue, &cq->mm_count_queue);
 		if (unlikely(ret)) {
 			ehca_err(cq->ib_cq.device,
-				 "ehca_mmap_queue() failed rc=%x cq_num=%x",
+				 "ehca_mmap_queue() failed rc=%i cq_num=%x",
 				 ret, cq->cq_number);
 			return ret;
 		}
@@ -206,7 +206,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 		ret = ehca_mmap_fw(vma, &qp->galpas, &qp->mm_count_galpa);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
-				 "remap_pfn_range() failed ret=%x qp_num=%x",
+				 "remap_pfn_range() failed ret=%i qp_num=%x",
 				 ret, qp->ib_qp.qp_num);
 			return -ENOMEM;
 		}
@@ -219,7 +219,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 				      &qp->mm_count_rqueue);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
-				 "ehca_mmap_queue(rq) failed rc=%x qp_num=%x",
+				 "ehca_mmap_queue(rq) failed rc=%i qp_num=%x",
 				 ret, qp->ib_qp.qp_num);
 			return ret;
 		}
@@ -232,7 +232,7 @@ static int ehca_mmap_qp(struct vm_area_struct *vma, struct ehca_qp *qp,
 				      &qp->mm_count_squeue);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
-				 "ehca_mmap_queue(sq) failed rc=%x qp_num=%x",
+				 "ehca_mmap_queue(sq) failed rc=%i qp_num=%x",
 				 ret, qp->ib_qp.qp_num);
 			return ret;
 		}
@@ -283,7 +283,7 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		ret = ehca_mmap_cq(vma, cq, rsrc_type);
 		if (unlikely(ret)) {
 			ehca_err(cq->ib_cq.device,
-				 "ehca_mmap_cq() failed rc=%x cq_num=%x",
+				 "ehca_mmap_cq() failed rc=%i cq_num=%x",
 				 ret, cq->cq_number);
 			return ret;
 		}
@@ -313,7 +313,7 @@ int ehca_mmap(struct ib_ucontext *context, struct vm_area_struct *vma)
 		ret = ehca_mmap_qp(vma, qp, rsrc_type);
 		if (unlikely(ret)) {
 			ehca_err(qp->ib_qp.device,
-				 "ehca_mmap_qp() failed rc=%x qp_num=%x",
+				 "ehca_mmap_qp() failed rc=%i qp_num=%x",
 				 ret, qp->ib_qp.qp_num);
 			return ret;
 		}
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index 32f465b..a70a5ed 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -238,7 +238,7 @@ u64 hipz_h_alloc_resource_eq(const struct ipz_adapter_handle adapter_handle,
 	*eq_ist = (u32)outs[5];
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
-		ehca_gen_err("Not enough resource - ret=%lx ", ret);
+		ehca_gen_err("Not enough resource - ret=%li ", ret);
 
 	return ret;
 }
@@ -276,7 +276,7 @@ u64 hipz_h_alloc_resource_cq(const struct ipz_adapter_handle adapter_handle,
 		hcp_galpas_ctor(&cq->galpas, outs[5], outs[6]);
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
-		ehca_gen_err("Not enough resources. ret=%lx", ret);
+		ehca_gen_err("Not enough resources. ret=%li", ret);
 
 	return ret;
 }
@@ -351,7 +351,7 @@ u64 hipz_h_alloc_resource_qp(const struct ipz_adapter_handle adapter_handle,
 		hcp_galpas_ctor(&parms->galpas, outs[6], outs[6]);
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
-		ehca_gen_err("Not enough resources. ret=%lx", ret);
+		ehca_gen_err("Not enough resources. ret=%li", ret);
 
 	return ret;
 }
@@ -546,7 +546,7 @@ u64 hipz_h_modify_qp(const struct ipz_adapter_handle adapter_handle,
 				0, 0, 0, 0, 0);
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
-		ehca_gen_err("Insufficient resources ret=%lx", ret);
+		ehca_gen_err("Insufficient resources ret=%li", ret);
 
 	return ret;
 }
@@ -582,7 +582,7 @@ u64 hipz_h_destroy_qp(const struct ipz_adapter_handle adapter_handle,
 				qp->ipz_qp_handle.handle,  /* r6 */
 				0, 0, 0, 0, 0, 0);
 	if (ret == H_HARDWARE)
-		ehca_gen_err("HCA not operational. ret=%lx", ret);
+		ehca_gen_err("HCA not operational. ret=%li", ret);
 
 	ret = ehca_plpar_hcall_norets(H_FREE_RESOURCE,
 				      adapter_handle.handle,     /* r4 */
@@ -590,7 +590,7 @@ u64 hipz_h_destroy_qp(const struct ipz_adapter_handle adapter_handle,
 				      0, 0, 0, 0, 0);
 
 	if (ret == H_RESOURCE)
-		ehca_gen_err("Resource still in use. ret=%lx", ret);
+		ehca_gen_err("Resource still in use. ret=%li", ret);
 
 	return ret;
 }
@@ -625,7 +625,7 @@ u64 hipz_h_define_aqp1(const struct ipz_adapter_handle adapter_handle,
 	*bma_qp_nr = (u32)outs[1];
 
 	if (ret == H_ALIAS_EXIST)
-		ehca_gen_err("AQP1 already exists. ret=%lx", ret);
+		ehca_gen_err("AQP1 already exists. ret=%li", ret);
 
 	return ret;
 }
@@ -647,7 +647,7 @@ u64 hipz_h_attach_mcqp(const struct ipz_adapter_handle adapter_handle,
 				      0, 0);
 
 	if (ret == H_NOT_ENOUGH_RESOURCES)
-		ehca_gen_err("Not enough resources. ret=%lx", ret);
+		ehca_gen_err("Not enough resources. ret=%li", ret);
 
 	return ret;
 }
@@ -686,7 +686,7 @@ u64 hipz_h_destroy_cq(const struct ipz_adapter_handle adapter_handle,
 				      0, 0, 0, 0);
 
 	if (ret == H_RESOURCE)
-		ehca_gen_err("H_FREE_RESOURCE failed ret=%lx ", ret);
+		ehca_gen_err("H_FREE_RESOURCE failed ret=%li ", ret);
 
 	return ret;
 }
@@ -708,7 +708,7 @@ u64 hipz_h_destroy_eq(const struct ipz_adapter_handle adapter_handle,
 				      0, 0, 0, 0, 0);
 
 	if (ret == H_RESOURCE)
-		ehca_gen_err("Resource in use. ret=%lx ", ret);
+		ehca_gen_err("Resource in use. ret=%li ", ret);
 
 	return ret;
 }
-- 
1.5.2


