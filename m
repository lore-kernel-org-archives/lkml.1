Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbYBSP2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbYBSP2j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:28:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYBSP2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:28:31 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:47892 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1752196AbYBSP2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:28:30 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Wed, 20 Feb 2008 02:27:59 +1100
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Improve init/Kconfig help descriptions [PATCH 9/9]
Message-ID: <20080219152756.GG27352@tull.net>
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
> Patch 9
> 	MODULES
> 	MODULE_UNLOAD
> 	MODULE_FORCE_UNLOAD
> 	MODVERSIONS
> 	MODULE_SRCVERSION_ALL
> 	KMOD

Changelog:

Improve usefulness and consistency of kernel configuration help messages.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>

--- a/init/Kconfig	2008-02-20 00:45:07.000000000 +1100
+++ b/init/Kconfig	2008-02-20 00:52:07.000000000 +1100
@@ -680,20 +680,26 @@ config BASE_SMALL
 menuconfig MODULES
 	bool "Enable loadable module support"
 	help
-	  Kernel modules are small pieces of compiled code which can
-	  be inserted in the running kernel, rather than being
-	  permanently built into the kernel.  You use the "modprobe"
-	  tool to add (and sometimes remove) them.  If you say Y here,
-	  many parts of the kernel can be built as modules (by
-	  answering M instead of Y where indicated): this is most
-	  useful for infrequently used options which are not required
-	  for booting.  For more information, see the man pages for
-	  modprobe, lsmod, modinfo, insmod and rmmod.
-
-	  If you say Y here, you will need to run "make
-	  modules_install" to put the modules under /lib/modules/
-	  where modprobe can find them (you may need to be root to do
-	  this).
+	  This option allows the kernel to load Kernel modules
+	  at runtime to increase functionality, support new
+	  devices and so on.
+
+	  Kernel modules are compiled code such as device drivers
+	  and filesystems. You can use the "lsmod" command to see
+	  what modules are currently loaded, and "modprobe" to
+	  add (and sometimes remove) them.
+
+	  If you say Y here, many parts of the kernel can be built as
+	  modules (by answering M instead of Y where indicated). This
+	  reduces the size of the compiled kernel and allows you to
+	  choose at runtime which modules will be loaded. With some
+	  other options enabled, module loading and unloading can be
+	  performed automatically by the kernel upon demand.
+
+	  If you say Y here, you will need to run "make modules_install"
+	  after building the kernel to put the modules under /lib/modules/
+	  where "modprobe" can find them. You probably need to be root to
+	  install the modules.
 
 	  If unsure, say Y.
 
@@ -701,10 +707,16 @@ config MODULE_UNLOAD
 	bool "Module unloading"
 	depends on MODULES
 	help
-	  Without this option you will not be able to unload any
-	  modules (note that some modules may not be unloadable
-	  anyway), which makes your kernel slightly smaller and
-	  simpler.  If unsure, say Y.
+	  This option allows the kernel to unload unused modules.
+
+	  A module can only be unloaded if it is not in use by
+	  other modules, the kernel or running processes (for
+	  example, using a device through the module).
+
+	  Disabling this option will make the kernel slightly
+	  smaller and simpler.
+
+	  If unsure, say Y.
 
 config MODULE_FORCE_UNLOAD
 	bool "Forced module unloading"
@@ -714,6 +726,7 @@ config MODULE_FORCE_UNLOAD
 	  kernel believes it is unsafe: the kernel will remove the module
 	  without waiting for anyone to stop using it (using the -f option to
 	  rmmod).  This is mainly for kernel developers and desperate users.
+
 	  If unsure, say N.
 
 config MODVERSIONS
@@ -724,8 +737,9 @@ config MODVERSIONS
 	  Saying Y here makes it sometimes possible to use modules
 	  compiled for different kernels, by adding enough information
 	  to the modules to (hopefully) spot any changes which would
-	  make them incompatible with the kernel you are running.  If
-	  unsure, say N.
+	  make them incompatible with the kernel you are running.
+	  
+	  If unsure, say N.
 
 config MODULE_SRCVERSION_ALL
 	bool "Source checksum for all modules"
@@ -733,11 +747,15 @@ config MODULE_SRCVERSION_ALL
 	help
 	  Modules which contain a MODULE_VERSION get an extra "srcversion"
 	  field inserted into their modinfo section, which contains a
-    	  sum of the source files which made it.  This helps maintainers
-	  see exactly which source was used to build a module (since
-	  others sometimes change the module source without updating
-	  the version).  With this option, such a "srcversion" field
-	  will be created for all modules.  If unsure, say N.
+	  checksum (using the MD4 algorithm) of the source files which
+	  made it.
+
+	  This helps maintainers see exactly which source was used
+	  to build a module (since others sometimes change the module
+	  source without updating the version).  With this option, such
+	  a "srcversion" field will be created for all modules.
+
+	  If unsure, say N.
 
 config KMOD
 	bool "Automatic kernel module loading"
@@ -745,11 +763,14 @@ config KMOD
 	help
 	  Normally when you have selected some parts of the kernel to
 	  be created as kernel modules, you must load them (using the
-	  "modprobe" command) before you can use them. If you say Y
-	  here, some parts of the kernel will be able to load modules
-	  automatically: when a part of the kernel needs a module, it
-	  runs modprobe with the appropriate arguments, thereby
-	  loading the module if it is available.  If unsure, say Y.
+	  "modprobe" command) before you can use them.
+
+	  If you say Y here, some parts of the kernel will be able to
+	  load modules automatically: when a part of the kernel needs a
+	  module, it will run modprobe with the appropriate arguments,
+	  thereby loading the module if it is available.
+
+	  If unsure, say Y.
 
 config STOP_MACHINE
 	bool
