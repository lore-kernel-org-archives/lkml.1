Return-Path: <linux-kernel-owner+w=401wt.eu-S1758532AbYAPCmE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532AbYAPCmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:42:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757969AbYAPClc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:41:32 -0500
Received: from mga03.intel.com ([143.182.124.21]:63877 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594AbYAPClO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:41:14 -0500
X-ExtLoop1: 1
Message-Id: <20080116024111.825025000@intel.com>
References: <20080116023955.597433000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 18:39:57 -0800
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/4] x86: PAT followup - Remove KERNPG_TABLE from pte entry
Content-Disposition: inline; filename=remove_pgtable_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KERNPG_TABLE was a bug in earlier patch. Remove it from pte.
pte_val() check is redundant as this routine is called immediately after a
ptepage is allocated afresh.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6.git/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mm/init_64.c	2008-01-15 11:02:23.000000000 -0800
+++ linux-2.6.git/arch/x86/mm/init_64.c	2008-01-15 11:06:37.000000000 -0800
@@ -541,9 +541,6 @@
 		if (address >= end)
 			break;
 
-		if (pte_val(*pte))
-			continue;
-
 		/* Nothing to map. Map the null page */
 		if (!(address & (~PAGE_MASK)) &&
 		    (address + PAGE_SIZE <= end) &&
@@ -561,9 +558,9 @@
 		}
 
 		if (exec)
-			entry = _PAGE_NX|_KERNPG_TABLE|_PAGE_GLOBAL|address;
+			entry = _PAGE_NX|_PAGE_GLOBAL|address;
 		else
-			entry = _KERNPG_TABLE|_PAGE_GLOBAL|address;
+			entry = _PAGE_GLOBAL|address;
 		entry &= __supported_pte_mask;
 		set_pte(pte, __pte(entry));
 	}

-- 
