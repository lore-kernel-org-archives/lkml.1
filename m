Return-Path: <linux-kernel-owner+w=401wt.eu-S1755069AbXKZK4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbXKZK4c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbXKZK4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:56:25 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53657 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbXKZK4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:56:24 -0500
Date: Mon, 26 Nov 2007 10:56:19 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Jeff Dike <jdike@addtoit.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [PATCH] Keep UML Kconfig in sync with x86
Message-ID: <20071126105619.GR8181@ftp.linux.org.uk>
References: <20071119190224.GA7723@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119190224.GA7723@c2.user-mode-linux.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 02:02:24PM -0500, Jeff Dike wrote:
> Fix a 2.6.24-rc3 UML build breakage introduced by commit
> 1032c0ba9da5c5b53173ad2dcf8b2a2da78f8b17 - it introduces X86_32, with
> many things which UML needs depending on it.
> 
> This patch adds definitions of X86_32 and RWSEM_XCHGADD_ALGORITHM to
> the UML/i386 Kconfig.

That's not enough, unfortunately.  If we go that way, we need to add
dependencies on !UML for several options.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 5fd6688..ddd3a25 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -12,7 +12,7 @@ if CRYPTO_HW
 
 config CRYPTO_DEV_PADLOCK
 	tristate "Support for VIA PadLock ACE"
-	depends on X86_32
+	depends on X86_32 && !UML
 	select CRYPTO_ALGAPI
 	help
 	  Some VIA processors come with an integrated crypto engine
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index f5f2c76..2ea1e34 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
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
