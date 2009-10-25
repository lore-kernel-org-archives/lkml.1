Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094AbZJYS2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094AbZJYS2T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 14:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZJYS2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 14:28:18 -0400
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:25569 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbZJYS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 14:28:18 -0400
Date: Sun, 25 Oct 2009 19:45:57 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH] powernow-k6: set transition latency value so ondemand
 governor can be used
Message-Id: <20091025194557.1d5ed484.krzysztof.h1@poczta.fm>
In-Reply-To: <20091025032813.GB2475@redhat.com>
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
	<20091025032813.GB2475@redhat.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 9ce2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Krzysztof Helt <krzysztof.h1@wp.pl>

Set the transition latency to value smaller than CPUFREQ_ETERNAL so
governors other than "performance" work (like the "ondemand" one).

The value is found in "AMD PowerNow! Technology Platform Design Guide for 
Embedded Processors" dated December 2000 (AMD doc #24267A). There is the 
answer to one of FAQs on page 40 which states that suggested complete transition 
period is 200 us.

Tested on K6-2+ CPU with K6-3 core (model 13, stepping 4).

Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---


diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
index f10dea4..afc6a27 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k6.c
@@ -164,7 +164,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
+	policy->cpuinfo.transition_latency = 200000;
 	policy->cur = busfreq * max_multiplier;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);

----------------------------------------------------------------------
Szukasz pracy? Chcesz lepiej zarabiaæ?
Sprawd¼ oferty na http://link.interia.pl/f23ba

