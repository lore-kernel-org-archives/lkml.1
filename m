Return-Path: <linux-kernel-owner+w=401wt.eu-S933822AbXCOWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822AbXCOWXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422986AbXCOWXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:23:19 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33708 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764AbXCOWP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:28 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 08 of 33] IB/ipath - fix up some debug messages
X-Mercurial-Node: 187ff5af5e5dd2b1f2ca48ba6ad0056ce7fc7403
Message-Id: <187ff5af5e5dd2b1f2ca.1173995092@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:52 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Bryan O'Sullivan <bryan.osullivan@qlogic.com>
# Date 1173994464 25200
# Node ID 187ff5af5e5dd2b1f2ca48ba6ad0056ce7fc7403
# Parent  02b57b02578b7ffb189de66f7886214e9d5f2045
IB/ipath - fix up some debug messages

ipath_dbg doesn't need the same prefixes that printk does.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 02b57b02578b -r 187ff5af5e5d drivers/infiniband/hw/ipath/ipath_driver.c
--- a/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c	Thu Mar 15 14:34:24 2007 -0700
@@ -1989,7 +1989,8 @@ static int __init infinipath_init(void)
 {
 	int ret;
 
-	ipath_dbg(KERN_INFO DRIVER_LOAD_MSG "%s", ib_ipath_version);
+	if (ipath_debug & __IPATH_DBG)
+		printk(KERN_INFO DRIVER_LOAD_MSG "%s", ib_ipath_version);
 
 	/*
 	 * These must be called before the driver is registered with
diff -r 02b57b02578b -r 187ff5af5e5d drivers/infiniband/hw/ipath/ipath_keys.c
--- a/drivers/infiniband/hw/ipath/ipath_keys.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_keys.c	Thu Mar 15 14:34:24 2007 -0700
@@ -61,7 +61,7 @@ int ipath_alloc_lkey(struct ipath_lkey_t
 		r = (r + 1) & (rkt->max - 1);
 		if (r == n) {
 			spin_unlock_irqrestore(&rkt->lock, flags);
-			ipath_dbg(KERN_INFO "LKEY table full\n");
+			ipath_dbg("LKEY table full\n");
 			ret = 0;
 			goto bail;
 		}
diff -r 02b57b02578b -r 187ff5af5e5d drivers/infiniband/hw/ipath/ipath_qp.c
--- a/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_qp.c	Thu Mar 15 14:34:24 2007 -0700
@@ -274,7 +274,7 @@ void ipath_free_all_qps(struct ipath_qp_
 				free_qpn(qpt, qp->ibqp.qp_num);
 			if (!atomic_dec_and_test(&qp->refcount) ||
 			    !ipath_destroy_qp(&qp->ibqp))
-				ipath_dbg(KERN_INFO "QP memory leak!\n");
+				ipath_dbg("QP memory leak!\n");
 			qp = nqp;
 		}
 	}
@@ -369,7 +369,7 @@ void ipath_error_qp(struct ipath_qp *qp,
 	struct ipath_ibdev *dev = to_idev(qp->ibqp.device);
 	struct ib_wc wc;
 
-	ipath_dbg(KERN_INFO "QP%d/%d in error state\n",
+	ipath_dbg("QP%d/%d in error state\n",
 		  qp->ibqp.qp_num, qp->remote_qpn);
 
 	spin_lock(&dev->pending_lock);
@@ -980,7 +980,7 @@ void ipath_sqerror_qp(struct ipath_qp *q
 	struct ipath_ibdev *dev = to_idev(qp->ibqp.device);
 	struct ipath_swqe *wqe = get_swqe_ptr(qp, qp->s_last);
 
-	ipath_dbg(KERN_INFO "Send queue error on QP%d/%d: err: %d\n",
+	ipath_dbg("Send queue error on QP%d/%d: err: %d\n",
 		  qp->ibqp.qp_num, qp->remote_qpn, wc->status);
 
 	spin_lock(&dev->pending_lock);
