Return-Path: <linux-kernel-owner+w=401wt.eu-S1946046AbXDLJsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946046AbXDLJsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945980AbXDLJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:40:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:57867 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945952AbXDLJk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:29 -0400
Message-Id: <20070412090836.582976000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:11 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Tony Jones <tonyj@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, John Johansen <jjohansen@suse.de>
Subject: [AppArmor 02/41] Remove redundant check from proc_setattr()
Content-Disposition: inline; filename=proc_setattr.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
Signed-off-by: John Johansen <jjohansen@suse.de>

---
 fs/proc/base.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -344,11 +344,8 @@ static int proc_setattr(struct dentry *d
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
