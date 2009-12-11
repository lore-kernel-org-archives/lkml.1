Return-Path: <linux-kernel-owner+w=401wt.eu-S934290AbZLKWcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290AbZLKWcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934197AbZLKWbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:31:24 -0500
Received: from kroah.org ([198.145.64.141]:32840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762760AbZLKWZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:25:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 25/27] sysfs: sysfs_setattr remove unnecessary permission check.
Date: Fri, 11 Dec 2009 14:24:47 -0800
Message-Id: <1260570289-6997-25-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>

inode_change_ok already clears the SGID bit when necessary
so there is no reason for sysfs_setattr to carry code to do
the same, and it is good to kill the extra copy because when
I moved the code last in certain corner cases the code will
look at the wrong gid.

Acked-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/inode.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 9f783d4..220b758 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -117,10 +117,6 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
 		return error;
 
 	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
-	if (iattr->ia_valid & ATTR_MODE) {
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			iattr->ia_mode &= ~S_ISGID;
-	}
 
 	error = inode_setattr(inode, iattr);
 	if (error)
-- 
1.6.5.5

