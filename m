Return-Path: <linux-kernel-owner+w=401wt.eu-S1763334AbZFKOzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763334AbZFKOzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763086AbZFKOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:54:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:13006 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763011AbZFKOya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:54:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,203,1243839600"; 
   d="scan'208";a="153177175"
Message-Id: <20090611144430.414445947@intel.com>
References: <20090611142239.192891591@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 11 Jun 2009 22:22:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
CC: Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when feature is disabled
Content-Disposition: inline; filename=hwpoison-remove-ifdef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So as to eliminate one #ifdef in the c source.

Proposed by Nick Piggin.

CC: Nick Piggin <npiggin@suse.de>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 arch/x86/mm/fault.c |    3 +--
 include/linux/mm.h  |    7 ++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

--- sound-2.6.orig/arch/x86/mm/fault.c
+++ sound-2.6/arch/x86/mm/fault.c
@@ -819,14 +819,13 @@ do_sigbus(struct pt_regs *regs, unsigned
 	tsk->thread.error_code	= error_code;
 	tsk->thread.trap_no	= 14;
 
-#ifdef CONFIG_MEMORY_FAILURE
 	if (fault & VM_FAULT_HWPOISON) {
 		printk(KERN_ERR
 	"MCE: Killing %s:%d due to hardware memory corruption fault at %lx\n",
 			tsk->comm, tsk->pid, address);
 		code = BUS_MCEERR_AR;
 	}
-#endif
+
 	force_sig_info_fault(SIGBUS, code, address, tsk);
 }
 
--- sound-2.6.orig/include/linux/mm.h
+++ sound-2.6/include/linux/mm.h
@@ -702,11 +702,16 @@ static inline int page_mapped(struct pag
 #define VM_FAULT_SIGBUS	0x0002
 #define VM_FAULT_MAJOR	0x0004
 #define VM_FAULT_WRITE	0x0008	/* Special case for get_user_pages */
-#define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned page */
 
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 
+#ifdef CONFIG_MEMORY_FAILURE
+#define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned page */
+#else
+#define VM_FAULT_HWPOISON 0
+#endif
+
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_HWPOISON)
 
 /*

-- 

