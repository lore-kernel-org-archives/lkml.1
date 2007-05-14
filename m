Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbXENJnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbXENJnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbXENJmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:42:54 -0400
Received: from koto.vergenet.net ([210.128.90.7]:54652 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755350AbXENJmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:42:53 -0400
To: linux-kernel@vger.kernel.org
Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
       Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
From: Simon Horman <horms@verge.net.au>
Subject: [ALPHA] Fix hard_smp_processor_id compile error
Message-Id: <20070514094249.E29144FA28@tabatha.lab.ultramonkey.org>
Date: Mon, 14 May 2007 18:42:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Remove hardcoding of hard_smp_processor_id on UP systems",
2f4dfe206a2fc07099dfad77a8ea2f4b4ae2140f in Linus' tree, moved
the definition of hard_smp_processor_id linux/smp.h to asm/smp.h
for UP systems. This causes a regression on Alpha.

cc1: warnings being treated as errors
arch/alpha/kernel/setup.c: In function 'setup_arch':
arch/alpha/kernel/setup.c:506: warning: implicit declaration of function 'hard_smp_processor_id'
make[1]: *** [arch/alpha/kernel/setup.o] error 1
make: *** [arch/alpha/kernel] error 2

By including asm/smp.h non-conditionally in asm/mmu_context.h
the problem appears to be resolved.

Cc: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/include/asm-alpha/mmu_context.h
===================================================================
--- linux-2.6.orig/include/asm-alpha/mmu_context.h	2007-05-14 16:29:22.000000000 +0900
+++ linux-2.6/include/asm-alpha/mmu_context.h	2007-05-14 16:29:40.000000000 +0900
@@ -85,8 +85,8 @@ __reload_thread(struct pcb_struct *pcb)
  * +-------------+----------------+--------------+
  */
 
-#ifdef CONFIG_SMP
 #include <asm/smp.h>
+#ifdef CONFIG_SMP
 #define cpu_last_asn(cpuid)	(cpu_data[cpuid].last_asn)
 #else
 extern unsigned long last_asn;
