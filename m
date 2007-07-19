Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXGSNtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXGSNtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932550AbXGSNsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 09:48:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:48581 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761065AbXGSNsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 09:48:31 -0400
From: Andi Kleen <ak@suse.de>
References: <20070719348.540885000@suse.de>
In-Reply-To: <20070719348.540885000@suse.de>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: [PATCH for review] [2/48] i386: fix section mismatch warning in intel_cacheinfo
Message-Id: <20070719134830.B513314E6E@wotan.suse.de>
Date: Thu, 19 Jul 2007 15:48:30 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: arch/i386/kernel/built-in.o(.init.text+0x3818): Section mismatch: reference to .exit.text:cache_remove_dev (between 'cacheinfo_cpu_callback' and 'cache_sysfs_init')

It points out that a function marked __cpuexit is calling a function marked
__cpuinit => oops.

The call happens only in an error-condition which may explain why we have
not seen it before.

The offending function was not used anywhere else - so marked it __cpuexit.

Note: This warning triggers only with a local copy of modpost
      but that version will soon be pushed out.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/i386/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/arch/i386/kernel/cpu/intel_cacheinfo.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/intel_cacheinfo.c
+++ linux/arch/i386/kernel/cpu/intel_cacheinfo.c
@@ -746,7 +746,7 @@ static int __cpuinit cache_add_dev(struc
 	return retval;
 }
 
-static void __cpuexit cache_remove_dev(struct sys_device * sys_dev)
+static void __cpuinit cache_remove_dev(struct sys_device * sys_dev)
 {
 	unsigned int cpu = sys_dev->id;
 	unsigned long i;
