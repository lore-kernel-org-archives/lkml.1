Return-Path: <linux-kernel-owner+w=401wt.eu-S1765575AbXEUKTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765575AbXEUKTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762026AbXEUKJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:49 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33581 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbXEUKJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:22 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510306:sNHT25599210"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 15/32] Blackfin arch: dont clear status register bits in SWRST so we can actually use it
Date: Mon, 21 May 2007 18:09:23 +0800
Message-Id: <11797421852163-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf533/head.S |    6 ------
 arch/blackfin/mach-bf537/head.S |    6 ------
 arch/blackfin/mach-bf561/head.S |    6 ------
 3 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/mach-bf533/head.S b/arch/blackfin/mach-bf533/head.S
index 4808edb..7cb8258 100644
--- a/arch/blackfin/mach-bf533/head.S
+++ b/arch/blackfin/mach-bf533/head.S
@@ -468,12 +468,6 @@ ENTRY(_bfin_reset)
 	w[p0] = r0.l;
 #endif
 
-	/* Clear the bits 13-15 in SWRST if they werent cleared */
-	p0.h = hi(SWRST);
-	p0.l = lo(SWRST);
-	csync;
-	r0.l = w[p0];
-
 	/* Clear the IMASK register */
 	p0.h = hi(IMASK);
 	p0.l = lo(IMASK);
diff --git a/arch/blackfin/mach-bf537/head.S b/arch/blackfin/mach-bf537/head.S
index d104e1d..de78e42 100644
--- a/arch/blackfin/mach-bf537/head.S
+++ b/arch/blackfin/mach-bf537/head.S
@@ -504,12 +504,6 @@ _delay_lab1_end:
 	nop;
 #endif
 
-	/* Clear the bits 13-15 in SWRST if they werent cleared */
-	p0.h = hi(SWRST);
-	p0.l = lo(SWRST);
-	csync;
-	r0.l = w[p0];
-
 	/* Clear the IMASK register */
 	p0.h = hi(IMASK);
 	p0.l = lo(IMASK);
diff --git a/arch/blackfin/mach-bf561/head.S b/arch/blackfin/mach-bf561/head.S
index 7bca478..462c39e 100644
--- a/arch/blackfin/mach-bf561/head.S
+++ b/arch/blackfin/mach-bf561/head.S
@@ -414,12 +414,6 @@ ENTRY(_bfin_reset)
 	w[p0] = r0.l;
 #endif
 
-	/* Clear the bits 13-15 in SWRST if they werent cleared */
-	p0.h = hi(SICA_SWRST);
-	p0.l = lo(SICA_SWRST);
-	csync;
-	r0.l = w[p0];
-
 	/* Clear the IMASK register */
 	p0.h = hi(IMASK);
 	p0.l = lo(IMASK);
-- 
1.5.1.2
