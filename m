Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbZFKP2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbZFKP2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754176AbZFKP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:28:44 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29223 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbZFKP2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:28:43 -0400
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: davej@codemonkey.org.uk
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>, andreas.herrmann3@amd.com,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com, trenn@suse.de
Message-Id: <20090611152609.8510.77996.sendpatchset@linux-fd7s.americas.hpqcorp.net>
In-Reply-To: <20090611152558.8510.75249.sendpatchset@linux-fd7s.americas.hpqcorp.net>
References: <20090611152558.8510.75249.sendpatchset@linux-fd7s.americas.hpqcorp.net>
Subject: [PATCH 2/2] powernow-k8: get drv data for correct CPU
Date: Thu, 11 Jun 2009 15:26:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make powernowk8_get() similar to powernowk8_target() and powernowk8_verify()
in the way it obtains "powernow_data" for a given CPU.

Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Langsdorf, Mark <mark.langsdorf@amd.com>
Cc: Thomas Renninger <trenn@suse.de>

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Reviewed-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Acked-by: Langsdorf, Mark <mark.langsdorf@amd.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 700ede9..069c825 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1371,13 +1371,9 @@ static int __devexit powernowk8_cpu_exit(struct cpufreq_policy *pol)
 
 static unsigned int powernowk8_get(unsigned int cpu)
 {
-	struct powernow_k8_data *data;
+	struct powernow_k8_data *data = per_cpu(powernow_data, cpu);
 	cpumask_t oldmask = current->cpus_allowed;
 	unsigned int khz = 0;
-	unsigned int first;
-
-	first = cpumask_first(cpu_core_mask(cpu));
-	data = per_cpu(powernow_data, first);
 
 	if (!data)
 		return -EINVAL;
-- 
1.6.2.2

