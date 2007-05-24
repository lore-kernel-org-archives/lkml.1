Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXEXBkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXEXBkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757257AbXEXBkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:40:33 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42011 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756579AbXEXBkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:40:32 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: mhalcrow@us.ibm.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] eCryptfs: Move ecryptfs docs into Documentation/filesystems/
Date: Wed, 23 May 2007 21:40:20 -0400
Message-Id: <1179970820209-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/ecryptfs.txt             |   77 --------------------------------
 Documentation/filesystems/ecryptfs.txt |   77 ++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+), 77 deletions(-)
 delete mode 100644 Documentation/ecryptfs.txt
 create mode 100644 Documentation/filesystems/ecryptfs.txt

diff --git a/Documentation/ecryptfs.txt b/Documentation/ecryptfs.txt
deleted file mode 100644
index 01d8a08..0000000
--- a/Documentation/ecryptfs.txt
+++ /dev/null
@@ -1,77 +0,0 @@
-eCryptfs: A stacked cryptographic filesystem for Linux
-
-eCryptfs is free software. Please see the file COPYING for details.
-For documentation, please see the files in the doc/ subdirectory.  For
-building and installation instructions please see the INSTALL file.
-
-Maintainer: Phillip Hellewell
-Lead developer: Michael A. Halcrow <mhalcrow@us.ibm.com>
-Developers: Michael C. Thompson
-            Kent Yoder
-Web Site: http://ecryptfs.sf.net
-
-This software is currently undergoing development. Make sure to
-maintain a backup copy of any data you write into eCryptfs.
-
-eCryptfs requires the userspace tools downloadable from the
-SourceForge site:
-
-http://sourceforge.net/projects/ecryptfs/
-
-Userspace requirements include:
- - David Howells' userspace keyring headers and libraries (version
-   1.0 or higher), obtainable from
-   http://people.redhat.com/~dhowells/keyutils/
- - Libgcrypt
-
-
-NOTES
-
-In the beta/experimental releases of eCryptfs, when you upgrade
-eCryptfs, you should copy the files to an unencrypted location and
-then copy the files back into the new eCryptfs mount to migrate the
-files.
-
-
-MOUNT-WIDE PASSPHRASE
-
-Create a new directory into which eCryptfs will write its encrypted
-files (i.e., /root/crypt).  Then, create the mount point directory
-(i.e., /mnt/crypt).  Now it's time to mount eCryptfs:
-
-mount -t ecryptfs /root/crypt /mnt/crypt
-
-You should be prompted for a passphrase and a salt (the salt may be
-blank).
-
-Try writing a new file:
-
-echo "Hello, World" > /mnt/crypt/hello.txt
-
-The operation will complete.  Notice that there is a new file in
-/root/crypt that is at least 12288 bytes in size (depending on your
-host page size).  This is the encrypted underlying file for what you
-just wrote.  To test reading, from start to finish, you need to clear
-the user session keyring:
-
-keyctl clear @u
-
-Then umount /mnt/crypt and mount again per the instructions given
-above.
-
-cat /mnt/crypt/hello.txt
-
-
-NOTES
-
-eCryptfs version 0.1 should only be mounted on (1) empty directories
-or (2) directories containing files only created by eCryptfs. If you
-mount a directory that has pre-existing files not created by eCryptfs,
-then behavior is undefined. Do not run eCryptfs in higher verbosity
-levels unless you are doing so for the sole purpose of debugging or
-development, since secret values will be written out to the system log
-in that case.
-
-
-Mike Halcrow
-mhalcrow@us.ibm.com
diff --git a/Documentation/filesystems/ecryptfs.txt b/Documentation/filesystems/ecryptfs.txt
new file mode 100644
index 0000000..01d8a08
--- /dev/null
+++ b/Documentation/filesystems/ecryptfs.txt
@@ -0,0 +1,77 @@
+eCryptfs: A stacked cryptographic filesystem for Linux
+
+eCryptfs is free software. Please see the file COPYING for details.
+For documentation, please see the files in the doc/ subdirectory.  For
+building and installation instructions please see the INSTALL file.
+
+Maintainer: Phillip Hellewell
+Lead developer: Michael A. Halcrow <mhalcrow@us.ibm.com>
+Developers: Michael C. Thompson
+            Kent Yoder
+Web Site: http://ecryptfs.sf.net
+
+This software is currently undergoing development. Make sure to
+maintain a backup copy of any data you write into eCryptfs.
+
+eCryptfs requires the userspace tools downloadable from the
+SourceForge site:
+
+http://sourceforge.net/projects/ecryptfs/
+
+Userspace requirements include:
+ - David Howells' userspace keyring headers and libraries (version
+   1.0 or higher), obtainable from
+   http://people.redhat.com/~dhowells/keyutils/
+ - Libgcrypt
+
+
+NOTES
+
+In the beta/experimental releases of eCryptfs, when you upgrade
+eCryptfs, you should copy the files to an unencrypted location and
+then copy the files back into the new eCryptfs mount to migrate the
+files.
+
+
+MOUNT-WIDE PASSPHRASE
+
+Create a new directory into which eCryptfs will write its encrypted
+files (i.e., /root/crypt).  Then, create the mount point directory
+(i.e., /mnt/crypt).  Now it's time to mount eCryptfs:
+
+mount -t ecryptfs /root/crypt /mnt/crypt
+
+You should be prompted for a passphrase and a salt (the salt may be
+blank).
+
+Try writing a new file:
+
+echo "Hello, World" > /mnt/crypt/hello.txt
+
+The operation will complete.  Notice that there is a new file in
+/root/crypt that is at least 12288 bytes in size (depending on your
+host page size).  This is the encrypted underlying file for what you
+just wrote.  To test reading, from start to finish, you need to clear
+the user session keyring:
+
+keyctl clear @u
+
+Then umount /mnt/crypt and mount again per the instructions given
+above.
+
+cat /mnt/crypt/hello.txt
+
+
+NOTES
+
+eCryptfs version 0.1 should only be mounted on (1) empty directories
+or (2) directories containing files only created by eCryptfs. If you
+mount a directory that has pre-existing files not created by eCryptfs,
+then behavior is undefined. Do not run eCryptfs in higher verbosity
+levels unless you are doing so for the sole purpose of debugging or
+development, since secret values will be written out to the system log
+in that case.
+
+
+Mike Halcrow
+mhalcrow@us.ibm.com
-- 
1.5.2.rc1.165.gaf9b

