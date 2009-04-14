Return-Path: <linux-kernel-owner+w=401wt.eu-S1756465AbZDNKD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465AbZDNKD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbZDNKCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:02:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:45811 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbZDNKCa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:02:30 -0400
Date: Tue, 14 Apr 2009 10:01:10 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       penberg@cs.helsinki.fi, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, jaswinder@kernel.org, jaswinderrajput@gmail.com,
       akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1239693869.3033.31.camel@ht.satnam>
References: <1239693869.3033.31.camel@ht.satnam>
Subject: [tip:x86/mm] x86: page_types.h unification of declarations
Message-ID: <tip-66aa230e437d89ca56224135f617e2d8e391a3ef@git.kernel.org>
Git-Commit-ID: 66aa230e437d89ca56224135f617e2d8e391a3ef
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 10:01:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  66aa230e437d89ca56224135f617e2d8e391a3ef
Gitweb:     http://git.kernel.org/tip/66aa230e437d89ca56224135f617e2d8e391a3ef
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Tue, 14 Apr 2009 12:54:29 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:44:45 +0200

x86: page_types.h unification of declarations

Impact: unification of declarations, cleanup

Unification of declarations:
 moved init_memory_mapping, initmem_init and free_initmem from
page_XX_types.h to page_types.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1239693869.3033.31.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/page_32_types.h |    4 ----
 arch/x86/include/asm/page_64_types.h |    6 ------
 arch/x86/include/asm/page_types.h    |    6 ++++++
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/page_32_types.h b/arch/x86/include/asm/page_32_types.h
index 0f915ae..6f1b733 100644
--- a/arch/x86/include/asm/page_32_types.h
+++ b/arch/x86/include/asm/page_32_types.h
@@ -54,10 +54,6 @@ extern unsigned int __VMALLOC_RESERVE;
 extern int sysctl_legacy_va_layout;
 
 extern void find_low_pfn_range(void);
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-extern void initmem_init(unsigned long, unsigned long);
-extern void free_initmem(void);
 extern void setup_bootmem_allocator(void);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d38c91b..3f58718 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -71,12 +71,6 @@ extern unsigned long __phys_addr(unsigned long);
 
 #define vmemmap ((struct page *)VMEMMAP_START)
 
-extern unsigned long init_memory_mapping(unsigned long start,
-					 unsigned long end);
-
-extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
-extern void free_initmem(void);
-
 extern void init_extra_mapping_uc(unsigned long phys, unsigned long size);
 extern void init_extra_mapping_wb(unsigned long phys, unsigned long size);
 
diff --git a/arch/x86/include/asm/page_types.h b/arch/x86/include/asm/page_types.h
index 826ad37..6473f5c 100644
--- a/arch/x86/include/asm/page_types.h
+++ b/arch/x86/include/asm/page_types.h
@@ -46,6 +46,12 @@ extern int devmem_is_allowed(unsigned long pagenr);
 extern unsigned long max_low_pfn_mapped;
 extern unsigned long max_pfn_mapped;
 
+extern unsigned long init_memory_mapping(unsigned long start,
+					 unsigned long end);
+
+extern void initmem_init(unsigned long start_pfn, unsigned long end_pfn);
+extern void free_initmem(void);
+
 #endif	/* !__ASSEMBLY__ */
 
 #endif	/* _ASM_X86_PAGE_DEFS_H */
