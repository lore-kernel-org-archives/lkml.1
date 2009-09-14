Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbZINUJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbZINUJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933733AbZINUJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:09:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54215 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933685AbZINUJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:09:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 72/72] Blackfin: swap clocksource ratings for gptimer/cycles
Date: Mon, 14 Sep 2009 16:08:16 -0400
Message-Id: <1252958896-25150-73-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
References: <1252958896-25150-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

The cycles clocksource is a higher resolution than the gptimer one, so
make sure the ratings field reflects this.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig          |    2 +-
 arch/blackfin/kernel/time-ts.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index e7a781d..9a01d44 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -648,7 +648,7 @@ config CYCLES_CLOCKSOURCE
 	  writing the registers will most likely crash the kernel.
 
 config GPTMR0_CLOCKSOURCE
-	bool "Use GPTimer0 as a clocksource (higher rating)"
+	bool "Use GPTimer0 as a clocksource"
 	select BFIN_GPTIMERS
 	depends on GENERIC_CLOCKEVENTS
 	depends on !TICKSOURCE_GPTMR0
diff --git a/arch/blackfin/kernel/time-ts.c b/arch/blackfin/kernel/time-ts.c
index 0791eba..f971576 100644
--- a/arch/blackfin/kernel/time-ts.c
+++ b/arch/blackfin/kernel/time-ts.c
@@ -66,7 +66,7 @@ static cycle_t bfin_read_cycles(struct clocksource *cs)
 
 static struct clocksource bfin_cs_cycles = {
 	.name		= "bfin_cs_cycles",
-	.rating		= 350,
+	.rating		= 400,
 	.read		= bfin_read_cycles,
 	.mask		= CLOCKSOURCE_MASK(64),
 	.shift		= 22,
@@ -115,7 +115,7 @@ static cycle_t bfin_read_gptimer0(void)
 
 static struct clocksource bfin_cs_gptimer0 = {
 	.name		= "bfin_cs_gptimer0",
-	.rating		= 400,
+	.rating		= 350,
 	.read		= bfin_read_gptimer0,
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 22,
-- 
1.6.4.2

