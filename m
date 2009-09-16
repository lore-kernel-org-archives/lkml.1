Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZIPIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZIPIn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 04:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbZIPInY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 04:43:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:51178 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbZIPInT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 04:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,396,1249282800"; 
   d="scan'208";a="551023847"
From: Sheng Yang <sheng@linux.intel.com>
To: Keir Fraser <keir.fraser@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jun Nakajima <jun.nakajima@intel.com>, Eddie Dong <eddie.dong@intel.com>,
       linux-kernel@vger.kernel.org, xen-devel <xen-devel@lists.xensource.com>,
       Sheng Yang <sheng@linux.intel.com>
Subject: [RFC][PATCH 04/10] xen/hybrid: Modify pv_init_ops and xen_info
Date: Wed, 16 Sep 2009 16:42:25 +0800
Message-Id: <1253090551-7969-5-git-send-email-sheng@linux.intel.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
References: <1253090551-7969-1-git-send-email-sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including Hybrid specific banner

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
---
 arch/x86/xen/enlighten.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index b93604e..b290d65 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1040,6 +1040,17 @@ asmlinkage void __init xen_start_kernel(void)
 #endif
 }
 
+static void __init xen_hybrid_banner(void)
+{
+	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
+	struct xen_extraversion extra;
+	HYPERVISOR_xen_version(XENVER_extraversion, &extra);
+
+	printk(KERN_INFO "Booting hybrid kernel on %s\n", pv_info.name);
+	printk(KERN_INFO "Xen version: %d.%d%s\n",
+	       version >> 16, version & 0xffff, extra.extraversion);
+}
+
 static int xen_para_available(void)
 {
 	uint32_t eax, ebx, ecx, edx;
@@ -1094,6 +1105,10 @@ static int init_hybrid_info(void)
 	if (enable_hybrid(flags))
 		return -EINVAL;
 
+	pv_init_ops.banner = xen_hybrid_banner;
+	pv_info = xen_info;
+	pv_info.kernel_rpl = 0;
+
 	return 0;
 }
 
-- 
1.5.4.5

