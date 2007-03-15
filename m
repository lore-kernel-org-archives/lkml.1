Return-Path: <linux-kernel-owner+w=401wt.eu-S933929AbXCOWRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933929AbXCOWRi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933875AbXCOWPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:15:33 -0400
Received: from mx.pathscale.com ([198.186.3.68]:33690 "EHLO mx.pathscale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXCOWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:15:25 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 32 of 33] IB/ipath - check that a UD work request's address
	handle is valid
X-Mercurial-Node: c3b5b279bc90e5758da2ac382cbff4ee0245e84b
Message-Id: <c3b5b279bc90e5758da2.1173995116@iqa-25.internal.keyresearch.com>
In-Reply-To: <patchbomb.1173995084@iqa-25.internal.keyresearch.com>
Date: Thu, 15 Mar 2007 14:45:16 -0700
From: "Bryan O'Sullivan" <bos@pathscale.com>
To: rdreier@cisco.com
Cc: openib-general@openfabrics.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

# HG changeset patch
# User Robert Walsh <robert.walsh@qlogic.com>
# Date 1173994466 25200
# Node ID c3b5b279bc90e5758da2ac382cbff4ee0245e84b
# Parent  9f6468cddf59f26e087d100980a11ee9f1af4f56
IB/ipath - check that a UD work request's address handle is valid

Signed-off-by: Bryan O'Sullivan <bryan.osullivan@qlogic.com>

diff -r 9f6468cddf59 -r c3b5b279bc90 drivers/infiniband/hw/ipath/ipath_ud.c
--- a/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:25 2007 -0700
+++ b/drivers/infiniband/hw/ipath/ipath_ud.c	Thu Mar 15 14:34:26 2007 -0700
@@ -305,6 +305,11 @@ int ipath_post_ud_send(struct ipath_qp *
 
 	if (!(ib_ipath_state_ops[qp->state] & IPATH_PROCESS_SEND_OK)) {
 		ret = 0;
+		goto bail;
+	}
+
+	if (wr->wr.ud.ah->pd != qp->ibqp.pd) {
+		ret = -EPERM;
 		goto bail;
 	}
 
