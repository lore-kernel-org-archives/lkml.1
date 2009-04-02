Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbZDBO5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbZDBO5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDBO5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:57:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:49002 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbZDBO5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,314,1235980800"; 
   d="scan'208";a="444385884"
Message-Id: <20090402145455.597376000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Apr 2009 16:54:55 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
Subject: [patch 00/18] x86, bts, ptrace, hw-branch-tracer: fixes and cleanups
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- 
Patches 1-5 fix races with context swithcing code when the branch traced task
is currently running.

In the worst case, this might cause context switch code to access freed
memory or the tracing hardware to continue tracing into a freed buffer.
Both might crash the kernel.

The first 4 patches apply to .29 using the below preparation patch.


The remaining patches fix bugs in the context of per-cpu tracing (i.e.
hw-branch-tracer) and pebs, add more selftest code, and do some cleanups.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6.29/arch/x86/kernel/ds.c
===================================================================
--- linux-2.6.29.orig/arch/x86/kernel/ds.c	2009-04-01 17:39:55.000000000 +0200
+++ linux-2.6.29/arch/x86/kernel/ds.c	2009-04-01 17:40:42.000000000 +0200
@@ -78,8 +78,8 @@ struct bts_tracer {
 	struct ds_tracer ds;
 	/* the trace including the DS configuration */
 	struct bts_trace trace;
-	/* buffer overflow notification function */
-	bts_ovfl_callback_t ovfl;
+	/* Buffer overflow notification function: */
+	bts_ovfl_callback_t	ovfl;
 };
 
 struct pebs_tracer {
Index: linux-2.6.29/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6.29.orig/arch/x86/kernel/ptrace.c	2009-04-01 17:39:55.000000000 +0200
+++ linux-2.6.29/arch/x86/kernel/ptrace.c	2009-04-01 17:40:42.000000000 +0200
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

