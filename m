Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYIEVkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYIEVkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYIEVkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:40:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54840 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752118AbYIEVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:40:21 -0400
Message-Id: <20080905214020.399774000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Sep 2008 14:40:22 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: restore 4096 limit for NR_CPUS
References: <20080905214019.821172000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=Kconfig
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * With the previous cleanups, NR_CPUS=4096 can now be enabled again.

Based on 2.6.27-rc5-git6.

Applies to linux-2.6.tip/master (with FUZZ).

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.orig/arch/x86/Kconfig
+++ linux-2.6/arch/x86/Kconfig
@@ -587,8 +587,8 @@ config MAXSMP
 	  If unsure, say N.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-512)" if !MAXSMP
-	range 2 512
+	int "Maximum number of CPUs (2-4096)" if !MAXSMP
+	range 2 4096
 	depends on SMP
 	default "4096" if MAXSMP
 	default "32" if X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000
@@ -599,7 +599,7 @@ config NR_CPUS
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
-	  approximately eight kilobytes to the kernel image.
+	  approximately one kilobyte to the kernel image.
 
 config SCHED_SMT
 	bool "SMT (Hyperthreading) scheduler support"

