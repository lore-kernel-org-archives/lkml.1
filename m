Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZGZIVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZGZIVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZGZIUZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:20:25 -0400
Received: from www.tglx.de ([62.245.132.106]:33800 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbZGZIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:20:20 -0400
Message-Id: <20090726081556.004474377@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [Patch RFC 21/37] affs: use semaphore_init instead of init_MUTEX
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=affs-use-semaphore-init-instead-of-init-MUTEX.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of these "mutex" is non obvious and probably a completion
in some places. Make it them semaphores.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/affs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/fs/affs/super.c
===================================================================
--- linux-2.6-tip.orig/fs/affs/super.c
+++ linux-2.6-tip/fs/affs/super.c
@@ -113,8 +113,8 @@ static void init_once(void *foo)
 {
 	struct affs_inode_info *ei = (struct affs_inode_info *) foo;
 
-	init_MUTEX(&ei->i_link_lock);
-	init_MUTEX(&ei->i_ext_lock);
+	semaphore_init(&ei->i_link_lock);
+	semaphore_init(&ei->i_ext_lock);
 	inode_init_once(&ei->vfs_inode);
 }
 


