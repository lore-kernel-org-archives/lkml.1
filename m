Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbYDDUmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbYDDUmP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 16:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYDDUmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 16:42:00 -0400
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:4475 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYDDUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 16:41:59 -0400
Date: Fri, 4 Apr 2008 22:40:27 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Dike <jdike@addtoit.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] uml: cleanup: use def_bool in Kconfig files
Message-ID: <20080404204027.GA9417@mailshack.com>
References: <20080404184930.GA8978@mailshack.com> <20080404185147.GB8989@mailshack.com> <1207335610.18838.85.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1207335610.18838.85.camel@brick>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Fri, 04 Apr 2008 22:41:28 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.121; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup: use def_bool in User-mode Linux' Kconfig files.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Harvey Harrison wrote:
> > +config GENERIC_FIND_FIRST_BIT
> > +	bool
> > +	default y
> > +
> 	def_bool y

Indeed! But it is hardly the only occurence of the long version.
Should we add this patch? If so, should it go via the -x86 tree,
as this depends on changes I introduced for the bitops unification?

Greetings,
	Alexander

 arch/um/Kconfig        |   50 +++++++++++++++++------------------------------
 arch/um/Kconfig.char   |    6 +---
 arch/um/Kconfig.i386   |   27 ++++++++-----------------
 arch/um/Kconfig.x86_64 |   33 ++++++++++---------------------
 4 files changed, 40 insertions(+), 76 deletions(-)

diff --git a/arch/um/Kconfig b/arch/um/Kconfig
index dba8e05..bbbc198 100644
--- a/arch/um/Kconfig
+++ b/arch/um/Kconfig
@@ -5,16 +5,13 @@ config DEFCONFIG_LIST
 
 # UML uses the generic IRQ subsystem
 config GENERIC_HARDIRQS
-	bool
-	default y
+	def_bool y
 
 config UML
-	bool
-	default y
+	def_bool y
 
 config MMU
-	bool
-	default y
+	def_bool y
 
 config NO_IOMEM
 	def_bool y
@@ -22,51 +19,43 @@ config NO_IOMEM
 mainmenu "Linux/Usermode Kernel Configuration"
 
 config ISA
-	bool
+	def_bool n
 
 config SBUS
-	bool
+	def_bool n
 
 config PCI
-	bool
+	def_bool n
 
 config PCMCIA
-	bool
+	def_bool n
 
 # Yet to do!
 config TRACE_IRQFLAGS_SUPPORT
-	bool
-	default n
+	def_bool n
 
 config LOCKDEP_SUPPORT
-	bool
-	default y
+	def_bool y
 
 config STACKTRACE_SUPPORT
-	bool
-	default n
+	def_bool n
 
 config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
+	def_bool y
 
 config GENERIC_BUG
-	bool
-	default y
+	def_bool y
 	depends on BUG
 
 config GENERIC_TIME
-	bool
-	default y
+	def_bool y
 
 config GENERIC_CLOCKEVENTS
-	bool
-	default y
+	def_bool y
 
 # Used in kernel/irq/manage.c and include/linux/irq.h
 config IRQ_RELEASE_METHOD
-	bool
-	default y
+	def_bool y
 
 config HZ
 	int
@@ -90,13 +79,11 @@ source "mm/Kconfig"
 source "kernel/time/Kconfig"
 
 config LD_SCRIPT_STATIC
-	bool
-	default y
+	def_bool y
 	depends on STATIC_LINK
 
 config LD_SCRIPT_DYN
-	bool
-	default y
+	def_bool y
 	depends on !LD_SCRIPT_STATIC
 
 source "fs/Kconfig.binfmt"
@@ -261,7 +248,6 @@ endif
 
 #This is just to shut up some Kconfig warnings, so no prompt.
 config INPUT
-	bool
-	default n
+	def_bool n
 
 source "arch/um/Kconfig.debug"
diff --git a/arch/um/Kconfig.char b/arch/um/Kconfig.char
index 3a4b396..c51b3b3 100644
--- a/arch/um/Kconfig.char
+++ b/arch/um/Kconfig.char
@@ -8,8 +8,7 @@ config STDERR_CONSOLE
 	  console driver which dumps all printk messages to stderr.
 
 config STDIO_CONSOLE
-	bool
-	default y
+	def_bool y
 
 config SSL
 	bool "Virtual serial line"
@@ -68,8 +67,7 @@ config XTERM_CHAN
           It is safe to say 'Y' here.
 
 config NOCONFIG_CHAN
-	bool
-	default !(XTERM_CHAN && TTY_CHAN && PTY_CHAN && PORT_CHAN && NULL_CHAN)
+	def_bool !(XTERM_CHAN && TTY_CHAN && PTY_CHAN && PORT_CHAN && NULL_CHAN)
 
 config CON_ZERO_CHAN
 	string "Default main console channel initialization"
diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index f694cff..4d36f66 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -5,23 +5,19 @@ source "arch/x86/Kconfig.cpu"
 endmenu
 
 config UML_X86
-	bool
-	default y
+	def_bool y
 
 config X86_32
-       bool
-       default y
+       def_bool y
 
 config RWSEM_XCHGADD_ALGORITHM
 	def_bool y
 
 config 64BIT
-	bool
-	default n
+	def_bool n
 
 config SEMAPHORE_SLEEPERS
-	bool
-	default y
+	def_bool y
 
 config 3_LEVEL_PGTABLES
 	bool "Three-level pagetables (EXPERIMENTAL)"
@@ -36,24 +32,19 @@ config 3_LEVEL_PGTABLES
 	N (on x86-64 it's automatically enabled, instead, as it's safe there).
 
 config ARCH_HAS_SC_SIGNALS
-	bool
-	default y
+	def_bool y
 
 config ARCH_REUSE_HOST_VSYSCALL_AREA
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_FIRST_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config ARCH_SUPPORTS_AOUT
 	def_bool y
diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index 84cefd5..42131b2 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -1,47 +1,36 @@
 config UML_X86
-	bool
-	default y
+	def_bool y
 
 config 64BIT
-	bool
-	default y
+	def_bool y
 
 #XXX: this is so in the underlying arch, but it's wrong!!!
 config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
+	def_bool y
 
 config SEMAPHORE_SLEEPERS
-	bool
-	default y
+	def_bool y
 
 config 3_LEVEL_PGTABLES
-       bool
-       default y
+       def_bool y
 
 config ARCH_HAS_SC_SIGNALS
-	bool
-	default n
+	def_bool n
 
 config ARCH_REUSE_HOST_VSYSCALL_AREA
-	bool
-	default n
+	def_bool n
 
 config SMP_BROKEN
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_FIRST_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config ARCH_SUPPORTS_AOUT
 	def_bool y

