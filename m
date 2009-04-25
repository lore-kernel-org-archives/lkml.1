Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbZDYBbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbZDYBbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 21:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753167AbZDYB3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 21:29:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:44575 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbZDYB2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 21:28:50 -0400
Message-Id: <20090425012209.802548502@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sat, 25 Apr 2009 11:20:26 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 06/27] fs: dcache fix LRU ordering
References: <20090425012020.457460929@suse.de>
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


