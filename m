Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXL1ASK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXL1ASK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 19:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755326AbXL1AQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 19:16:25 -0500
Received: from relay1.sgi.com ([192.48.171.29]:57370 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755230AbXL1AQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 19:16:19 -0500
Message-Id: <20071228001618.550107000@sgi.com>
References: <20071228001617.597161000@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Dec 2007 16:16:24 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [PATCH 07/10] Powerpc: Use generic per cpu
Content-Disposition: inline; filename=power_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- add missing #endif

Powerpc has a way to determine the address of the per cpu area of the
currently executing processor via the paca and the array of per cpu
offsets is avoided by looking up the per cpu area from the remote
paca's (copying x86_64).

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Mike Travis <travis@sgi.com>

---
 include/asm-powerpc/percpu.h |   21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

--- a/include/asm-powerpc/percpu.h
+++ b/include/asm-powerpc/percpu.h
@@ -16,25 +16,8 @@
 #define __my_cpu_offset() get_paca()->data_offset
 #define per_cpu_offset(x) (__per_cpu_offset(x))
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*RELOC_HIDE(&per_cpu__##var, __per_cpu_offset(cpu)))
-#define __get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, __my_cpu_offset()))
-#define __raw_get_cpu_var(var) (*RELOC_HIDE(&per_cpu__##var, local_paca->data_offset))
-
-extern void setup_per_cpu_areas(void);
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
-
-#endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#else
+#endif /* CONFIG_SMP */
+#endif /* __powerpc64__ */
 #include <asm-generic/percpu.h>
-#endif
 
 #endif /* _ASM_POWERPC_PERCPU_H_ */

-- 
