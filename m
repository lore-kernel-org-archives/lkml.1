Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXDIVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXDIVu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbXDIVuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:50:51 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:27255 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030192AbXDIVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:23:46 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 15/18] ARM: OMAP: add SoSSI clock (call propagate_rate for childrens)
Date: Mon,  9 Apr 2007 17:22:20 -0400
Message-Id: <11761538013111-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761537971468-git-send-email-tony@atomide.com>
References: <11761537431635-git-send-email-tony@atomide.com> <117615374683-git-send-email-tony@atomide.com> <11761537491968-git-send-email-tony@atomide.com> <11761537522665-git-send-email-tony@atomide.com> <11761537563620-git-send-email-tony@atomide.com> <11761537613625-git-send-email-tony@atomide.com> <11761537672719-git-send-email-tony@atomide.com> <1176153771729-git-send-email-tony@atomide.com> <11761537743905-git-send-email-tony@atomide.com> <1176153781321-git-send-email-tony@atomide.com> <1176153783637-git-send-email-tony@atomide.com> <11761537863183-git-send-email-tony@atomide.com> <117615378995-git-send-email-tony@atomide.com> <11761537921036-git-send-email-tony@atomide.com> <11761537971468-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Imre Deak <imre.deak@solidboot.com>

Clocks with the follow parent rate mode were not updating their
children at propagate rate time.

Signed-off-by: Imre Deak <imre.deak@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/clock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -284,6 +284,8 @@ void followparent_recalc(struct clk *clk)
 		return;
 
 	clk->rate = clk->parent->rate;
+	if (unlikely(clk->flags & RATE_PROPAGATES))
+		propagate_rate(clk);
 }
 
 /* Propagate rate to children */
-- 
1.4.4.2

