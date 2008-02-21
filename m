Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbYBUNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbYBUNIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbYBUNHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:07:09 -0500
Received: from 75.neteffect.com ([204.57.75.75]:63725 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932660AbYBUNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:07:07 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Feb 2008 08:07:07 EST
Date: Thu, 21 Feb 2008 08:01:18 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211401.m1LE1I88004984@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 2/8] infiniband/hw/nes/nes_verbs.c: fix off-by-one
Cc: bunk@kernel.org, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes an off-by-one spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 201b95e..692f0d8 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -929,7 +929,7 @@ static struct ib_pd *nes_alloc_pd(struct ib_device *ibdev,
 				NES_MAX_USER_DB_REGIONS, nesucontext->first_free_db);
 		nes_debug(NES_DBG_PD, "find_first_zero_biton doorbells returned %u, mapping pd_id %u.\n",
 				nespd->mmap_db_index, nespd->pd_id);
-		if (nespd->mmap_db_index > NES_MAX_USER_DB_REGIONS) {
+		if (nespd->mmap_db_index >= NES_MAX_USER_DB_REGIONS) {
 			nes_debug(NES_DBG_PD, "mmap_db_index > MAX\n");
 			nes_free_resource(nesadapter, nesadapter->allocated_pds, pd_num);
 			kfree(nespd);
