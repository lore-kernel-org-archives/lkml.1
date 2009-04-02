Return-Path: <linux-kernel-owner+w=401wt.eu-S1758263AbZDBKIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbZDBKIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 06:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757608AbZDBKIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 06:08:14 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:11929
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755496AbZDBKIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 06:08:13 -0400
X-BigFish: VPS-14(zz936eQ4015M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KHGXH3-03-BEC-01
Date: Thu, 2 Apr 2009 12:07:56 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: cacheinfo: complete L2/L3 Cache and TLB associativity
	field definitions
Message-ID: <20090402100756.GN5740@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 02 Apr 2009 10:07:50.0953 (UTC) FILETIME=[E1A04990:01C9B37A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: complete cache information for AMD CPUs

See "CPUID Specification" (AMD Publication #: 25481, Rev. 2.28, April 2008)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

Please apply.

Thanks,

Andreas


diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index c471eb1..8f5f084 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -207,10 +207,17 @@ union l3_cache {
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
@@ -271,7 +278,8 @@ amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
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



