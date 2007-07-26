Return-Path: <linux-kernel-owner+w=401wt.eu-S1764583AbXGZXw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764583AbXGZXw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:52:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbXGZXwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:52:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:58163 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628AbXGZXwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:52:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,585,1175497200"; 
   d="scan'208";a="273239150"
Date: Thu, 26 Jul 2007 16:46:30 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       venkatesh.pallipadi@intel.com
Subject: [PATCH] Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
Message-ID: <20070726234630.GA29288@linux-os.sc.intel.com>
References: <1181754124.6148.37.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181754124.6148.37.camel@localhost>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The local variable "covered" is used without initialization in i386 acpi-cpufreq
driver. The initial value of covered should be 0. The bug will cause memory leak
when hit. The following patch fixes this bug.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 6f846be..bfb4959 100644
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -511,7 +511,7 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
 static int acpi_cpufreq_early_init(void)
 {
 	struct acpi_processor_performance *data;
-	cpumask_t covered;
+	cpumask_t covered=0;
 	unsigned int i, j;
 
 	dprintk("acpi_cpufreq_early_init\n");
