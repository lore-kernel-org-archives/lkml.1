Return-Path: <linux-kernel-owner+w=401wt.eu-S1751422AbZLRMcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbZLRMcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:32:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZLRMcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:32:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:15458 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZLRMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:32:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j81gHP0gEQyy6Y/Y9uPNQ8c3zKashFXm6FS+v8TwufRhe8buO+60iHP+rLDV1H4w7J
         NGvz2jsbEEk4IvCUOTFTCFXmsbCn1wv3C8rTOnRAGKnparvNIgXElU7zqwq7F2aMGKtY
         2VSGe8xG8AOkMXHrxOUgw9vmhrBXrrxQtW8rI=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] Staging: POHMELFS: replace I_LOCK with I_NEW
Date: Fri, 18 Dec 2009 15:33:28 +0300
Message-Id: <1261139608-12493-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See commit eaff8079 (kill I_LOCK)
Fix build error.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

diff --git a/drivers/staging/pohmelfs/dir.c b/drivers/staging/pohmelfs/dir.c
index 6c5b261..368968f 100644
--- a/drivers/staging/pohmelfs/dir.c
+++ b/drivers/staging/pohmelfs/dir.c
@@ -723,7 +723,7 @@ static int pohmelfs_remove_entry(struct inode *dir, struct dentry *dentry)
 			inode_dec_link_count(inode);
 	}
 	dprintk("%s: inode: %p, lock: %ld, unhashed: %d.\n",
-		__func__, pi, inode->i_state & I_LOCK, hlist_unhashed(&inode->i_hash));
+		__func__, pi, inode->i_state & I_NEW, hlist_unhashed(&inode->i_hash));
 
 	return err;
 }
-- 
1.6.6.rc3

