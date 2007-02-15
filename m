Return-Path: <linux-kernel-owner+w=401wt.eu-S966020AbXBOQGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966020AbXBOQGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 11:06:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966019AbXBOQGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 11:06:47 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:48571 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966020AbXBOQGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 11:06:46 -0500
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org,
       bos@pathscale.com
Subject: [PATCH 2.6.21-rc1 5/5] ehca: query_port() returns LINK_UP instead UNKNOWN
Date: Thu, 15 Feb 2007 17:10:06 +0100
User-Agent: KMail/1.8.2
Cc: raisch@de.ibm.com, heiko.carstens@de.ibm.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702151710.06432.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

set port phys state as a result of ehca_query_port() to LINK_UP.
On pSeries ehca actually represents a logical HCA, whose phys/link state 
always is LINK_UP.


Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
---


 ehca_hca.c |    3 +++
 1 files changed, 3 insertions(+)


diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index b7be950..30eb45d 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -162,6 +162,9 @@ int ehca_query_port(struct ib_device *ib
 	props->active_width    = IB_WIDTH_12X;
 	props->active_speed    = 0x1;
 
+	/* at the moment (logical) link state is always LINK_UP */
+	props->phys_state      = 0x5;
+
 query_port1:
 	ehca_free_fw_ctrlblock(rblock);
 

