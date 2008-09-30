Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYI3DUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYI3DUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYI3DTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:19:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:59268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbYI3DTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:19:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="621752533"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [RFC PATCH 01/12] x86: export set_memory_ro and set_memory_rw
To: linux-kernel@vger.kernel.org
Cc: linux-netdev@vger.kernel.org, kkeil@suse.de, agospoda@redhat.com,
       arjan@linux.intel.com, david.graham@intel.com, bruce.w.allan@intel.com,
       jkosina@suse.cz, john.ronciak@intel.com, tglx@linutronix.de,
       chris.jones@canonical.com, tim.gardner@intel.com, airlied@gmail.com,
       Bruce Allan <bruce.w.allan@intel.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Mon, 29 Sep 2008 20:19:22 -0700
Message-ID: <20080930031922.22950.84239.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Sep 2008 03:19:22.0247 (UTC) FILETIME=[554A8970:01C922AB]
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

