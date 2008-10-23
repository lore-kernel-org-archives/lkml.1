Return-Path: <linux-kernel-owner+w=401wt.eu-S1758071AbYJWCMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbYJWCMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYJWCIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:46606 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753929AbYJWCI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:29 -0400
Message-Id: <20081023020828.489427000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:37 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/35] x86: enable MAXSMP
Content-Disposition: inline; filename=x86:enable-MAXSMP.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set MAXSMP to enable CONFIG_CPUMASK_OFFSTACK which moves cpumask's off
the stack (and in structs) when using cpumask_var_t.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/Kconfig |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- linux-2.6.28.orig/arch/x86/Kconfig
+++ linux-2.6.28/arch/x86/Kconfig
@@ -573,6 +573,7 @@ config IOMMU_HELPER
 config MAXSMP
 	bool "Configure Maximum number of SMP Processors and NUMA Nodes"
 	depends on X86_64 && SMP && DEBUG_KERNEL && EXPERIMENTAL
+	select CPUMASK_OFFSTACK
 	help
 	  Configure maximum number of CPUS and NUMA Nodes for this
 	  architecture (up to 4096!).
@@ -584,16 +585,16 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-4096)" if !MAXSMP
-	range 2 4096
 	depends on SMP
+ 	int "Maximum number of CPUs" if SMP && !MAXSMP
+ 	range 2 512 if SMP && !MAXSMP
 	default "4096" if MAXSMP
-	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
+ 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
 	default "8"
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 512 and the
-	  minimum value which makes sense is 2.
+	  kernel will support.  The maximum supported value is 512 (4096
+	  if MAXSMP set) and the minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
 	  approximately one kilobyte to the kernel image.

-- 
