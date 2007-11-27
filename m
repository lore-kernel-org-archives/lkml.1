Return-Path: <linux-kernel-owner+w=401wt.eu-S1758964AbXK0AR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964AbXK0AR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 19:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758029AbXK0AOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 19:14:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45364 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757125AbXK0AOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 19:14:32 -0500
Message-Id: <20071127001431.688565525@sgi.com>
References: <20071127001407.859743255@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 26 Nov 2007 16:14:18 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [patch 11/14] Powerpc: Use generic per cpu
Content-Disposition: inline; filename=power_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc has a way to determine the address of the per cpu area of the
currently executing processor via the paca and the array of per cpu
offsets is avoided by looking up the per cpu area from the remote
paca's (copying x86_64).

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-powerpc/percpu.h |   19 -------------------
 1 file changed, 19 deletions(-)

Index: linux-2.6/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-powerpc/percpu.h	2007-11-24 10:27:31.088350556 -0800
+++ linux-2.6/include/asm-powerpc/percpu.h	2007-11-24 10:29:20.752350757 -0800
@@ -16,25 +16,6 @@
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
 #endif	/* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
-
-#else
 #include <asm-generic/percpu.h>
-#endif
-
 #endif /* _ASM_POWERPC_PERCPU_H_ */

-- 
