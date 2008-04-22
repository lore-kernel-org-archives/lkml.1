Return-Path: <linux-kernel-owner+w=401wt.eu-S1762858AbYDVPvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762858AbYDVPvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 11:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbYDVPvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 11:51:06 -0400
Received: from sandeen.net ([209.173.210.139]:30802 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752696AbYDVPvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 11:51:05 -0400
Message-ID: <480E0967.8070302@sandeen.net>
Date: Tue, 22 Apr 2008 10:51:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] mark sys_mount helper functions as noinline_for_stack
References: <480E06A6.1080803@redhat.com>
In-Reply-To: <480E06A6.1080803@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the self-documenting noinline_for_stack attribute
in sys_mount helper functions.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Index: linux-2.6.25/fs/namespace.c
===================================================================
--- linux-2.6.25.orig/fs/namespace.c	2008-04-20 22:32:50.000000000 -0500
+++ linux-2.6.25/fs/namespace.c	2008-04-22 09:56:59.824406548 -0500
@@ -946,9 +946,8 @@ out_unlock:
 
 /*
  * recursively change the type of the mountpoint.
- * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_change_type(struct nameidata *nd, int flag)
+static noinline_for_stack int do_change_type(struct nameidata *nd, int flag)
 {
 	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
@@ -971,9 +970,8 @@ static noinline int do_change_type(struc
 
 /*
  * do loopback mount.
- * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_loopback(struct nameidata *nd, char *old_name,
+static noinline_for_stack int do_loopback(struct nameidata *nd, char *old_name,
 				int recurse)
 {
 	struct nameidata old_nd;
@@ -1023,10 +1021,9 @@ out:
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
- * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_remount(struct nameidata *nd, int flags, int mnt_flags,
-		      void *data)
+static noinline_for_stack int do_remount(struct nameidata *nd, int flags,
+		      int mnt_flags, void *data)
 {
 	int err;
 	struct super_block *sb = nd->path.mnt->mnt_sb;
@@ -1060,10 +1057,8 @@ static inline int tree_contains_unbindab
 	return 0;
 }
 
-/*
- * noinline this do_mount helper to save do_mount stack space.
- */
-static noinline int do_move_mount(struct nameidata *nd, char *old_name)
+static noinline_for_stack int do_move_mount(struct nameidata *nd,
+		char *old_name)
 {
 	struct nameidata old_nd;
 	struct path parent_path;
@@ -1141,10 +1136,9 @@ out:
 /*
  * create a new mount for userspace and request it to be added into the
  * namespace's tree
- * noinline this do_mount helper to save do_mount stack space.
  */
-static noinline int do_new_mount(struct nameidata *nd, char *type, int flags,
-			int mnt_flags, char *name, void *data)
+static noinline_for_stack int do_new_mount(struct nameidata *nd, char *type,
+			int flags, int mnt_flags, char *name, void *data)
 {
 	struct vfsmount *mnt;
 

