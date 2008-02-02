Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbYBBEFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbYBBEFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 23:05:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbYBBEE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 23:04:57 -0500
Received: from po-out-1718.google.com ([72.14.252.159]:5666 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbYBBEE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 23:04:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l9ofF6XVI7BqpvYfcGu0EZqTlOoJOq6bYiKWTlttr9d7/ohhfNBdulep4e3jJcHiCmDYpW7t7Knfu46FQFKHWuTXSD+hYZT5XosUPLr3wg9CqlDXNJcOp932O8UZ2ik/3Zll/cdVdQw9MPBQm18c8mvV7WGavIPldkblNemn8O8=
Subject: [PATCH 1/2] x86: add cpu init function defintions to cpu.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 20:05:01 -0800
Message-Id: <1201925101.23523.146.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu.h was already included everywhere needed.

Fixes following sparse warnings:

arch/x86/kernel/cpu/amd.c:343:12: warning: symbol 'amd_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/cyrix.c:444:12: warning: symbol 'cyrix_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/cyrix.c:456:12: warning: symbol 'nsc_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/centaur.c:467:12: warning: symbol 'centaur_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/transmeta.c:112:12: warning: symbol 'transmeta_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/intel.c:296:12: warning: symbol 'intel_cpu_init' was not declared. Should it be static?
arch/x86/kernel/cpu/nexgen.c:56:12: warning: symbol 'nexgen_init_cpu' was not declared. Should it be static?
arch/x86/kernel/cpu/umc.c:22:12: warning: symbol 'umc_init_cpu' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/common.c |   10 ----------
 arch/x86/kernel/cpu/cpu.h    |    9 +++++++++
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b7b2142..d9313d9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -623,16 +623,6 @@ cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
  * They will insert themselves into the cpu_devs structure.
  * Then, when cpu_init() is called, we can just iterate over that array.
  */
-
-extern int intel_cpu_init(void);
-extern int cyrix_init_cpu(void);
-extern int nsc_init_cpu(void);
-extern int amd_init_cpu(void);
-extern int centaur_init_cpu(void);
-extern int transmeta_init_cpu(void);
-extern int nexgen_init_cpu(void);
-extern int umc_init_cpu(void);
-
 void __init early_cpu_init(void)
 {
 	intel_cpu_init();
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index ad6527a..e0b38c3 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -27,3 +27,12 @@ extern void display_cacheinfo(struct cpuinfo_x86 *c);
 extern void early_init_intel(struct cpuinfo_x86 *c);
 extern void early_init_amd(struct cpuinfo_x86 *c);
 
+/* Specific CPU type init functions */
+int intel_cpu_init(void);
+int amd_init_cpu(void);
+int cyrix_init_cpu(void);
+int nsc_init_cpu(void);
+int centaur_init_cpu(void);
+int transmeta_init_cpu(void);
+int nexgen_init_cpu(void);
+int umc_init_cpu(void);
-- 
1.5.4.rc4.1142.gf5a97


