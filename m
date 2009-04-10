Return-Path: <linux-kernel-owner+w=401wt.eu-S938610AbZDJOGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938610AbZDJOGy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 10:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765311AbZDJOGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 10:06:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758534AbZDJOGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 10:06:43 -0400
Date: Fri, 10 Apr 2009 14:06:02 GMT
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, mark.langsdorf@amd.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, mark.langsdorf@amd.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090409134710.GA8026@alberich.amd.com>
References: <20090409134710.GA8026@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: complete L2/L3 Cache and TLB associativity field definitions
Message-ID: <tip-6265ff19ca08df0d96c859ae5e4dc2d9ad07070e@git.kernel.org>
Git-Commit-ID: 6265ff19ca08df0d96c859ae5e4dc2d9ad07070e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 14:06:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6265ff19ca08df0d96c859ae5e4dc2d9ad07070e
Gitweb:     http://git.kernel.org/tip/6265ff19ca08df0d96c859ae5e4dc2d9ad07070e
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:47:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 15:41:18 +0200

x86: cacheinfo: complete L2/L3 Cache and TLB associativity field definitions

See "CPUID Specification" (AMD Publication #: 25481, Rev. 2.28, April 2008)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
LKML-Reference: <20090409134710.GA8026@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/intel_cacheinfo.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index d46a849..789efe2 100644
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
+	[0xf] = 0xffff /* fully associative - no way to show this currently */
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
