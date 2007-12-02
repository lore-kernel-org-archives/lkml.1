Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbXLBAnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbXLBAnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 19:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbXLBAnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 19:43:13 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60151 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755267AbXLBAnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 19:43:12 -0500
Date: Sun, 2 Dec 2007 01:43:04 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Chris Clayton <chris2553@googlemail.com>, davej@codemonkey.org.uk
Cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
Subject: [2.6 patch] drivers/cpufreq/cpufreq_stats.c section fix
Message-ID: <20071202004304.GG15974@stusta.de>
References: <200711291419.49261.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711291419.49261.chris2553@googlemail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpufreq_stats_free_table() mustn't be __cpuexit since it's called by the 
__cpuinit cpufreq_stat_cpu_callback().

This patch fixes the following section mismatch reported by
Chris Clayton:

<--  snip  -->

...
WARNING: vmlinux.o(.init.text+0x143dd): Section mismatch: reference to .exit.text:cpufreq_stats_free_table (between 'cpufreq_stat_cpu_callback' and 'cpufreq_stats_init')
...

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b845706570b48f091f855c33cdb9979d7e83a424 
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 8a45d0f..1b8312b 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -164,7 +164,7 @@ freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	return -1;
 }
 
-static void __cpuexit cpufreq_stats_free_table(unsigned int cpu)
+static void cpufreq_stats_free_table(unsigned int cpu)
 {
 	struct cpufreq_stats *stat = cpufreq_stats_table[cpu];
 	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);

