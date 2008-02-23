Return-Path: <linux-kernel-owner+w=401wt.eu-S937415AbYBWAxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937415AbYBWAxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 19:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933373AbYBWAnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 19:43:39 -0500
Received: from yoi5.greathalifaxhome.com ([66.180.172.116]:38024 "HELO
	vps1.tull.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1763914AbYBWAnb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 19:43:31 -0500
X-Spam-Check-By: mail.local.tull.net
From: Nick Andrew <nick@nick-andrew.net>
Subject: [PATCH try #1] Kconfig: cleanup usr/Kconfig help descriptions
To: trivial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Sat, 23 Feb 2008 11:43:00 +1100
Message-ID: <20080223003118.16651.69344.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify the help descriptions of usr/Kconfig for clarity, accuracy and consistency.

This patch mostly clarifies what INITRAMFS_SOURCE does, i.e. optionally
build a CPIO archive of the initial root filesystem (initramfs) and
compress it and link it into the kernel.  Note that usually the initramfs
is separate, and loaded by a bootloader (and I give a list of the common
ones, for clarity).

Correct the filename of gen_init_cpio.c and clarify that any filenames
specified contain lists of directives for the archive builder, rather than
files to be added directly into the archive.

Improve grammar on INITRAMFS_ROOT_UID and INITRAMFS_ROOT_GID and
use consistent terminology.

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---
I think I might be starting to get the hang of this :-)


 usr/Kconfig |   51 +++++++++++++++++++++++++++++++++------------------
 1 files changed, 33 insertions(+), 18 deletions(-)


diff --git a/usr/Kconfig b/usr/Kconfig
index 86cecb5..0ad8713 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -6,41 +6,56 @@ config INITRAMFS_SOURCE
 	string "Initramfs source file(s)"
 	default ""
 	help
-	  This can be either a single cpio archive with a .cpio suffix or a
-	  space-separated list of directories and files for building the
-	  initramfs image.  A cpio archive should contain a filesystem archive
-	  to be used as an initramfs image.  Directories should contain a
-	  filesystem layout to be included in the initramfs image.  Files
-	  should contain entries according to the format described by the
-	  "usr/gen_init_cpio" program in the kernel tree.
+	  Specify the contents of an early userspace image to be linked
+	  into the kernel image.
+
+	  A booting kernel usually obtains an initramfs image from a
+	  bootloader (e.g. loadlin, lilo or grub). Alternately one can
+	  be built and linked into the kernel image using this option.
+
+	  You can specify either a single cpio archive filename with a .cpio
+	  suffix or a space-separated list of directories and files for
+	  building the initramfs image. The result will be a compressed
+	  cpio archive containing a filesystem layout which will be
+	  used as an initramfs image by the booting kernel.
+
+	  A cpio archive should contain a filesystem layout which will
+	  become the initramfs image.
+
+	  Directories should contain a filesystem layout to be included
+	  into the initramfs image.
+
+	  Files should contain a list of directives according to the
+	  format described by the <file:usr/gen_init_cpio.c> program in
+	  the kernel tree.
 
 	  When multiple directories and files are specified then the
 	  initramfs image will be the aggregate of all of them.
 
 	  See <file:Documentation/early-userspace/README> for more details.
 
-	  If you are not sure, leave it blank.
+	  If unsure, leave it blank.
 
 config INITRAMFS_ROOT_UID
 	int "User ID to map to 0 (user root)"
 	depends on INITRAMFS_SOURCE!=""
 	default "0"
 	help
-	  This setting is only meaningful if the INITRAMFS_SOURCE is
-	  contains a directory.  Setting this user ID (UID) to something
-	  other than "0" will cause all files owned by that UID to be
-	  owned by user root in the initial ramdisk image.
+	  This setting is only meaningful if INITRAMFS_SOURCE contains
+	  a directory.	Setting this user ID (UID) to something other
+	  than "0" will cause all files owned by that UID in the source
+	  directories to be owned by user root in the initramfs image.
 
-	  If you are not sure, leave it set to "0".
+	  If unsure, leave it set to "0".
 
 config INITRAMFS_ROOT_GID
 	int "Group ID to map to 0 (group root)"
 	depends on INITRAMFS_SOURCE!=""
 	default "0"
 	help
-	  This setting is only meaningful if the INITRAMFS_SOURCE is
-	  contains a directory.  Setting this group ID (GID) to something
-	  other than "0" will cause all files owned by that GID to be
-	  owned by group root in the initial ramdisk image.
+	  This setting is only meaningful if INITRAMFS_SOURCE contains
+	  a directory.	Setting this group ID (GID) to something other
+	  than "0" will cause all files owned by that GID in the source
+	  directories to be owned by group root in the initramfs image.
 
-	  If you are not sure, leave it set to "0".
+	  If unsure, leave it set to "0".

