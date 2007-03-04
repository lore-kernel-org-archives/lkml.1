Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXCDOM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXCDOM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 09:12:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbXCDOM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 09:12:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60533 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbXCDOM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 09:12:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Kconfig: Update swsusp description
Date: Sun, 4 Mar 2007 15:14:44 +0100
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703041514.44680.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Update the outdated and inaccurate description of the software suspend in
Kconfig.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig |   39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

Index: linux-2.6.21-rc2/kernel/power/Kconfig
===================================================================
--- linux-2.6.21-rc2.orig/kernel/power/Kconfig	2007-02-28 23:54:45.000000000 +0100
+++ linux-2.6.21-rc2/kernel/power/Kconfig	2007-03-04 11:50:48.000000000 +0100
@@ -81,30 +81,35 @@ config SOFTWARE_SUSPEND
 	bool "Software Suspend"
 	depends on PM && SWAP && ((X86 && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
 	---help---
-	  Enable the possibility of suspending the machine.
-	  It doesn't need ACPI or APM.
-	  You may suspend your machine by 'swsusp' or 'shutdown -z <time>' 
-	  (patch for sysvinit needed). 
+	  Enable the suspend to disk (STD) functionality.
 
-	  It creates an image which is saved in your active swap. Upon next
+	  You can suspend your machine with 'echo disk > /sys/power/state'.
+	  Alternatively, you can use the additional userland tools available
+	  from <http://suspend.sf.net>.
+
+	  In principle it does not require ACPI or APM, although for example
+	  ACPI will be used if available.
+
+	  It creates an image which is saved in your active swap. Upon the next
 	  boot, pass the 'resume=/dev/swappartition' argument to the kernel to
 	  have it detect the saved image, restore memory state from it, and
 	  continue to run as before. If you do not want the previous state to
-	  be reloaded, then use the 'noresume' kernel argument. However, note
-	  that your partitions will be fsck'd and you must re-mkswap your swap
-	  partitions. It does not work with swap files.
-
-	  Right now you may boot without resuming and then later resume but
-	  in meantime you cannot use those swap partitions/files which were
-	  involved in suspending. Also in this case there is a risk that buffers
-	  on disk won't match with saved ones.
+	  be reloaded, then use the 'noresume' kernel command line argument.
+	  Note, however, that fsck will be run on your filesystems and you will
+	  need to run mkswap against the swap partition used for the suspend.
+
+	  It also works with swap files to a limited extent (for details see
+	  <file:Documentation/power/swsusp-and-swap-files.txt>).
+
+	  Right now you may boot without resuming and resume later but in the
+	  meantime you cannot use the swap partition(s)/file(s) involved in
+	  suspending.  Also in this case you must not use the filesystems
+	  that were mounted before the suspend.  In particular, you MUST NOT
+	  MOUNT any journaled filesystems mounted before the suspend or they
+	  will get corrupted in a nasty way.
 
 	  For more information take a look at <file:Documentation/power/swsusp.txt>.
 
-	  (For now, swsusp is incompatible with PAE aka HIGHMEM_64G on i386.
-	  we need identity mapping for resume to work, and that is trivial
-	  to get with 4MB pages, but less than trivial on PAE).
-
 config PM_STD_PARTITION
 	string "Default resume partition"
 	depends on SOFTWARE_SUSPEND
