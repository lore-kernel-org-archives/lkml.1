Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbZEVU2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbZEVU2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 16:28:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757454AbZEVU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 16:28:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:16832 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757008AbZEVU2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 16:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,235,1241420400"; 
   d="scan'208";a="414966631"
Message-Id: <20090522202505.278649000@intel.com>
References: <20090522202336.942728000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 22 May 2009 13:23:37 -0700
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       shaohua.li@intel.com,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 1/2] x86: bugfix wbinvd() model check instead of family check
Content-Disposition: inline; filename=0001--bugfix-wbinvd-model-check-instead-of-family-chec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wbinvd is supported on all CPUs 486 or later. But,
pageattr.c is checking x86_model >= 4 before wbinvd(), which looks like
an oversight bug. It was first introduced at one place by changeset
d7c8f21a8cad0228c7c5ce2bb6dbd95d1ee49d13 and got copied over to second
place in the same file later.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 arch/x86/mm/pageattr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 797f9f1..2cc019a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -153,7 +153,7 @@ static void __cpa_flush_all(void *arg)
 	 */
 	__flush_tlb_all();
 
-	if (cache && boot_cpu_data.x86_model >= 4)
+	if (cache && boot_cpu_data.x86 >= 4)
 		wbinvd();
 }
 
@@ -218,7 +218,7 @@ static void cpa_flush_array(unsigned long *start, int numpages, int cache,
 
 	/* 4M threshold */
 	if (numpages >= 1024) {
-		if (boot_cpu_data.x86_model >= 4)
+		if (boot_cpu_data.x86 >= 4)
 			wbinvd();
 		return;
 	}
-- 
1.6.0.6

-- 

