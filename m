Return-Path: <linux-kernel-owner+w=401wt.eu-S1754795AbZFVCLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbZFVCLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 22:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZFVCLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 22:11:24 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52407 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZFVCLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 22:11:23 -0400
Date: Mon, 22 Jun 2009 11:11:20 +0900 (JST)
Message-Id: <20090622.111120.683298528766430835.mitake@dcl.info.waseda.ac.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Making fs/minix/minix.h double including safe
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This is a very VERY trivial fix for Minix file system.

I happen to find that fs/minix/minix.h doesn't guard double include.
Yes, I know this never cause something destructive
because this is self-evidence that no source file includes minix.h twice,
but I think fixing this is better than disregarding it.
If you agree, please use it.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>

diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index cb7fdd1..9dcf95b 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -1,3 +1,6 @@
+#ifndef FS_MINIX_H
+#define FS_MINIX_H
+
 #include <linux/fs.h>
 #include <linux/pagemap.h>
 #include <linux/minix_fs.h>
@@ -86,3 +89,5 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 {
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
+
+#endif /* FS_MINIX_H */

