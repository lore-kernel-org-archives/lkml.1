Return-Path: <linux-kernel-owner+w=401wt.eu-S1758592AbZA1Uuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbZA1Uuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756578AbZA1Uc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:27 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47880 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbZA1UcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:24 -0500
MBOX-Line: From nobody Wed Jan 28 12:35:33 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH F 12/12] OMAP2/3 McBSP: add temporary clockdomain fix for
	McBSP virtual clocks
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>,
       Eero Nurkkala <ext-eero.nurkkala@nokia.com>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:35:33 -0700
Message-ID: <20090128193531.2396.91172.stgit@localhost.localdomain>
In-Reply-To: <20090128193326.2396.9437.stgit@localhost.localdomain>
References: <20090128193326.2396.9437.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The McBSP driver uses virtual clocks to handle enabling and disabling
its hardware clocks.  These virtual clocks have no associated
clockdomain. After commit 60b8b431e47d8c5b8c02a2e4fa9af388aae20790,
this prevents the McBSP clocks from registering correctly.
Resolve this for the short term by using virt_opp_clkdm for these clocks.
These McBSP virtual clocks should be removed, but such a fix would require
significant changes to the McBSP drivers that would require testing on
OMAP1, 2, and 3 platforms.

Tested on 2430SDP and 3430SDP GP ES2.1.

linux-omap source commit is 818862e11bad091dc635baedace58265a126b5c8.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Eero Nurkkala <ext-eero.nurkkala@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clockdomains.h |    2 +-
 arch/arm/mach-omap2/mcbsp.c        |    5 +++++
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index 3d4eaca..b29035e 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -40,7 +40,7 @@ static struct clockdomain cm_clkdm = {
 static struct clockdomain virt_opp_clkdm = {
 	.name		= "virt_opp_clkdm",
 	.pwrdm		= { .name = "wkup_pwrdm" },
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
 };
 
 /*
diff --git a/arch/arm/mach-omap2/mcbsp.c b/arch/arm/mach-omap2/mcbsp.c
index e20023c..1785d7a 100644
--- a/arch/arm/mach-omap2/mcbsp.c
+++ b/arch/arm/mach-omap2/mcbsp.c
@@ -79,6 +79,7 @@ static struct mcbsp_internal_clk omap_mcbsp_clks[] = {
 		.clk = {
 			.name 		= "mcbsp_clk",
 			.id		= 1,
+			.clkdm		= { .name = "virt_opp_clkdm" },
 			.enable		= omap_mcbsp_clk_enable,
 			.disable	= omap_mcbsp_clk_disable,
 		},
@@ -87,6 +88,7 @@ static struct mcbsp_internal_clk omap_mcbsp_clks[] = {
 		.clk = {
 			.name 		= "mcbsp_clk",
 			.id		= 2,
+			.clkdm		= { .name = "virt_opp_clkdm" },
 			.enable		= omap_mcbsp_clk_enable,
 			.disable	= omap_mcbsp_clk_disable,
 		},
@@ -95,6 +97,7 @@ static struct mcbsp_internal_clk omap_mcbsp_clks[] = {
 		.clk = {
 			.name		= "mcbsp_clk",
 			.id		= 3,
+			.clkdm		= { .name = "virt_opp_clkdm" },
 			.enable		= omap_mcbsp_clk_enable,
 			.disable	= omap_mcbsp_clk_disable,
 		},
@@ -103,6 +106,7 @@ static struct mcbsp_internal_clk omap_mcbsp_clks[] = {
 		.clk = {
 			.name		= "mcbsp_clk",
 			.id		= 4,
+			.clkdm		= { .name = "virt_opp_clkdm" },
 			.enable		= omap_mcbsp_clk_enable,
 			.disable	= omap_mcbsp_clk_disable,
 		},
@@ -111,6 +115,7 @@ static struct mcbsp_internal_clk omap_mcbsp_clks[] = {
 		.clk = {
 			.name		= "mcbsp_clk",
 			.id		= 5,
+			.clkdm		= { .name = "virt_opp_clkdm" },
 			.enable		= omap_mcbsp_clk_enable,
 			.disable	= omap_mcbsp_clk_disable,
 		},


