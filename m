Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYEEPLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYEEPLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 11:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756205AbYEEPLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 11:11:38 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57709 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755640AbYEEPLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 11:11:37 -0400
From: Stefan Roscher <ossrosch@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "OF-EWG" <ewg@lists.openfabrics.org>
Subject: [PATCH] IB/ehca: Change function return types to correct type.
Date: Mon, 5 May 2008 17:11:13 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: raisch@de.ibm.com, fenkes@de.ibm.com, hnguyen@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051711.15281.ossrosch@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove duplicate assignment of local_ca_ack_delay
and change min_t check for local_ca_ack_delay to u8 instead of int.

Signed-off-by: Stefan Roscher <stefan.roscher at de.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_hca.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 2515cbd..bc3b37d 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -101,7 +101,6 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	props->max_ee          = limit_uint(rblock->max_rd_ee_context);
 	props->max_rdd         = limit_uint(rblock->max_rd_domain);
 	props->max_fmr         = limit_uint(rblock->max_mr);
-	props->local_ca_ack_delay  = limit_uint(rblock->local_ca_ack_delay);
 	props->max_qp_rd_atom  = limit_uint(rblock->max_rr_qp);
 	props->max_ee_rd_atom  = limit_uint(rblock->max_rr_ee_context);
 	props->max_res_rd_atom = limit_uint(rblock->max_rr_hca);
@@ -115,7 +114,7 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props)
 	}
 
 	props->max_pkeys           = 16;
-	props->local_ca_ack_delay  = limit_uint(rblock->local_ca_ack_delay);
+	props->local_ca_ack_delay  = min_t(u8, rblock->local_ca_ack_delay, 255);
 	props->max_raw_ipv6_qp     = limit_uint(rblock->max_raw_ipv6_qp);
 	props->max_raw_ethy_qp     = limit_uint(rblock->max_raw_ethy_qp);
 	props->max_mcast_grp       = limit_uint(rblock->max_mcast_grp);
@@ -136,7 +135,7 @@ query_device1:
 	return ret;
 }
 
-static int map_mtu(struct ehca_shca *shca, u32 fw_mtu)
+static enum ib_mtu map_mtu(struct ehca_shca *shca, u32 fw_mtu)
 {
 	switch (fw_mtu) {
 	case 0x1:
@@ -156,7 +155,7 @@ static int map_mtu(struct ehca_shca *shca, u32 fw_mtu)
 	}
 }
 
-static int map_number_of_vls(struct ehca_shca *shca, u32 vl_cap)
+static u8 map_number_of_vls(struct ehca_shca *shca, u32 vl_cap)
 {
 	switch (vl_cap) {
 	case 0x1:
-- 
1.5.5

