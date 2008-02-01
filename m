Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYBAJJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYBAJJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbYBAJJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:09:36 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:15455 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYBAJJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:09:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KvduZEkL6RPb7hpZTDenWe8SeqsB8ks33ugdkn4+WSttKM2nWj7/hhoLpa0qHDYzw71bCVtyffJGQql10K4EIfsb5Jcn0QuKobtjTPKfSU1ppoaSTpaa/aqYXKxY9oAUDnNphHPV60cyYRJHWKKwSmqEzEhmIGVAV7LyxFSLcpk=
Subject: [PATCH] x86: fix sparse warnings in cpu/common.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 01:09:20 -0800
Message-Id: <1201856960.23523.99.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The casts will always be needed, may as well make them the right
signedness.  The ebx variables can easily be unsigned, may as well.

arch/x86/kernel/cpu/common.c:261:21: warning: incorrect type in argument 2 (different signedness)
arch/x86/kernel/cpu/common.c:261:21:    expected unsigned int *eax
arch/x86/kernel/cpu/common.c:261:21:    got int *<noident>
arch/x86/kernel/cpu/common.c:262:9: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/cpu/common.c:262:9:    expected unsigned int *ebx
arch/x86/kernel/cpu/common.c:262:9:    got int *<noident>
arch/x86/kernel/cpu/common.c:263:9: warning: incorrect type in argument 4 (different signedness)
arch/x86/kernel/cpu/common.c:263:9:    expected unsigned int *ecx
arch/x86/kernel/cpu/common.c:263:9:    got int *<noident>
arch/x86/kernel/cpu/common.c:264:9: warning: incorrect type in argument 5 (different signedness)
arch/x86/kernel/cpu/common.c:264:9:    expected unsigned int *edx
arch/x86/kernel/cpu/common.c:264:9:    got int *<noident>
arch/x86/kernel/cpu/common.c:293:30: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/cpu/common.c:293:30:    expected unsigned int *ebx
arch/x86/kernel/cpu/common.c:293:30:    got int *<noident>
arch/x86/kernel/cpu/common.c:350:22: warning: incorrect type in argument 2 (different signedness)
arch/x86/kernel/cpu/common.c:350:22:    expected unsigned int *eax
arch/x86/kernel/cpu/common.c:350:22:    got int *<noident>
arch/x86/kernel/cpu/common.c:351:10: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/cpu/common.c:351:10:    expected unsigned int *ebx
arch/x86/kernel/cpu/common.c:351:10:    got int *<noident>
arch/x86/kernel/cpu/common.c:352:10: warning: incorrect type in argument 4 (different signedness)
arch/x86/kernel/cpu/common.c:352:10:    expected unsigned int *ecx
arch/x86/kernel/cpu/common.c:352:10:    got int *<noident>
arch/x86/kernel/cpu/common.c:353:10: warning: incorrect type in argument 5 (different signedness)
arch/x86/kernel/cpu/common.c:353:10:    expected unsigned int *edx
arch/x86/kernel/cpu/common.c:353:10:    got int *<noident>
arch/x86/kernel/cpu/common.c:362:30: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/cpu/common.c:362:30:    expected unsigned int *ebx
arch/x86/kernel/cpu/common.c:362:30:    got int *<noident>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/common.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d608c9e..b7b2142 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -258,10 +258,10 @@ static int __cpuinit have_cpuid_p(void)
 void __init cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
-	cpuid(0x00000000, &c->cpuid_level,
-	      (int *)&c->x86_vendor_id[0],
-	      (int *)&c->x86_vendor_id[8],
-	      (int *)&c->x86_vendor_id[4]);
+	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
+	      (unsigned int *)&c->x86_vendor_id[0],
+	      (unsigned int *)&c->x86_vendor_id[8],
+	      (unsigned int *)&c->x86_vendor_id[4]);
 
 	c->x86 = 4;
 	if (c->cpuid_level >= 0x00000001) {
@@ -283,7 +283,7 @@ void __init cpu_detect(struct cpuinfo_x86 *c)
 static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
-	int ebx;
+	unsigned int ebx;
 
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 	if (have_cpuid_p()) {
@@ -343,14 +343,14 @@ static void __init early_cpu_detect(void)
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 {
 	u32 tfms, xlvl;
-	int ebx;
+	unsigned int ebx;
 
 	if (have_cpuid_p()) {
 		/* Get vendor name */
-		cpuid(0x00000000, &c->cpuid_level,
-		      (int *)&c->x86_vendor_id[0],
-		      (int *)&c->x86_vendor_id[8],
-		      (int *)&c->x86_vendor_id[4]);
+		cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
+		      (unsigned int *)&c->x86_vendor_id[0],
+		      (unsigned int *)&c->x86_vendor_id[8],
+		      (unsigned int *)&c->x86_vendor_id[4]);
 		
 		get_cpu_vendor(c, 0);
 		/* Initialize the standard set of capabilities */
-- 
1.5.4.rc4.1142.gf5a97



