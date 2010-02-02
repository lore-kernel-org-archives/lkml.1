Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0BBIUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:20:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:14680 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755399Ab0BBIUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:20:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,389,1262592000"; 
   d="scan'208";a="769295338"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Cc: xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/6] xen/hybrid: The entrance for Hybrid
Date: Tue,  2 Feb 2010 16:19:05 +0800
Message-Id: <1265098747-10117-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
References: <1265098747-10117-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_hybrid_init() would setup Hybrid environment.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/setup.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7b8b98..db82295 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -113,6 +113,10 @@
 #endif
 #include <asm/mce.h>
 
+#ifdef CONFIG_XEN
+#include <xen/xen.h>
+#endif
+
 /*
  * end_pfn only includes RAM, while max_pfn_mapped includes all e820 entries.
  * The direct mapping extends to max_pfn_mapped, so that we can directly access
@@ -732,6 +736,10 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+#ifdef CONFIG_XEN
+	xen_hybrid_init();
+#endif
+
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.5.4.5

