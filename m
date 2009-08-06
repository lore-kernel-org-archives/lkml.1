Return-Path: <linux-kernel-owner+w=401wt.eu-S1754169AbZHFGUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169AbZHFGUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 02:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZHFGUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 02:20:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43346 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbZHFGUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 02:20:32 -0400
Date: Thu, 6 Aug 2009 02:19:50 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090806062211.5578.59301.sendpatchset@localhost.localdomain>
In-Reply-To: <20090806062125.5578.72123.sendpatchset@localhost.localdomain>
References: <20090806062125.5578.72123.sendpatchset@localhost.localdomain>
Subject: [Patch 4/7] ia64: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 2/7 we already implement the generic part, this will
add the rest part for ia64.

Signed-off-by: WANG Cong <amwang@redhat.com>

---

Index: linux-2.6/arch/ia64/include/asm/kexec.h
===================================================================
--- linux-2.6.orig/arch/ia64/include/asm/kexec.h
+++ linux-2.6/arch/ia64/include/asm/kexec.h
@@ -19,6 +19,14 @@
                 flush_icache_range(page_addr, page_addr + PAGE_SIZE); \
         } while(0)
 
+#ifdef CONFIG_KEXEC_AUTO_RESERVE
+#ifdef KEXEC_AUTO_RESERVED_SIZE
+#undef KEXEC_AUTO_RESERVED_SIZE
+#endif
+#define KEXEC_AUTO_RESERVED_SIZE (1ULL<<28) /* 256M */
+#include <asm-generic/kexec.h>
+#endif
+
 extern struct kimage *ia64_kimage;
 extern const unsigned int relocate_new_kernel_size;
 extern void relocate_new_kernel(unsigned long, unsigned long,
