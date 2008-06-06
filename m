Return-Path: <linux-kernel-owner+w=401wt.eu-S932121AbYFFRDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbYFFRDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 13:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758645AbYFFRDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 13:03:10 -0400
Received: from relay2.sgi.com ([192.48.171.30]:59570 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755571AbYFFRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 13:03:08 -0400
Date: Fri, 6 Jun 2008 12:03:07 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 18/18] add _sn2 suffix to a few variables
Message-ID: <20080606170307.GS13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606164034.GA13695@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an '_sn2' suffix to some variables found in xpc_sn2.c.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xpc_sn2.c |  124 +++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 59 deletions(-)

Index: linux-2.6/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-06 08:04:57.994324350 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xpc_sn2.c	2008-06-06 08:05:03.463001668 -0500
@@ -56,15 +56,15 @@
 static char *xpc_remote_copy_buffer_sn2;
 static void *xpc_remote_copy_buffer_base_sn2;
 
-static struct xpc_vars_sn2 *xpc_vars;	/* >>> Add _sn2 suffix? */
-static struct xpc_vars_part_sn2 *xpc_vars_part; /* >>> Add _sn2 suffix? */
+static struct xpc_vars_sn2 *xpc_vars_sn2;
+static struct xpc_vars_part_sn2 *xpc_vars_part_sn2;
 
 /* SH_IPI_ACCESS shub register value on startup */
-static u64 xpc_sh1_IPI_access;
-static u64 xpc_sh2_IPI_access0;
-static u64 xpc_sh2_IPI_access1;
-static u64 xpc_sh2_IPI_access2;
-static u64 xpc_sh2_IPI_access3;
+static u64 xpc_sh1_IPI_access_sn2;
+static u64 xpc_sh2_IPI_access0_sn2;
+static u64 xpc_sh2_IPI_access1_sn2;
+static u64 xpc_sh2_IPI_access2_sn2;
+static u64 xpc_sh2_IPI_access3_sn2;
 
 /*
  * Change protections to allow IPI operations.
@@ -77,13 +77,13 @@ xpc_allow_IPI_ops_sn2(void)
 
 	/* >>> The following should get moved into SAL. */
 	if (is_shub2()) {
-		xpc_sh2_IPI_access0 =
+		xpc_sh2_IPI_access0_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS0));
-		xpc_sh2_IPI_access1 =
+		xpc_sh2_IPI_access1_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS1));
-		xpc_sh2_IPI_access2 =
+		xpc_sh2_IPI_access2_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS2));
-		xpc_sh2_IPI_access3 =
+		xpc_sh2_IPI_access3_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH2_IPI_ACCESS3));
 
 		for_each_online_node(node) {
@@ -98,7 +98,7 @@ xpc_allow_IPI_ops_sn2(void)
 			      -1UL);
 		}
 	} else {
-		xpc_sh1_IPI_access =
+		xpc_sh1_IPI_access_sn2 =
 		    (u64)HUB_L((u64 *)LOCAL_MMR_ADDR(SH1_IPI_ACCESS));
 
 		for_each_online_node(node) {
@@ -123,19 +123,19 @@ xpc_disallow_IPI_ops_sn2(void)
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS0),
-			      xpc_sh2_IPI_access0);
+			      xpc_sh2_IPI_access0_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS1),
-			      xpc_sh2_IPI_access1);
+			      xpc_sh2_IPI_access1_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS2),
-			      xpc_sh2_IPI_access2);
+			      xpc_sh2_IPI_access2_sn2);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH2_IPI_ACCESS3),
-			      xpc_sh2_IPI_access3);
+			      xpc_sh2_IPI_access3_sn2);
 		}
 	} else {
 		for_each_online_node(node) {
 			nasid = cnodeid_to_nasid(node);
 			HUB_S((u64 *)GLOBAL_MMR_ADDR(nasid, SH1_IPI_ACCESS),
-			      xpc_sh1_IPI_access);
+			      xpc_sh1_IPI_access_sn2);
 		}
 	}
 }
@@ -182,7 +182,7 @@ xpc_send_IRQ_sn2(struct amo *amo, u64 fl
 static struct amo *
 xpc_init_IRQ_amo_sn2(int index)
 {
-	struct amo *amo = xpc_vars->amos_page + index;
+	struct amo *amo = xpc_vars_sn2->amos_page + index;
 
 	(void)xpc_receive_IRQ_amo_sn2(amo);	/* clear amo variable */
 	return amo;
@@ -225,7 +225,7 @@ xpc_send_local_activate_IRQ_sn2(int from
 {
 	int w_index = XPC_NASID_W_INDEX(from_nasid);
 	int b_index = XPC_NASID_B_INDEX(from_nasid);
-	struct amo *amos = (struct amo *)__va(xpc_vars->amos_page_pa +
+	struct amo *amos = (struct amo *)__va(xpc_vars_sn2->amos_page_pa +
 					      (XPC_ACTIVATE_IRQ_AMOS_SN2 *
 					      sizeof(struct amo)));
 
@@ -492,7 +492,8 @@ xpc_indicate_partition_disengaged_sn2(st
 static int
 xpc_partition_engaged_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
@@ -502,7 +503,8 @@ xpc_partition_engaged_sn2(short partid)
 static int
 xpc_any_partition_engaged_sn2(void)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* our partition's amo variable */
 	return FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) != 0;
@@ -511,7 +513,8 @@ xpc_any_partition_engaged_sn2(void)
 static void
 xpc_assume_partition_disengaged_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_ENGAGED_PARTITIONS_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_ENGAGED_PARTITIONS_AMO_SN2;
 
 	/* clear bit(s) based on partid mask in our partition's amo */
 	FETCHOP_STORE_OP(TO_AMO((u64)&amo->variable), FETCHOP_AND,
@@ -580,27 +583,27 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 	int i;
 	int ret;
 
-	xpc_vars = XPC_RP_VARS(rp);
+	xpc_vars_sn2 = XPC_RP_VARS(rp);
 
-	rp->sn.vars_pa = __pa(xpc_vars);
+	rp->sn.vars_pa = __pa(xpc_vars_sn2);
 
 	/* vars_part array follows immediately after vars */
-	xpc_vars_part = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
-						     XPC_RP_VARS_SIZE);
+	xpc_vars_part_sn2 = (struct xpc_vars_part_sn2 *)((u8 *)XPC_RP_VARS(rp) +
+							 XPC_RP_VARS_SIZE);
 
 	/*
-	 * Before clearing xpc_vars, see if a page of amos had been previously
-	 * allocated. If not we'll need to allocate one and set permissions
-	 * so that cross-partition amos are allowed.
+	 * Before clearing xpc_vars_sn2, see if a page of amos had been
+	 * previously allocated. If not we'll need to allocate one and set
+	 * permissions so that cross-partition amos are allowed.
 	 *
 	 * The allocated amo page needs MCA reporting to remain disabled after
 	 * XPC has unloaded.  To make this work, we keep a copy of the pointer
-	 * to this page (i.e., amos_page) in the struct xpc_vars structure,
+	 * to this page (i.e., amos_page) in the struct xpc_vars_sn2 structure,
 	 * which is pointed to by the reserved page, and re-use that saved copy
 	 * on subsequent loads of XPC. This amo page is never freed, and its
 	 * memory protections are never restricted.
 	 */
-	amos_page = xpc_vars->amos_page;
+	amos_page = xpc_vars_sn2->amos_page;
 	if (amos_page == NULL) {
 		amos_page = (struct amo *)TO_AMO(uncached_alloc_page(0, 1));
 		if (amos_page == NULL) {
@@ -621,18 +624,18 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 		}
 	}
 
-	/* clear xpc_vars */
-	memset(xpc_vars, 0, sizeof(struct xpc_vars_sn2));
+	/* clear xpc_vars_sn2 */
+	memset(xpc_vars_sn2, 0, sizeof(struct xpc_vars_sn2));
 
-	xpc_vars->version = XPC_V_VERSION;
-	xpc_vars->activate_IRQ_nasid = cpuid_to_nasid(0);
-	xpc_vars->activate_IRQ_phys_cpuid = cpu_physical_id(0);
-	xpc_vars->vars_part_pa = __pa(xpc_vars_part);
-	xpc_vars->amos_page_pa = ia64_tpa((u64)amos_page);
-	xpc_vars->amos_page = amos_page;	/* save for next load of XPC */
+	xpc_vars_sn2->version = XPC_V_VERSION;
+	xpc_vars_sn2->activate_IRQ_nasid = cpuid_to_nasid(0);
+	xpc_vars_sn2->activate_IRQ_phys_cpuid = cpu_physical_id(0);
+	xpc_vars_sn2->vars_part_pa = __pa(xpc_vars_part_sn2);
+	xpc_vars_sn2->amos_page_pa = ia64_tpa((u64)amos_page);
+	xpc_vars_sn2->amos_page = amos_page;	/* save for next load of XPC */
 
-	/* clear xpc_vars_part */
-	memset((u64 *)xpc_vars_part, 0, sizeof(struct xpc_vars_part_sn2) *
+	/* clear xpc_vars_part_sn2 */
+	memset((u64 *)xpc_vars_part_sn2, 0, sizeof(struct xpc_vars_part_sn2) *
 	       xp_max_npartitions);
 
 	/* initialize the activate IRQ related amo variables */
@@ -649,30 +652,30 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 static void
 xpc_increment_heartbeat_sn2(void)
 {
-	xpc_vars->heartbeat++;
+	xpc_vars_sn2->heartbeat++;
 }
 
 static void
 xpc_offline_heartbeat_sn2(void)
 {
 	xpc_increment_heartbeat_sn2();
-	xpc_vars->heartbeat_offline = 1;
+	xpc_vars_sn2->heartbeat_offline = 1;
 }
 
 static void
 xpc_online_heartbeat_sn2(void)
 {
 	xpc_increment_heartbeat_sn2();
-	xpc_vars->heartbeat_offline = 0;
+	xpc_vars_sn2->heartbeat_offline = 0;
 }
 
 static void
 xpc_heartbeat_init_sn2(void)
 {
-	DBUG_ON(xpc_vars == NULL);
+	DBUG_ON(xpc_vars_sn2 == NULL);
 
-	bitmap_zero(xpc_vars->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
-	xpc_heartbeating_to_mask = &xpc_vars->heartbeating_to_mask[0];
+	bitmap_zero(xpc_vars_sn2->heartbeating_to_mask, XP_MAX_NPARTITIONS_SN2);
+	xpc_heartbeating_to_mask = &xpc_vars_sn2->heartbeating_to_mask[0];
 	xpc_online_heartbeat_sn2();
 }
 
@@ -845,7 +848,8 @@ xpc_cancel_partition_deactivation_reques
 static int
 xpc_partition_deactivation_requested_sn2(short partid)
 {
-	struct amo *amo = xpc_vars->amos_page + XPC_DEACTIVATE_REQUEST_AMO_SN2;
+	struct amo *amo = xpc_vars_sn2->amos_page +
+			  XPC_DEACTIVATE_REQUEST_AMO_SN2;
 
 	/* our partition's amo variable ANDed with partid mask */
 	return (FETCHOP_LOAD_OP(TO_AMO((u64)&amo->variable), FETCHOP_LOAD) &
@@ -1033,7 +1037,7 @@ xpc_identify_activate_IRQ_sender_sn2(voi
 	int n_IRQs_detected = 0;
 	struct amo *act_amos;
 
-	act_amos = xpc_vars->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
+	act_amos = xpc_vars_sn2->amos_page + XPC_ACTIVATE_IRQ_AMOS_SN2;
 
 	/* scan through act amo variable looking for non-zero entries */
 	for (word = 0; word < xpc_nasid_mask_words; word++) {
@@ -1261,15 +1265,17 @@ xpc_setup_infrastructure_sn2(struct xpc_
 	 * The setting of the magic # indicates that these per partition
 	 * specific variables are ready to be used.
 	 */
-	xpc_vars_part[partid].GPs_pa = __pa(part_sn2->local_GPs);
-	xpc_vars_part[partid].openclose_args_pa =
+	xpc_vars_part_sn2[partid].GPs_pa = __pa(part_sn2->local_GPs);
+	xpc_vars_part_sn2[partid].openclose_args_pa =
 	    __pa(part->local_openclose_args);
-	xpc_vars_part[partid].chctl_amo_pa = __pa(part_sn2->local_chctl_amo_va);
+	xpc_vars_part_sn2[partid].chctl_amo_pa =
+	    __pa(part_sn2->local_chctl_amo_va);
 	cpuid = raw_smp_processor_id();	/* any CPU in this partition will do */
-	xpc_vars_part[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
-	xpc_vars_part[partid].notify_IRQ_phys_cpuid = cpu_physical_id(cpuid);
-	xpc_vars_part[partid].nchannels = part->nchannels;
-	xpc_vars_part[partid].magic = XPC_VP_MAGIC1;
+	xpc_vars_part_sn2[partid].notify_IRQ_nasid = cpuid_to_nasid(cpuid);
+	xpc_vars_part_sn2[partid].notify_IRQ_phys_cpuid =
+	    cpu_physical_id(cpuid);
+	xpc_vars_part_sn2[partid].nchannels = part->nchannels;
+	xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC1;
 
 	return xpSuccess;
 
@@ -1316,7 +1322,7 @@ xpc_teardown_infrastructure_sn2(struct x
 	DBUG_ON(part->setup_state != XPC_P_SETUP);
 	part->setup_state = XPC_P_WTEARDOWN;
 
-	xpc_vars_part[partid].magic = 0;
+	xpc_vars_part_sn2[partid].magic = 0;
 
 	free_irq(SGI_XPC_NOTIFY, (void *)(u64)partid);
 
@@ -1432,7 +1438,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 		return xpRetry;
 	}
 
-	if (xpc_vars_part[partid].magic == XPC_VP_MAGIC1) {
+	if (xpc_vars_part_sn2[partid].magic == XPC_VP_MAGIC1) {
 
 		/* validate the variables */
 
@@ -1462,7 +1468,7 @@ xpc_pull_remote_vars_part_sn2(struct xpc
 
 		/* let the other side know that we've pulled their variables */
 
-		xpc_vars_part[partid].magic = XPC_VP_MAGIC2;
+		xpc_vars_part_sn2[partid].magic = XPC_VP_MAGIC2;
 	}
 
 	if (pulled_entry->magic == XPC_VP_MAGIC1)
