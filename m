Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0BSTta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 14:49:30 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:49065 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab0BSTrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 14:47:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=UWJH9Ak/BVqqfk1gxdSwZ4S1ILm8opMmhVuNubG+vwe27euD3sVwDwCrmv19Wy/5yc
         XopiZhe1A0oV6OOCp5/gsu5Kx9FFBORSWaAK7BjKZWQysq7Nw33/1j+xe7jQ2l/fn0kr
         /Mua60j/nnsR7ARQrUWebLLdpi+rRgFACBMVw=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/7] ext2: use nofail variant of inode_setattr()
Date: Fri, 19 Feb 2010 22:47:22 +0300
Message-Id: <1266608845-13212-5-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
References: <1266608845-13212-1-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-2-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-3-git-send-email-dmonakhov@openvz.org>
 <1266608845-13212-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since inode_change_ok() is now responsible for all
necessery checks we may call __inode_setattr() which can
not fail.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext2/inode.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 71b032c..8542b20 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1463,7 +1463,11 @@ int ext2_setattr(struct dentry *dentry, struct iattr *iattr)
 		if (error)
 			return error;
 	}
-	error = inode_setattr(inode, iattr);
+	/*
+	 * All necessery check already done in inode_check_ok(),
+	 * it is safe to use nofail version here.
+	 */
+	__inode_setattr(inode, iattr);
 	if (!error && (iattr->ia_valid & ATTR_MODE))
 		error = ext2_acl_chmod(inode);
 	return error;
-- 
1.6.6

