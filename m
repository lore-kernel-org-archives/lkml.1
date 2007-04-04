Return-Path: <linux-kernel-owner+w=401wt.eu-S1422667AbXDDSUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422667AbXDDSUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934096AbXDDSNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:13:48 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39470 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934070AbXDDSNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:13 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Imre Deak <imre.deak@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 70/90] ARM: OMAP: add SoSSI clock (call propagate_rate for childrens)
Date: Wed,  4 Apr 2007 14:05:49 -0400
Message-Id: <11757101581123-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101563868-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
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

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 3d017b0..0a60324 100644
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

