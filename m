Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab0CAJhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:37:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:57735 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab0CAJhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:37:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,559,1262592000"; 
   d="scan'208";a="544840235"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/7] xen: The entrance for PV extension of HVM
Date: Mon,  1 Mar 2010 17:38:32 +0800
Message-Id: <1267436315-24486-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
References: <1267436315-24486-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_guest_init() would setup the environment.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/setup.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d9e40c..2b61d46 100644
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
@@ -740,6 +744,10 @@ void __init setup_arch(char **cmdline_p)
 
 	x86_init.oem.arch_setup();
 
+#ifdef CONFIG_XEN
+	xen_guest_init();
+#endif
+
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.5.4.5

