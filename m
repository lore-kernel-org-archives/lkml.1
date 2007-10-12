Return-Path: <linux-kernel-owner+w=401wt.eu-S933015AbXJLW2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015AbXJLW2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 18:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760899AbXJLWTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 18:19:06 -0400
Received: from ns2.suse.de ([195.135.220.15]:49670 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbXJLWTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 18:19:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/75] sysfs: cleanup semaphore.h
Date: Fri, 12 Oct 2007 15:16:23 -0700
Message-Id: <1192227527856-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <11922275221643-git-send-email-gregkh@suse.de>
References: \<20071012221251.GB4559@kroah.com\>
 <11922274393667-git-send-email-gregkh@suse.de>
 <11922274441634-git-send-email-gregkh@suse.de>
 <11922274503271-git-send-email-gregkh@suse.de>
 <11922274543490-git-send-email-gregkh@suse.de>
 <11922274643370-git-send-email-gregkh@suse.de>
 <11922274682487-git-send-email-gregkh@suse.de>
 <11922274732211-git-send-email-gregkh@suse.de>
 <11922274772578-git-send-email-gregkh@suse.de>
 <1192227481691-git-send-email-gregkh@suse.de>
 <11922274853108-git-send-email-gregkh@suse.de>
 <11922274901810-git-send-email-gregkh@suse.de>
 <11922274941588-git-send-email-gregkh@suse.de>
 <11922274993462-git-send-email-gregkh@suse.de>
 <11922275031518-git-send-email-gregkh@suse.de>
 <11922275074080-git-send-email-gregkh@suse.de>
 <11922275121763-git-send-email-gregkh@suse.de>
 <11922275181138-git-send-email-gregkh@suse.de>
 <11922275221643-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Cleanup semaphore.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c     |    2 +-
 fs/sysfs/dir.c     |    2 +-
 fs/sysfs/group.c   |    1 -
 fs/sysfs/inode.c   |    1 -
 fs/sysfs/mount.c   |    1 -
 fs/sysfs/symlink.c |    2 +-
 6 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 5afe2a2..a819a7e 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -14,9 +14,9 @@
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ea33b66..86d75e0 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -11,7 +11,7 @@
 #include <linux/namei.h>
 #include <linux/idr.h>
 #include <linux/completion.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 #include "sysfs.h"
 
 DEFINE_MUTEX(sysfs_mutex);
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index f318b73..e6b904d 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -14,7 +14,6 @@
 #include <linux/namei.h>
 #include <linux/err.h>
 #include <linux/fs.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 10d1b52..aecb6e7 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
-#include <asm/semaphore.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index fbc7b65..69a73ae 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -8,7 +8,6 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
-#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 4ce687f..9048453 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -7,7 +7,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
-#include <asm/semaphore.h>
+#include <linux/mutex.h>
 
 #include "sysfs.h"
 
-- 
1.5.3.4

