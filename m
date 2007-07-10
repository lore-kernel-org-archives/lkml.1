Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbXGJMq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbXGJMq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 08:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbXGJMof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 08:44:35 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:56649 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755281AbXGJMoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 08:44:11 -0400
Date: Tue, 10 Jul 2007 14:44:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386: intel_cacheinfo.c:find_num_cache_leaves() should
	be __cpuinit
Message-ID: <20070710124444.GW3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following section mismatch:

<--  snip  -->

...
  MODPOST vmlinux
WARNING: arch/i386/kernel/built-in.o(.text+0xb6a7): Section mismatch: reference to .init.text:find_num_cache_leaves (between 'init_intel_cacheinfo' and 'cache_shared_cpu_map_setup')
...

<--  snip  -->

It could be __init_refok, but gcc >= 4.0 anyway inlines it into the 
__cpuinit init_intel_cacheinfo(), and IMHO it's too small
for "noinline __init".

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/intel_cacheinfo.c.old	2007-07-10 04:21:03.000000000 +0200
+++ linux-2.6.22-rc6-mm1/arch/i386/kernel/cpu/intel_cacheinfo.c	2007-07-10 04:24:27.000000000 +0200
@@ -275,8 +275,7 @@
 	return 0;
 }
 
-/* will only be called once; __init is safe here */
-static int __init find_num_cache_leaves(void)
+static int __cpuinit find_num_cache_leaves(void)
 {
 	unsigned int		eax, ebx, ecx, edx;
 	union _cpuid4_leaf_eax	cache_eax;

