Return-Path: <linux-kernel-owner+w=401wt.eu-S1755895AbZKNLse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895AbZKNLse (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 06:48:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZKNLsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 06:48:31 -0500
Received: from sh.osrg.net ([192.16.179.4]:52999 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbZKNLsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 06:48:15 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/3] x86: move iommu_shutdown_noop to x86_init.c
Date: Sat, 14 Nov 2009 20:46:37 +0900
Message-Id: <1258199198-16657-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1258199198-16657-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 14 Nov 2009 20:48:04 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iommu_init_noop() is in arch/x86/kernel/x86_init.c but
iommu_shutdown_noop() in arch/x86/include/asm/iommu.h.

This moves iommu_shutdown_noop() to x86_init.c for consistency.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/include/asm/iommu.h |    1 -
 arch/x86/kernel/x86_init.c   |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index df42a71..345c99c 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_IOMMU_H
 #define _ASM_X86_IOMMU_H
 
-static inline void iommu_shutdown_noop(void) {}
 extern struct dma_map_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c46984d..80f3ae2 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -20,6 +20,7 @@ void __cpuinit x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 void __init x86_init_pgd_noop(pgd_t *unused) { }
 int __init iommu_init_noop(void) { return 0; }
+void __init iommu_shutdown_noop(void) { }
 
 /*
  * The platform setup functions are preset with the default functions
-- 
1.5.6.5

