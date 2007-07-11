Return-Path: <linux-kernel-owner+w=401wt.eu-S1763790AbXGKNeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763790AbXGKNeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762180AbXGKNeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:34:06 -0400
Received: from c-69-242-210-120.hsd1.mi.comcast.net ([69.242.210.120]:34358
	"EHLO heimdal.trondhjem.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761713AbXGKNeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:34:05 -0400
X-Greylist: delayed 1194 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 09:34:05 EDT
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] locks: kill redundant local variable
Date: Wed, 11 Jul 2007 09:14:05 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       nfsv4@linux-nfs.org
Message-Id: <20070711131405.14746.99176.stgit@heimdal.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: \"J. Bruce Fields\" <bfields@fieldses.org>

There's no need for another variable local to this loop; we can use the
variable (of the same name!) already declared at the top of the function,
and not used till later (at which point it's initialized, so this is safe).

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/locks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 431a8b8..2e8f21b 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -823,7 +823,7 @@ static int __posix_lock_file(struct inode *inode, struct file_lock *request, str
 	lock_kernel();
 	if (request->fl_type != F_UNLCK) {
 		for_each_lock(inode, before) {
-			struct file_lock *fl = *before;
+			fl = *before;
 			if (!IS_POSIX(fl))
 				continue;
 			if (!posix_locks_conflict(request, fl))
