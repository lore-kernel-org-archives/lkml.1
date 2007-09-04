Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbXIDK6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbXIDK6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 06:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbXIDK6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 06:58:40 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:33918 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753146AbXIDK6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 06:58:39 -0400
Date: Tue, 4 Sep 2007 13:00:00 +0200
From: aherrman@arcor.de
To: benh@kernel.crashing.org, linux-fbdev-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] radeonfb: fix setting of PPLL_REF_DIV for RV370 5B60
Message-ID: <20070904110000.GG7320@devil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As observed with various Radeon X300: console goes blank
without fixing setting of PPLL_REF_DIV.

Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
---
 drivers/video/aty/radeon_base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index f672c0c..71b0c17 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -1287,7 +1287,8 @@ static void radeon_write_pll_regs(struct radeonfb_info *rinfo, struct radeon_reg
 	if (rinfo->family == CHIP_FAMILY_R300 ||
 	    rinfo->family == CHIP_FAMILY_RS300 ||
 	    rinfo->family == CHIP_FAMILY_R350 ||
-	    rinfo->family == CHIP_FAMILY_RV350) {
+	    rinfo->family == CHIP_FAMILY_RV350 ||
+	    rinfo->family == CHIP_FAMILY_RV380 ) {
 		if (mode->ppll_ref_div & R300_PPLL_REF_DIV_ACC_MASK) {
 			/* When restoring console mode, use saved PPLL_REF_DIV
 			 * setting.
-- 
1.5.3


