Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYFVVOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYFVVOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYFVVOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:60900 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391AbYFVVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=jSBvV+7XOczRwJ0Xe8LwFitypqc5VfprdDoVIJfKp7G5CUz57U8rlzbgKWtgcWTTG9
         VRz27DUU0UJP4kk1KtrOxlcNGlqQcmzcS+kb96v0JfeQF3mzLkdq6L+Xs+ypy70goYYY
         /GlHnVsUzQws3wm100zCkSLKA51KKcgsgnBjM=
Date: Mon, 23 Jun 2008 01:09:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: move Kconfig to fs/proc/Kconfig
Message-ID: <20080622210952.GA31702@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/Kconfig      |   60 --------------------------------------------------------
 fs/proc/Kconfig |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 59 deletions(-)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -894,65 +894,7 @@ endif # BLOCK
 
 menu "Pseudo filesystems"
 
-config PROC_FS
-	bool "/proc file system support" if EMBEDDED
-	default y
-	help
-	  This is a virtual file system providing information about the status
-	  of the system. "Virtual" means that it doesn't take up any space on
-	  your hard disk: the files are created on the fly by the kernel when
-	  you try to access them. Also, you cannot read the files with older
-	  version of the program less: you need to use more or cat.
-
-	  It's totally cool; for example, "cat /proc/interrupts" gives
-	  information about what the different IRQs are used for at the moment
-	  (there is a small number of Interrupt ReQuest lines in your computer
-	  that are used by the attached devices to gain the CPU's attention --
-	  often a source of trouble if two devices are mistakenly configured
-	  to use the same IRQ). The program procinfo to display some
-	  information about your system gathered from the /proc file system.
-
-	  Before you can use the /proc file system, it has to be mounted,
-	  meaning it has to be given a location in the directory hierarchy.
-	  That location should be /proc. A command such as "mount -t proc proc
-	  /proc" or the equivalent line in /etc/fstab does the job.
-
-	  The /proc file system is explained in the file
-	  <file:Documentation/filesystems/proc.txt> and on the proc(5) manpage
-	  ("man 5 proc").
-
-	  This option will enlarge your kernel by about 67 KB. Several
-	  programs depend on this, so everyone should say Y here.
-
-config PROC_KCORE
-	bool "/proc/kcore support" if !ARM
-	depends on PROC_FS && MMU
-
-config PROC_VMCORE
-        bool "/proc/vmcore support (EXPERIMENTAL)"
-        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
-	default y
-        help
-        Exports the dump image of crashed kernel in ELF format.
-
-config PROC_SYSCTL
-	bool "Sysctl support (/proc/sys)" if EMBEDDED
-	depends on PROC_FS
-	select SYSCTL
-	default y
-	---help---
-	  The sysctl interface provides a means of dynamically changing
-	  certain kernel parameters and variables on the fly without requiring
-	  a recompile of the kernel or reboot of the system.  The primary
-	  interface is through /proc/sys.  If you say Y here a tree of
-	  modifiable sysctl entries will be generated beneath the
-          /proc/sys directory. They are explained in the files
-	  in <file:Documentation/sysctl/>.  Note that enabling this
-	  option will enlarge the kernel by at least 8 KB.
-
-	  As it is generally a good thing, you should say Y here unless
-	  building a kernel for install/rescue disks or your system is very
-	  limited in memory.
+source "fs/proc/Kconfig"
 
 config SYSFS
 	bool "sysfs file system support" if EMBEDDED
new file mode 100644
--- /dev/null
+++ b/fs/proc/Kconfig
@@ -0,0 +1,59 @@
+config PROC_FS
+	bool "/proc file system support" if EMBEDDED
+	default y
+	help
+	  This is a virtual file system providing information about the status
+	  of the system. "Virtual" means that it doesn't take up any space on
+	  your hard disk: the files are created on the fly by the kernel when
+	  you try to access them. Also, you cannot read the files with older
+	  version of the program less: you need to use more or cat.
+
+	  It's totally cool; for example, "cat /proc/interrupts" gives
+	  information about what the different IRQs are used for at the moment
+	  (there is a small number of Interrupt ReQuest lines in your computer
+	  that are used by the attached devices to gain the CPU's attention --
+	  often a source of trouble if two devices are mistakenly configured
+	  to use the same IRQ). The program procinfo to display some
+	  information about your system gathered from the /proc file system.
+
+	  Before you can use the /proc file system, it has to be mounted,
+	  meaning it has to be given a location in the directory hierarchy.
+	  That location should be /proc. A command such as "mount -t proc proc
+	  /proc" or the equivalent line in /etc/fstab does the job.
+
+	  The /proc file system is explained in the file
+	  <file:Documentation/filesystems/proc.txt> and on the proc(5) manpage
+	  ("man 5 proc").
+
+	  This option will enlarge your kernel by about 67 KB. Several
+	  programs depend on this, so everyone should say Y here.
+
+config PROC_KCORE
+	bool "/proc/kcore support" if !ARM
+	depends on PROC_FS && MMU
+
+config PROC_VMCORE
+        bool "/proc/vmcore support (EXPERIMENTAL)"
+        depends on PROC_FS && EXPERIMENTAL && CRASH_DUMP
+	default y
+        help
+        Exports the dump image of crashed kernel in ELF format.
+
+config PROC_SYSCTL
+	bool "Sysctl support (/proc/sys)" if EMBEDDED
+	depends on PROC_FS
+	select SYSCTL
+	default y
+	---help---
+	  The sysctl interface provides a means of dynamically changing
+	  certain kernel parameters and variables on the fly without requiring
+	  a recompile of the kernel or reboot of the system.  The primary
+	  interface is through /proc/sys.  If you say Y here a tree of
+	  modifiable sysctl entries will be generated beneath the
+          /proc/sys directory. They are explained in the files
+	  in <file:Documentation/sysctl/>.  Note that enabling this
+	  option will enlarge the kernel by at least 8 KB.
+
+	  As it is generally a good thing, you should say Y here unless
+	  building a kernel for install/rescue disks or your system is very
+	  limited in memory.

