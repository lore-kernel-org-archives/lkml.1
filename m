Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZA1Umc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZA1Umc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbZA1UaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:18 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32999 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693AbZA1UaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:13 -0500
MBOX-Line: From nobody Tue Jan 27 19:13:12 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH A 08/10] OMAP: Make dpll4_m4_ck programmable with
	clk_set_rate()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: =?utf-8?b?TcOlbnM=?= =?utf-8?b?UnVsbGfDpXJk?= <mans@mansr.com>,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>,
       linux-omap@vger.kernel.org
Date: Tue, 27 Jan 2009 19:13:12 -0700
Message-ID: <20090128021309.7244.65001.stgit@localhost.localdomain>
In-Reply-To: <20090128020447.7244.80496.stgit@localhost.localdomain>
References: <20090128020447.7244.80496.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Filling the set_rate and round_rate fields of dpll4_m4_ck makes
this clock programmable through clk_set_rate().  This is needed
to give omapfb control over the dss1_alwon_fck rate.

This patch includes a fix from Tomi Valkeinen <tomi.valkeinen@nokia.com>.

linux-omap source commits are e42218d45afbc3e654e289e021e6b80c657b16c2 and
9d211b761b3cdf7736602ecf7e68f8a298c13278.

Signed-off-by: Måns Rullgård <mans@mansr.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock34xx.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index d19558d..a01d8d9 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -816,6 +816,8 @@ static struct clk dpll4_m4_ck = {
 	.flags		= CLOCK_IN_OMAP343X | RATE_PROPAGATES |
 				PARENT_CONTROLS_CLOCK,
 	.recalc		= &omap2_clksel_recalc,
+	.set_rate	= &omap2_clksel_set_rate,
+	.round_rate	= &omap2_clksel_round_rate,
 };
 
 /* The PWRDN bit is apparently only available on 3430ES2 and above */


