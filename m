Return-Path: <linux-kernel-owner+w=401wt.eu-S1755075AbXIWLPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075AbXIWLPN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 07:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750756AbXIWLPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 07:15:01 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:44661 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbXIWLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 07:15:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=Zo/lD+4inxZDbA0s6j3YiMtfYgtNyw56InRyHynSQmbnS3hHFAHO0leg65+lbLuk//SVlB7nLcm9YB5CEuXe4W9wspiv71banbsl1BNJi+6z0IHuul7RYZVpcouhUeiDjVQn7iaxBxxJdKATLFlzKmPEVcfhlWt8OX6AKnjs3FI=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, cr_quan@163.com
Subject: [PATCH] vfs: use the predefined d_unhashed inline function instead
Date: Sun, 23 Sep 2007 19:14:11 +0800
Message-Id: <1190546051-15590-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/dcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 678d39d..62e1800 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1546,7 +1546,7 @@ static void d_move_locked(struct dentry * dentry, struct dentry * target)
 	}
 
 	/* Move the dentry to the target hash queue, if on different bucket */
-	if (dentry->d_flags & DCACHE_UNHASHED)
+	if (d_unhashed(dentry))
 		goto already_unhashed;
 
 	hlist_del_rcu(&dentry->d_hash);
-- 
1.5.3

