Return-Path: <linux-kernel-owner+w=401wt.eu-S1754831AbYIKMdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbYIKMdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 08:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYIKMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 08:33:05 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50936 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYIKMdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 08:33:04 -0400
Date: Thu, 11 Sep 2008 14:33:01 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: rolandd@cisco.com, sean.hefty@intel.com, hal.rosenstock@gmail.com,
       general@lists.openfabrics.org, vigneshbabu@gmail.com,
       richard.genoud@gmail.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/5] drivers/infiniband/hw: Drop code after return
Message-ID: <Pine.LNX.4.64.0809111432400.9593@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The break after the return serves no purpose.

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/infiniband/hw/amso1100/c2_provider.c |    1 -
 drivers/infiniband/hw/nes/nes_verbs.c        |    3 ---
 2 files changed, 4 deletions(-)

diff -u -p a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -272,7 +272,6 @@ static struct ib_qp *c2_create_qp(struct
 		pr_debug("%s: Invalid QP type: %d\n", __func__,
 			init_attr->qp_type);
 		return ERR_PTR(-EINVAL);
-		break;
 	}
 
 	if (err) {
diff -u -p a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1467,7 +1467,6 @@ static struct ib_qp *nes_create_qp(struc
 		default:
 			nes_debug(NES_DBG_QP, "Invalid QP type: %d\n", init_attr->qp_type);
 			return ERR_PTR(-EINVAL);
-			break;
 	}
 
 	/* update the QP table */
@@ -2498,7 +2497,6 @@ static struct ib_mr *nes_reg_user_mr(str
 			nes_debug(NES_DBG_MR, "Leaving, ibmr=%p", ibmr);
 
 			return ibmr;
-			break;
 		case IWNES_MEMREG_TYPE_QP:
 		case IWNES_MEMREG_TYPE_CQ:
 			nespbl = kzalloc(sizeof(*nespbl), GFP_KERNEL);
@@ -2572,7 +2570,6 @@ static struct ib_mr *nes_reg_user_mr(str
 			nesmr->ibmr.lkey = -1;
 			nesmr->mode = req.reg_type;
 			return &nesmr->ibmr;
-			break;
 	}
 
 	return ERR_PTR(-ENOSYS);
