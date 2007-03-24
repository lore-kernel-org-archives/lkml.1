Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbXCXNHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbXCXNHu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXCXNHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:07:24 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33367 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751630AbXCXNHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:07:05 -0400
Date: Sat, 24 Mar 2007 14:07:08 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] fs/revoke.c: cleanups (and bugfix for 64bit systems)
Message-ID: <20070324130708.GK752@stusta.de>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc3-mm1:
>...
> +revoke-core-code.patch
>...
>  revoke() syscall
>...


This patch contains the following:
- every file should #include the headers containing the prototypes for
  it's global functions
- fix the wrong return value of sys_frevoke() gcc was now able to detect
- make 2 needlessly global structs static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 fs/revoke.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.21-rc4-mm1/fs/revoke.c.old	2007-03-23 23:31:46.000000000 +0100
+++ linux-2.6.21-rc4-mm1/fs/revoke.c	2007-03-23 23:50:39.000000000 +0100
@@ -16,6 +16,7 @@
 #include <linux/mount.h>
 #include <linux/sched.h>
 #include <linux/revoked_fs_i.h>
+#include <linux/syscalls.h>
 
 /*
  * This is used for pre-allocating an array of file pointers so that we don't
@@ -28,7 +29,7 @@
 	unsigned long restore_start;
 };
 
-struct kmem_cache *revokefs_inode_cache;
+static struct kmem_cache *revokefs_inode_cache;
 
 /*
  * Revoked file descriptors point to inodes in the revokefs filesystem.
@@ -551,7 +552,7 @@
 	return err;
 }
 
-asmlinkage int sys_frevoke(unsigned int fd)
+asmlinkage long sys_frevoke(unsigned int fd)
 {
 	struct file *file = fget(fd);
 	int err = -EBADF;
@@ -618,7 +619,7 @@
 			     REVOKEFS_MAGIC, mnt);
 }
 
-struct file_system_type revokefs_fs_type = {
+static struct file_system_type revokefs_fs_type = {
 	.name = "revokefs",
 	.get_sb = revokefs_get_sb,
 	.kill_sb = kill_anon_super

