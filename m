Return-Path: <linux-kernel-owner+w=401wt.eu-S1760031AbYENPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031AbYENPPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbYENPPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:15:08 -0400
Received: from relay2.sgi.com ([192.48.171.30]:41157 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753704AbYENPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:07 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:04 -0700
Message-Id: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 1/10] x86 boot: include missing smp.h header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

The patch:
    x86: convert cpu_to_apicid to be a per cpu variable
introduced a dependency of ipi.h on smp.h in x86
builds with an allnoconfig.  Including smp.h in ipi.h
fixes the build error:
    In file included from arch/x86/kernel/traps_64.c:48:
    include/asm/ipi.h: In function 'send_IPI_mask_sequence':
    include/asm/ipi.h:114: error: 'per_cpu__x86_cpu_to_apicid' undeclared (first use in this function)

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: Mike Travis <travis@sgi.com>

---
 include/asm-x86/ipi.h |    1 +
 1 file changed, 1 insertion(+)

--- linux.orig/include/asm-x86/ipi.h	2008-05-13 10:44:39.000000000 -0700
+++ linux/include/asm-x86/ipi.h	2008-05-13 10:56:37.431506774 -0700
@@ -20,6 +20,7 @@
 
 #include <asm/hw_irq.h>
 #include <asm/apic.h>
+#include <asm/smp.h>
 
 /*
  * the following functions deal with sending IPIs between CPUs.

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
