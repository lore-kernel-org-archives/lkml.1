Return-Path: <linux-kernel-owner+w=401wt.eu-S1753243AbYJQHJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243AbYJQHJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 03:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbYJQHJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 03:09:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:64782 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbYJQHJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 03:09:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,430,1220252400"; 
   d="scan'208";a="452429837"
Date: Fri, 17 Oct 2008 09:09:27 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       akpm@linux-foundation.org
Subject: [patch] x86, bts: improve help text for BTS config
Message-ID: <20081017090927.A5454@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve the help text of the X86_PTRACE_BTS config.
Make X86_DS invisible and depend on X86_PTRACE_BTS.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: gits/arch/x86/Kconfig.cpu
===================================================================
--- gits.orig/arch/x86/Kconfig.cpu	2008-10-15 09:02:47.000000000 +0200
+++ gits/arch/x86/Kconfig.cpu	2008-10-15 12:59:21.000000000 +0200
@@ -513,19 +513,19 @@
 	  If unsure, say N.
 
 config X86_DS
-	bool "Debug Store support"
-	default y
-	help
-	  Add support for Debug Store.
-	  This allows the kernel to provide a memory buffer to the hardware
-	  to store various profiling and tracing events.
+	def_bool X86_PTRACE_BTS
+	depends on X86_DEBUGCTLMSR
 
 config X86_PTRACE_BTS
-	bool "ptrace interface to Branch Trace Store"
+	bool "Branch Trace Store"
 	default y
-	depends on (X86_DS && X86_DEBUGCTLMSR)
+	depends on X86_DEBUGCTLMSR
 	help
-	  Add a ptrace interface to allow collecting an execution trace
-	  of the traced task.
-	  This collects control flow changes in a (cyclic) buffer and allows
-	  debuggers to fill in the gaps and show an execution trace of the debuggee.
+	  This adds a ptrace interface to the hardware's branch trace store.
+
+	  Debuggers may use it to collect an execution trace of the debugged
+	  application in order to answer the question 'how did I get here?'.
+	  Debuggers may trace user mode as well as kernel mode.
+
+	  Say Y unless there is no application development on this machine
+	  and you want to save a small amount of code size.
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

