Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYBSPQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYBSPQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYBSPQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:16:04 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:54936 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1751773AbYBSPQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:16:03 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 02:15:27 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 7/9]
Message-ID: <20080219151527.GE27352@tull.net>
References: <20080219140609.GA26619@tull.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080219140609.GA26619@tull.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 01:06:09AM +1100, Nick Andrew wrote:
> Here is a series of 9 patches to init/Kconfig intended to improve the
> usefulness and consistency of the help descriptions. The patches are
> against linux-2.6.24.2.
> [...]
> Patch 7
> 	EMBEDDED
> 	SYSCTL_SYSCALL
> 	KALLSYMS
> 	KALLSYMS_ALL
> 	KALLSYMS_EXTRA_PASS
> 	HOTPLUG
> 	PRINTK
> 	BUG
> 	ELF_CORE
> 	BASE_FULL
> 	FUTEX
> 	EPOLL
> 	SIGNALFD
> 	TIMERFD
> 	EVENTFD

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -439,10 +439,14 @@ menuconfig EMBEDDED
 	bool "Configure standard kernel features (for small systems)"
 	help
 	  This option allows certain base kernel options and settings
-          to be disabled or tweaked. This is for specialized
-          environments which can tolerate a "non-standard" kernel.
+	  to be disabled or tweaked. This is for embedded systems and
+	  specialized environments which can tolerate a "non-standard"
+	  kernel.
+
           Only use this if you really know what you are doing.
 
+	  If unsure, say N.
+
 config UID16
 	bool "Enable 16-bit UID system calls" if EMBEDDED
 	depends on ARM || BLACKFIN || CRIS || FRV || H8300 || X86_32 || M68K || (S390 && !64BIT) || SUPERH || SPARC32 || (SPARC64 && SPARC32_COMPAT) || UML || (X86_64 && IA32_EMULATION)
@@ -460,51 +464,62 @@ config SYSCTL_SYSCALL
 	  using paths with ascii names is now the primary path to this
 	  information.
 
-	  Almost nothing using the binary sysctl interface so if you are
+	  Almost nothing uses the binary sysctl interface so if you are
 	  trying to save some space it is probably safe to disable this,
 	  making your kernel marginally smaller.
 
-	  If unsure say Y here.
+	  If unsure, say Y.
 
 config KALLSYMS
-	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
-	 default y
-	 help
-	   Say Y here to let the kernel print out symbolic crash information and
-	   symbolic stack backtraces. This increases the size of the kernel
-	   somewhat, as all symbols have to be loaded into the kernel image.
+	bool "Load all symbols for debugging/ksymoops" if EMBEDDED
+	default y
+	help
+	  This information causes the kernel to print out symbolic crash
+	  information and symbolic stack backtraces.
+
+	  It increases the size of the kernel somewhat, as all symbols
+	  have to be loaded into the kernel image.
+
+	  If unsure, say Y.
 
 config KALLSYMS_ALL
 	bool "Include all symbols in kallsyms"
 	depends on DEBUG_KERNEL && KALLSYMS
 	help
-	   Normally kallsyms only contains the symbols of functions, for nicer
-	   OOPS messages.  Some debuggers can use kallsyms for other
-	   symbols too: say Y here to include all symbols, if you need them 
-	   and you don't care about adding 300k to the size of your kernel.
+	  Normally kallsyms only contains the symbols of functions, for nicer
+	  OOPS messages.  Some debuggers can use kallsyms for other
+	  symbols too: say Y here to include all symbols, if you need them.
+
+	  Your kernel size will increase by around 300k.
 
-	   Say N.
+	  If unsure, say N.
 
 config KALLSYMS_EXTRA_PASS
 	bool "Do an extra kallsyms pass"
 	depends on KALLSYMS
 	help
-	   If kallsyms is not working correctly, the build will fail with
-	   inconsistent kallsyms data.  If that occurs, log a bug report and
-	   turn on KALLSYMS_EXTRA_PASS which should result in a stable build.
-	   Always say N here unless you find a bug in kallsyms, which must be
-	   reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
-	   you wait for kallsyms to be fixed.
+	  If kallsyms is not working correctly, the build will fail with
+	  inconsistent kallsyms data.  If that occurs, log a bug report and
+	  turn on KALLSYMS_EXTRA_PASS which should result in a stable build.
+
+	  Always say N here unless you find a bug in kallsyms, which must be
+	  reported.  KALLSYMS_EXTRA_PASS is only a temporary workaround while
+	  you wait for kallsyms to be fixed.
 
+	  If unsure, say N.
 
 config HOTPLUG
 	bool "Support for hot-pluggable devices" if EMBEDDED
 	default y
 	help
 	  This option is provided for the case where no hotplug or uevent
-	  capabilities is wanted by the kernel.  You should only consider
-	  disabling this option for embedded systems that do not use modules, a
-	  dynamic /dev tree, or dynamic device discovery.  Just say Y.
+	  capabilities are wanted by the kernel.
+
+	  You should only consider disabling this option for embedded
+	  systems that do not use modules, a dynamic /dev tree, or
+	  dynamic device discovery.
+
+	  If unsure, say Y.
 
 config PRINTK
 	default y
@@ -516,21 +531,30 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+	  If unsure, say Y.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y
 	help
           Disabling this option eliminates support for BUG and WARN, reducing
           the size of your kernel image and potentially quietly ignoring
-          numerous fatal conditions. You should only consider disabling this
-          option for embedded systems with no facilities for reporting errors.
-          Just say Y.
+          numerous fatal conditions.
+
+	  You should only consider disabling this option for embedded
+	  systems with no facilities for reporting errors.
+
+	  If unsure, say Y.
 
 config ELF_CORE
 	default y
 	bool "Enable ELF core dumps" if EMBEDDED
 	help
-	  Enable support for generating core dumps. Disabling saves about 4k.
+	  Enable support for generating core dumps when a process fails.
+
+	  Your kernel size will increase by around 4k.
+
+	  If unsure, say Y.
 
 config BASE_FULL
 	default y
@@ -540,6 +564,8 @@ config BASE_FULL
 	  kernel data structures. This saves memory on small machines,
 	  but may reduce performance.
 
+	  If unsure, say Y.
+
 config FUTEX
 	bool "Enable futex support" if EMBEDDED
 	default y
@@ -549,6 +575,8 @@ config FUTEX
 	  support for "fast userspace mutexes".  The resulting kernel may not
 	  run glibc-based applications correctly.
 
+	  If unsure, say Y.
+
 config ANON_INODES
 	bool
 
@@ -560,13 +588,15 @@ config EPOLL
 	  Disabling this option will cause the kernel to be built without
 	  support for epoll family of system calls.
 
+	  If unsure, say Y.
+
 config SIGNALFD
 	bool "Enable signalfd() system call" if EMBEDDED
 	select ANON_INODES
 	default y
 	help
-	  Enable the signalfd() system call that allows to receive signals
-	  on a file descriptor.
+	  Enable the signalfd() system call that allows a process to
+	  receive signals on a file descriptor.
 
 	  If unsure, say Y.
 
@@ -576,8 +606,8 @@ config TIMERFD
 	depends on BROKEN
 	default y
 	help
-	  Enable the timerfd() system call that allows to receive timer
-	  events on a file descriptor.
+	  Enable the timerfd() system call that allows a process to
+	  receive timer events on a file descriptor.
 
 	  If unsure, say Y.
 
@@ -586,8 +616,9 @@ config EVENTFD
 	select ANON_INODES
 	default y
 	help
-	  Enable the eventfd() system call that allows to receive both
-	  kernel notification (ie. KAIO) or userspace notifications.
+	  Enable the eventfd() system call that allows a process to
+	  receive both kernel notification (ie. KAIO) or userspace
+	  notifications.
 
 	  If unsure, say Y.
 
