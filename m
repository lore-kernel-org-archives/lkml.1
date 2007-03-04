Return-Path: <linux-kernel-owner+w=401wt.eu-S1751754AbXCDNmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751754AbXCDNmH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbXCDNmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:42:07 -0500
Received: from an-out-0708.google.com ([209.85.132.245]:53774 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbXCDNmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:42:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=KP6M4fw4+Vp6hi/MWtw0YlryZjAkomnRzENVHc2FyRB1Lb/tZ8iauBBO3cN476cse1c5fWPWRS+wosUbEJFSGPjgWOWmRM7VpaBLrNgr7dtxYwERTN1dYAtRirV2rNKRqSJFgH7PqjVCey+oKaj1B6f1TLzL3rWXmNQUrXTwW6g=
Date: Sun, 4 Mar 2007 22:38:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joel Becker <joel.becker@oracle.com>
Subject: [PATCH] configfs: add missing mutex_unlock()
Message-ID: <20070304133812.GC8519@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Joel Becker <joel.becker@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] configfs: add missing mutex_unlock()

Add missing mutex_unlock() on d_alloc() failure in
configfs_register_subsystem().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Joel Becker <joel.becker@oracle.com>
---
 fs/configfs/dir.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: 2.6-mm/fs/configfs/dir.c
===================================================================
--- 2.6-mm.orig/fs/configfs/dir.c
+++ 2.6-mm/fs/configfs/dir.c
@@ -1168,8 +1168,10 @@ int configfs_register_subsystem(struct c
 
 	err = -ENOMEM;
 	dentry = d_alloc(configfs_sb->s_root, &name);
-	if (!dentry)
+	if (!dentry) {
+		mutex_unlock(&configfs_sb->s_root->d_inode->i_mutex);
 		goto out_release;
+	}
 
 	d_add(dentry, NULL);
 
