Return-Path: <linux-kernel-owner+w=401wt.eu-S1762242AbXGRVPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762242AbXGRVPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754325AbXGRVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:15:39 -0400
Received: from gw.goop.org ([64.81.55.164]:56017 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbXGRVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:15:38 -0400
Message-ID: <469E82C2.8090107@goop.org>
Date: Wed, 18 Jul 2007 14:14:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [PATCH] fix cpu_llc_id section mismatch warning
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: William Lee Irwin III <wli@holomorphy.com>

This patch silences the following warning:
WARNING: arch/i386/kernel/built-in.o(.text+0xdba6): Section mismatch: reference to .init.data:cpu_llc_id (between 'set_cpu_sibling_map' and 'initialize_secondary')
Marking set_cpu_sibling_map() as __cpuinit resolves the section conflict
with the __cpuinitdata cpu_llc_id[] variable.

Signed-off-by: William Irwin <bill.irwin@oracle.com>
Acked-by: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/smpboot.c~fix-x86_64-mm-xen-xen-smp-guest-support arch/i386/kernel/smpboot.c
--- a/arch/i386/kernel/smpboot.c~fix-x86_64-mm-xen-xen-smp-guest-support
+++ a/arch/i386/kernel/smpboot.c
@@ -308,7 +308,7 @@ cpumask_t cpu_coregroup_map(int cpu)
 /* representing cpus for which sibling maps can be computed */
 static cpumask_t cpu_sibling_setup_map;
 
-void set_cpu_sibling_map(int cpu)
+void __cpuinit set_cpu_sibling_map(int cpu)
 {
 	int i;
 	struct cpuinfo_x86 *c = cpu_data;
_


