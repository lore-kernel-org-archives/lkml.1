Return-Path: <linux-kernel-owner+w=401wt.eu-S936525AbYBVAyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525AbYBVAyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbYBVAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:54:40 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:60978 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1753538AbYBVAyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:54:39 -0500
X-Spam-Check-By: mail.local.tull.net
Date: Fri, 22 Feb 2008 11:54:07 +1100
Message-ID: <20080222-114832-init-kconfig-5@tull.net>
From: Nick Andrew <nick@nick-andrew.net>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Serge Hallyn <serue@us.ibm.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: [PATCH 2.6.25-rc2 5/9] Kconfig: Improve init/Kconfig help descriptions - IKCONFIG etc
References: <20080219140609.GA26619@tull.net>
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rewrite the help descriptions for clarity, accuracy and consistency.

Kernel config options affected:

  - IKCONFIG
  - IKCONFIG_PROC
  - LOG_BUF_SHIFT
  - SYSFS_DEPRECATED
  - RELAY
  - BLK_DEV_INITRD

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
Try #3.

--- a/init/Kconfig	2008-02-20 09:34:48.000000000 +1100
+++ b/init/Kconfig	2008-02-22 09:15:48.000000000 +1100
@@ -241,20 +241,30 @@ config IKCONFIG
 	tristate "Kernel .config support"
 	---help---
 	  This option enables the complete Linux kernel ".config" file
-	  contents to be saved in the kernel. It provides documentation
-	  of which kernel options are used in a running kernel or in an
-	  on-disk kernel.  This information can be extracted from the kernel
-	  image file with the script scripts/extract-ikconfig and used as
-	  input to rebuild the current kernel or to build another kernel.
-	  It can also be extracted from a running kernel by reading
-	  /proc/config.gz if enabled (below).
+	  contents to be saved in the kernel.
+
+	  It provides documentation of which kernel options are used in
+	  a running kernel or in an on-disk kernel.  This information
+	  can be extracted from the kernel image file with the script
+	  "scripts/extract-ikconfig" and used as input to rebuild the
+	  current kernel or to build another kernel.
+
+	  It can also be extracted from a running kernel with
+	  "zcat /proc/config.gz" if CONFIG_IKCONFIG_PROC is enabled
+	  below.
+
+	  Your kernel size will increase by around 14k.
+
+	  If unsure, say N.
 
 config IKCONFIG_PROC
 	bool "Enable access to .config through /proc/config.gz"
 	depends on IKCONFIG && PROC_FS
 	---help---
-	  This option enables access to the kernel configuration file
-	  through /proc/config.gz.
+	  This option enables access to the configuration of the running
+	  kernel through /proc/config.gz.
+
+	  If unsure, say Y.
 
 config LOG_BUF_SHIFT
 	int "Kernel log buffer size (16 => 64KB, 17 => 128KB)"
@@ -264,14 +274,15 @@ config LOG_BUF_SHIFT
 	default 15 if SMP
 	default 14
 	help
-	  Select kernel log buffer size as a power of 2.
-	  Defaults and Examples:
+	  Select the kernel log buffer size as a power of 2.
+
+	  Defaults and examples:
 	  	     17 => 128 KB for S/390
-		     16 => 64 KB for x86 NUMAQ or IA-64
-	             15 => 32 KB for SMP
-	             14 => 16 KB for uniprocessor
-		     13 =>  8 KB
-		     12 =>  4 KB
+		     16 =>  64 KB for x86 NUMAQ or IA-64
+	             15 =>  32 KB for SMP
+	             14 =>  16 KB for uniprocessor
+		     13 =>   8 KB
+		     12 =>   4 KB
 
 config CGROUPS
 	bool "Control Group support"
@@ -402,11 +413,14 @@ config PROC_PID_CPUSET
 config RELAY
 	bool "Kernel->user space relay support (formerly relayfs)"
 	help
-	  This option enables support for relay interface support in
+	  This option enables support for the relay interface in
 	  certain file systems (such as debugfs).
+
 	  It is designed to provide an efficient mechanism for tools and
 	  facilities to relay large amounts of data from kernel space to
-	  user space.
+	  userspace.
+
+	  See <file:Documentation/filesystems/relay.txt> for more information.
 
 	  If unsure, say N.
 
@@ -457,17 +471,24 @@ config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
 	help
+	  Enable use of an initial RAM filesystem or RAM disk at boot
+	  time.
+
 	  The initial RAM filesystem is a ramfs which is loaded by the
-	  boot loader (loadlin or lilo) and that is mounted as root
+	  boot loader (loadlin, lilo, grub) and is mounted as root
 	  before the normal boot procedure. It is typically used to
 	  load modules needed to mount the "real" root file system,
-	  etc. See <file:Documentation/initrd.txt> for details.
+	  etc.
+
+	  For more information, see:
+	  <file:Documentation/initrd.txt>
+	  <file:Documentation/filesystems/ramfs-rootfs-initramfs.txt>
 
 	  If RAM disk support (BLK_DEV_RAM) is also included, this
 	  also enables initial RAM disk (initrd) support and adds
 	  15 Kbytes (more on some other architectures) to the kernel size.
 
-	  If unsure say Y.
+	  If unsure, say Y.
 
 if BLK_DEV_INITRD
 
