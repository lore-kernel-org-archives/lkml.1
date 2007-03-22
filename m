Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbXCVPiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbXCVPiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbXCVPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:38:22 -0400
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:41986 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933232AbXCVPiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:38:21 -0400
Subject: [PATCH 2.6.21] iw_cxgb3: Handle build_phys_page_list() failure in
	iwch_reregister_phys_mem().
From: Steve Wise <swise@opengridcomputing.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Netdev@vger.kernel.org,
       General@lists.openfabrics.org, Adrian Bunk <bunk@stusta.de>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 10:38:20 -0500
Message-Id: <1174577900.16862.27.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Handle build_phys_page_list() failure in iwch_reregister_phys_mem().

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/infiniband/hw/cxgb3/iwch_provider.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index f2774ae..24e0df0 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -545,11 +545,14 @@ static int iwch_reregister_phys_mem(stru
 		php = to_iwch_pd(pd);
 	if (mr_rereg_mask & IB_MR_REREG_ACCESS)
 		mh.attr.perms = iwch_ib_to_tpt_access(acc);
-	if (mr_rereg_mask & IB_MR_REREG_TRANS)
+	if (mr_rereg_mask & IB_MR_REREG_TRANS) {
 		ret = build_phys_page_list(buffer_list, num_phys_buf,
 					   iova_start,
 					   &total_size, &npages,
 					   &shift, &page_list);
+		if (ret)
+			return ret;
+	}
 
 	ret = iwch_reregister_mem(rhp, php, &mh, shift, page_list, npages);
 	kfree(page_list);

