Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160Ab0BHIGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 03:06:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:51620 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab0BHIGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 03:06:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,427,1262592000"; 
   d="scan'208";a="593982788"
From: Sheng Yang <sheng@linux.intel.com>
To: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Keir Fraser <keir.fraser@eu.citrix.com>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       xen-devel <xen-devel@lists.xensource.com>, linux-kernel@vger.kernel.org,
       Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 4/7] xen: The entrance for PV featured HVM
Date: Mon,  8 Feb 2010 16:05:51 +0800
Message-Id: <1265616354-7384-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
References: <1265616354-7384-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_guest_init() would setup the environment.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
---
 arch/x86/kernel/setup.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f7b8b98..1568a27 100644
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
+	xen_guest_init();
+#endif
+
 	setup_memory_map();
 	parse_setup_data();
 	/* update the e820_saved too */
-- 
1.5.4.5

