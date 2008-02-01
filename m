Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYBAJeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYBAJeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 04:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755583AbYBAJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 04:34:22 -0500
Received: from mga11.intel.com ([192.55.52.93]:9695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300AbYBAJeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 04:34:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,289,1199692800"; 
   d="scan'208";a="294850347"
Subject: [PATCH 1/4] x86: check __supported_pte_mask in set_memory_x/nx
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 01 Feb 2008 17:34:47 +0800
Message-Id: <1201858487.4051.17.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 01 Feb 2008 09:33:42.0103 (UTC) FILETIME=[88711670:01C864B5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __supported_pte_mask checking to set_memory_x/nx.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/pageattr.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -445,13 +445,21 @@ EXPORT_SYMBOL(set_memory_wb);
 
 int set_memory_x(unsigned long addr, int numpages)
 {
-	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_NX));
+	if (__supported_pte_mask & _PAGE_NX)
+		return change_page_attr_clear(addr, numpages,
+					      __pgprot(_PAGE_NX));
+	else
+		return 0;
 }
 EXPORT_SYMBOL(set_memory_x);
 
 int set_memory_nx(unsigned long addr, int numpages)
 {
-	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_NX));
+	if (__supported_pte_mask & _PAGE_NX)
+		return change_page_attr_set(addr, numpages,
+					    __pgprot(_PAGE_NX));
+	else
+		return 0;
 }
 EXPORT_SYMBOL(set_memory_nx);
 

