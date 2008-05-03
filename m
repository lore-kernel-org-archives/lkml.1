Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYECUwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYECUwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 16:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752451AbYECUwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 16:52:10 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51820 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbYECUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 16:52:09 -0400
Date: Sat, 3 May 2008 23:51:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] fix asm-alpha/types.h breakage
Message-ID: <20080503205103.GS5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following compile error on alpha caused by
commit 3726c23df8e4d95b6f2b335dfa90e3f4850a8a00
(alpha: types: use <asm-generic/int-*.h> for the alpha architecture):

<--  snip  -->

...
  CC      arch/alpha/kernel/asm-offsets.s
In file included from include2/asm/topology.h:6,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/topology.h:34,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/mmzone.h:683,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/gfp.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/slab.h:12,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/percpu.h:5,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/rcupdate.h:39,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/pid.h:4,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/sched.h:74,
                 from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/alpha/kernel/asm-offsets.c:9:
include2/asm/machvec.h:44: error: expected declaration specifiers or '...' before 'dma_addr_t'
include2/asm/machvec.h:44: error: expected declaration specifiers or '...' before 'dma_addr_t'
In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/alpha/kernel/asm-offsets.c:12:
include2/asm/io.h:94: warning: type defaults to 'int' in declaration of 'dma_addr_t'
include2/asm/io.h:94: warning: variable 'dma_addr_t' declared 'inline'
include2/asm/io.h:94: error: expected ',' or ';' before 'isa_page_to_bus'
make[2]: *** [arch/alpha/kernel/asm-offsets.s] Error 1

<--  snip  -->

---
--- a/include/asm-alpha/types.h
+++ b/include/asm-alpha/types.h
@@ -23,5 +23,11 @@ typedef unsigned int umode_t;
 
 #define BITS_PER_LONG 64
 
+#ifndef __ASSEMBLY__
+
+typedef u64 dma_addr_t;
+typedef u64 dma64_addr_t;
+
+#endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_TYPES_H */

