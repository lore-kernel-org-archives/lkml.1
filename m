Return-Path: <linux-kernel-owner+w=401wt.eu-S934128AbZLKWal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128AbZLKWal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:30:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762781AbZLKWZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:27 -0500
Received: from kroah.org ([198.145.64.141]:32793 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762724AbZLKWZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:06 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/27] sysfs: Simplify iattr time assignments
Date: Fri, 11 Dec 2009 14:24:38 -0800
Message-Id: <1260570289-6997-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

The granularity of sysfs time when we keep it is 1 ns.  Which
when passed to timestamp_trunc results in a nop.  So remove
the unnecessary function call making sysfs_setattr slightly
easier to read.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 000bd98..86fb230 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -104,14 +104,11 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 		if (ia_valid & ATTR_GID)
 			iattrs->ia_gid = iattr->ia_gid;
 		if (ia_valid & ATTR_ATIME)
-			iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_atime = iattr->ia_atime;
 		if (ia_valid & ATTR_MTIME)
-			iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_mtime = iattr->ia_mtime;
 		if (ia_valid & ATTR_CTIME)
-			iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
-					inode->i_sb->s_time_gran);
+			iattrs->ia_ctime = iattr->ia_ctime;
 		if (ia_valid & ATTR_MODE) {
 			umode_t mode = iattr->ia_mode;
 
-- 
1.6.5.5

