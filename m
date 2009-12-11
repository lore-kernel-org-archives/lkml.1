Return-Path: <linux-kernel-owner+w=401wt.eu-S934359AbZLKWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934359AbZLKWeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761361AbZLKWdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:33:50 -0500
Received: from kroah.org ([198.145.64.141]:32797 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762716AbZLKWZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:03 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 13/27] sysfs: Rename sysfs_d_iput to sysfs_dentry_iput
Date: Fri, 11 Dec 2009 14:24:35 -0800
Message-Id: <1260570289-6997-13-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

Using dentry instead of d in the function name is what
several other filesystems are doing and it seems to be
a more readable convention.

Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e020183..01a9a64 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -298,7 +298,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 		goto repeat;
 }
 
-static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
+static void sysfs_dentry_iput(struct dentry *dentry, struct inode *inode)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
 
@@ -307,7 +307,7 @@ static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
 }
 
 static const struct dentry_operations sysfs_dentry_ops = {
-	.d_iput		= sysfs_d_iput,
+	.d_iput		= sysfs_dentry_iput,
 };
 
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
-- 
1.6.5.5

