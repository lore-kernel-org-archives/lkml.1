Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736Ab0A0RDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab0A0RDO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 12:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717Ab0A0RDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 12:03:13 -0500
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:58266 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704Ab0A0RDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 12:03:12 -0500
Date: Wed, 27 Jan 2010 18:03:08 +0100
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, Linux RDMA <linux-rdma@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Joachim Fenkes <fenkes@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       David Wilder <wilder@us.ibm.com>
Subject: [PATCH 2/2] ib/ehca: allow access for ib_query_qp()
Message-ID: <20100127180308.5155480d@alex-laptop>
In-Reply-To: <20100127180035.779b24d1@alex-laptop>
References: <20100127180035.779b24d1@alex-laptop>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max_dest_rd_atomic and max_qp_rd_atomic values are
properly returned by query_qp(), so there should not be
an error returned when they are queried.

Signed-off-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/ehca/ehca_qp.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.orig/drivers/infiniband/hw/ehca/ehca_qp.c
+++ linux-2.6/drivers/infiniband/hw/ehca/ehca_qp.c
@@ -55,9 +55,7 @@ static struct kmem_cache *qp_cache;
 /*
  * attributes not supported by query qp
  */
-#define QP_ATTR_QUERY_NOT_SUPPORTED (IB_QP_MAX_DEST_RD_ATOMIC | \
-				     IB_QP_MAX_QP_RD_ATOMIC   | \
-				     IB_QP_ACCESS_FLAGS       | \
+#define QP_ATTR_QUERY_NOT_SUPPORTED (IB_QP_ACCESS_FLAGS       | \
 				     IB_QP_EN_SQD_ASYNC_NOTIFY)
 
 /*
