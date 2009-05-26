Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbZEZWYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbZEZWYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZEZWWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:22:39 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:33585 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755555AbZEZWWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:22:31 -0400
MBOX-Line: From nobody Tue May 26 16:12:36 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 09/10] OMAP3 clock: GPIO de-bounce clocks don't affect module
	idle state
To: linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 26 May 2009 16:12:36 -0600
Message-ID: <20090526221235.25381.35689.stgit@localhost.localdomain>
In-Reply-To: <20090526220517.25381.75976.stgit@localhost.localdomain>
References: <20090526220517.25381.75976.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO de-bounce clocks don't have any impact on the module idle state, so
the clock code should not wait for the module to enable after the de-bounce
clocks are enabled.

Problem found by Kevin Hilman <khilman@deeprootsystems.com>.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 arch/arm/mach-omap2/clock34xx.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/clock34xx.h b/arch/arm/mach-omap2/clock34xx.h
index 6763b8f..017a30e 100644
--- a/arch/arm/mach-omap2/clock34xx.h
+++ b/arch/arm/mach-omap2/clock34xx.h
@@ -2182,7 +2182,7 @@ static struct clk wkup_32k_fck = {
 
 static struct clk gpio1_dbck = {
 	.name		= "gpio1_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &wkup_32k_fck,
 	.enable_reg	= OMAP_CM_REGADDR(WKUP_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO1_SHIFT,
@@ -2427,7 +2427,7 @@ static struct clk per_32k_alwon_fck = {
 
 static struct clk gpio6_dbck = {
 	.name		= "gpio6_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &per_32k_alwon_fck,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO6_SHIFT,
@@ -2437,7 +2437,7 @@ static struct clk gpio6_dbck = {
 
 static struct clk gpio5_dbck = {
 	.name		= "gpio5_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &per_32k_alwon_fck,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO5_SHIFT,
@@ -2447,7 +2447,7 @@ static struct clk gpio5_dbck = {
 
 static struct clk gpio4_dbck = {
 	.name		= "gpio4_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &per_32k_alwon_fck,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO4_SHIFT,
@@ -2457,7 +2457,7 @@ static struct clk gpio4_dbck = {
 
 static struct clk gpio3_dbck = {
 	.name		= "gpio3_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &per_32k_alwon_fck,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO3_SHIFT,
@@ -2467,7 +2467,7 @@ static struct clk gpio3_dbck = {
 
 static struct clk gpio2_dbck = {
 	.name		= "gpio2_dbck",
-	.ops		= &clkops_omap2_dflt_wait,
+	.ops		= &clkops_omap2_dflt,
 	.parent		= &per_32k_alwon_fck,
 	.enable_reg	= OMAP_CM_REGADDR(OMAP3430_PER_MOD, CM_FCLKEN),
 	.enable_bit	= OMAP3430_EN_GPIO2_SHIFT,


