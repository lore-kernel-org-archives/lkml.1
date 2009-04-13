Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZDMHNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZDMHNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 03:13:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZDMHM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 03:12:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54406 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZDMHMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 03:12:55 -0400
Message-ID: <49E2E5CD.9050402@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 15:12:13 +0800
From: Shen Feng <shen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] doc: add documentation for debugfs
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


debugfs is used as a virtual filesystem devoted to debugging
information. But it's not documented in Documentation/filesystems.
Add one for it. The content is mainly from
http://lwn.net/Articles/115405/

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
---
 Documentation/filesystems/debugfs.txt |   51 +++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/debugfs.txt

diff --git a/Documentation/filesystems/debugfs.txt b/Documentation/filesystems/debugfs.txt
new file mode 100644
index 0000000..112cf0c
--- /dev/null
+++ b/Documentation/filesystems/debugfs.txt
@@ -0,0 +1,51 @@
+        Debugfs - a virtual filesystem devoted to debugging information
+
+Debugfs is a virtual filesystem devoted to debugging information. Debugfs is
+intended to be a relatively easy and lightweight subsystem which gracefully
+disappears when configured out of the kernel.
+
+Traditionally debugfs is supposed to be mounted at /sys/kernel/debug with the
+following command:
+
+ # mount -t debugfs none /sys/kernel/debug/
+
+A developer wishing to use debugfs starts by creating a directory within the
+filesystem:
+
+    struct dentry *debugfs_create_dir(const char *name,
+                                      struct dentry *parent);
+
+The parent argument will usually be NULL, causing the directory to be created
+in the debugfs root. If debugfs is not configured into the system, the return
+value is -ENODEV; a NULL return, instead, indicates some other sort of error.
+
+The general-purpose function for creating a file in debugfs is:
+
+    struct dentry *debugfs_create_file(const char *name, mode_t mode,
+                                       struct dentry *parent, void *data,
+                                       struct file_operations *fops);
+
+The structure pointed to by fops should, of course, contain pointers to the
+functions which implement the actual operations on the file. In many cases,
+most of those functions can be the helpers provided by seq_file, making the
+task of exporting a file easy.
+
+Some additional helpers have been provided to make exporting a single value as
+easy as possible:
+
+    struct dentry *debugfs_create_u8(const char *name, mode_t mode,
+                                     struct dentry *parent, u8 *value);
+    struct dentry *debugfs_create_u16(const char *name, mode_t mode,
+                                      struct dentry *parent, u16 *value);
+    struct dentry *debugfs_create_u32(const char *name, mode_t mode,
+                                      struct dentry *parent, u32 *value);
+    struct dentry *debugfs_create_bool(const char *name, mode_t mode,
+                                       struct dentry *parent, u32 *value);
+
+Debugfs does not automatically clean up files when a module shuts down, so,
+for every file or directory created with the above functions, there must be a
+call to:
+
+    void debugfs_remove(struct dentry *dentry);
+
+See Documentation/DocBook/filesystems for more details.
-- 
1.6.0.6


