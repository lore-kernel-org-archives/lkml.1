Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbYKWVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbYKWVBA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751000AbYKWVAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:00:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:57540 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbYKWVAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:00:51 -0500
Date: Sun, 23 Nov 2008 13:01:42 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: viro@ftp.linux.org.uk
Subject: [PATCH] vfs: expand some comments (d_path / seq_path)
Message-ID: <20081123130142.5293e50f@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From 126cd09e3c64ce6406cb2869c623064631c98add Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 4 Nov 2008 21:29:34 -0800
Subject: [PATCH] vfs: expand some comments (d_path / seq_path)

explain that you really need to use the return value of d_path rather
than the buffer you passed into it.

Also fix the comment for seq_path(), the function arguments changed
recently but the comment hadn't been updated in sync.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/dcache.c   |    8 ++++++--
 fs/seq_file.c |   10 ++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..e39f3e9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1911,7 +1911,8 @@ static int prepend_name(char **buffer, int *buflen, struct qstr *name)
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
+ * Returns a pointer into the buffer or an error code if the
+ * path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
  *
@@ -1987,7 +1988,10 @@ Elong:
  * Convert a dentry into an ASCII path name. If the entry has been deleted
  * the string " (deleted)" is appended. Note that this is ambiguous.
  *
- * Returns the buffer or an error code if the path was too long.
+ * Returns a pointer into the buffer or an error code if the path was
+ * too long. Note: Callers should use the returned pointer, not the passed
+ * in buffer, to use the name! The implementation often starts at an offset
+ * into the buffer, and may leave 0 bytes at the start.
  *
  * "buflen" should be positive.
  */
diff --git a/fs/seq_file.c b/fs/seq_file.c
index eba2eab..9e1c051 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -377,8 +377,14 @@ static char *mangle_path(char *s, char *p, char *esc)
 	return NULL;
 }
 
-/*
- * return the absolute path of 'dentry' residing in mount 'mnt'.
+/**
+ * seq_path - seq_file interface to print a pathname
+ * @m: the seq_file handle
+ * @path: the struct path to print
+ * @esc: set of characters to escape in the output
+ *
+ * return the absolute path of 'path', as represented by the
+ * dentry / mnt pair in the path parameter.
  */
 int seq_path(struct seq_file *m, struct path *path, char *esc)
 {
-- 
1.6.0.3


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
