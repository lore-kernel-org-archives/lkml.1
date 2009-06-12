Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbZFLL2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbZFLL2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFLL2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:28:40 -0400
Received: from ozlabs.org ([203.10.76.45]:36234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbZFLL2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:28:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dave Jones <davej@redhat.com>
Subject: [PATCH] cpumask: new cpumask operators for arch/x86/kernel/cpu/cpufreq/powernow-k8.c
Date: Fri, 12 Jun 2009 20:58:37 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, mark.langsdorf@amd.com
References: <20090611225928.E6FF4DDDA1@ozlabs.org> <20090611232517.GA32486@redhat.com>
In-Reply-To: <20090611232517.GA32486@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906122058.38112.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all old-style cpumask operators, and cpumask_t.

Also: get rid of the unused define_siblings function.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    8 ++++----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |   11 -----------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1060,7 +1060,7 @@ static int transition_frequency_fidvid(s
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1068,7 +1068,7 @@ static int transition_frequency_fidvid(s
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -1093,7 +1093,7 @@ static int transition_frequency_pstate(s
 			data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1101,7 +1101,7 @@ static int transition_frequency_pstate(s
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.h
@@ -223,14 +223,3 @@ static void powernow_k8_acpi_pst_values(
 
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
-
-#ifdef CONFIG_SMP
-static inline void define_siblings(int cpu, cpumask_t cpu_sharedcore_mask[])
-{
-}
-#else
-static inline void define_siblings(int cpu, cpumask_t cpu_sharedcore_mask[])
-{
-	cpu_set(0, cpu_sharedcore_mask[0]);
-}
-#endif

