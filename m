Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbYHUCiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbYHUCiV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 22:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbYHUChF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 22:37:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:13995 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbYHUChE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 22:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,243,1217833200"; 
   d="scan'208";a="608454893"
Subject: [patch 4/4] fix pageattr-test
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Dave Airlie <airlied@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 10:46:21 +0800
Message-Id: <1219286781.18007.42.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We changed the interface of some pageattr, this patch makes
pageattr-test compile.

Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 arch/x86/mm/pageattr-test.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/arch/x86/mm/pageattr-test.c
===================================================================
--- linux.orig/arch/x86/mm/pageattr-test.c	2008-08-21 09:57:56.000000000 +0800
+++ linux/arch/x86/mm/pageattr-test.c	2008-08-21 10:01:41.000000000 +0800
@@ -118,6 +118,7 @@ static int pageattr_test(void)
 	unsigned int level;
 	int i, k;
 	int err;
+	unsigned long test_addr;
 
 	if (print)
 		printk(KERN_INFO "CPA self-test:\n");
@@ -172,7 +173,8 @@ static int pageattr_test(void)
 			continue;
 		}
 
-		err = change_page_attr_set(addr[i], len[i], PAGE_TESTBIT);
+		test_addr = addr[i];
+		err = change_page_attr_set(&test_addr, len[i], PAGE_TESTBIT, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA %d failed %d\n", i, err);
 			failed++;
@@ -204,7 +206,8 @@ static int pageattr_test(void)
 			failed++;
 			continue;
 		}
-		err = change_page_attr_clear(addr[i], len[i], PAGE_TESTBIT);
+		test_addr = addr[i];
+		err = change_page_attr_clear(&test_addr, len[i], PAGE_TESTBIT, 0);
 		if (err < 0) {
 			printk(KERN_ERR "CPA reverting failed: %d\n", err);
 			failed++;


