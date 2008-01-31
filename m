Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbYAaKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbYAaKi0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765254AbYAaKiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:38:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:18637 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbYAaKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oKrofrlTZ5ezzlnQDC4ifzD3o04J57AXWhGlI5wgqC4BFUYP3r/fqhM6uNGX/rLihf2ZmmUe8NuHPUPF3Ggra4wLo9JRD5p57Yybqnxs20uV0FjS0zDz8rO3IWvFGwhGChDh+bpu0lj6VeUE/svogcHDZdZtd/pDxOtvt8c9V7A=
Subject: [PATCH] x86: fix sparse warnings in intel_cacheinfo.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 31 Jan 2008 02:38:10 -0800
Message-Id: <1201775890.23523.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/intel_cacheinfo.c:355:7: warning: symbol 'i' shadows an earlier one
arch/x86/kernel/cpu/intel_cacheinfo.c:296:39: originally declared here
arch/x86/kernel/cpu/intel_cacheinfo.c:367:18: warning: incorrect type in argument 2 (different signedness)
arch/x86/kernel/cpu/intel_cacheinfo.c:367:18:    expected unsigned int *eax
arch/x86/kernel/cpu/intel_cacheinfo.c:367:18:    got int *
arch/x86/kernel/cpu/intel_cacheinfo.c:367:28: warning: incorrect type in argument 3 (different signedness)
arch/x86/kernel/cpu/intel_cacheinfo.c:367:28:    expected unsigned int *ebx
arch/x86/kernel/cpu/intel_cacheinfo.c:367:28:    got int *
arch/x86/kernel/cpu/intel_cacheinfo.c:367:38: warning: incorrect type in argument 4 (different signedness)
arch/x86/kernel/cpu/intel_cacheinfo.c:367:38:    expected unsigned int *ecx
arch/x86/kernel/cpu/intel_cacheinfo.c:367:38:    got int *
arch/x86/kernel/cpu/intel_cacheinfo.c:367:48: warning: incorrect type in argument 5 (different signedness)
arch/x86/kernel/cpu/intel_cacheinfo.c:367:48:    expected unsigned int *edx
arch/x86/kernel/cpu/intel_cacheinfo.c:367:48:    got int *

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 8b4507b..1b88986 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -352,8 +352,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	 */
 	if ((num_cache_leaves == 0 || c->x86 == 15) && c->cpuid_level > 1) {
 		/* supports eax=2  call */
-		int i, j, n;
-		int regs[4];
+		int j, n;
+		unsigned int regs[4];
 		unsigned char *dp = (unsigned char *)regs;
 		int only_trace = 0;
 
@@ -368,7 +368,7 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 			/* If bit 31 is set, this is an unknown format */
 			for ( j = 0 ; j < 3 ; j++ ) {
-				if ( regs[j] < 0 ) regs[j] = 0;
+				if (regs[j] & (1 << 31)) regs[j] = 0;
 			}
 
 			/* Byte 0 is level count, not a descriptor */
-- 
1.5.4.rc4.1142.gf5a97



