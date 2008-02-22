Return-Path: <linux-kernel-owner+w=401wt.eu-S964902AbYBVBAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964902AbYBVBAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932794AbYBVBAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:00:22 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:42692 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S936306AbYBVBAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:00:17 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:59:44 +1100
Message-ID: <20080222-114832-init-kconfig-9@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 9/9] Kconfig: Improve init/Kconfig help descriptions - MODULES
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - MODULES
  - MODULE_UNLOAD
  - MODULE_FORCE_UNLOAD
  - MODVERSIONS
  - MODULE_SRCVERSION_ALL
  - KMOD

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-22 09:17:11.000000000 +1100
@@ -769,20 +769,26 @@ config BASE_SMALL
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
 
@@ -790,10 +796,16 @@ config MODULE_UNLOAD
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
@@ -803,6 +815,7 @@ config MODULE_FORCE_UNLOAD
 	  kernel believes it is unsafe: the kernel will remove the module
 	  without waiting for anyone to stop using it (using the -f option to
 	  rmmod).  This is mainly for kernel developers and desperate users.
+
 	  If unsure, say N.
 
 config MODVERSIONS
@@ -813,8 +826,9 @@ config MODVERSIONS
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
@@ -822,11 +836,15 @@ config MODULE_SRCVERSION_ALL
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
@@ -834,11 +852,14 @@ config KMOD
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
