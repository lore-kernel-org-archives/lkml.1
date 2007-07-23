Return-Path: <linux-kernel-owner+w=401wt.eu-S1760204AbXGWG5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204AbXGWG5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763513AbXGWG5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758130AbXGWG4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:56:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462860"
Subject: [RFC 2/8]KVM: export several symbols kvm swap out needed
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:34 +0800
Message-Id: <1185173494.2645.66.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

export symbols kvm swapout required

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

Index: linux/mm/swap_state.c
===================================================================
--- linux.orig/mm/swap_state.c	2007-07-23 13:06:20.000000000 +0800
+++ linux/mm/swap_state.c	2007-07-23 13:29:14.000000000 +0800
@@ -207,6 +207,7 @@ void delete_from_swap_cache(struct page 
 	swap_free(entry);
 	page_cache_release(page);
 }
+EXPORT_SYMBOL(delete_from_swap_cache);
 
 /*
  * Strange swizzling function only for use by shmem_writepage
@@ -225,6 +226,7 @@ int move_to_swap_cache(struct page *page
 		INC_CACHE_INFO(exist_race);
 	return err;
 }
+EXPORT_SYMBOL(move_to_swap_cache);
 
 /*
  * Strange swizzling function for shmem_getpage (and shmem_unuse)
@@ -307,6 +309,7 @@ struct page * lookup_swap_cache(swp_entr
 	INC_CACHE_INFO(find_total);
 	return page;
 }
+EXPORT_SYMBOL(lookup_swap_cache);
 
 /* 
  * Locate a page of swap in physical memory, reserving swap cache space
@@ -364,3 +367,4 @@ struct page *read_swap_cache_async(swp_e
 		page_cache_release(new_page);
 	return found_page;
 }
+EXPORT_SYMBOL(read_swap_cache_async);
Index: linux/mm/swapfile.c
===================================================================
--- linux.orig/mm/swapfile.c	2007-07-23 13:06:20.000000000 +0800
+++ linux/mm/swapfile.c	2007-07-23 13:29:14.000000000 +0800
@@ -211,6 +211,7 @@ noswap:
 	spin_unlock(&swap_lock);
 	return (swp_entry_t) {0};
 }
+EXPORT_SYMBOL(get_swap_page);
 
 swp_entry_t get_swap_page_of_type(int type)
 {
@@ -303,6 +304,7 @@ void swap_free(swp_entry_t entry)
 		spin_unlock(&swap_lock);
 	}
 }
+EXPORT_SYMBOL(swap_free);
 
 /*
  * How many references to page are currently swapped out?
Index: linux/mm/filemap.c
===================================================================
--- linux.orig/mm/filemap.c	2007-07-23 13:06:20.000000000 +0800
+++ linux/mm/filemap.c	2007-07-23 13:29:14.000000000 +0800
@@ -465,6 +465,7 @@ int add_to_page_cache_lru(struct page *p
 		lru_cache_add(page);
 	return ret;
 }
+EXPORT_SYMBOL(add_to_page_cache_lru);
 
 #ifdef CONFIG_NUMA
 struct page *__page_cache_alloc(gfp_t gfp)
