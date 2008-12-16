Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYLPC0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYLPC0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 21:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYLPCYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 21:24:21 -0500
Received: from relay2.sgi.com ([192.48.179.30]:50750 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787AbYLPCYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 21:24:14 -0500
Message-Id: <20081216022410.137548000@polaris-admin.engr.sgi.com>
References: <20081216022409.679598000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 15 Dec 2008 18:24:11 -0800
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hy>
Subject: [PATCH 02/16] x86: enable MAXSMP
Content-Disposition: inline; filename=0001-x86-enable-MAXSMP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: activates new off-stack cpumask code on MAXSMP (non-default) x86 configs

Set MAXSMP to enable CONFIG_CPUMASK_OFFSTACK which moves cpumask's off
the stack (and in structs) when using cpumask_var_t.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Ingo Molnar <mingo@elte.hy>
---
 arch/x86/Kconfig |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8acab5b..09638b1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -581,16 +581,17 @@ config IOMMU_HELPER
 
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
-	depends on X86_64 && SMP && BROKEN
+	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	select CPUMASK_OFFSTACK
 	default n
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this architecture.
 	  If unsure, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-512)" if !MAXSMP
-	range 2 512
 	depends on SMP
+	int "Maximum number of CPUs" if SMP && !MAXSMP
+	range 2 512 if SMP && !MAXSMP
 	default "4096" if MAXSMP
 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
-- 
1.6.0

-- 
