Return-Path: <linux-kernel-owner+w=401wt.eu-S1758936AbZFIID0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936AbZFIID0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbZFIIDC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:03:02 -0400
Received: from mga05.intel.com ([192.55.52.89]:7992 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756662AbZFIIDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:03:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,330,1241420400"; 
   d="scan'208";a="697697058"
Date: Tue, 9 Jun 2009 15:46:21 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -tip] perf_counter/x86: Fix incorrect default branch
Message-ID: <20090609074621.GA19290@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The event selector and UMASK values of Nehalem do not apply to all Intel processors.

Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 arch/x86/kernel/cpu/perf_counter.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 56001fe..c74b6d1 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1413,7 +1413,6 @@ static int intel_pmu_init(void)
 
 		pr_cont("Core2 events, ");
 		break;
-	default:
 	case 26:
 		memcpy(hw_cache_event_ids, nehalem_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
@@ -1426,6 +1425,8 @@ static int intel_pmu_init(void)
 
 		pr_cont("Atom events, ");
 		break;
+	default:
+		break;
 	}
 	return 0;
 }
