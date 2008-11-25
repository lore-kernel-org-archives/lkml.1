Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbYKYHrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbYKYHrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYKYHrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:47:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:34922 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYKYHrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:47:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="407752015"
Date: Tue, 25 Nov 2008 08:47:19 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 2/9] x86, bts: turn macro into static inline function
Message-ID: <20081125084719.A30957@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a macro with a static inline function.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/include/asm/ds.h
===================================================================
--- ftrace.orig/arch/x86/include/asm/ds.h	2008-11-25 08:17:08.000000000 +0100
+++ ftrace/arch/x86/include/asm/ds.h	2008-11-25 08:17:48.000000000 +0100
@@ -23,12 +23,13 @@
 #ifndef _ASM_X86_DS_H
 #define _ASM_X86_DS_H
 
-#ifdef CONFIG_X86_DS
 
 #include <linux/types.h>
 #include <linux/init.h>
 
 
+#ifdef CONFIG_X86_DS
+
 struct task_struct;
 
 /*
@@ -232,7 +233,8 @@
 
 #else /* CONFIG_X86_DS */
 
-#define ds_init_intel(config) do {} while (0)
+struct cpuinfo_x86;
+static inline void __cpuinit ds_init_intel(struct cpuinfo_x86 *ignored) {}
 
 #endif /* CONFIG_X86_DS */
 #endif /* _ASM_X86_DS_H */
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

