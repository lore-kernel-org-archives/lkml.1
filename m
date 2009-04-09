Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZDINrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZDINrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbZDINrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:47:31 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:5376 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752561AbZDINra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:47:30 -0400
X-BigFish: VPS-14(zz936eQ4015M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KHU6AM-01-NFP-01
Date: Thu, 9 Apr 2009 15:47:10 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Mark Langsdorf <mark.langsdorf@amd.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: cacheinfo: complete L2/L3 Cache and TLB
	associativity field definitions
Message-ID: <20090409134710.GA8026@alberich.amd.com>
References: <20090402100756.GN5740@alberich.amd.com> <20090402103008.GA10828@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090402103008.GA10828@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 13:47:11.0240 (UTC) FILETIME=[AEA8F880:01C9B919]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


See "CPUID Specification" (AMD Publication #: 25481, Rev. 2.28, April 2008)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

This patch applies on top of the changes sent with

  [PATCH 0/8] x86: cacheinfo: cache_disable fixes/cleanup

Please apply.


Thanks,

Andreas


diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 47e4fb4..3329347 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -200,10 +200,17 @@ union l3_cache {
 };
 
 static const unsigned short __cpuinitconst assocs[] = {
-	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
-	[8] = 16, [0xa] = 32, [0xb] = 48,
+	[1] = 1,
+	[2] = 2,
+	[4] = 4,
+	[6] = 8,
+	[8] = 16,
+	[0xa] = 32,
+	[0xb] = 48,
 	[0xc] = 64,
-	[0xf] = 0xffff // ??
+	[0xd] = 96,
+	[0xe] = 128,
+	[0xf] = 0xffff // fully associative - no way to show this currently
 };
 
 static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
@@ -264,7 +271,8 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 	eax->split.type = types[leaf];
 	eax->split.level = levels[leaf];
 	if (leaf == 3)
-		eax->split.num_threads_sharing = current_cpu_data.x86_max_cores - 1;
+		eax->split.num_threads_sharing =
+			current_cpu_data.x86_max_cores - 1;
 	else
 		eax->split.num_threads_sharing = 0;
 	eax->split.num_cores_on_die = current_cpu_data.x86_max_cores - 1;
-- 
1.6.2



