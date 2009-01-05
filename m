Return-Path: <linux-kernel-owner+w=401wt.eu-S1754284AbZAELfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbZAELfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZAELff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:35:35 -0500
Received: from lon1-post-3.mail.demon.net ([195.173.77.150]:64795 "EHLO
	lon1-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbZAELfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:35:34 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: [PATCH V3 14/17] Squashfs: Kconfig entry
Message-Id: <E1LJnJo-0002MA-7l@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 05 Jan 2009 11:08:24 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/Kconfig |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index ff0e819..2553e0b 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -894,6 +894,58 @@ config CRAMFS
 
 	  If unsure, say N.
 
+config SQUASHFS
+	tristate "SquashFS 4.0 - Squashed file system support"
+	depends on BLOCK
+	select ZLIB_INFLATE
+	help
+	  Saying Y here includes support for SquashFS 4.0 (a Compressed
+	  Read-Only File System).  Squashfs is a highly compressed read-only
+	  filesystem for Linux.  It uses zlib compression to compress both
+	  files, inodes and directories.  Inodes in the system are very small
+	  and all blocks are packed to minimise data overhead. Block sizes
+	  greater than 4K are supported up to a maximum of 1 Mbytes (default
+	  block size 128K).  SquashFS 4.0 supports 64 bit filesystems and files
+	  (larger than 4GB), full uid/gid information, hard links and
+	  timestamps.  
+
+	  Squashfs is intended for general read-only filesystem use, for
+	  archival use (i.e. in cases where a .tar.gz file may be used), and in
+	  embedded systems where low overhead is needed.  Further information
+	  and tools are available from http://squashfs.sourceforge.net.
+
+	  If you want to compile this as a module ( = code which can be
+	  inserted in and removed from the running kernel whenever you want),
+	  say M here and read <file:Documentation/modules.txt>.  The module
+	  will be called squashfs.  Note that the root file system (the one
+	  containing the directory /) cannot be compiled as a module.
+
+	  If unsure, say N.
+
+config SQUASHFS_EMBEDDED
+
+	bool "Additional option for memory-constrained systems" 
+	depends on SQUASHFS
+	default n
+	help
+	  Saying Y here allows you to specify cache size.
+
+	  If unsure, say N.
+
+config SQUASHFS_FRAGMENT_CACHE_SIZE
+	int "Number of fragments cached" if SQUASHFS_EMBEDDED
+	depends on SQUASHFS
+	default "3"
+	help
+	  By default SquashFS caches the last 3 fragments read from
+	  the filesystem.  Increasing this amount may mean SquashFS
+	  has to re-read fragments less often from disk, at the expense
+	  of extra system memory.  Decreasing this amount will mean
+	  SquashFS uses less memory at the expense of extra reads from disk.
+
+	  Note there must be at least one cached fragment.  Anything
+	  much more than three will probably not make much difference.
+
 config VXFS_FS
 	tristate "FreeVxFS file system support (VERITAS VxFS(TM) compatible)"
 	depends on BLOCK
-- 
1.5.6.3

