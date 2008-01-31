Return-Path: <linux-kernel-owner+w=401wt.eu-S1765338AbYAaHgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765338AbYAaHgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 02:36:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYAaHg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 02:36:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:44333 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYAaHgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 02:36:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,283,1199692800"; 
   d="scan'208";a="332638348"
Subject: [PATCH 1/5] x86: change_page_attr_clear fix
From: "Huang, Ying" <ying.huang@intel.com>
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 31 Jan 2008 15:35:59 +0800
Message-Id: <1201764959.12950.22.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 31 Jan 2008 07:34:57.0027 (UTC) FILETIME=[C7270530:01C863DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces __change_page_attr_set_clr() with
change_page_attr_set_clr() in change_page_attr_clear() to flush the
TLB/cache properly.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/mm/pageattr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -426,8 +426,7 @@ static inline int change_page_attr_set(u
 static inline int change_page_attr_clear(unsigned long addr, int numpages,
 					 pgprot_t mask)
 {
-	return __change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
-
+	return change_page_attr_set_clr(addr, numpages, __pgprot(0), mask);
 }
 
 int set_memory_uc(unsigned long addr, int numpages)

