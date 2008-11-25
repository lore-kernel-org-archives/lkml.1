Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbYKYHpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbYKYHpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:45:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYKYHpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:45:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:39942 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYKYHpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:45:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,663,1220252400"; 
   d="scan'208";a="643310457"
Date: Tue, 25 Nov 2008 08:45:13 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com, juan.villacis@intel.com
Subject: [patch 1/9] x86, bts: exclude ds.c from build when disabled
Message-ID: <20081125084513.A30615@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the CONFIG guard from the .c file into the makefile.

Reported-by: Andi Kleen <andi-suse@firstfloor.org>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/Makefile
===================================================================
--- ftrace.orig/arch/x86/kernel/Makefile	2008-11-24 12:57:07.000000000 +0100
+++ ftrace/arch/x86/kernel/Makefile	2008-11-24 12:58:31.000000000 +0100
@@ -48,7 +48,7 @@
 obj-y				+= process.o
 obj-y				+= i387.o xsave.o
 obj-y				+= ptrace.o
-obj-y				+= ds.o
+obj-$(CONFIG_X86_DS)		+= ds.o
 obj-$(CONFIG_X86_32)		+= tls.o
 obj-$(CONFIG_IA32_EMULATION)	+= tls.o
 obj-y				+= step.o
Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-11-24 12:57:08.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-11-24 12:58:31.000000000 +0100
@@ -21,8 +21,6 @@
  */
 
 
-#ifdef CONFIG_X86_DS
-
 #include <asm/ds.h>
 
 #include <linux/errno.h>
@@ -877,4 +875,3 @@
 	while (leftovers--)
 		ds_put_context(context);
 }
-#endif /* CONFIG_X86_DS */
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

