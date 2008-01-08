Return-Path: <linux-kernel-owner+w=401wt.eu-S1759064AbYAHKvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759064AbYAHKvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:51:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbYAHKvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:51:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:56420 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYAHKva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:51:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,257,1196668800"; 
   d="scan'208";a="318486395"
Date: Tue, 8 Jan 2008 11:49:52 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 1/2] x86, ptrace: add bts_struct size to status command
Message-ID: <20080108114952.A3352@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the size of bts_struct in the PTRACE_BTS_STATUS command.
Change types to u32.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2008-01-07 12:42:39.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2008-01-08 11:18:35.%N +0100
@@ -787,6 +787,8 @@
 			cfg.flags |= PTRACE_BTS_O_SCHED;
 	}
 
+	cfg.bts_size = sizeof(struct bts_struct);
+
 	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
 		return -EFAULT;
 
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2008-01-07 12:42:39.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2008-01-08 11:42:55.%N +0100
@@ -81,16 +81,21 @@
 #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
 
 #ifndef __ASSEMBLY__
+
+#include <asm/types.h>
+
 /* configuration/status structure used in PTRACE_BTS_CONFIG and
    PTRACE_BTS_STATUS commands.
 */
 struct ptrace_bts_config {
 	/* requested or actual size of BTS buffer in bytes */
-	unsigned int size;
+	u32 size;
 	/* bitmask of below flags */
-	unsigned int flags;
+	u32 flags;
 	/* buffer overflow signal */
-	unsigned int signal;
+	u32 signal;
+	/* actual size of bts_struct in bytes */
+	u32 bts_size;
 };
 #endif
 
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

