Return-Path: <linux-kernel-owner+w=401wt.eu-S936771AbXG0KnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936771AbXG0KnV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 06:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbXG0KnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 06:43:14 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:23398 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760084AbXG0KnN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 06:43:13 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, general@lists.openfabrics.org
Subject: [PATCH 1/2] ehca: remove checkpatch.pl's warnings "externs should be avoided in .c files"
Date: Fri, 27 Jul 2007 12:54:50 +0200
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, stefan.roscher@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707271254.51055.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From b5d0336089b5ebe5b18acb94b2c94c2026cb95ee Mon Sep 17 00:00:00 2001
From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>
Date: Fri, 27 Jul 2007 10:24:49 +0200
Subject: [PATCH] remove checkpatch.pl's warnings "externs should be avoided in .c files"

Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_classes.h |    1 +
 drivers/infiniband/hw/ehca/ehca_mrmw.c    |    2 --
 drivers/infiniband/hw/ehca/ehca_pd.c      |    1 -
 drivers/infiniband/hw/ehca/hcp_if.c       |    1 -
 drivers/infiniband/hw/ehca/ipz_pt_fn.h    |    2 ++
 5 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
index 3725aa8..b5e9603 100644
--- a/drivers/infiniband/hw/ehca/ehca_classes.h
+++ b/drivers/infiniband/hw/ehca/ehca_classes.h
@@ -322,6 +322,7 @@ extern int ehca_static_rate;
 extern int ehca_port_act_time;
 extern int ehca_use_hp_mr;
 extern int ehca_scaling_code;
+extern int ehca_mr_largepage;
 
 struct ipzu_queue_resp {
 	u32 qe_size;      /* queue entry size */
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index c1b868b..773ac3f 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -64,8 +64,6 @@ enum ehca_mr_pgsize {
 	EHCA_MR_PGSIZE16M = 0x1000000L
 };
 
-extern int ehca_mr_largepage;
-
 static u32 ehca_encode_hwpage_size(u32 pgsize)
 {
 	u32 idx = 0;
diff --git a/drivers/infiniband/hw/ehca/ehca_pd.c b/drivers/infiniband/hw/ehca/ehca_pd.c
index 3dafd7f..43bcf08 100644
--- a/drivers/infiniband/hw/ehca/ehca_pd.c
+++ b/drivers/infiniband/hw/ehca/ehca_pd.c
@@ -88,7 +88,6 @@ int ehca_dealloc_pd(struct ib_pd *pd)
 	u32 cur_pid = current->tgid;
 	struct ehca_pd *my_pd = container_of(pd, struct ehca_pd, ib_pd);
 	int i, leftovers = 0;
-	extern struct kmem_cache *small_qp_cache;
 	struct ipz_small_queue_page *page, *tmp;
 
 	if (my_pd->ib_pd.uobject && my_pd->ib_pd.uobject->context &&
diff --git a/drivers/infiniband/hw/ehca/hcp_if.c b/drivers/infiniband/hw/ehca/hcp_if.c
index fdbfebe..24f4541 100644
--- a/drivers/infiniband/hw/ehca/hcp_if.c
+++ b/drivers/infiniband/hw/ehca/hcp_if.c
@@ -758,7 +758,6 @@ u64 hipz_h_register_rpage_mr(const struct ipz_adapter_handle adapter_handle,
 			     const u64 logical_address_of_page,
 			     const u64 count)
 {
-	extern int ehca_debug_level;
 	u64 ret;
 
 	if (unlikely(ehca_debug_level >= 2)) {
diff --git a/drivers/infiniband/hw/ehca/ipz_pt_fn.h b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
index c6937a0..a801274 100644
--- a/drivers/infiniband/hw/ehca/ipz_pt_fn.h
+++ b/drivers/infiniband/hw/ehca/ipz_pt_fn.h
@@ -54,6 +54,8 @@
 struct ehca_pd;
 struct ipz_small_queue_page;
 
+extern struct kmem_cache *small_qp_cache;
+
 /* struct generic ehca page */
 struct ipz_page {
 	u8 entries[EHCA_PAGESIZE];
-- 
1.5.2




