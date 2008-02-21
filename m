Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbYBUNda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbYBUNda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 08:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbYBUNdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 08:33:23 -0500
Received: from 75.neteffect.com ([204.57.75.75]:64031 "EHLO
	velma.neteffect.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750792AbYBUNdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 08:33:22 -0500
Date: Thu, 21 Feb 2008 08:27:32 -0600
From: gstreiff@neteffect.com
Message-Id: <200802211427.m1LERWee005135@velma.neteffect.com>
To: rdreier@cisco.com
Subject: [PATCH 2.6 6/8] infiniband/hw/nes/nes_cm.c: Fix use-after-free
Cc: bunk@kernel.org, flatif@neteffect.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Faisal Latif <flatif@neteffect.com>

Use-after-free spotted by Coverity checker.  Flagged by Adrian Bunk.

Signed-off-by: Faisal Latif <flatif@neteffect.com>
Signed-off-by: Glenn Streiff <gstreiff@neteffect.com>

---
 drivers/infiniband/hw/nes/nes_cm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
index 78e845c..6c298aa 100644
--- a/drivers/infiniband/hw/nes/nes_cm.c
+++ b/drivers/infiniband/hw/nes/nes_cm.c
@@ -947,6 +947,7 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
 		nes_debug(NES_DBG_CM, "destroying listener (%p)\n", listener);
 
 		kfree(listener);
+		listener = NULL;
 		ret = 0;
 		cm_listens_destroyed++;
 	} else {
