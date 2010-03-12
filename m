Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039Ab0CLC4W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 21:56:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:36861 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab0CLC4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 21:56:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,624,1262592000"; 
   d="scan'208";a="253809162"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH][v9 5/6] x86/xen: The entrance for PV extension of HVM
Date: Fri, 12 Mar 2010 10:57:26 +0800
Message-Id: <1268362647-5317-6-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
References: <1268362647-5317-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_guest_init() would setup the environment.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/include/asm/xen/hypervisor.h |    6 ++++++
 arch/x86/kernel/setup.c               |    4 ++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 7569f64..f7d61a5 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -76,4 +76,10 @@ extern u32 xen_hvm_pv_features;
 #define xen_initial_domain()	(0)
 #endif	/* CONFIG_XEN_DOM0 */
 
+#ifdef CONFIG_XEN_HVM_PV
+void xen_guest_init(void);
+#else
+static inline void xen_guest_init(void) {};
+#endif
+
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2a34f9c..9bfb8ce 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -110,6 +110,8 @@
 #include <asm/numa_64.h>
 #endif
 
+#include <asm/xen/hypervisor.h>
+
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
@@ -753,6 +755,8 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	xen_guest_init();
+
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.7.0.1

