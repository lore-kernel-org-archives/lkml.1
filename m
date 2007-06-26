Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXFZXXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXFZXXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760141AbXFZXMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:12:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760084AbXFZXMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:12:22 -0400
Message-Id: <20070626231136.985740185@suse.de>
References: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:08:31 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>,
       John Johansen <jjohansen@suse.de>
Subject: [AppArmor 35/44] Allow permission functions to tell between parent and leaf checks
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
@@ -1409,6 +1409,10 @@ static int may_delete(struct inode *dir,
 	BUG_ON(victim->d_parent->d_inode != dir);
 	audit_inode_child(victim->d_name.name, victim->d_inode, dir);
 
+#if 0
+	if (nd)
+		nd->flags |= LOOKUP_CONTINUE;
+#endif
 	error = permission(dir,MAY_WRITE | MAY_EXEC, NULL);
 	if (error)
 		return error;
@@ -1446,6 +1450,8 @@ static inline int may_create(struct inod
 		return -EEXIST;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
+	if (nd)
+		nd->flags |= LOOKUP_CONTINUE;
 	return permission(dir,MAY_WRITE | MAY_EXEC, nd);
 }
 

-- 
