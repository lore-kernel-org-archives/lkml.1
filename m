Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZLAGoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZLAGoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 01:44:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZLAGoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 01:44:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZLAGoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 01:44:06 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: dhowells@redhat.com, ericvh@gmail.com, rminnich@sandia.gov,
       lucho@ionkov.net, adkulkar@umail.iu.edu
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] build fix for fs/9p/cache.c
Date: Tue,  1 Dec 2009 14:44:02 +0800
Message-Id: <1259649842-7909-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make allyesconfig, I got:

fs/9p/cache.c: In function '__v9fs_fscache_release_page':
fs/9p/cache.c:346: error: 'vnode' undeclared (first use in this function)

which is introduced by commit 201a154, fix to use the right parameters.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 fs/9p/cache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index bcc5357..e777961 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -343,7 +343,7 @@ int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
 
 	BUG_ON(!vcookie->fscache);
 
-	return fscache_maybe_release_page(vnode->cache, page, gfp);
+	return fscache_maybe_release_page(vcookie->fscache, page, gfp);
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
-- 
1.6.5.2

