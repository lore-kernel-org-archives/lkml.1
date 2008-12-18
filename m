Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753779AbYLRUDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbYLRUDU (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYLRUBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:01:48 -0500
Received: from mga09.intel.com ([134.134.136.24]:27331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYLRUBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:01:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,244,1228118400"; 
   d="scan'208";a="475173574"
Message-Id: <20081218194617.987565000@intel.com>
References: <20081218194126.963894000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 18 Dec 2008 11:41:33 -0800
From: venkatesh.pallipadi@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        akpm@linux-foundation.org, npiggin@suse.de, hugh@veritas.com
Cc: arjan@infradead.org, jbarnes@virtuousgeek.org, rdreier@cisco.com,
        jeremy@goop.org, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 7/7] x86 PAT: update documentation to cover pgprot and remap_pfn related changes - v3
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

Index: linux-2.6/Documentation/x86/pat.txt
===================================================================
--- linux-2.6.orig/Documentation/x86/pat.txt	2008-12-17 15:01:50.000000000 -0800
+++ linux-2.6/Documentation/x86/pat.txt	2008-12-17 17:23:16.000000000 -0800
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

