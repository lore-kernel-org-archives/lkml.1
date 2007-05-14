Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbXENLjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbXENLjH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762422AbXENLcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:32:51 -0400
Received: from 213.210.179.104.adsl.nextra.cz ([213.210.179.104]:27936 "EHLO
	duck8.pdx.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758616AbXENLca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:32:30 -0400
Message-Id: <20070514110620.237075017@suse.de>
References: <20070514110607.549397248@suse.de>
User-Agent: quilt/0.46-14
Date: Mon, 14 May 2007 04:06:42 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 35/45] Allow permission functions to tell between parent and leaf checks
Content-Disposition: inline; filename=parent-permission.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Set the LOOKUP_CONTINUE flag when checking parent permissions. This allows
permission functions to tell between parent and leaf checks.

Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

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
