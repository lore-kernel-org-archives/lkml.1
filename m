Return-Path: <linux-kernel-owner+w=401wt.eu-S934615AbZIEAcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615AbZIEAcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934592AbZIEAUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:49 -0400
Received: from kroah.org ([198.145.64.141]:42084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934531AbZIEAUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:49 2009
Message-Id: <20090905001449.225930718@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mimi Zohar <zohar@us.ibm.com>, James Morris <jmorris@namei.org>
Subject: [patch 12/71] kernel_read: redefine offset type
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kernel_read-redefine-offset-type.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>

commit 6777d773a463ac045d333b989d4e44660f8d92ad upstream.

vfs_read() offset is defined as loff_t, but kernel_read()
offset is only defined as unsigned long. Redefine
kernel_read() offset as loff_t.

Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c          |    4 ++--
 include/linux/fs.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -677,8 +677,8 @@ exit:
 }
 EXPORT_SYMBOL(open_exec);
 
-int kernel_read(struct file *file, unsigned long offset,
-	char *addr, unsigned long count)
+int kernel_read(struct file *file, loff_t offset,
+		char *addr, unsigned long count)
 {
 	mm_segment_t old_fs;
 	loff_t pos = offset;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2121,7 +2121,7 @@ extern struct file *do_filp_open(int dfd
 		int open_flag, int mode, int acc_mode);
 extern int may_open(struct path *, int, int);
 
-extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
+extern int kernel_read(struct file *, loff_t, char *, unsigned long);
 extern struct file * open_exec(const char *);
  
 /* fs/dcache.c -- generic fs support functions */


