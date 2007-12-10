Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXLJC5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXLJC5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbXLJCop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:44:45 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49776 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbXLJCnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:13 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 39/42] Put Unionfs and eCryptfs under one layered filesystems menu
Date: Sun,  9 Dec 2007 21:42:12 -0500
Message-Id: <11972545613331-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/Kconfig |   53 +++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 12 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 635f3e2..cbcbbee 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1041,6 +1041,47 @@ config CONFIGFS_FS
 
 endmenu
 
+menu "Layered filesystems"
+
+config ECRYPT_FS
+	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
+	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
+	help
+	  Encrypted filesystem that operates on the VFS layer.  See
+	  <file:Documentation/filesystems/ecryptfs.txt> to learn more about
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
+	  See <http://unionfs.filesystems.org> for details
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
+config UNION_FS_DEBUG
+	bool "Debug Unionfs"
+	depends on UNION_FS
+	help
+	  If you say Y here, you can turn on debugging output from Unionfs.
+
+endmenu
+
 menu "Miscellaneous filesystems"
 
 config ADFS_FS
@@ -1093,18 +1134,6 @@ config AFFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
 
-config ECRYPT_FS
-	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
-	help
-	  Encrypted filesystem that operates on the VFS layer.  See
-	  <file:Documentation/filesystems/ecryptfs.txt> to learn more about
-	  eCryptfs.  Userspace components are required and can be
-	  obtained from <http://ecryptfs.sf.net>.
-
-	  To compile this file system support as a module, choose M here: the
-	  module will be called ecryptfs.
-
 config HFS_FS
 	tristate "Apple Macintosh file system support (EXPERIMENTAL)"
 	depends on BLOCK && EXPERIMENTAL
-- 
1.5.2.2

