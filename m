Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbZFEISz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbZFEISz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755872AbZFEIGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:45 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37559 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbZFEIF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:58 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 37/62] Blackfin: add note about anomaly 05000242 being worked around
Date: Fri,  5 Jun 2009 04:04:46 -0400
Message-Id: <1244189111-19639-38-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document anomaly 05000242 workaround in source code.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/clocks-init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/clocks-init.c b/arch/blackfin/mach-common/clocks-init.c
index 3539365..ef6870e 100644
--- a/arch/blackfin/mach-common/clocks-init.c
+++ b/arch/blackfin/mach-common/clocks-init.c
@@ -72,6 +72,7 @@ void init_clocks(void)
 #endif
 	bfin_write_PLL_LOCKCNT(0x300);
 	do_sync();
+	/* We always write PLL_CTL thus avoiding Anomaly 05000242 */
 	bfin_write16(PLL_CTL, PLL_CTL_VAL);
 	__asm__ __volatile__("IDLE;");
 	bfin_write_PLL_DIV(CONFIG_CCLK_ACT_DIV | CONFIG_SCLK_DIV);
-- 
1.6.3.1

