Return-Path: <linux-kernel-owner+w=401wt.eu-S1754636AbYLVMCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbYLVMCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYLVMC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:02:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:36047 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753496AbYLVMC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:02:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,263,1228118400"; 
   d="scan'208";a="475961409"
Date: Mon, 22 Dec 2008 13:02:18 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch] x86, ptrace: require admin privileges for ptrace BTS extension
Message-ID: <20081222130218.A31747@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Require admin privileges for ptrace BTS extension.


Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/kernel/ptrace.c
===================================================================
--- gits.orig/arch/x86/kernel/ptrace.c	2008-12-22 09:09:25.000000000 +0100
+++ gits/arch/x86/kernel/ptrace.c	2008-12-22 11:03:01.000000000 +0100
@@ -21,6 +21,7 @@
 #include <linux/audit.h>
 #include <linux/seccomp.h>
 #include <linux/signal.h>
+#include <linux/capability.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -742,6 +743,10 @@
 	struct ptrace_bts_config cfg;
 	int error = 0;
 
+	error = -EPERM;
+	if (!capable(CAP_SYS_ADMIN))
+		goto errout;
+
 	error = -EOPNOTSUPP;
 	if (!bts_cfg.sizeof_bts)
 		goto errout;
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

