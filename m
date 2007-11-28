Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbXK1VR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbXK1VR0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 16:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbXK1VPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 16:15:34 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56241 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755573AbXK1VP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 16:15:28 -0500
Message-Id: <20071128211527.605502990@sgi.com>
References: <20071128210926.008783214@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 28 Nov 2007 13:09:33 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>
Subject: [patch 07/10] Powerpc: Use generic per cpu
Content-Disposition: inline; filename=power_generic_percpu
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

V1->V2:
- add missing #endif

Powerpc has a way to determine the address of the per cpu area of the
currently executing processor via the paca and the array of per cpu
offsets is avoided by looking up the per cpu area from the remote
paca's (copying x86_64).

Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/asm-powerpc/percpu.h |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

Index: linux-2.6.24-rc3-mm2/include/asm-powerpc/percpu.h
===================================================================
--- linux-2.6.24-rc3-mm2.orig/include/asm-powerpc/percpu.h	2007-11-28 12:51:42.448213150 -0800
+++ linux-2.6.24-rc3-mm2/include/asm-powerpc/percpu.h	2007-11-28 12:51:57.612463251 -0800
@@ -16,25 +16,7 @@
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
-#include <asm-generic/percpu.h>
 #endif
-
+#include <asm-generic/percpu.h>
 #endif /* _ASM_POWERPC_PERCPU_H_ */

-- 
