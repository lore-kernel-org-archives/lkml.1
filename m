Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbXG0AH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbXG0AH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXG0AHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:07:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:59790 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbXG0AHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:07:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,585,1175497200"; 
   d="scan'208";a="273245190"
Date: Thu, 26 Jul 2007 17:01:33 -0700
From: Fenghua Yu <fenghua.yu@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       venkatesh.pallipadi@intel.com, Dave Jones <davej@redhat.com>
Subject: Re:[PATCH] Fix uninitialized local variable "covered" in i386 acpi-cpufreq driver
Message-ID: <20070727000133.GA31746@linux-os.sc.intel.com>
References: <1181754124.6148.37.camel@localhost> <20070613172106.GA3002@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070613172106.GA3002@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patch:
Use CPU_MASK_NONE for initil value.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

---

 arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
index 6f846be..14fc5b8 100644
--- a/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/i386/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -511,7 +511,7 @@ acpi_cpufreq_guess_freq(struct acpi_cpufreq_data *data, unsigned int cpu)
 static int acpi_cpufreq_early_init(void)
 {
 	struct acpi_processor_performance *data;
-	cpumask_t covered;
+	cpumask_t covered = CPU_MASK_NONE;
 	unsigned int i, j;
 
 	dprintk("acpi_cpufreq_early_init\n");
