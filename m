Return-Path: <linux-kernel-owner+w=401wt.eu-S1757072AbZEUXA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbZEUXA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 19:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756340AbZEUXA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 19:00:28 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2551 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404AbZEUXA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 19:00:26 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@redhat.com>, x86@vger.kernel.org,
       Len Brown <len.brown@intel.com>, Mike Travis <travis@sgi.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [PATCH 2/3] arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: Use DO_ONCE & spelling fix
Date: Thu, 21 May 2009 16:00:23 -0700
Message-Id: <a4b6b12afa9cf1ee6e936de5eed7cb31181553d8.1242943463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1242943463.git.joe@perches.com>
References: <cover.1242943463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allows removal of printk_once.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 208ecf6..f569cff 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -693,8 +693,8 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
 	    policy->cpuinfo.transition_latency > 20 * 1000) {
 		policy->cpuinfo.transition_latency = 20 * 1000;
-			printk_once(KERN_INFO "Capping off P-state tranision"
-				    " latency at 20 uS\n");
+		DO_ONCE(printk(KERN_INFO
+			       "P-state transition latency capped at 20 uS\n"));
 	}
 
 	/* table init */
-- 
1.6.3.1.10.g659a0.dirty

