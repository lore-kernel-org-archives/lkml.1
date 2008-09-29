Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYI2Vje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYI2Vje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 17:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYI2VjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 17:39:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:57312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602AbYI2VjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 17:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="445052877"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH] x86: export set_memory_ro and set_memory_rw
To: mingo@elte.hu, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       jesse.brandeburg@intel.com, bruce.w.allan@intel.com
Date: Mon, 29 Sep 2008 14:39:21 -0700
Message-ID: <20080929213921.20384.77770.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Export set_memory_ro() and set_memory_rw() calls for use by drivers that need
to have more debug information about who might be writing to memory space.
this was initially developed for use while debugging a memory corruption
problem with e1000e.

Ingo Molnar <mingo@elte.hu> said:
>> +EXPORT_SYMBOL(set_memory_rw);
> that's fine, as long as you make it kernel-internal EXPORT_SYMBOL_GPL()

patch was modified with this suggestion.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/mm/pageattr.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 43e2f84..62c1eef 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -906,11 +906,13 @@ int set_memory_ro(unsigned long addr, int numpages)
 {
 	return change_page_attr_clear(addr, numpages, __pgprot(_PAGE_RW));
 }
+EXPORT_SYMBOL_GPL(set_memory_ro);
 
 int set_memory_rw(unsigned long addr, int numpages)
 {
 	return change_page_attr_set(addr, numpages, __pgprot(_PAGE_RW));
 }
+EXPORT_SYMBOL_GPL(set_memory_rw);
 
 int set_memory_np(unsigned long addr, int numpages)
 {

