Return-Path: <linux-kernel-owner+w=401wt.eu-S1764270AbXGNBUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764270AbXGNBUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbXGNBUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:20:35 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:34748 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761889AbXGNBUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:20:35 -0400
Date: Fri, 13 Jul 2007 21:20:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>
Subject: Powerpc - Include pagemap.h in asm/powerpc/tlb.h
Message-ID: <20070714012033.GC31649@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:19:15 up 6 days, 15:24,  2 users,  load average: 0.13, 0.21, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc - Include pagemap.h in asm/powerpc/tlb.h

Fixes this powerpc build error in 2.6.22-rc6-mm1 for powerpc 64 :

In file included from include2/asm/tlb.h:60,
                 from /home/compudj/git/linux-2.6-lttng/arch/powerpc/mm/init_64.
c:56:
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_fl
ush_mmu':
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:76: error: implicit 
declaration of function 'release_pages'
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h: In function 'tlb_re
move_page':
/home/compudj/git/linux-2.6-lttng/include/asm-generic/tlb.h:105: error: implicit
 declaration of function 'page_cache_release'
make[2]: *** [arch/powerpc/mm/init_64.o] Error 1

release_pages is declared in linux/pagemap.h, but cannot be included in
linux/swap.h because of a sparc related comment:

/* only sparc can not include linux/pagemap.h in this file
 * so leave page_cache_release and release_pages undeclared... */
#define free_page_and_swap_cache(page) \
        page_cache_release(page)
#define free_pages_and_swap_cache(pages, nr) \
        release_pages((pages), (nr), 0);

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: linuxppc-dev@ozlabs.org
CC: Paul Mackerras <paulus@samba.org>
---
 include/asm-powerpc/tlb.h |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6-lttng/include/asm-powerpc/tlb.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-powerpc/tlb.h	2007-07-13 11:30:54.000000000 -0400
+++ linux-2.6-lttng/include/asm-powerpc/tlb.h	2007-07-13 11:31:22.000000000 -0400
@@ -23,6 +23,8 @@
 #include <asm/mmu.h>
 #endif
 
+#include <linux/pagemap.h>
+
 struct mmu_gather;
 
 #define tlb_start_vma(tlb, vma)	do { } while (0)
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
