Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbYKLXVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbYKLXVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbYKLXUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:43883 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755767AbYKLXUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="402946546"
Message-Id: <20081112212900.151113000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:49 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh@veritas.com>, Roland Dreier <rdreier@cisco.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/8] x86 PAT: set VM_PFNMAP flag in vm_insert_pfn
Content-Disposition: inline; filename=pfnmap_flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vm_insert_pfn() is not setting the VM_PFNMAP flag in vma. Fix that.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

Index: tip/mm/memory.c
===================================================================
--- tip.orig/mm/memory.c	2008-11-06 09:44:56.000000000 -0800
+++ tip/mm/memory.c	2008-11-10 09:44:47.000000000 -0800
@@ -1444,6 +1444,8 @@ int vm_insert_pfn(struct vm_area_struct 
 
 	if (addr < vma->vm_start || addr >= vma->vm_end)
 		return -EFAULT;
+
+	vma->vm_flags |= VM_PFNMAP;
 	return insert_pfn(vma, addr, pfn, vma->vm_page_prot);
 }
 EXPORT_SYMBOL(vm_insert_pfn);

-- 

