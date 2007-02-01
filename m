Return-Path: <linux-kernel-owner+w=401wt.eu-S1422889AbXBANxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422889AbXBANxG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:53:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422881AbXBANwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:52:53 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51220 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422880AbXBANwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:34 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] sanitize sections for sparc32 smp
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Message-Id: <E1HCcMb-0007PU-Va@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


a) sun4d_boot_one_cpu() should be __cpuinit (called only from
__cpuinit __cpu_up(), for one thing, leads to calls of __cpuinit
functions for another).
b) got externs in arch/sparc/kernel/smp.c to match reality.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/kernel/smp.c       |    8 ++++----
 arch/sparc/kernel/sun4d_smp.c |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/sparc/kernel/smp.c b/arch/sparc/kernel/smp.c
index 276f228..6b5f26b 100644
--- a/arch/sparc/kernel/smp.c
+++ b/arch/sparc/kernel/smp.c
@@ -292,8 +292,8 @@ int setup_profiling_timer(unsigned int multiplier)
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	extern void smp4m_boot_cpus(void);
-	extern void smp4d_boot_cpus(void);
+	extern void __init smp4m_boot_cpus(void);
+	extern void __init smp4d_boot_cpus(void);
 	int i, cpuid, extra;
 
 	printk("Entering SMP Mode...\n");
@@ -375,8 +375,8 @@ void __init smp_prepare_boot_cpu(void)
 
 int __cpuinit __cpu_up(unsigned int cpu)
 {
-	extern int smp4m_boot_one_cpu(int);
-	extern int smp4d_boot_one_cpu(int);
+	extern int __cpuinit smp4m_boot_one_cpu(int);
+	extern int __cpuinit smp4d_boot_one_cpu(int);
 	int ret=0;
 
 	switch(sparc_cpu_model) {
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index c80ea61..c69de5d 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -164,7 +164,7 @@ void __init smp4d_boot_cpus(void)
 	local_flush_cache_all();
 }
 
-int smp4d_boot_one_cpu(int i)
+int __cpuinit smp4d_boot_one_cpu(int i)
 {
 			extern unsigned long sun4d_cpu_startup;
 			unsigned long *entry = &sun4d_cpu_startup;
-- 
1.5.0-rc2.GIT


