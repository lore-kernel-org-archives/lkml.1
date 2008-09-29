Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYI2SwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYI2SwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYI2SwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:52:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34380 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYI2SwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:52:05 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH] x86: IOMMU setup failures should not be KERN_ERR
Date: Mon, 29 Sep 2008 14:52:03 -0400
Message-Id: <1222714323-1203-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of BIOSes that have an option to enable the IOMMU, or fix
anything about its configuration, is vanishingly small.  There's no good
reason to punish quiet boot for this.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 arch/x86/kernel/aperture_64.c |    6 +++---
 include/asm-x86/gart.h        |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 44e2182..9a32b37 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -455,11 +455,11 @@ out:
 		   force_iommu ||
 		   valid_agp ||
 		   fallback_aper_force) {
-		printk(KERN_ERR
+		printk(KERN_INFO
 			"Your BIOS doesn't leave a aperture memory hole\n");
-		printk(KERN_ERR
+		printk(KERN_INFO
 			"Please enable the IOMMU option in the BIOS setup\n");
-		printk(KERN_ERR
+		printk(KERN_INFO
 			"This costs you %d MB of RAM\n",
 				32 << fallback_aper_order);
 
diff --git a/include/asm-x86/gart.h b/include/asm-x86/gart.h
index 3f62a83..583031c 100644
--- a/include/asm-x86/gart.h
+++ b/include/asm-x86/gart.h
@@ -52,15 +52,15 @@ static inline int aperture_valid(u64 aper_base, u32 aper_size, u32 min_size)
 		return 0;
 
 	if (aper_base + aper_size > 0x100000000ULL) {
-		printk(KERN_ERR "Aperture beyond 4GB. Ignoring.\n");
+		printk(KERN_INFO "Aperture beyond 4GB. Ignoring.\n");
 		return 0;
 	}
 	if (e820_any_mapped(aper_base, aper_base + aper_size, E820_RAM)) {
-		printk(KERN_ERR "Aperture pointing to e820 RAM. Ignoring.\n");
+		printk(KERN_INFO "Aperture pointing to e820 RAM. Ignoring.\n");
 		return 0;
 	}
 	if (aper_size < min_size) {
-		printk(KERN_ERR "Aperture too small (%d MB) than (%d MB)\n",
+		printk(KERN_INFO "Aperture too small (%d MB) than (%d MB)\n",
 				 aper_size>>20, min_size>>20);
 		return 0;
 	}
-- 
1.6.0.1

