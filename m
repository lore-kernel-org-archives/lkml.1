Return-Path: <linux-kernel-owner+w=401wt.eu-S1758155AbZC2Qia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155AbZC2Qia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbZC2Qhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:37:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39822 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbZC2Qh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:37:29 -0400
Message-Id: <20090329155748.362472600@nick.local0.net>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Mon, 30 Mar 2009 02:55:40 +1100
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 01/14] fs: dcache fix LRU ordering
References: <20090329155539.275927173@nick.local0.net>
Content-Disposition: inline; filename=fs-dcache-order-lru.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix ordering of LRU when moving referenced dentries to the head of the list
(they should go to the head of the list in the same order as they were found
from the tail, rather than reverse order).
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


