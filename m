Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYHUFph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYHUFph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYHUFox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:44:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbYHUFou (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:44:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=EJmrG0z1ULFi1FUKU32bC73r2SchjAgwDsx6+zhIQOUzXGwG6uA2JD08+MaDsefG9M
         miseZpUaULyY7kcBf/5VNnbtoveHOL2JUmTn2zWG/ACEBL+77xN44SRgsXA+UYgZCjh2
         jz7GlLJxdsk1vvHGrmpeycKhDA5Kj80GT9LhI=
Message-ID: <48AD00DF.9080207@gmail.com>
Date: Wed, 20 Aug 2008 22:45:03 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 02/10] AXFS: Kconfig and Makefiles
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig edits and Makefiles required for AXFS.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
diff --git a/fs/Kconfig b/fs/Kconfig
index d387358..02d5f48 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -1033,6 +1033,26 @@ config AFFS_FS
 	  To compile this file system support as a module, choose M here: the
 	  module will be called affs.  If unsure, say N.
 
+config AXFS
+	tristate "Advanced XIP File System (AXFS) support (EXPERIMENTAL)"
+	select FS_XIP
+	select ZLIB_INFLATE
+	default n
+	help
+	  The Advanced XIP File System or (AXFS) is a highly compressed
+	  readonly filesystem like cramfs or squashfs.  It also can be
+	  configured to store individual pages of files compressed or
+	  uncompressed as XIP pages.  This allows for faster boot up and
+	  application launch time with a smaller memory footprint.
+
+config AXFS_PROFILING
+	bool "Profiling extensions for AXFS (EXPERIMENTAL)"
+	depends on AXFS
+	default n
+	help
+	  Profiling tooling used to identify what pages in the filesystem
+	  image are actually accessed and how much.
+
 config ECRYPT_FS
 	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && KEYS && CRYPTO && NET
diff --git a/fs/Makefile b/fs/Makefile
index a1482a5..8636019 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -74,6 +74,7 @@ obj-$(CONFIG_JBD)		+= jbd/
 obj-$(CONFIG_JBD2)		+= jbd2/
 obj-$(CONFIG_EXT2_FS)		+= ext2/
 obj-$(CONFIG_CRAMFS)		+= cramfs/
+obj-$(CONFIG_AXFS)		+= axfs/
 obj-y				+= ramfs/
 obj-$(CONFIG_HUGETLBFS)		+= hugetlbfs/
 obj-$(CONFIG_CODA_FS)		+= coda/
diff --git a/fs/axfs/Makefile b/fs/axfs/Makefile
new file mode 100644
index 0000000..4c40e13
--- /dev/null
+++ b/fs/axfs/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux axfs routines
+#
+
+obj-$(CONFIG_AXFS) += axfs.o
+
+axfs-objs := axfs_inode.o axfs_super.o axfs_uncompress.o axfs_profiling.o axfs_uml.o axfs_mtd.o axfs_bdev.o


