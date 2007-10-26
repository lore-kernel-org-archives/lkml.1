Return-Path: <linux-kernel-owner+w=401wt.eu-S1760860AbXJZHLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860AbXJZHLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 03:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762071AbXJZG65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 02:58:57 -0400
Received: from mail.suse.de ([195.135.220.2]:34961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762009AbXJZG6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 02:58:55 -0400
X-Mailbox-Line: From jjohansen@suse.de Thu Oct 25 23:40:51 2007
Message-Id: <20071026064051.877606581@suse.de>
References: <20071026064024.243943043@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 25 Oct 2007 23:40:59 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 35/45] Allow permission functions to tell between parent and leaf checks
Content-Disposition: inline; filename=parent-permission.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set the LOOKUP_CONTINUE flag when checking parent permissions. This allows
permission functions to tell between parent and leaf checks.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/namei.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1472,6 +1472,10 @@ static int may_delete(struct inode *dir,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim, dir);
 
+#if 0
+	if (nd)
+		nd->flags |= LOOKUP_CONTINUE;
+#endif
 	error = permission(dir,MAY_WRITE | MAY_EXEC, NULL);
 	if (error)
 		return error;
@@ -1509,6 +1513,8 @@ static inline int may_create(struct inod
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
+	if (nd)
+		nd->flags |= LOOKUP_CONTINUE;
 	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
 }
 

-- 

