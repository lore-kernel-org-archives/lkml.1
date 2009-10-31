Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbZJaJpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbZJaJpG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZJaJpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:45:03 -0400
Received: from smtp.wp.pl ([212.77.101.1]:42044 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757377AbZJaJpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:45:01 -0400
Date: Sat, 31 Oct 2009 11:03:01 +0100
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] powernow-k6: set transition latency value so ondemand
 governor can be used
Message-Id: <20091031110301.eb3c83d3.krzysztof.h1@wp.pl>
In-Reply-To: <20091025032813.GB2475@redhat.com>
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
	<20091025032813.GB2475@redhat.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [0dME]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Set the transition latency to value smaller than CPUFREQ_ETERNAL so
governors other than "performance" work (like the "ondemand" one).

The value is found in "AMD PowerNow! Technology Platform Design Guide for
Embedded Processors" dated December 2000 (AMD doc #24267A). There is the
answer to one of FAQs on page 40 which states that suggested complete
transition period is 200 us.

Tested on K6-2+ CPU with K6-3 core (model 13, stepping 4).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
This is the second version of the patch with added comment into the source code.

 arch/x86/kernel/cpu/cpufreq/powernow-k6.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index f10dea4..15f84a6 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -163,8 +163,15 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 			clock_ratio[i].frequency = busfreq * f;
 	}
 
-	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	/*
+	 * cpuinfo and default policy values
+	 *
+	 * The value is found in "AMD PowerNow! Technology Platform
+	 * Design Guide for Embedded Processors" dated December 2000
+	 * (AMD doc #24267A). There is the answer to one of FAQs on page 40
+	 * which states that suggested complete transition period is 200 us.
+	 */
+	policy->cpuinfo.transition_latency = 200000;
 	policy->cur = busfreq * max_multiplier;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
-- 
1.6.4

