Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbXGZGwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbXGZGwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 02:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbXGZGwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 02:52:43 -0400
Received: from hu-out-0506.google.com ([72.14.214.230]:50427 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbXGZGwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 02:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=KJfoiD933jPplzzFnv1Kt4izxweyMmglzGyGUtmhSp2nGZ/iNbxMNVbY593O8Wdj7U5qjHh6fbrxuIwNruCuhksYTbMfRJW76hAe9SP9p0DPcVgdmZVxMUBHdqlHFTjRr4TU4RQAntlKs4BpFS+YgY8nb2mOP0aoXWrJR8BBU18=
Date: Thu, 26 Jul 2007 14:53:53 +0000
From: Dave Young <hidave.darkstar@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs - cleanup semaphore.h
Message-ID: <20070726145353.GA7971@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup semaphore.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
fs/sysfs/bin.c     |    2 +-
fs/sysfs/dir.c     |    2 +-
fs/sysfs/group.c   |    1 -
fs/sysfs/inode.c   |    1 -
fs/sysfs/mount.c   |    1 -
fs/sysfs/symlink.c |    2 +-
6 files changed, 3 insertions(+), 6 deletions(-)

diff -upr linux/fs/sysfs/bin.c linux.new/fs/sysfs/bin.c
--- linux/fs/sysfs/bin.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/bin.c	2007-07-26 14:35:22.000000000 +0000
@@ -14,9 +14,9 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -upr linux/fs/sysfs/dir.c linux.new/fs/sysfs/dir.c
--- linux/fs/sysfs/dir.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/dir.c	2007-07-26 14:35:47.000000000 +0000
@@ -11,7 +11,7 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
diff -upr linux/fs/sysfs/group.c linux.new/fs/sysfs/group.c
--- linux/fs/sysfs/group.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/group.c	2007-07-26 14:36:17.000000000 +0000
@@ -14,7 +14,6 @@
 #include <linux/namei.h>
 #include <linux/err.h>
 #include <linux/fs.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 
diff -upr linux/fs/sysfs/inode.c linux.new/fs/sysfs/inode.c
--- linux/fs/sysfs/inode.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/inode.c	2007-07-26 14:36:38.000000000 +0000
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff -upr linux/fs/sysfs/mount.c linux.new/fs/sysfs/mount.c
--- linux/fs/sysfs/mount.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/mount.c	2007-07-26 14:36:45.000000000 +0000
@@ -8,7 +8,6 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff -upr linux/fs/sysfs/symlink.c linux.new/fs/sysfs/symlink.c
--- linux/fs/sysfs/symlink.c	2007-07-26 14:31:57.000000000 +0000
+++ linux.new/fs/sysfs/symlink.c	2007-07-26 14:37:12.000000000 +0000
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "sysfs.h"
 
