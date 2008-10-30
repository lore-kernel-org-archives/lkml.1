Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbYJ3VFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbYJ3VFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbYJ3VFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:05:42 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55842 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774AbYJ3VFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:05:41 -0400
Subject: [PATCH] x86: use CONFIG_X86_SMP instead of CONFIG_SMP
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 16:05:39 -0500
Message-Id: <1225400739.19324.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6e5fbb4691fd68f5b03608c5d8d96e4f189e623a Mon Sep 17 00:00:00 2001
From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Wed, 29 Oct 2008 13:11:48 -0500
Subject: [VOYAGER] x86: use CONFIG_X86_SMP instead of CONFIG_SMP

CONFIG_SMP is used for features which work on *all* x86 boxes.
CONFIG_X86_SMP is used for standard PC like x86 boxes (for things like
multi core and apics)

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 +-
 arch/x86/kernel/tsc.c                      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 0d9c993..ef8f831 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -69,7 +69,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
  */
 void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 {
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
 	unsigned int ht_mask_width, core_plus_mask_width;
 	unsigned int core_select_mask, core_level_siblings;
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 161bb85..62348e4 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -759,7 +759,7 @@ __cpuinit int unsynchronized_tsc(void)
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
 
-#ifdef CONFIG_SMP
+#ifdef CONFIG_X86_SMP
 	if (apic_is_clustered_box())
 		return 1;
 #endif
-- 
1.5.6.5



