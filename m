Return-Path: <linux-kernel-owner+w=401wt.eu-S933001AbXBESXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001AbXBESXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933014AbXBESXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:23:36 -0500
Received: from ns2.suse.de ([195.135.220.15]:47586 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932995AbXBESXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:23:32 -0500
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Tony Jones <tonyj@suse.de>, linux-security-module@vger.kernel.org,
       agruen@suse.de
Date: Mon, 05 Feb 2007 10:22:34 -0800
Message-Id: <20070205182234.12164.15765.sendpatchset@ermintrude.int.wirex.com>
In-Reply-To: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
Subject: [RFC 2/28] Remove redundant check from proc_setattr().
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove redundant check from proc_setattr()

notify_change() already calls security_inode_setattr() before
calling iop->setattr.

Signed-off-by: Tony Jones <tonyj@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

Index: linux-2.6/fs/proc/base.c
===================================================================
--- linux-2.6.orig/fs/proc/base.c
+++ linux-2.6/fs/proc/base.c
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
 
