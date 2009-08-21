Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZHUG4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZHUG4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZHUG4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:56:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbZHUG4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:56:16 -0400
Date: Fri, 21 Aug 2009 02:55:24 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       bernhard.walle@gmx.de, Fenghua Yu <fenghua.yu@intel.com>,
       kamezawa.hiroyu@jp.fujitsu.com,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Message-Id: <20090821065749.4855.3923.sendpatchset@localhost.localdomain>
In-Reply-To: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain>
Subject: [Patch 7/8] powerpc: implement crashkernel=auto
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since in patch 3/8 we already implement the generic part, this will
add the rest part for powerpc.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>

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
