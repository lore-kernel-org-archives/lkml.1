Return-Path: <linux-kernel-owner+w=401wt.eu-S1751495AbXEXQWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495AbXEXQWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXQVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:21:53 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37776 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXEXQVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:21:52 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 1/1] Documentation: Fix up docs still talking about i_sem
Date: Thu, 24 May 2007 12:21:43 -0400
Message-Id: <11800237034135-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 Documentation/filesystems/directory-locking |    5 +++--
 Documentation/filesystems/porting           |    8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/directory-locking b/Documentation/filesystems/directory-locking
index d7099a9..ff7b611 100644
--- a/Documentation/filesystems/directory-locking
+++ b/Documentation/filesystems/directory-locking
@@ -1,5 +1,6 @@
 	Locking scheme used for directory operations is based on two
-kinds of locks - per-inode (->i_sem) and per-filesystem (->s_vfs_rename_sem).
+kinds of locks - per-inode (->i_mutex) and per-filesystem
+(->s_vfs_rename_mutex).
 
 	For our purposes all operations fall in 5 classes:
 
@@ -63,7 +64,7 @@ objects - A < B iff A is an ancestor of B.
 attempt to acquire some lock and already holds at least one lock.  Let's
 consider the set of contended locks.  First of all, filesystem lock is
 not contended, since any process blocked on it is not holding any locks.
-Thus all processes are blocked on ->i_sem.
+Thus all processes are blocked on ->i_mutex.
 
 	Non-directory objects are not contended due to (3).  Thus link
 creation can't be a part of deadlock - it can't be blocked on source
diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
index 5531694..dac45c9 100644
--- a/Documentation/filesystems/porting
+++ b/Documentation/filesystems/porting
@@ -107,7 +107,7 @@ free to drop it...
 ---
 [informational]
 
-->link() callers hold ->i_sem on the object we are linking to.  Some of your
+->link() callers hold ->i_mutex on the object we are linking to.  Some of your
 problems might be over...
 
 ---
@@ -130,9 +130,9 @@ went in - and hadn't been documented ;-/).  Just remove it from fs_flags
 ---
 [mandatory]
 
-->setattr() is called without BKL now.  Caller _always_ holds ->i_sem, so
-watch for ->i_sem-grabbing code that might be used by your ->setattr().
-Callers of notify_change() need ->i_sem now.
+->setattr() is called without BKL now.  Caller _always_ holds ->i_mutex, so
+watch for ->i_mutex-grabbing code that might be used by your ->setattr().
+Callers of notify_change() need ->i_mutex now.
 
 ---
 [recommended]
-- 
1.5.2.rc1.165.gaf9b

