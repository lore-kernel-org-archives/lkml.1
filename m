Return-Path: <linux-kernel-owner+w=401wt.eu-S936358AbXEVPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936358AbXEVPd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934961AbXEVPT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:19:59 -0400
Received: from host217-46-209-99.in-addr.btopenworld.com ([217.46.209.99]:5015
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934721AbXEVPTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:19:20 -0400
Message-Id: <20070522141251.267503488@goop.org>
References: <20070522140941.802382212@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 22 May 2007 15:09:46 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: [patch 05/33] xen: paravirt: unstatic smp_store_cpu_info
Content-Disposition: inline; filename=paravirt-unstatic-smp_store_cpu_info.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirt implementations need to store cpu info when bringing up cpus.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

---
 arch/i386/kernel/smpboot.c |    2 +-
 include/asm-i386/smp.h     |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

===================================================================
--- a/include/asm-i386/smp.h
+++ b/include/asm-i386/smp.h
@@ -129,6 +132,8 @@ extern void __cpu_die(unsigned int cpu);
 extern void __cpu_die(unsigned int cpu);
 extern unsigned int num_processors;
 
+void __cpuinit smp_store_cpu_info(int id);
+
 #endif /* !__ASSEMBLY__ */
 
 #else /* CONFIG_SMP */
===================================================================
--- a/arch/i386/kernel/smpboot.c
+++ b/arch/i386/kernel/smpboot.c
@@ -148,7 +148,7 @@ void __init smp_alloc_memory(void)
  * a given CPU
  */
 
-static void __cpuinit smp_store_cpu_info(int id)
+void __cpuinit smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = cpu_data + id;
 

-- 

