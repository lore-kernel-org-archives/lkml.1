Return-Path: <linux-kernel-owner+w=401wt.eu-S934130AbZDINAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130AbZDINAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761281AbZDIM7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:59:50 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:3881 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933960AbZDIM7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:59:48 -0400
X-BigFish: VPS-8(zz936eQzz1202hzzz32i6bh)
X-FB-SS: 5,13,
X-WSS-ID: 0KHU437-01-L5U-01
Date: Thu, 9 Apr 2009 14:59:34 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] Revert "x86, cpu: intel_cacheinfo.c: use
	cpumask_first(to_cpumask())"
Message-ID: <20090409125934.GE31527@alberich.amd.com>
References: <20090409125659.GD31527@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090409125659.GD31527@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 09 Apr 2009 12:59:35.0245 (UTC) FILETIME=[085AB7D0:01C9B913]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

revert "x86, cpu: intel_cacheinfo.c: use cpumask_first(to_cpumask())"
and "x86, cpu: conform L3 Cache Index Disable to Linux standards"

in order to incrementally fix the L3 Cache index disable feature

This reverts commit d42c33ef0a236c6874c748438500c78edfaa1187.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>

---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6f4d2a3..b728325 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -643,8 +643,7 @@ static ssize_t show_##file_name						\
 static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 		 unsigned int index)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
 	struct pci_dev *dev = k8_northbridges[node];
 	unsigned int reg = 0;
 
@@ -666,8 +665,7 @@ static ssize_t
 store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 		 size_t count, unsigned int index)
 {
-	int cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
-	int node = cpu_to_node(cpu);
+	int node = cpu_to_node(first_cpu(this_leaf->shared_cpu_map));
 	struct pci_dev *dev = k8_northbridges[node];
 	unsigned long val = 0;
 	unsigned int scrubber = 0;
-- 
1.6.2



