Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYLSVwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYLSVwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754529AbYLSVuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:50:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:53755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbYLSVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:50:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,250,1228118400"; 
   d="scan'208";a="372404920"
Message-Id: <20081219214836.980861000@intel.com>
References: <20081219214725.125171000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Dec 2008 13:47:26 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
       jeremy@goop.org, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/5] x86 PAT: clarify is_linear_pfn_mapping() interface
Content-Disposition: inline; filename=linear_pfnmap_comments.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Incremental patches to address the review comments from Nick Piggin
for v3 version of x86 PAT pfnmap changes patchset here

http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/01330.html

This patch:

Clarify is_linear_pfn_mapping() and its usage.

It is used by x86 PAT code for performance reasons. Identifying pfnmap
as linear over entire vma helps speedup reserve and free of memtype
for the region.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 include/linux/mm.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h	2008-12-19 09:55:33.000000000 -0800
+++ linux-2.6/include/linux/mm.h	2008-12-19 09:56:02.000000000 -0800
@@ -145,6 +145,14 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_WRITE	0x01	/* Fault was a write access */
 #define FAULT_FLAG_NONLINEAR	0x02	/* Fault was via a nonlinear mapping */
 
+/*
+ * This interface is used by x86 PAT code to identify a pfn mapping that is
+ * linear over entire vma. This is to optimize PAT code that deals with
+ * marking the physical region with a particular prot. This is not for generic
+ * mm use. Note also that this check will not work if the pfn mapping is
+ * linear for a vma starting at physical address 0. In which case PAT code
+ * falls back to slow path of reserving physical range page by page.
+ */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
 	return ((vma->vm_flags & VM_PFNMAP) && vma->vm_pgoff);

-- 

