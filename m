Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYAGMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYAGMec (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:34:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbYAGMeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:34:23 -0500
Received: from mga02.intel.com ([134.134.136.20]:32659 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920AbYAGMeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:34:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,253,1196668800"; 
   d="scan'208";a="250511040"
Date: Mon, 7 Jan 2008 13:33:46 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 1/2] x86, ptrace: add version and last remaining size to status command
Message-ID: <20080107133346.A11643@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return the API version and the size of a bts_struct in the PTRACE_BTS_STATUS command. This might be handy in case other archs want to use and extend the interface. It allows users to program against one version and continue to work for newer versions (they have to discard everything they don't understand, of course).

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/ptrace.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/ptrace.c	2008-01-07 12:42:39.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/ptrace.c	2008-01-07 13:09:07.%N +0100
@@ -787,6 +787,9 @@
 			cfg.flags |= PTRACE_BTS_O_SCHED;
 	}
 
+	cfg.bts_size = sizeof(struct bts_struct);
+	cfg.version  = PTRACE_BTS_VERSION;
+
 	if (copy_to_user(ucfg, &cfg, sizeof(cfg)))
 		return -EFAULT;
 
Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2008-01-07 12:42:39.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2008-01-07 13:08:39.%N +0100
@@ -91,6 +91,10 @@
 	unsigned int flags;
 	/* buffer overflow signal */
 	unsigned int signal;
+	/* actual size of bts_struct in bytes */
+	unsigned short bts_size;
+	/* interface version */
+	unsigned short version;
 };
 #endif
 
Index: linux-2.6-x86/include/asm-x86/ptrace.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace.h	2008-01-07 12:42:39.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace.h	2008-01-07 13:08:39.%N +0100
@@ -9,6 +9,8 @@
 
 #ifdef __KERNEL__
 
+#define PTRACE_BTS_VERSION 1
+
 /* the DS BTS struct is used for ptrace as well */
 #include <asm/ds.h>
 
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

