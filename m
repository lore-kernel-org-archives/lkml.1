Return-Path: <linux-kernel-owner+w=401wt.eu-S1759436AbXK1TFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436AbXK1TFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbXK1TFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:05:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:42870 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbXK1TFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:05:04 -0500
Date: Wed, 28 Nov 2007 14:04:39 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 2/4] UML - Add !UML dependencies
Message-ID: <20071128190439.GA8303@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

That's not enough, unfortunately.  If we go that way, we need to add
dependencies on !UML for several options.

[ jdike - "not enough" refers to my patch which enables X86_32 and
RWSEM_XCHGADD_ALGORITHM in UML's Kconfig.i386 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 drivers/crypto/Kconfig         |    2 +-
 kernel/Kconfig.instrumentation |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22/drivers/crypto/Kconfig
===================================================================
--- linux-2.6.22.orig/drivers/crypto/Kconfig	2007-11-21 11:49:37.000000000 -0500
+++ linux-2.6.22/drivers/crypto/Kconfig	2007-11-26 11:54:18.000000000 -0500
@@ -12,7 +12,7 @@ if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32
+	depends on X86_32 && !UML
 	select CRYPTO_ALGAPI
 	help
 	  Some VIA processors come with an integrated crypto engine
Index: linux-2.6.22/kernel/Kconfig.instrumentation
===================================================================
--- linux-2.6.22.orig/kernel/Kconfig.instrumentation	2007-11-14 10:33:42.000000000 -0500
+++ linux-2.6.22/kernel/Kconfig.instrumentation	2007-11-26 11:54:18.000000000 -0500
@@ -21,7 +21,7 @@ config PROFILING
 config OPROFILE
 	tristate "OProfile system profiling (EXPERIMENTAL)"
 	depends on PROFILING
-	depends on ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64
+	depends on (ALPHA || ARM || BLACKFIN || X86_32 || IA64 || M32R || MIPS || PARISC || PPC || S390 || SUPERH || SPARC || X86_64) && !UML
 	help
 	  OProfile is a profiling system capable of profiling the
 	  whole system, include the kernel, kernel modules, libraries,
@@ -32,7 +32,7 @@ config OPROFILE
 config KPROBES
 	bool "Kprobes"
 	depends on KALLSYMS && MODULES
-	depends on X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32
+	depends on (X86_32 || IA64 || PPC || S390 || SPARC64 || X86_64 || AVR32) && !UML
 	help
 	  Kprobes allows you to trap at almost any kernel address and
 	  execute a callback function.  register_kprobe() establishes
