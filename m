Return-Path: <linux-kernel-owner+w=401wt.eu-S1945975AbXDLJkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbXDLJkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945963AbXDLJka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:40:30 -0400
Received: from ns.suse.de ([195.135.220.2]:57868 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945959AbXDLJk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:29 -0400
Message-Id: <20070412090836.943689000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:12 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Steve Beattie <sbeattie@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 03/41] Remove redundant check from proc_sys_setattr()
Content-Disposition: inline; filename=proc_sys_setattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Signed-off-by: Steve Beattie <sbeattie@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/proc/proc_sysctl.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -429,11 +429,8 @@ static int proc_sys_setattr(struct dentr
 		return -EPERM;
 
 	error = inode_change_ok(inode, attr);
-	if (!error) {
-		error = security_inode_setattr(dentry, attr);
-		if (!error)
-			error = inode_setattr(inode, attr);
-	}
+	if (!error)
+		error = inode_setattr(inode, attr);
 
 	return error;
 }

-- 
