Return-Path: <linux-kernel-owner+w=401wt.eu-S1763065AbYDTC4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763065AbYDTC4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 22:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762861AbYDTCzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 22:55:04 -0400
Received: from smtp01.mtu.ru ([62.5.255.48]:62291 "EHLO smtp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbYDTCyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 22:54:38 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: conditionally compile sysfs stuff in intel_cacheinfo.c
Date: Sun, 20 Apr 2008 06:54:34 +0400
Message-Id: <1208660074-7324-5-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208660074-7324-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp01.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Four functions defined in arch/x86/kernel/cpu/intel_cacheinfo.c:

cache_shared_cpu_map_setup()
cache_remove_shared_cpu_map()
free_cache_attributes()
detect_cache_attributes()

are needed only in the code that is conditionally compiled when
CONFIG_SYSFS is defined. The same is true about the cpuid4_info[]
array. This patch places the definitions of these functions and
the array inside the corresponding ifdef.

This patch was build-tested both with sysfs turned off and on.
The kernel was built successfully in both cases. Runtime tests
were performed using x86 and x86_64 machines, which booted to
the shell prompt successfully.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 1b88986..d743dfe 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -450,6 +450,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
+#ifdef CONFIG_SYSFS
+
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static struct _cpuid4_info *cpuid4_info[NR_CPUS];
 #define CPUID4_INFO_IDX(x,y)    (&((cpuid4_info[x])[y]))
@@ -553,8 +555,6 @@ out:
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
-
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
-- 
1.5.3

