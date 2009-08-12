Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbZHLIRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbZHLIRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 04:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754907AbZHLIRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 04:17:41 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54921 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZHLIRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 04:17:40 -0400
Date: Wed, 12 Aug 2009 04:16:20 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090812081843.5757.64083.sendpatchset@localhost.localdomain>
In-Reply-To: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
References: <20090812081731.5757.25254.sendpatchset@localhost.localdomain>
Subject: [Patch 6/8] powerpc: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 2/8 we already implement the generic part, this will
add the rest part for powerpc.

Signed-off-by: WANG Cong <amwang@redhat.com>

---

Index: linux-2.6/arch/powerpc/include/asm/kexec.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/kexec.h
+++ linux-2.6/arch/powerpc/include/asm/kexec.h
@@ -39,6 +39,14 @@ typedef void (*crash_shutdown_t)(void);
 
 #ifdef CONFIG_KEXEC
 
+#ifdef CONFIG_KEXEC_AUTO_RESERVE
+#ifdef KEXEC_AUTO_RESERVED_SIZE
+#undef KEXEC_AUTO_RESERVED_SIZE
+#endif
+#define KEXEC_AUTO_RESERVED_SIZE (1ULL<<28) /* 256M */
+#include <asm-generic/kexec.h>
+#endif
+
 /*
  * This function is responsible for capturing register states if coming
  * via panic or invoking dump using sysrq-trigger.
