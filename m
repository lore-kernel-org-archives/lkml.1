Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYKLXXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYKLXXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 18:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755870AbYKLXUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 18:20:19 -0500
Received: from mga14.intel.com ([143.182.124.37]:4164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755833AbYKLXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 18:20:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,592,1220252400"; 
   d="scan'208";a="75121296"
Message-Id: <20081112212900.999435000@intel.com>
References: <20081112212647.259698000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 13:26:55 -0800
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
Subject: [patch 8/8] x86 PAT: update documentation to cover pgprot and remap_pfn related changes
Content-Disposition: inline; filename=documentation_update.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation related to pgprot_* change.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 Documentation/x86/pat.txt |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: tip/Documentation/x86/pat.txt
===================================================================
--- tip.orig/Documentation/x86/pat.txt	2008-11-06 09:44:10.000000000 -0800
+++ tip/Documentation/x86/pat.txt	2008-11-06 16:19:05.000000000 -0800
@@ -80,6 +80,30 @@ pci proc               |    --    |    -
                        |          |            |                  |
 -------------------------------------------------------------------
 
+Advanced APIs for drivers
+-------------------------
+A. Exporting pages to user with remap_pfn_range, io_remap_pfn_range,
+vm_insert_pfn
+
+Drivers wanting to export some pages to userspace, do it by using mmap
+interface and a combination of
+1) pgprot_noncached()
+2) io_remap_pfn_range() or remap_pfn_range() or vm_insert_pfn()
+
+With pat support, a new API pgprot_writecombine is being added. So, driver can
+continue to use the above sequence, with either pgprot_noncached() or
+pgprot_writecombine() in step 1, followed by step 2.
+
+In addition, step 2 internally tracks the region as UC or WC in memtype
+list in order to ensure no conflicting mapping.
+
+Note that this set of APIs only work with IO (non RAM) regions. If driver
+wants to export RAM region, it has to do set_memory_uc() or set_memory_wc()
+as step 0 above and also track the usage of those pages and use set_memory_wb()
+before the page is freed to free pool.
+
+
+
 Notes:
 
 -- in the above table mean "Not suggested usage for the API". Some of the --'s

-- 

