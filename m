Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746AbXJUXyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbXJUXyy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 19:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbXJUXws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 19:52:48 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49331 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbXJUXwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 19:52:46 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 1/9] Unionfs: security convert lsm into a static interface fix
Date: Sun, 21 Oct 2007 19:51:14 -0400
Message-Id: <11930106831948-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
References: <11930106823372-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "security_inode_permission" [fs/unionfs/unionfs.ko] undefined!
ERROR: "security_file_ioctl" [fs/unionfs/unionfs.ko] undefined!

Need these back.

Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: James Morris <jmorris@namei.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 security/security.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/security/security.c b/security/security.c
index 0e1f1f1..95a6733 100644
--- a/security/security.c
+++ b/security/security.c
@@ -409,6 +409,7 @@ int security_inode_permission(struct inode *inode, int mask, struct nameidata *n
 		return 0;
 	return security_ops->inode_permission(inode, mask, nd);
 }
+EXPORT_SYMBOL(security_inode_permission);
 
 int security_inode_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -518,6 +519,7 @@ int security_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	return security_ops->file_ioctl(file, cmd, arg);
 }
+EXPORT_SYMBOL(security_file_ioctl);
 
 int security_file_mmap(struct file *file, unsigned long reqprot,
 			unsigned long prot, unsigned long flags,
-- 
1.5.2.2

