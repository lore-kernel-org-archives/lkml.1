Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbZA1Uqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbZA1Uqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZA1Ub3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:31:29 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47758 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZA1UbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:31:25 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:28 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 07/10] OMAP3 powerdomains: remove RET from SGX power states
	list
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Richard Woodruff <r-woodruff2@ti.com>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:28 -0700
Message-ID: <20090128024425.27240.28890.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGX device on OMAP3 does not support retention, so remove RET from the
list of possible SGX power states.  Problem debugged by Richard Woodruff
<r-woodruff2@ti.com>.

Signed-off-by: Richard Woodruff <r-woodruff2@ti.com>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/powerdomains34xx.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index 446a1ed..edfad42 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -255,6 +255,11 @@ static struct powerdomain dss_pwrdm = {
 	},
 };
 
+/*
+ * Although the 34XX TRM Rev K Table 4-371 notes that retention is a
+ * possible SGX powerstate, the SGX device itself does not support
+ * retention.
+ */
 static struct powerdomain sgx_pwrdm = {
 	.name		  = "sgx_pwrdm",
 	.prcm_offs	  = OMAP3430ES2_SGX_MOD,
@@ -262,7 +267,7 @@ static struct powerdomain sgx_pwrdm = {
 	.wkdep_srcs	  = gfx_sgx_wkdeps,
 	.sleepdep_srcs	  = cam_gfx_sleepdeps,
 	/* XXX This is accurate for 3430 SGX, but what about GFX? */
-	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts		  = PWRSTS_OFF_ON,
 	.pwrsts_logic_ret = PWRDM_POWER_RET,
 	.banks		  = 1,
 	.pwrsts_mem_ret	  = {


