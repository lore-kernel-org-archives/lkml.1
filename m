Return-Path: <linux-kernel-owner+w=401wt.eu-S1758771AbZFJLH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771AbZFJLH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbZFJLHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:07:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56340 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZFJLHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:07:14 -0400
Date: Wed, 10 Jun 2009 11:06:34 GMT
From: tip-bot for Yong Wang <yong.y.wang@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       yong.y.wang@intel.com, arnd@arndb.de, yong.y.wang@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       yong.y.wang@intel.com, arnd@arndb.de, yong.y.wang@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
References: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
Subject: [tip:perfcounters/core] perf_counter/x86: Fix the model number of Intel Core2 processors
Message-ID: <tip-dc81081b2d9a6a9d64dad1bef1e5fc9fb660e53e@git.kernel.org>
Git-Commit-ID: dc81081b2d9a6a9d64dad1bef1e5fc9fb660e53e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 10 Jun 2009 11:06:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dc81081b2d9a6a9d64dad1bef1e5fc9fb660e53e
Gitweb:     http://git.kernel.org/tip/dc81081b2d9a6a9d64dad1bef1e5fc9fb660e53e
Author:     Yong Wang <yong.y.wang@linux.intel.com>
AuthorDate: Wed, 10 Jun 2009 17:06:12 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 10 Jun 2009 13:04:43 +0200

perf_counter/x86: Fix the model number of Intel Core2 processors

Fix the model number of Intel Core2 processors according to the
documentation: Intel Processor Identification with the CPUID
Instruction: http://www.intel.com/support/processors/sb/cs-009861.htm

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Also-Reported-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20090610090612.GA26580@ywang-moblin2.bj.intel.com>
[ Added two more model numbers suggested by Arnd Bergmann ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 40978aa..49f2585 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1407,7 +1407,10 @@ static int intel_pmu_init(void)
 	 * Install the hw-cache-events table:
 	 */
 	switch (boot_cpu_data.x86_model) {
-	case 17:
+	case 15: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
+	case 22: /* single-core 65 nm celeron/core2solo "Merom-L"/"Conroe-L" */
+	case 23: /* current 45 nm celeron/core2/xeon "Penryn"/"Wolfdale" */
+	case 29: /* six-core 45 nm xeon "Dunnington" */
 		memcpy(hw_cache_event_ids, core2_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
 
