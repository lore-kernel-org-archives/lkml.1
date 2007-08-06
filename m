Return-Path: <linux-kernel-owner+w=401wt.eu-S933943AbXHFOBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933943AbXHFOBb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764407AbXHFNzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:55:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763578AbXHFNzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:55:00 -0400
Date: Mon, 6 Aug 2007 09:54:57 -0400
Message-Id: <200708061354.l76DsvRj002342@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 17/25] procfs: add attr_kill_to_mode to setattr functions
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this is really needed, but I don't think it will hurt anything

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/proc/base.c        |    3 +++
 fs/proc/generic.c     |    3 +++
 fs/proc/proc_sysctl.c |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3c77d5a..d2e56ba 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -348,6 +348,9 @@ static int proc_setattr(struct dentry *dentry, struct iattr *attr)
 	int error;
 	struct inode *inode = dentry->d_inode;
 
+	/* FIXME: is this necessary? */
+	attr_kill_to_mode(inode, attr);
+
 	if (attr->ia_valid & ATTR_MODE)
 		return -EPERM;
 
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b5e7155..88d736c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -239,6 +239,9 @@ static int proc_notify_change(struct dentry *dentry, struct iattr *iattr)
 	struct proc_dir_entry *de = PDE(inode);
 	int error;
 
+	/* FIXME: is this necessary? */
+	attr_kill_to_mode(inode, iattr);
+
 	error = inode_change_ok(inode, iattr);
 	if (error)
 		goto out;
diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 680c429..37c0cca 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -425,6 +425,9 @@ static int proc_sys_setattr(struct dentry *dentry, struct iattr *attr)
 	struct inode *inode = dentry->d_inode;
 	int error;
 
+	/* FIXME: is this necessary */
+	attr_kill_to_mode(inode, attr);
+
 	if (attr->ia_valid & (ATTR_MODE | ATTR_UID | ATTR_GID))
 		return -EPERM;
 
-- 
1.5.2.2

