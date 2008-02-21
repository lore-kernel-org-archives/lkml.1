Return-Path: <linux-kernel-owner+w=401wt.eu-S1762467AbYBUNYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762467AbYBUNYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932931AbYBUNXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:23:44 -0500
Received: from 75.neteffect.com ([204.57.75.75]:63941 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932922AbYBUNXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:23:43 -0500
Date: Thu, 21 Feb 2008 08:17:54 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211417.m1LEHsQu005081@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 5/8] infiniband/hw/nes/nes_verbs.c: fix use-after-free
Cc: bunk@kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk flagged this check-after-use issue spotted by the 
Coverity checker.

Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 692f0d8..a651e9d 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -1832,9 +1832,6 @@ static struct ib_cq *nes_create_cq(struct ib_device *ibdev, int entries,
 				spin_unlock_irqrestore(&nesdev->cqp.lock, flags);
 			}
 		}
-		nes_debug(NES_DBG_CQ, "iWARP CQ%u create timeout expired, major code = 0x%04X,"
-				" minor code = 0x%04X\n",
-				nescq->hw_cq.cq_number, cqp_request->major_code, cqp_request->minor_code);
 		if (!context)
 			pci_free_consistent(nesdev->pcidev, nescq->cq_mem_size, mem,
 					nescq->hw_cq.cq_pbase);
