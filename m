Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbZA1UyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbZA1UyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756607AbZA1Ucn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:32:43 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:47783 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbZA1UcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:32:10 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:35 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 09/10] OMAP2/3 clockdomains: autodeps should respect
	platform flags
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:35 -0700
Message-ID: <20090128024431.27240.80132.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the clockdomain autodep code to respect omap_chip platform flags.

Resolves "Unable to handle kernel paging request at virtual address
5f75706d" panic during power management initialization on OMAP2.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clockdomain.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index ad6dfe4..f713d0b 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -96,6 +96,9 @@ static void _clkdm_add_autodeps(struct clockdomain *clkdm)
 	struct clkdm_pwrdm_autodep *autodep;
 
 	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
+		if (!omap_chip_is(autodep->omap_chip))
+			continue;
+
 		pr_debug("clockdomain: adding %s sleepdep/wkdep for "
 			 "pwrdm %s\n", autodep->pwrdm.ptr->name,
 			 clkdm->pwrdm.ptr->name);
@@ -118,6 +121,9 @@ static void _clkdm_del_autodeps(struct clockdomain *clkdm)
 	struct clkdm_pwrdm_autodep *autodep;
 
 	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
+		if (!omap_chip_is(autodep->omap_chip))
+			continue;
+
 		pr_debug("clockdomain: removing %s sleepdep/wkdep for "
 			 "pwrdm %s\n", autodep->pwrdm.ptr->name,
 			 clkdm->pwrdm.ptr->name);


