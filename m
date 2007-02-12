Return-Path: <linux-kernel-owner+w=401wt.eu-S965282AbXBLSbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965282AbXBLSbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:31:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965284AbXBLSbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:31:50 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34294 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965282AbXBLSbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:31:49 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: [PATCH 2/3] fs/: Move eCryptfs & Unionfs config options into a sub-menu
Date: Mon, 12 Feb 2007 13:30:51 -0500
Message-Id: <11713050533314-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.rc3.g5057
In-Reply-To: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
References: <11713050521708-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using The Misc filesystems sub-menu for layered/stackable filesystems only
makes it harder for users to find eCryptfs/Unionfs.

Additionally, the menu can be easily turned into a menuconfig, which could
be used to turn on any VFS/VM functionality required by layered filesystems
(there is none at the moment).

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/Kconfig |   66 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index cf46c71..99ea991 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1041,6 +1041,41 @@ config CONFIGFS_FS
 
 endmenu
 
+menu "Layered filesystems"
+
+config ECRYPT_FS
+	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && KEYS && CRYPTO
+	help
+	  Encrypted filesystem that operates on the VFS layer.  See
+	  <file:Documentation/ecryptfs.txt> to learn more about
+	  eCryptfs.  Userspace components are required and can be
+	  obtained from <http://ecryptfs.sf.net>.
+
+	  To compile this file system support as a module, choose M here: the
+	  module will be called ecryptfs.
+
+config UNION_FS
+	tristate "Union file system (EXPERIMENTAL)"
+	depends on EXPERIMENTAL
+	help
+	  Unionfs is a stackable unification file system, which appears to
+	  merge the contents of several directories (branches), while keeping
+	  their physical content separate.
+
+	  See <http://www.unionfs.org> for details
+
+config UNION_FS_XATTR
+	bool "Unionfs extended attributes"
+	depends on UNION_FS
+	help
+	  Extended attributes are name:value pairs associated with inodes by
+	  the kernel or by users (see the attr(5) manual page).
+
+	  If unsure, say N.
+
+endmenu
+
 menu "Miscellaneous filesystems"
 
 config ADFS_FS
@@ -1093,18 +1128,6 @@ config AFFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
 
-config ECRYPT_FS
-	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO
-	help
-	  Encrypted filesystem that operates on the VFS layer.  See
-	  <file:Documentation/ecryptfs.txt> to learn more about
-	  eCryptfs.  Userspace components are required and can be
-	  obtained from <http://ecryptfs.sf.net>.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called ecryptfs.
-
 config HFS_FS
 	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
@@ -1554,25 +1577,6 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
-config UNION_FS
-	tristate "Union file system (EXPERIMENTAL)"
-	depends on EXPERIMENTAL
-	help
-	  Unionfs is a stackable unification file system, which appears to
-	  merge the contents of several directories (branches), while keeping
-	  their physical content separate.
-
-	  See <http://www.unionfs.org> for details
-
-config UNION_FS_XATTR
-	bool "Unionfs extended attributes"
-	depends on UNION_FS
-	help
-	  Extended attributes are name:value pairs associated with inodes by
-	  the kernel or by users (see the attr(5) manual page).
-
-	  If unsure, say N.
-
 endmenu
 
 menu "Network File Systems"
-- 
1.5.0.rc3.g5057

