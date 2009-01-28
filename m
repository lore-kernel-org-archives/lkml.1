Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbZA1UkN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbZA1UkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:40:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755389AbZA1U33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:29 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32904 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980AbZA1U3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:24 -0500
MBOX-Line: From nobody Wed Jan 28 12:27:48 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 07/14] OMAP2/3 clock: use standard set_rate fn in
	omap2_clk_arch_init()
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:27:48 -0700
Message-ID: <20090128192745.29333.13603.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the standard clk_set_rate() function in omap2_clk_arch_init()
rather than omap2_select_table_rate() -- this will ensure that clock
rates are recalculated and propagated correctly after those operations
are consolidated into clk_set_rate().

linux-omap source commit is 03c03330017eeb445b01957608ff5db49a7151b6.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clock24xx.c |    2 +-
 arch/arm/mach-omap2/clock34xx.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/clock24xx.c b/arch/arm/mach-omap2/clock24xx.c
index 640a2cb..3727a73 100644
--- a/arch/arm/mach-omap2/clock24xx.c
+++ b/arch/arm/mach-omap2/clock24xx.c
@@ -502,7 +502,7 @@ static int __init omap2_clk_arch_init(void)
 	if (!mpurate)
 		return -EINVAL;
 
-	if (omap2_select_table_rate(&virt_prcm_set, mpurate))
+	if (clk_set_rate(&virt_prcm_set, mpurate))
 		printk(KERN_ERR "Could not find matching MPU rate\n");
 
 	recalculate_root_clocks();
diff --git a/arch/arm/mach-omap2/clock34xx.c b/arch/arm/mach-omap2/clock34xx.c
index 2c655be..738a029 100644
--- a/arch/arm/mach-omap2/clock34xx.c
+++ b/arch/arm/mach-omap2/clock34xx.c
@@ -665,7 +665,7 @@ static int __init omap2_clk_arch_init(void)
 
 	/* REVISIT: not yet ready for 343x */
 #if 0
-	if (omap2_select_table_rate(&virt_prcm_set, mpurate))
+	if (clk_set_rate(&virt_prcm_set, mpurate))
 		printk(KERN_ERR "Could not find matching MPU rate\n");
 #endif
 


