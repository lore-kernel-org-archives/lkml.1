Return-Path: <linux-kernel-owner+w=401wt.eu-S1757822AbXH2EJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757822AbXH2EJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbXH2EJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:09:29 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:18792 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbXH2EJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:09:28 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 2/2] iw_cxgb3 - dev->priv fix follow up
To: jeff@garzik.org, rdreier@cisco.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 28 Aug 2007 21:09:20 -0700
Message-ID: <20070829040920.2085.38426.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

The RDMA driver sitting on top of cxgb3 
now uses the exported function dev2t3cdev() 
to retrieve the the t3cdev associated with 
a net_device.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/infiniband/hw/cxgb3/cxio_hal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
index 1518b41..beb2a38 100644
--- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
@@ -916,7 +916,7 @@ int cxio_rdev_open(struct cxio_rdev *rdev_p)
 	PDBG("%s opening rnic dev %s\n", __FUNCTION__, rdev_p->dev_name);
 	memset(&rdev_p->ctrl_qp, 0, sizeof(rdev_p->ctrl_qp));
 	if (!rdev_p->t3cdev_p)
-		rdev_p->t3cdev_p = T3CDEV(netdev_p);
+		rdev_p->t3cdev_p = dev2t3cdev(netdev_p);
 	rdev_p->t3cdev_p->ulp = (void *) rdev_p;
 	err = rdev_p->t3cdev_p->ctl(rdev_p->t3cdev_p, RDMA_GET_PARAMS,
 					 &(rdev_p->rnic_info));
