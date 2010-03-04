Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab0CDJhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 04:37:13 -0500
Received: from mga11.intel.com ([192.55.52.93]:41614 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755367Ab0CDJgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 04:36:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,580,1262592000"; 
   d="scan'208";a="777868097"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>, linux-kernel@vger.kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 5/7] x86/xen: The entrance for PV extension of HVM
Date: Thu,  4 Mar 2010 17:36:54 +0800
Message-Id: <1267695416-14988-6-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
References: <1267695416-14988-1-git-send-email-sheng@linux.intel.com>
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
index 396ff4c..13e089a 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -37,4 +37,10 @@
 extern struct shared_info *HYPERVISOR_shared_info;
 extern struct start_info *xen_start_info;
 
+#ifdef CONFIG_XEN_HVM_PV
+void __init xen_guest_init(void);
+#else
+static inline void xen_guest_init(void) {};
+#endif
+
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d9e40c..1cc4786 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,8 @@
 #endif
 #include <asm/mce.h>
 
+#include <asm/xen/hypervisor.h>
+
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
@@ -740,6 +742,8 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+	xen_guest_init();
+
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.5.4.5

