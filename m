Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZDZKhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZDZKhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbZDZKg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:36:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:45752 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbZDZKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:36:25 -0400
Message-Id: <20090426102953.114421174@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sun, 26 Apr 2009 20:25:53 +1000
From: npiggin@suse.de
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 1/5] fs: dcache fix LRU ordering
References: <20090426102552.947523845@suse.de>
Content-Disposition: inline; filename=fs-dcache-order-lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ordering of LRU when moving referenced dentries to the head of the list
(they should go to the head of the list in the same order as they were found
from the tail, rather than reverse order).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/dcache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -481,7 +481,7 @@ restart:
 			if ((flags & DCACHE_REFERENCED)
 				&& (dentry->d_flags & DCACHE_REFERENCED)) {
 				dentry->d_flags &= ~DCACHE_REFERENCED;
-				list_move_tail(&dentry->d_lru, &referenced);
+				list_move(&dentry->d_lru, &referenced);
 				spin_unlock(&dentry->d_lock);
 			} else {
 				list_move_tail(&dentry->d_lru, &tmp);


