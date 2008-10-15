Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbYJORQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbYJORQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 13:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYJORQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 13:16:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:47782 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYJORQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 13:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BG1n5SV4t7KheV/YuXEtJrowLsg3PNLVa4x+kth3q92lg6JBP5e+0VYDLKI6xIV8S/
         7Xj96TS0APWHyK8mUwm+3x6v1DfQRdR/smGMM3WRn7czHNUR9NwSlMOelf6vfbRVOAoF
         OI0ObQ1WrICYCwfl38MA2R6vGKpSqfDK5JJzw=
Date: Wed, 15 Oct 2008 21:16:24 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/intel_cacheinfo: fix warning defined but not used
Message-ID: <20081015171624.GA30703@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/intel_cacheinfo.c:527: warning: 'free_cache_attributes' defined but not used
arch/x86/kernel/cpu/intel_cacheinfo.c:538: warning: 'detect_cache_attributes' defined but not used

Compile tested with and without sysfs.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 arch/x86/kernel/cpu/intel_cacheinfo.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3f46afb..a8c226d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -475,6 +475,12 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
+
+#ifdef CONFIG_SYSFS
+
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
@@ -521,7 +527,7 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 #else
 static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index) {}
 static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index) {}
-#endif
+#endif /* !CONFIG_SMP */
 
 static void __cpuinit free_cache_attributes(unsigned int cpu)
 {
@@ -578,11 +584,6 @@ out:
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
-
-#include <linux/kobject.h>
-#include <linux/sysfs.h>
-
 extern struct sysdev_class cpu_sysdev_class; /* from drivers/base/cpu.c */
 
 /* pointer to kobject for cpuX/cache */
