Return-Path: <linux-kernel-owner+w=401wt.eu-S1764942AbXEUKQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764942AbXEUKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756679AbXEUKJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:09:41 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:4457 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761454AbXEUKJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:09:19 -0400
X-IronPort-AV: i="4.14,560,1170651600"; 
   d="scan'208"; a="39510279:sNHT21421323"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Cc: Mike Frysinger <michael.frysinger@analog.com>,
       Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 04/32] Blackfin arch: fix a few random warnings
Date: Mon, 21 May 2007 18:09:12 +0800
Message-Id: <11797421823946-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1179742180228-git-send-email-bryan.wu@analog.com>
References: <1179742180228-git-send-email-bryan.wu@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <michael.frysinger@analog.com>

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/mach-bf537/cpu.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/mach-bf537/cpu.c b/arch/blackfin/mach-bf537/cpu.c
index 2d83b7e..0442c4c 100644
--- a/arch/blackfin/mach-bf537/cpu.c
+++ b/arch/blackfin/mach-bf537/cpu.c
@@ -43,13 +43,13 @@
 #define VCO1 (CONFIG_CLKIN_HZ*9)	/*99532800 */
 #define VCO(x) VCO##x
 
-#define FREQ(x) {VCO(x),VCO(x)/4},{VCO(x),VCO(x)/2},{VCO(x),VCO(x)}
+#define MFREQ(x) {VCO(x),VCO(x)/4},{VCO(x),VCO(x)/2},{VCO(x),VCO(x)}
 /* frequency */
 static struct cpufreq_frequency_table bf537_freq_table[] = {
-	FREQ(1),
-	FREQ(3),
+	MFREQ(1),
+	MFREQ(3),
 	{VCO4, VCO4 / 2}, {VCO4, VCO4},
-	FREQ(5),
+	MFREQ(5),
 	{0, CPUFREQ_TABLE_END},
 };
 
@@ -59,13 +59,14 @@ static struct cpufreq_frequency_table bf537_freq_table[] = {
  */
 static int bf537_getfreq(unsigned int cpu)
 {
-	unsigned long cclk_mhz, vco_mhz;
+	unsigned long cclk_mhz;
 
 	/* The driver only support single cpu */
 	if (cpu == 0)
 		dpmc_fops.ioctl(NULL, NULL, IOCTL_GET_CORECLOCK, &cclk_mhz);
 	else
 		cclk_mhz = -1;
+
 	return cclk_mhz;
 }
 
@@ -75,13 +76,12 @@ static int bf537_target(struct cpufreq_policy *policy,
 	unsigned long cclk_mhz;
 	unsigned long vco_mhz;
 	unsigned long flags;
-	unsigned int index, vco_index;
-	int i;
-
+	unsigned int index;
 	struct cpufreq_freqs freqs;
-	if (cpufreq_frequency_table_target
-	    (policy, bf537_freq_table, target_freq, relation, &index))
+
+	if (cpufreq_frequency_table_target(policy, bf537_freq_table, target_freq, relation, &index))
 		return -EINVAL;
+
 	cclk_mhz = bf537_freq_table[index].frequency;
 	vco_mhz = bf537_freq_table[index].index;
 
@@ -114,8 +114,6 @@ static int bf537_verify_speed(struct cpufreq_policy *policy)
 
 static int __init __bf537_cpu_init(struct cpufreq_policy *policy)
 {
-	int result;
-
 	if (policy->cpu != 0)
 		return -EINVAL;
 
-- 
1.5.1.2
