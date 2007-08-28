Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbXH1EtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbXH1EtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 00:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXH1EtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 00:49:04 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48044 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXH1EtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 00:49:03 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 28 Aug 2007 00:38:40 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove valueless definition of hard-selected RAMFS option.
Message-ID: <Pine.LNX.4.64.0708280025240.2587@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since CONFIG_RAMFS is currently hard-selected to "y", and since
Documentation/filesystems/ramfs-rootfs-initramfs.txt reads as follows:

"The amount of code required to implement ramfs is tiny, because all
the work is done by the existing Linux caching infrastructure.
Basically, you're mounting the disk cache as a filesystem.  Because of
this, ramfs is not an optional component removable via menuconfig,
since there would be negligible space savings."

it seems pointless to leave this as a Kconfig entry.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  this also allows almost 300 "CONFIG_RAMFS=y" lines to be dropped
from various defconfig files.  and that horribly misleading Kconfig
help text disappears as well.  :-)

  compile tested under i386.


 fs/Kconfig        |   14 --------------
 fs/Makefile       |    2 +-
 fs/ramfs/Makefile |    2 +-
 3 files changed, 2 insertions(+), 16 deletions(-)


diff --git a/fs/Kconfig b/fs/Kconfig
index 58a0650..60d859b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1002,20 +1002,6 @@ config HUGETLBFS
 config HUGETLB_PAGE
 	def_bool HUGETLBFS

-config RAMFS
-	bool
-	default y
-	---help---
-	  Ramfs is a file system which keeps all files in RAM. It allows
-	  read and write access.
-
-	  It is more of an programming example than a useable file system.  If
-	  you need a file system which lives in RAM with limit checking use
-	  tmpfs.
-
-	  To compile this as a module, choose M here: the module will be called
-	  ramfs.
-
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem (EXPERIMENTAL)"
 	depends on SYSFS && EXPERIMENTAL
diff --git a/fs/Makefile b/fs/Makefile
index 720c29d..500cf15 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
-obj-$(CONFIG_RAMFS)		+= ramfs/
+obj-y				+= ramfs/
 obj-$(CONFIG_HUGETLBFS)		+= hugetlbfs/
 obj-$(CONFIG_CODA_FS)		+= coda/
 obj-$(CONFIG_MINIX_FS)		+= minix/
diff --git a/fs/ramfs/Makefile b/fs/ramfs/Makefile
index 5a0236e..c71e65d 100644
--- a/fs/ramfs/Makefile
+++ b/fs/ramfs/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the linux ramfs routines.
 #

-obj-$(CONFIG_RAMFS) += ramfs.o
+obj-y += ramfs.o

 file-mmu-y := file-nommu.o
 file-mmu-$(CONFIG_MMU) := file-mmu.o

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
