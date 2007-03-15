Return-Path: <linux-kernel-owner+w=401wt.eu-S933879AbXCOWP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879AbXCOWP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933887AbXCOWPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:36 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33694 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411AbXCOWP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 33] IB/ipath - fix case where SRQ limit event causes CQ
	entry to be dropped
X-Mercurial-Node: fa38a027a0853a80c4f7dfc50345c89f195bc85b
Message-Id: <fa38a027a0853a80c4f7.1173995089@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:44:49 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Ralph Campbell <ralph.campbell@qlogic.com>
# Date 1173994464 25200
# Node ID fa38a027a0853a80c4f7dfc50345c89f195bc85b
# Parent  d90faa722f120e0896aff3643a623b1e0c0c69d0
IB/ipath - fix case where SRQ limit event causes CQ entry to be dropped

A silly programming error causes a CQ entry to not be generated if a
SRQ limit event is generated.

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r d90faa722f12 -r fa38a027a085 drivers/infiniband/hw/ipath/ipath_ruc.c
--- a/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ruc.c	Thu Mar 15 14:34:24 2007 -0700
@@ -202,6 +202,7 @@ int ipath_get_rwqe(struct ipath_qp *qp, 
 	wq->tail = tail;
 
 	ret = 1;
+	qp->r_wrid_valid = 1;
 	if (handler) {
 		u32 n;
 
@@ -229,7 +230,6 @@ int ipath_get_rwqe(struct ipath_qp *qp, 
 		}
 	}
 	spin_unlock_irqrestore(&rq->lock, flags);
-	qp->r_wrid_valid = 1;
 
 bail:
 	return ret;
